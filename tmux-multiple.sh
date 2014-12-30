#!/bin/bash
usage(){
    echo "#########################################################################################################"
    echo "#"
    echo "# tmux-multiple"
    echo "# Author: Mehmet Ali ERGUT"
    echo "# E-mail: mim@taximact.com"
    echo "# https://github.com/memnuniyetsizim/tmux-multiple"
    echo "#"
    echo "#  This script can be used for example multi redis connections, multi database queries etc"
    echo "#  Yo! you need to send your arguments with a semicolon."
    echo "#  To use different panes, use different session names."
    echo "#  Command (-c) is optional"
    echo "#"
    echo "#"
    echo "#  -t for session title"
    echo "#  -c for the command what you want to call"
    echo "#  -m parameter list with seperated with space for every pane"
    echo "#  -g send command to all open panes"
    echo "#  -p parameters to run"
    echo "#  -i for install the script with tmux configuration"
    echo "#"
    echo "#  SAMPLE: "
    echo "#  with synchronized-panes"
    echo "#  bash tmux-multi.sh -g -t \"editFiles\" -c \"vim\" -p \"/etc/nginx/fastcgi_params;/etc/hosts\""
    echo "#"
    echo "#  without synchronization"
    echo "#  bash tmux-multi.sh -t \"editFiles\" -c \"vim\" -p \"/etc/nginx/fastcgi_params;/etc/hosts\""    
    echo "#"
    echo "#########################################################################################################"
}

install (){
    if [ -z "$linkfile" ]; then
        echo -n "Please enter name for link file"
        read linkfile
    fi

    if [ -z "$linkpath" ]; then
        echo -n "Please enter fullpath where you want to link file"
        echo -n "Ex: /usr/local/bin"
        read linkpath
    fi

    CURPATH=`pwd`
    sudo ln -s "$CURPATH/tmux-multiple.sh" "$linkpath/$linkfile"
    sudo chmod +x "$linkpath/$linkfile"
    echo "Link file created at $linkpath/$linkfile"
    "set-option -g mouse-select-pane on
     set-option -g mouse-select-window on
     set-window-option -g mode-mouse on" >> ~/.tmux.conf
}

pages=  length=  time=

while getopts h:t:c:p:g?:i: opt; do
  case $opt in
    h|help|\?)
        usage
        exit 0
        ;;
    i|install)
        install
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

if [ -z "$sessionname" ]; then
    echo -n "Please enter a session name without spaces"
    read sessionname
fi
if [ -z "$parameters" ]; then
   echo -n "Please provide of list of parameters separated by semicolon [ENTER]: "
   read parameters
fi
 
if [tmux has-session -t $sessionname ]; then
  tmux attach-session -d -t $sessionname
else
  tmux new-session -d -s $sessionname
fi

export IFS=";"
for i in $parameters
do
    if [ -z $runcommand ]; then
        tmux split-window -v -t $sessionname "$i"
    else
        tmux split-window -v -t $sessionname "$runcommand $i"
    fi
done

if [ "$sync" != "" ]; then
    tmux set-window-option synchronize-panes on
else
    tmux set-window-option synchronize-panes off
fi

tmux kill-pane -t 0
tmux select-layout tiled
tmux attach -t $sessionname