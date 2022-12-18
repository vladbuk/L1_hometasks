#!/bin/bash
#
# Create a data backup script
# Add this to crontab: * * * * * /path/to/this-script
#

if [[ $# -eq 2 ]]
then
    src=$1
    dest=$2
    rsync -avz --progress --delete $src $dest --log-file=/tmp/folder_backup.log
    echo -e "\n"
    echo "Logs writes to /tmp/folder_backup.log"
else
    echo "This script needs 2 arguments: source dir and destination dir."
fi