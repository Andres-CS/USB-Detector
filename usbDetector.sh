#! /bin/bash

#Get config file
. ./some.config

declare -A uuids

function readFSTAB(){
    dfault=$(cat /etc/fstab | grep ^UUID= | cut -d " " -f 1 | cut -d "=" -f 2)
    for a in ${dfault[@]}
    do
        name=$(lsblk -i -o name,uuid| grep $a | cut -d " " -f 1 | cut -d "-" -f 2)
        uuids[$name]=$a
    done
}

function addNewDevices(){
    newFlag=false
    while [ true ]
    do
        #Get devices UUID's but exclude internal storage devices
        for deviceID in $(lsblk -i -o name,uuid | egrep -v "*-sda" | egrep "*-sd*" | cut -d " " -f 2)
        do
            newFlag=true
            name=$(lsblk -i -o name,uuid| grep $deviceID | cut -d " " -f 1 | cut -d "-" -f 2)
            echo "$(date); USB ADDED; $name -> $deviceID" >> "/tmp/usbtracker.log"
        done
        if [ "$newFlag" == "true" ]
        then
            break #EXIT WHILE LOOP
        fi
    done
}

function YELLOWTAIL(){
    for uuid in $(lsblk -o uuid)
    do
        #CHECK ALL DEVICES(uuid) PLUGGED IN
        if [ "$uuid" = "$1" ]
        then
            echo "FLASH DRIVE DETECTED"
            label=$(lsblk -o label,uuid | grep $1 | cut -d " " -f 1)
            name=$(lsblk -i -o name,uuid | grep $1 | cut -d " " -f 1 | cut -d "-" -f 2 )
            #CHECK IF DEVICE IS MOUNTED
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

#readFSTAB
#addNewDevices
