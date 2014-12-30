Tmux-Multiplier

This is a simple multiple pane opener tmux script.
Originally it was created to open multiple ssh panes, 
i just changed it. 

 
This script can be used for example multi redis connections, multi database queries etc
You need to send your arguments with a semicolon.
To use different panes, use different session names.
Command (-c) is optional

-t for session title
-c for the command what you want to call
-m parameter list with seperated with space for every pane
-g send command to all open panes
-p parameters to run
-i for install the script with tmux configuration

To install:

```bash

$ ./tmux-multi.sh -install

```

Installation will need a path for symlink and gonna install a .tmux.conf file to your home folder.

Sample usage: 

with synchronized-panes

```bash

$ ./tmux-multi.sh -g -t "editFiles" -c "vim" -p "/etc/nginx/fastcgi_params;/etc/hosts"

```

without synchronization

```bash

./tmux-multi.sh -t "editFiles" -c "vim" -p "/etc/nginx/fastcgi_params;/etc/hosts"

```

Thanks to 
http://linuxpixies.blogspot.jp/2011/06/tmux-copy-mode-and-how-to-control.html


