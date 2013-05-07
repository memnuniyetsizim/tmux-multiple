Tmux-Multiplier

This is a simple multiple pane opener tmux script.
Originally it was created to open multiple ssh panes, 
i just changed it. 

 
You need to send your arguments in a quoted way.

-t for session title
-c for the command what you want to call
-m parameter list with seperated with space for every pane
-g send command to all open panes

Sample usage: 

with synchronized-panes

./tmux-multi.sh -g -t "CheckMultipleFiles" -c "vim" -p "/etc/nginx/fastcgi_params /etc/hosts /etc/nginx/nginx.conf"

without synchronization

./tmux-multi.sh -t "CheckMultipleFiles" -c "vim" -p "/etc/nginx/fastcgi_params /etc/hosts /etc/nginx/nginx.conf"

Thanks to 
http://linuxpixies.blogspot.jp/2011/06/tmux-copy-mode-and-how-to-control.html


