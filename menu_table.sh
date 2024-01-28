#!/usr/bin/bash
current_DB=$1
# cd ./.db/$current_DB
PS3=" $current_DB >> "
convension='^[a-zA-Z_]+[0-9]*([a-zA-Z0-9][[:space:]]?)*$' 

select var in "Create TB" "Insert TB" "List TB" "SELECT TB" "Delete From TB" "Remove TB" "Exit"

do
  case $REPLY in
         1 ) # "Create Table"
            read -p "Enter Name of Table : " name 
             if  [[ $name =~ $convension ]];then 
                name=`echo $name | tr ' ' '_'` #Replace Space _ 
                if [[ -f .db/$current_DB/$name ]];then 
                    echo "Sorry This name of Table is Already Exist"
                 else 
                    touch .db/$current_DB/$name
                fi 
            else 
                echo "Sorry this is an invalid database name,please follow the naming convension "
            fi
        ;;
         *)
            echo "Invalid input Menu number 1 - 5 "
         ;;
    esac
done 