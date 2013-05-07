#!/bin/bash
usage(){
    echo "#################################################################################"
    echo "#"
    echo "# tmux-multiple"
    echo "# Author: Mehmet Ali ERGUT"
    echo "# E-mail: mim@taximact.com"
    echo "# https://github.com/taximact/tmux-multiple"
    echo "#"
    echo "#  Yo! you need to send your arguments in a quoted way"
    echo "#  -t for session title"
    echo "#  -c for the command what you want to call"
    echo "#  -m parameter list with seperated with space for every pane"
    echo "#  -g send command to all open panes"
    echo "#"
    echo "#  SAMPLE: "
    echo "#  with synchronized-panes"
    echo "#  bash tmux-multi.sh -g -t \"CheckMultipleFiles\" -c \"vim\" -p \"/etc/nginx/fastcgi_params /etc/hosts /etc/nginx/nginx.conf\""
    echo "#"
    echo "# without synchronization"
    echo "#  bash tmux-multi.sh -t \"CheckMultipleFiles\" -c \"vim\" -p \"/etc/nginx/fastcgi_params /etc/hosts /etc/nginx/nginx.conf\""    
    echo "#"
    echo "#################################################################################"
}


pages=  length=  time=

while getopts g?:t:c:p:h: opt; do
  case $opt in
    h|help|\?)
        usage
        exit 0
        ;;
    g)  
        if [ "$OPTARG" = "-t" ];then
            sync=1
        else
            sync=0
        fi
        ;;
    t)  sessiontitle=$OPTARG
        ;;
    c)  runcommand=$OPTARG
        ;;
    p)  parameters=$OPTARG
        ;;
  esac
done

shift $((OPTIND - 1))

BNAME=`basename $0`
sessionname='$sessiontitle'

echo "command = $runcommand, parameters = $parameters"

if [ -z "$sessionname" ]; then
    echo -n "Please enter a session name without spaces"
    read sessionname
fi
if [ -z "$parameters" ]; then
   echo -n "Please provide of list of parameters separated by spaces [ENTER]: "
   read parameters
fi
 
if [tmux has-session -t $sessionname ]; then
  tmux attach-session -d -t $sessionname
else
  tmux new-session -d -s $sessionname
fi

for i in $parameters
do
tmux split-window -v -t $sessionname "$runcommand $i"
tmux select-layout tiled
done

if [ "$sync" != "" ]; then
    tmux set-window-option synchronize-panes on
else
    tmux set-window-option synchronize-panes off
fi

tmux attach -t $sessionname