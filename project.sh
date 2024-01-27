#!/usr/bin/bash
PS3=">"
if [[ -d ./.db ]] ;then 
    echo "Already Exit : "
else 
    echo "Create Folder .db : "
    mkdir ./.db
fi
convension='^[a-zA-Z_]+[0-9]*([a-zA-Z0-9][[:space:]]?)*$' 
select var in "Create DB" "List DB" "Connect DB" "Remove DB" "Exit"
do 
  case $REPLY in 
        1 ) # "Create DB"
            read -p "Enter Name of DB : " name 
             if  [[ $name =~ $convension ]];then 
                name=`echo $name | tr ' ' '_'` #Replace Space _ 
                if [[ -d ./.db/$name ]];then 
                    echo "Sorry This is name of DB  Already Exist"
                 else 
                    mkdir ./.db/$name
                fi 
            else 
                echo "Sorry this is an invalid database name,please follow the naming convension "
            fi
        ;;
        2 ) #List DB
            if [[ -d ./.db ]];then 
              ls -F ./.db | grep / | tr '/' ' '
            fi 
        ;;
        *)
            echo "Invalid input Menu number 1 - 5 "
        ;;
    esac 
done 