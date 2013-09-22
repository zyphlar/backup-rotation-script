#!/bin/bash

# Author: Marcello Torchio

# Set the directory name that you wish to backup
DIRTOBACKUP=$1

# Set up the backup destination directory
BACKUPDIRDEST=$2

# Set up the number of days for backup rotation
NUMDAYS=7;

# Start logging
echo "["$(date)"] - Started Backup"
# Check if the destination dir exists. If not create it
if [ ! -d "$BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/" ]; then
    # Creates directory for today's backup
    mkdir $BACKUPDIR/"$(date +"%m-%d-%Y")"
fi

# Echo the log line.
echo "["$(date)"] - Backup directory $DIRTOBACKUP in $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/"
# Execute the backup command. This backup consist in a recursive copy of the source dir into destination dir
cp -R $DIRTOBACKUP $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/

TOTMB=$(du $BACKUPDIRDEST/"$(date +"%m-%d-%Y")"/ -hs)
echo "["$(date)"] - Finished Backup - $TOTMB Copied"

# Search for folders older than NUMDAYS days and remove them. This makes possible rotation of backups
for i in `find $BACKUPDIRDEST/ -maxdepth 1 -type d -mtime +$NUMDAYS -print`;
do
        echo -e "["$(date)"] - Found outdated backup folder! Deleting directory $i";
        \rm -rf $i;
done
