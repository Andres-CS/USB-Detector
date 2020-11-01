#! /bin/bash

#Get config file
. ./some.config

function YELLOWTAIL(){
    for uuid in $(lsblk -o uuid)
    do
        #CHECK ALL DEVICES(uuid) PLUGGED IN
        if [ "$uuid" = "$1" ]
        then
            echo "FLASH DRIVE DETECTED"
            label=$(lsblk -o label,uuid | grep $1 | cut -d " " -f 1)
            name=$(lsblk -i -o name,uuid | grep $1 | cut -d " " -f 1 | cut -d "-" -f 2 )
            #CHECK IF DEVICES IS MOUNTED
            if [ "$(df -h | grep $name | cut -d " " -f 1 | cut -d "/" -f 3)" = "$name" ]
            then 
                echo "ALREADY MOUNTED"
            else
                #MOUNT THE DEVICE
                sudo mount "/dev/$name" "/media/$USER/$label/"
                echo "FLASH DRIVE MOUNTED"
            fi
        fi
    done
}

YELLOWTAIL $myUSB