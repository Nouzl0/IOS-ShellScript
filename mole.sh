#!/bin/bash
#!/bin/sh

# - - - - - - - - - - - - -
# Author:  Nikolas Nosál 
# Brief:   Created for IOS-Project-1
# - - - - - - - - - - - - - 
# script - mole (Makes One’s Life Easier)
# - Text wrapper


# - - - - - - - - - - - - #
#         Options         #
# - - - - - - - - - - - - #

POSIXLY_CORRECT=yes
export LC_ALL=C




# - - - - - - - - - - - - - - - - - - - - - - - #
#      Function - Check filters arguments       #
# - - - - - - - - - - - - - - - - - - - - - - - #

# filter argdata and variables -> all of these are setup by function check_filets_arg()

bFilterGroup=false             # [-g GROUP1[,GROUP2[,...]]]
bFilterDateBefore=false        # [-a DATE]
bFilterDateAfter=false         # [-b DATE]

strFilterGroup=""                 # [-g GROUP1[,GROUP2[,...]]] 
strFilterDateBefore=""            # [-a DATE]
strFilterDateAfter=""             # [-b DATE]

# function for checking filter arguments
# gets string input (all the filters) and returns 0=true or 1=false
check_filters_args() {

    # the check will depend on how many filters are there
    if [ $# -eq 2 ] || [ $# -eq 4 ] || [ $# -eq 6 ]; then
        local num=$#/2

        # check all the filters in pairs of 2           
        for (( i=1; i<=num; i++ )); do

            # check if the filter is -g
            if [ "$1" = "-g" ] && [ $bFilterGroup = false ]; then
                bFilterGroup=true
                strFilterGroup=$2
                shift
                shift
            
            # check if the filter is -a
            else 
                if [ "$1" = "-a" ] && [ $bFilterDateAfter = false ]; then
                    # check if the date is valid
                    if [ -n "$2" ] && [ "$(date -d "$2" +%Y-%m-%d 2> /dev/null)" = "$2" ]; then
                        bFilterDateAfter=true
                        strFilterDateAfter=$2
                        shift
                        shift
                    else
                        return 1
                    fi

            # check if the filter is -b
                else 
                    if [ "$1" = "-b" ] && [ $bFilterDateBefore = false ]; then
                        # check if the date is valid
                        if [ -n "$2" ] && [ "$(date -d "$2" +%Y-%m-%d 2> /dev/null)" = "$2" ]; then
                            bFilterDateBefore=true
                            strFilterDateBefore=$2
                            shift 
                            shift
                        else
                            return 1
                        fi
            
            # if none of the filters are correct return 1
                    else
                        return 1
                    fi
                fi
            fi
        done
    else
        return 1
    fi
    return 0
}



# - - - - - - - - - - - - #
#        Variables        #
# - - - - - - - - - - - - #

# script options and arguments
bHelpOpt=false              # [1] -h 
bFileOpenOpt=false          # [2] -g
bArgFileGroup=false   
bDirectoryOpenOpt=false     # [3] -m 
bArgMostOften=false  
bListOpt=false              # [4] list 
bSecretLogOpt=false         # [5] secret-log

# script arg errors
bErrorOpt=false             # [6] error first-arg or wrongopt
bErrorArgNum=false          # wrong number of arguments
bErrorPath=false            # wrong path
bErrorFilters=false         # wrong filters
bErrorMoleEnv=false         # wrong or non existing mole environment

# script argdata
strFilePath=""                    # [2] FILE argument
strFileGroup=""                   # [2] [-g GROUP] argument
strDirectoryPath=""               # [3] [DIRECTORY] argument
strEditor=""                      # system editor







# - - - - - - - - - - - - - #
#      Argument parsing     #
# - - - - - - - - - - - - - #
 
# mole -h                                                                   [1]
# mole [-g GROUP] FILE                                                      [2]                                   
# mole [-m] [FILTERS] [DIRECTORY]                                           [3]
# mole list [FILTERS] [DIRECTORY]                                           [4]                
# mole secret-log [-b DATE] [-a DATE] [DIRECTORY1 [DIRECTORY2 [...]]]       [5]

# - checking arguments
case $1 in
    # -h tag
    -h)
        # check num of arguments
        if [ $# -ne 1 ]; then
            bErrorArgNum=true
        else 
            bHelpOpt=true
        fi
        ;;

    # -m tag
    -m)
        # has to be directory open
        if [ $# -gt 2 ]; then
            
            # path and filters are given
            if [ -d "${*: -1}" ]; then

                #  check if the other arguments are filters
                if [ $bErrorPath = false ]; then
                    if check_filters_args "${*: -$#+1:$#-2}"; then
                        bDirectoryOpenOpt=true
                        strDirectoryPath=${*: -1}
                        bArgMostOften=true
                    else
                        bErrorFilters=true
                        bDirectoryOpenOpt=false
                    fi
                fi

            # filters are given but no path
            else
                if [ "-a" = "${*: -2:1}" ] || [ "-b" = "${*: -2:1}" ] || [ "-g" = "${*: -2:1}" ]; then
                    
                    #  check if the other arguments are filters
                    if [ $bErrorPath = false ]; then
                        if check_filters_args "${*: -$#+1:$#}"; then
                            bDirectoryOpenOpt=true
                            strDirectoryPath=$PWD
                            bArgMostOften=true
                        else
                            bErrorFilters=true
                            bDirectoryOpenOpt=false
                        fi
                    fi

            # wrong additional arguments
                else
                    bErrorFilters=true
                    bDirectoryOpenOpt=false

                    if [ $(($# % 2)) -eq 0 ] || [ $# -gt 7 ]; then
                            bErrorPath=true
                    fi
                fi
            fi
        else

            # check if path is given
            if [ -d "${*: -1}" ]; then
                bDirectoryOpenOpt=true
                strDirectoryPath=${*: -1}
                bArgMostOften=true
            
            # else open current directory
            else
                bDirectoryOpenOpt=true
                strDirectoryPath=$PWD
                bArgMostOften=true
            fi
        fi
        ;;

    # list tag
    list)

        # no directory given and no filters
        if [ $# -eq 1 ]; then
            bListOpt=true
            strDirectoryPath=$PWD
        else

        # directory path is given
        if [ -d "${*: -1}" ]; then
            bListOpt=true
            strDirectoryPath=${*: -1}
            
            #  check if the other arguments are filters
                if [ $bErrorPath = false ] && [ $# -ne 2 ]; then
                    if check_filters_args "${*: -$#+1:$#-2}"; then
                        bListOpt=true
                    else
                        bErrorFilters=true
                        bListOpt=false
                    fi
                fi
            else

                #  check if the other arguments are filters
                if [ $bErrorPath = false ]; then
                    if check_filters_args "${*: -$#+1:$#}"; then
                        bListOpt=true
                        strDirectoryPath=$PWD
                    else
                        bErrorFilters=true
                        bDirectoryOpenOpt=false

                        if [ $(($# % 2)) -eq 0 ] || [ $# -gt 7 ]; then
                            bErrorPath=true
                        fi
                    fi
                fi  
            fi
        fi
        ;;

    # secret-log tag
    secret-log)
        bSecretLogOpt=true

        # checking if there is directory path
        case $# in
        2)  
            strDirectoryPath=$2
            ;;
        4)
            strDirectoryPath=$4
            ;;
        6)
            strDirectoryPath=$6
            ;;

        *)
            strDirectoryPath="//secret-log//"
            ;;
        esac

        # error checking directory path

        # get the last argument of the script
        if [ -z "${*: -1}" ] || [ $# -gt 6 ]; then
            bErrorPath=true
        fi


        # checking first argument
        if [ "$(date -d "$3" +%Y-%m-%d 2> /dev/null)" = "$3" ] && [ $# -gt 2 ]; then
            
            # checking second argument
            if [ "-a" = "$2" ]; then
                bFilterDateAfter=true
                strFilterDateAfter=$3

            else
                if [ "-b" = "$2" ]; then
                    bFilterDateBefore=true
                    strFilterDateBefore=$3
            
            # wrong filters
                else
                    bErrorFilters=true
                    bSecretLogOpt=false
                fi
            fi
        fi

        if  [ "$(date -d "$5" +%Y-%m-%d 2> /dev/null)" = "$5" ] && [ $# -gt 4 ]; then
            if [ "-a" = "$4" ]; then
                bFilterDateAfter=true
                strFilterDateAfter=$3
            else 
                bErrorFilters=true
                bSecretLogOpt=false
            fi
        fi
        ;;

    # no tag
    *)
        # can be file open or directory open
        if [ $# -gt 1 ]; then
            
            # check if the first argument is a file
            if [ "$1" = "-g" ] && [ -f "$3" ]; then
                bFileOpenOpt=true
                bArgFileGroup=true
                strFileGroup=$2
                strFilePath=$3

            # path and filters are given
            else
                if [ -d "${*: -1}" ]; then

                    #  check if the other arguments are filters
                    if [ $bErrorPath = false ]; then
                        if check_filters_args "${*: -$#:$#-1}"; then
                            bDirectoryOpenOpt=true
                            strDirectoryPath=${*: -1}
                        else
                            bErrorFilters=true
                            bDirectoryOpenOpt=false
                        fi
                    fi

                # filters are given but no path
                else
                    if [ "-a" = "${*: -2:1}" ] || [ "-b" = "${*: -2:1}" ] || [ "-g" = "${*: -2:1}" ]; then

                        #  check if the other arguments are filters
                        if [ $bErrorPath = false ]; then
                            if check_filters_args "${*: -$#:$#}"; then
                                bDirectoryOpenOpt=true
                                strDirectoryPath=$PWD
                            else
                                bErrorFilters=true
                                bDirectoryOpenOpt=false
                            fi
                        fi

                # wrong additional arguments
                    else
                        bErrorFilters=true
                        bDirectoryOpenOpt=false

                        if [ $(($# % 2)) -eq 1 ] || [ $# -gt 6 ]; then
                            bErrorPath=true
                        fi
                    fi
                fi
            fi
        
        # can be file or directory open
        else
            # check if path $1 is file
            if [ -f "$1" ]; then
                bFileOpenOpt=true
                strFilePath=$1
            else 

                # check if path $1 is directory
                if [ -d "$1" ]; then
                    bDirectoryOpenOpt=true
                    strDirectoryPath=$1
                else
                    bDirectoryOpenOpt=true
                    strDirectoryPath=$PWD
                fi
            fi
        fi
        ;;
    esac



# - - - - - - - - - - - - - - #
#     Check env variables     #
# - - - - - - - - - - - - - - #

    # check if MOLE_RC is set
    if [ -z "$MOLE_RC" ]; then
        bErrorMoleEnv=true
    else
        if [ ! -f "$MOLE_RC" ]; then
            touch "$MOLE_RC"
        fi
    fi

    # check if EDITOR or VISUAL is set
    if [ -n "$EDITOR" ]; then
        strEditor="$EDITOR"
    else
        if [ -n "$VISUAL" ]; then
            strEditor="$VISUAL"
        else
            strEditor="vi"
        fi
    fi



# - - - - - - - - - - - - - - - - - #
#      Open a specific file [1]     #
# - - - - - - - - - - - - - - - - - #

if [ $bFileOpenOpt = true ] && [ $bErrorMoleEnv = false ]; then
    
    # write to the first line of the file mole_rc accessed through $MOLE_RC
    #echo "## $strFilePath" > $MOLE_RC
    
    # variables
    iNum=1                              # line number
    strLine=""                          # the string of theline
    strRewriteOpt=""                    # the option argument ( #[0-9]* )
    strRewritePath=""                   # the path argument
    iRewriteOpenNum=0                   # the number of times the file was opened
    strRewriteDate=$(date +%Y-%m-%d)    # the date of the last time the file was opened
    strRewriteTime=$(date +%H-%M-%S)    # the time of the last time the file was opened
    strRewriteGroups=""                 # the groups of the file

    bRewriteAction=false                # bool value which file was opened the last time
    bRewriteData=false                  # bool value which indicates adding or rewriting the line


    # going through the file and rewriting the log
    while read -r strLine; do

        # get the option argument and the path argument
        strRewriteOpt=$(echo "$strLine" | awk '{print $1}')
        strRewritePath=$(echo "$strLine" | awk '{print $2}')


        #file option [#0]
        # geting the directories of the strFilePath and the strRewritePath
        strRewriteDir1=$(echo "$strFilePath" | sed 's/\/[^\/]*$//')
        strRewriteDir2=$(echo "$strRewritePath" | sed 's/\/[^\/]*$//')

        # compare the directory of the strFilePath with the directory of the strRewritePath
        if [ "$strRewriteOpt" = "#0" ] && [ "$strRewriteDir1" = "$strRewriteDir2" ]; then
            # set bRewriteData to true
            bRewriteAction=true

            # Replace the #0 line with the new updated path
            strRewrite="#0 $strFilePath"
            awk -v line="$strRewrite" -v num="$($iNum)" 'NR==num{print line} NR!=num{print}' "$MOLE_RC" > "$MOLE_RC.tmp" && mv "$MOLE_RC.tmp" "$MOLE_RC"
        fi


        # file option [#1]
        if [ "$strRewriteOpt" = "#1" ] && [ "$strRewritePath" = "$strFilePath" ]; then
            # set bRewriteData to true
            bRewriteData=true

            # increase the number of times the file was opened
            iRewriteOpenNum=$(echo "$strLine" | awk '{print $3}')
            iRewriteOpenNum=$($iRewriteOpenNum + 1)

            # rewriting the groups
            strRewriteGroups=$(echo "$strLine" | cut -d ' ' -f 6-)
            if [ $bArgFileGroup = true ]; then
                if ! (echo " $strRewriteGroups " | grep -q " $strFileGroup "); then
                    strRewriteGroups="$strFileGroup ${strRewriteGroups}"
                fi
            fi 

            # create and replace the line
            strRewrite="#1 $strFilePath $iRewriteOpenNum $strRewriteDate $strRewriteTime $strRewriteGroups"
            awk -v line="$strRewrite" -v num="$($iNum)" 'NR==num{print line} NR!=num{print}' "$MOLE_RC" > "$MOLE_RC.tmp" && mv "$MOLE_RC.tmp" "$MOLE_RC"
        fi   

        # increase the line number
        iNum=$((iNum+1))
    done < "$MOLE_RC"


    # if the #0 tag does not exist
    if [ $bRewriteAction = false ]; then
        echo "#0 $strFilePath" >> "$MOLE_RC"
    fi


    # if the file is not in the log creating a new entry
    if [ $bRewriteData = false ]; then
        echo "#1 $strFilePath 1 $strRewriteDate $strRewriteTime $strFileGroup" >> "$MOLE_RC"
    fi

    # open the file
    #$strEditor $strFilePath
fi






# - - - - - - - - - - - - - - - - - - - - - #
#      Open file through directory [2]      #
# - - - - - - - - - - - - - - - - - - - - - #

if [ $bDirectoryOpenOpt = true ]; then

    # variables
    strSearchFiles=""
    strSearchFile=""
    strSearchCheckLine=""
    strSearchFilters=""
    strSearchDate=$(date -d 0000-00-00 + %s)
    strSearchOutputFilePath=""

    iSearchFileCount=0
    iSearchOpenNum=0

    bSearchDirectoryFound=false
    bSearchManyFiles=false

    # check if we have any record of the directory in molerc
    while read -r strLine; do

        # get the option argument and the path argument
        strSearchOpt=$(echo "$strLine" | awk '{print $1}')
        strSearchPath=$(echo "$strLine" | awk '{print $2}')
        strSearchDir=$(echo "$strSearchPath" | sed 's/\/[^\/]*$//')

        # check if the directory is in the log
        if [ "$strRewriteOpt" = "#0" ] && [ "$strSearchDir" = "$strDirectoryPath" ]; then
            bSearchDirectoryFound=true
        fi
    done < "$MOLE_RC"

    # check if there are more than one file in the directory
    if [ $iSearchFileCount -gt 1 ]; then
        bSearchManyFiles=true
    fi


    # contines if the directory is in the log
    if [ $bSearchDirectoryFound = false ]; then
        
        # get the file names from directory and put them in a string
        strSearchFiles=$(ls $strDirectoryPath)
        strSearchFiles=$(echo $strSearchFiles | tr '\n' ' ')

        # get the number of strings from the string and check if there are more than one file
        iDirectoryFilesNum=$(echo $strSearchFiles | wc -w)
        
        if [ $iDirectoryFilesNum -gt 1 ]; then
            bSearchManyFiles=true
        fi

        # there are more than one file in the directory
        if [ $bSearchManyFiles = true ]; then

            # searching for the right directory
            for (( i=1; i<=$iDirectoryFilesNum; i++ )); do

                # creating the path to the file
                strSearchFile=$(echo $strSearchFiles | cut -d ' ' -f $i)
                strSearchFile="$strDirectoryPath/$strSearchFile"
                echo "- $strSearchFile"

                # get line from file molerc which first argument is "#1" and second argument is $strSearchFile]
                strSearchCheckLine=$(grep -E "^#1 $strSearchFile" $MOLE_RC)
                echo "- file line = $strSearchCheckLine"

                # no filters
                if [ $bFilterGroup = false ] && [ $bFilterDateAfter = false ] && [ $bFilterDateBefore = false ]; then
                    
                    # save the args for checking the optimal file
                    echo $(echo "$strSearchCheckLine" | cut -d ' ' -f 3)
                    strSearchDate=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)
                    strSearchTime=$(echo "$strSearchCheckLine" | cut -d ' ' -f 5)
                    
                    # depening on [m] argument save the file path if it is the most opened file
                    if [ $bArgMostOften = true ]; then
                        if [ $(echo "$strSearchCheckLine" | cut -d ' ' -f 3) -gt $iSearchOpenNum ]; then
                            iSearchOpenNun=$(echo "$strSearchCheckLine" | cut -d ' ' -f 3)
                            strSearchOutputFilePath=$strSearchFile
                        fi

                    # save the file path which was the last opened
                    else
                        if [ $(date -d "$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)" + "$(echo "$strSearchCheckLine" | cut -d ' ' -f 5))" -gt $strSearchDate ]; then
                            strSearchDate=$(date -d $(echo "$strSearchCheckLine" | cut -d ' ' -f 4) + $(echo "$strSearchCheckLine" | cut -d ' ' -f 5))
                            strSearchOutputFilePath=$strSearchFile
                        fi
                    fi

                    echo "- date = $strSearchDate"
                    echo "- open num = $strSearchOpenNum"

                fi

                # filter by group
                if [ $bFilterGroup = true ]; then
                    # get the groups from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 6-)

                    # the file is in one of the groups
                    if echo " $strSearchFilters " | grep -q " $strFilterGroup "; then
                        echo "groups = $strSearchFilters"
                    
                    # the file is not in any of the groups did not pass the filter
                    else
                        echo "no groups"
                    fi
                fi

                # filter by date after
                if [ $bFilterDateAfter = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is after the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -gt "$(date -d "$strFilterDateAfter" +%s)" ]; then
                        echo "- date = $strSearchFilters"
                        echo "- filter date = $strFilterDateAfter"

                    # the date is not after the filter date did not pass the filter
                    else
                        echo "- invalid date"
                    fi
                fi

                # filter by date before
                if [ $bFilterDateBefore = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is before the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -lt "$(date -d "$strFilterDateBefore" +%s)" ]; then
                        echo "- date = $strSearchFilters"
                        echo "- filter date = $strFilterDateBefore"
                    
                    # the date is not before the filter date did not pass the filter
                    else
                        echo "- invalid date"
                    fi
                fi
            done
        

        # there is only one file in the directory
        else
            # creating the path to the file
            strSearchFile="$strSearchFiles"
            strSearchFile="$strDirectoryPath/$strSearchFile"

            # checking filters
            if [ $bFilterGroup = true ] || [ $bFilterDateAfter = true ] || [ $bFilterDateBefore = true ]; then
                
                # get line from file molerc which first argument is "#1" and second argument is $strSearchFile
                strSearchCheckLine=$(grep -E "^#1 $strSearchFile" "$MOLE_RC")
                echo "- file line = $strSearchCheckLine"

                # filter by group
                if [ $bFilterGroup = true ]; then
                    # get the groups from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 6-)

                    # the file is in one of the groups
                    if echo " $strSearchFilters " | grep -q " $strFilterGroup "; then
                        echo "groups = $strSearchFilters"
                    
                    # the file is not in any of the groups did not pass the filter
                    else
                        echo "no groups"
                    fi
                fi

                # filter by date after
                if [ $bFilterDateAfter = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is after the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -gt "$(date -d "$strFilterDateAfter" +%s)" ]; then
                        echo "- date = $strSearchFilters"
                        echo "- filter date = $strFilterDateAfter"

                    # the date is not after the filter date did not pass the filter
                    else
                        echo "- invalid date"
                    fi
                fi

                if [ $bFilterDateBefore = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is before the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -lt "$(date -d "$strFilterDateBefore" +%s)" ]; then
                        echo "- date = $strSearchFilters"
                        echo "- filter date = $strFilterDateBefore"
                    
                    # the date is not before the filter date did not pass the filter
                    else
                        echo "- invalid date"
                    fi
                fi    
            fi
            
        fi
    fi
fi




# - - - - - - - - - - - - - #
#           Debug           #
# - - - - - - - - - - - - - #

    # [1] 
    if [ $bHelpOpt = true ]; then
        echo "bHelpArg = true  [ ./mole $* ]"
    fi

    # [2]
    if [ $bFileOpenOpt = true ]; then

        # main
        # printing the option
        echo "bFileOpenOpt = true  [ ./mole $* ]"
        echo "strFilePath = $strFilePath"

        # group
        # printing the group
        if [ $bArgFileGroup = true ]; then
            echo "strFileGroup = $strFileGroup"
        fi 

        # Reading file $MOLE_RC
        echo ""
        n=1    
        while read -r line; do
            # reading each line
            echo "Line No. $n : $line"
            n=$((n+1))
        done < "$MOLE_RC"

    fi

    # [3]
    if [ $bDirectoryOpenOpt = true ]; then

        # main
        # printing the option
        echo "bDirectoryOpenOpt = true  [ ./mole $* ]"
        echo "strDirectoryPath = $strDirectoryPath"

        # most often argument
        if [ $bArgMostOften = true ]; then
            echo "bArgMostOften = true"
        fi

        # filters
        # printing the group filter
        if [ $bFilterGroup = true ]; then
            echo "bFilterGroup = true"
            echo "strFilterGroup = $strFilterGroup"
        fi
        # printing the date after filter
        if [ $bFilterDateAfter = true ]; then
            echo "bFilterDateAfter = true"
            echo "strFilterDateAfter = $strFilterDateAfter"
        fi
        # printing the date before filter
        if [ $bFilterDateBefore = true ]; then
            echo "bFilterDateBefore = true"
            echo "strFilterDateBefore = $strFilterDateBefore"
        fi

    fi

    # [4]
    if [ $bListOpt = true ]; then

        # main
        # printing the option
        echo "bListOpt = true  [ ./mole $* ]"
        echo "strDirectoryPath = $strDirectoryPath"

        # filters
        # printing the group filter
        if [ $bFilterGroup = true ]; then
            echo "bFilterGroup = true"
            echo "strFilterGroup = $strFilterGroup"
        fi
        # printing the date after filter
        if [ $bFilterDateAfter = true ]; then
            echo "bFilterDateAfter = true"
            echo "strFilterDateAfter = $strFilterDateAfter"
        fi
        # printing the date before filter
        if [ $bFilterDateBefore = true ]; then
            echo "bFilterDateBefore = true"
            echo "strFilterDateBefore = $strFilterDateBefore"
        fi
    fi

    # [5]
    if [ $bSecretLogOpt = true ]; then
        # main
        # printing the option
        echo "bSecretLogOpt = true  [ ./mole $* ]"
        echo "strDirectoryPath = $strDirectoryPath"

        # filters
        # printing the date after filter
        if [ $bFilterDateAfter = true ]; then
            echo "bFilterDateAfter = true"
            echo "strFilterDateAfter = $strFilterDateAfter"
        fi

        # printing the date before filter
        if [ $bFilterDateBefore = true ]; then
            echo "bFilterDateBefore = true"
            echo "strFilterDateBefore = $strFilterDateBefore"
        fi
    fi





# - - - - - - - - - - - - - - #
#       Error Printing        #
# - - - - - - - - - - - - - - #

    if [ $bErrorOpt = true ]; then
        echo "bSecretLogOpt = true  [ ./mole $* ]"
        echo "[error] - wrong use-case"
    fi

    if [ $bErrorArgNum = true ]; then
        echo "[error] - wrong number of arguments"
    fi

    if [ $bErrorPath = true ]; then
        echo "[error] - wrong path"
    fi

    if [ $bErrorFilters = true ]; then
        echo "[error] - wrong filters"
    fi

    if [ $bErrorMoleEnv = true ]; then
        echo "[error] - MOLE_RC is not set"
    fi
