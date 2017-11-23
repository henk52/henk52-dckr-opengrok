#!/bin/bash

FILELIST=/tmp/filelist
MONITOR_DIR=/var/opengrok/src

[[ -f ${FILELIST} ]] || ls ${MONITOR_DIR}/*.tgz > ${FILELIST}

while : ; do
    cur_files=$(ls ${MONITOR_DIR}/*.tgz)
    diff <(cat ${FILELIST}) <(echo $cur_files) || \
         { echo "Alert: ${MONITOR_DIR} changed" ;
           # TODO V only untar the new file(s)
           # TODO V create a subdir with the 'name' part of the .tgz
           cd ${MONITOR_DIR}; tar -xf *.tgz;
           # TODO V this could be sped up by indexing only the added dir.
           /opt/opengrok/bin/OpenGrok index;
           # Overwrite file list with the new one.
           echo $cur_files > ${FILELIST} ;
         }

    echo "Waiting for changes."
    # Wait 60 seconds.
    sleep 60
done
