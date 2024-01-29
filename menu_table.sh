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
                    echo "Table Name: "$name>>.db/$current_DB/metaData_$name
                    echo "Number of Columns: " $columns>>.db/$current_DB/metaData_$name
                    if [[ $columns =~ [0-9] ]];then
                     for ((i=1; i<=$columns; i++))
                        do 
                            read -p "Enter column $i : " column
                            if  [[ $column =~ $convension ]];then
                                    name=`echo $name | tr ' ' '_'` #Replace Space _
                                    # if (( $i==$columns ));then
                                    #     echo -n $column>>.db/$current_DB/$name # redirect the columns names to table file & -n to prevent addind new line
                                    #     echo -e "\n">>.db/$current_DB/$name # add new line after the columns names
                                    # else
                                    if (( $i==1 ));then
                                        echo -n "$column(PK)">>.db/$current_DB/$name  # redirect the columns names to table file & make the first column is a primary key 
                                    else
                                        echo -n $column>>.db/$current_DB/$name        # redirect the columns names to table file & -n to prevent addind new line
                                
                                    fi
                                    # fi
                                    PS3=" $current_DB >> $column >> "
                                    select datatype in "String" "Int"
                                    do
                                    case $REPLY in
                                        1 )
                                        echo -n "(string):">>.db/$current_DB/$name
                                        break 
                                        ;;
                                        2 )
                                        echo -n "(int):">>.db/$current_DB/$name
                                        break 
                                        ;;
                                        *)
                                        echo "Select a number from choices"
                                        ;;
                                    esac
                                    done  
                            else
                                    echo "Sorry this is an column database name,please follow the naming convension "
                            fi
                        done 
                        truncate -s -1 .db/$current_DB/$name   #? To remove the last ":"
                        echo -e "\n">>.db/$current_DB/$name # add new line after the columns names
                        cat "column name and data type: ".db/$current_DB/$name>>.db/$current_DB/metaData_$name
                        PS3=" $current_DB >>"
                    else
                       echo "Enter a valid number"
                    fi
                fi 
            else 
                echo "Sorry this is an invalid table name,please follow the naming convension "
            fi
        ;;
        2 ) #"Insert into table"
                read -p "Enter Table Name to insert data into : " name
                if  [[ $name =~ $convension ]];then 
                    name=`echo $name | tr ' ' '_'` #Replace Space _ 
                    if [[ -f .db/$current_DB/$name ]];then 
                        file=.db/$current_DB/$name
                        meta=.db/$current_DB/metaData_$name
                        awk -v file="$file" -v meta="$meta" '
                            function get_value(){
                                        printf "Enter the value in column " $i " "
                                        getline value < "-"
                                        if ( $i ~ /string/ && value !=  "" ){ #? Check string constraint
                                            
                                                if ( value !~ /^[a-zA-Z_0-9]*$/ ){
                                                    print "Please follow the naming convension , not incluse spaces , special characters or begin with numbers"
                                                    get_value()
                                                }
                                                
                                        }
                                        if ( $i ~ /int/ && value != "" ){
                                            
                                                if ( value !~ /^[0-9]+$/ ){ #? Check int constraint
                                                    print "Please enter a number value only"
                                                    get_value()
                                                }
                                               
                                        }
                                        if( i == 1 && value == "" ){ #?user must enter the first column(PK)
                                            print "You must enter a value to the primary key"
                                            get_value()
                                        }
                                      }
                        BEGIN{
                            FS=":"
                            OFS=":"
                        }
                            {
                                if(NR==1){
                                    for (i=1; i<=NF; i++){
                                      
                                        get_value()
                                        
                                        if( i!=0 && value == "" ){
                                            value="NULL"
                                        }
                                        if(i==NF){
                                            print substr(value, 1, length(value)-1) >> file #? To remove the : from tyhe last column
                                        }
                                        else{
                                            printf value":" >> file
                                        }
                                    }              
                                }
                            }
                        END {
                            
                            print " number of rows: "NR/2 >> meta   #? set number of rows in meta data & we divide by to beacause of new lines 
                            print "" >> file #? To add a new line in each row
                        }
                            
                        ' ".db/$current_DB/$name"
                            echo "Your Data saved Successfuly"

                         else 
                        echo "Sorry This name of Table is not Exist"
                    fi 
                else 
                    echo "Sorry this is an invalid table name,please follow the naming convension "
                fi
        ;;
        3 ) #"List TB"
                        if [[ -d .db/$current_DB ]];then 
                            echo -n "All tables in $current_DB database :"
                            ls -p .db/$current_DB | grep -v / #list only files(-p to appent/ to all directories , grep -v / to choose files that no have / at the end)
                        else 
                            echo "Sorry This name of database is not Exist"
                        fi 
                   
        ;;
         *)
            echo "Invalid input Menu number 1 - 5 "
         ;;
    esac
done 