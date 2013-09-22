#!/bin/bash

# Authors: Marcello Torchio, Will Bradley
# https://github.com/zyphlar/backup-rotation-script

# Set the directory name that you wish to backup
DIRTOBACKUP=$1

# Set up the backup destination directory
BACKUPDIRDEST=$2

# Set up the number of days for backup rotation (archives older than these # of days ago will be deleted)
NUMDAYS=7;

# Check for input / help / usage
if [ -z "$2" ]
  then
    echo "Usage: ./rotate.sh source_folder destination_folder"
else

  # Start logging
  echo "["$(date)"] - Started Backup"
  # Check if the destination dir exists. If not create it
  if [ ! -d "$BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/" ]; then
      # Creates directory for today's backup
      mkdir $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"
  fi

  # Echo the log line.
  echo "["$(date)"] - Backup directory $DIRTOBACKUP in $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/"
  # Execute the backup command. This backup consist in a recursive copy of the source dir into destination dir
  cp -R $DIRTOBACKUP $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/

  TOTMB=$(du $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/ -hs)
  echo "["$(date)"] - Finished Backup - $TOTMB Copied"

  # Search for folders older than NUMDAYS days and remove them. This makes possible rotation of backups
  if [ "$BACKUPDIRDEST" != "" ]; then
    for i in `find $BACKUPDIRDEST/ -maxdepth 1 -type d -mtime +$NUMDAYS -print`;
    do
        echo -e "["$(date)"] - Found backup folder from $(stat -c %y $i)! Deleting directory $i";
        #\rm -rf $i;
    done
  fi

fi
