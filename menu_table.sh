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
            # check of Name table Can't Start Number , no contain Special Character 
             if  [[ $name =~ $convension ]];then 
                name=`echo $name | tr ' ' '_'` #Replace Space _ 
                if [[ -f .db/$current_DB/$name ]];then 
                    echo "Sorry This name of Table is Already Exist"
                 else 
                    touch .db/$current_DB/$name
                    read -p "How many columns? : " columns
                    if [[ $columns =~ [0-9] ]];then
                     for ((i=0; i<$columns; i++))
                        do 
                            read -p "Enter column $i : " column
                            if  [[ $column =~ $convension ]];then
                                    name=`echo $name | tr ' ' '_'` #Replace Space _
                                    echo -n $column:>>.db/$current_DB/$name # redirect the columns names to table file & -n to prevent addind new line
                                    PS3=" $current_DB >> $column >> "
                                    select datatype in "String" "Int"
                                    do
                                    case $REPLY in
                                        1 )
                                        echo "String" #^ i will edit when create matadata file
                                        break 
                                        ;;
                                        2 )
                                        echo "Int" #^ i will edit when create matadata file
                                        break 
                                        ;;
                                        *)
                                        echo "Select a number from choices"
                                        ;;
                                    esac
                                    done  
                                    
                                if (( i==0 ));then
                                    echo -n "$column(PK)":>.db/$current_DB/$name  # redirect the columns names to table file & make the first column is a primary key 
                                fi
                            else
                                    echo "Sorry this is an column database name,please follow the naming convension "
                            fi
                        done 
                        PS3=" $current_DB >>"
                    else
                       echo "Enter a valid number"
                    fi
                fi 
            else 
                echo "Sorry this is an invalid table name,please follow the naming convension "
            fi
        ;;
        
         *)
            echo "Invalid input Menu number 1 - 5 "
         ;;
    esac
done 