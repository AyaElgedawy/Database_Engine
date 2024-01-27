#!/usr/bin/bash
PS3=">"
if [[ -d ./.db ]] ;then 
    echo "Already Exit : "
else 
    echo "Create Folder .db : "
    mkdir ./.db
fi

