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



# - - - - - - - - - - - - - - - - #
#      Parse arguments - [0]      #
# - - - - - - - - - - - - - - - - #
 
# parse args variables
bParseDirectory=false        # [2] open file in a directory
bParseDirectoryMost=false    # [2] when opening file in a directory open one with the most files
bParseFile=false             # [3] open file through given path
bParseFileGroup=false        # [3] when opening a file should it be given a group
bParseList=false             # [4] list all the opened files to terminal
bParseLog=false              # [5] list all file through log
bParseHelp=false             # [?] print help to terminal

# parse strings
strParseFilePath=""          # [2] FILE argument, user given file path
strParseFileGroup=""         # [2] [-g GROUP] argument, user given group
strParseDirectoryPath=""     # [3] [DIRECTORY] argument, user given directory path

# parse errors
bErrorParseArgNum=false      # wrong number of arguments
bErrorParsePath=false        # wrong path was given
bErrorParseFilters=false     # wrong filters were given

# - checking arguments
case $1 in
    # -h tag
    -h)
        # check num of arguments
        if [ $# -ne 1 ]; then
            bErrorParseArgNum=true
        else 
            bParseHelp=true
        fi
        ;;

    # -m tag
    -m)
        # has to be directory open
        if [ $# -gt 2 ]; then
            
            # path and filters are given
            if [ -d "${*: -1}" ]; then

                #  check if the other arguments are filters
                if [ $bErrorParsePath = false ]; then
                    if check_filters_args "${*: -$#+1:$#-2}"; then
                        bParseDirectory=true
                        strParseDirectoryPath=${*: -1}
                        bParseDirectoryMost=true
                    else
                        bErrorParseFilters=true
                        bParseDirectory=false
                    fi
                fi

            # filters are given but no path
            else
                if [ "-a" = "${*: -2:1}" ] || [ "-b" = "${*: -2:1}" ] || [ "-g" = "${*: -2:1}" ]; then
                    
                    #  check if the other arguments are filters
                    if [ $bErrorParsePath = false ]; then
                        if check_filters_args "${*: -$#+1:$#}"; then
                            bParseDirectory=true
                            strParseDirectoryPath=$PWD
                            bParseDirectoryMost=true
                        else
                            bErrorParseFilters=true
                            bParseDirectory=false
                        fi
                    fi

            # wrong additional arguments
                else
                    bErrorParseFilters=true
                    bParseDirectory=false

                    if [ $(($# % 2)) -eq 0 ] || [ $# -gt 7 ]; then
                            bErrorParsePath=true
                    fi
                fi
            fi
        else

            # check if path is given
            if [ -d "${*: -1}" ]; then
                bParseDirectory=true
                strParseDirectoryPath=${*: -1}
                bParseDirectoryMost=true
            
            # else open current directory
            else
                bParseDirectory=true
                strParseDirectoryPath=$PWD
                bParseDirectoryMost=true
            fi
        fi
        ;;

    # list tag
    list)

        # no directory given and no filters
        if [ $# -eq 1 ]; then
            bParseList=true
            strParseDirectoryPath=$PWD
        else

        # directory path is given
        if [ -d "${*: -1}" ]; then
            bParseList=true
            strParseDirectoryPath=${*: -1}
            
            #  check if the other arguments are filters
                if [ $bErrorParsePath = false ] && [ $# -ne 2 ]; then
                    if check_filters_args "${*: -$#+1:$#-2}"; then
                        bParseList=true
                    else
                        bErrorParseFilters=true
                        bParseList=false
                    fi
                fi
            else

                #  check if the other arguments are filters
                if [ $bErrorParsePath = false ]; then
                    if check_filters_args "${*: -$#+1:$#}"; then
                        bParseList=true
                        strParseDirectoryPath=$PWD
                    else
                        bErrorParseFilters=true
                        bParseDirectory=false

                        if [ $(($# % 2)) -eq 0 ] || [ $# -gt 7 ]; then
                            bErrorParsePath=true
                        fi
                    fi
                fi  
            fi
        fi
        ;;

    # secret-log tag
    secret-log)
        bParseLog=true

        # checking if there is directory path
        case $# in
        2)  
            strParseDirectoryPath=$2
            ;;
        4)
            strParseDirectoryPath=$4
            ;;
        6)
            strParseDirectoryPath=$6
            ;;

        *)
            strParseDirectoryPath="//secret-log//"
            ;;
        esac

        # error checking directory path

        # get the last argument of the script
        if [ -z "${*: -1}" ] || [ $# -gt 6 ]; then
            bErrorParsePath=true
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
                    bErrorParseFilters=true
                    bParseLog=false
                fi
            fi
        fi

        if  [ "$(date -d "$5" +%Y-%m-%d 2> /dev/null)" = "$5" ] && [ $# -gt 4 ]; then
            if [ "-a" = "$4" ]; then
                bFilterDateAfter=true
                strFilterDateAfter=$3
            else 
                bErrorParseFilters=true
                bParseLog=false
            fi
        fi
        ;;

    # no tag
    *)
        # can be file open or directory open
        if [ $# -gt 1 ]; then
            
            # check if the first argument is a file
            if [ "$1" = "-g" ] && [ -f "$3" ]; then
                bParseFile=true
                bParseFileGroup=true
                strParseFileGroup=$2
                strParseFilePath=$3

            # path and filters are given
            else
                if [ -d "${*: -1}" ]; then

                    #  check if the other arguments are filters
                    if [ $bErrorParsePath = false ]; then
                        if check_filters_args "${*: -$#:$#-1}"; then
                            bParseDirectory=true
                            strParseDirectoryPath=${*: -1}
                        else
                            bErrorParseFilters=true
                            bParseDirectory=false
                        fi
                    fi

                # filters are given but no path
                else
                    if [ "-a" = "${*: -2:1}" ] || [ "-b" = "${*: -2:1}" ] || [ "-g" = "${*: -2:1}" ]; then

                        #  check if the other arguments are filters
                        if [ $bErrorParsePath = false ]; then
                            if check_filters_args "${*: -$#:$#}"; then
                                bParseDirectory=true
                                strParseDirectoryPath=$PWD
                            else
                                bErrorParseFilters=true
                                bParseDirectory=false
                            fi
                        fi

                # wrong additional arguments
                    else
                        bErrorParseFilters=true
                        bParseDirectory=false

                        if [ $(($# % 2)) -eq 1 ] || [ $# -gt 6 ]; then
                            bErrorParsePath=true
                        fi
                    fi
                fi
            fi
        
        # can be file or directory open
        else
            # check if path $1 is file
            if [ -f "$1" ]; then
                bParseFile=true
                strParseFilePath=$1
            else 

                # check if path $1 is directory
                if [ -d "$1" ]; then
                    bParseDirectory=true
                    strParseDirectoryPath=$1
                else
                    bParseDirectory=true
                    strParseDirectoryPath=$PWD
                fi
            fi
        fi
        ;;
    esac



# - - - - - - - - - - - - - - - #
#      Enviroment variables     #
# - - - - - - - - - - - - - - - #

# variables
bEnvErrorMole=false         # wrong or non existing mole environment
strEnvEditor=""             # system editor, default is vim


# check if MOLE_RC is set
if [ -z "$MOLE_RC" ]; then
    bEnvErrorMole=true
else
    if [ ! -f "$MOLE_RC" ]; then
        touch "$MOLE_RC"
    fi
fi

# check if EDITOR or VISUAL is set
if [ -n "$EDITOR" ]; then
    strEnvEditor="$EDITOR"
else
    if [ -n "$VISUAL" ]; then
        strEnvEditor="$VISUAL"
    else
        strEnvEditor="vi"
    fi
fi



# - - - - - - - - - - - - - - - - - - - - - #
#      Open file through directory [2]      #
# - - - - - - - - - - - - - - - - - - - - - #

    # variables
    strSearchFiles=""                   # list of files in directory
    strSearchFile=""                    # current file, which is being checked
    strSearchCheckLine=""               # current line string, which is being checked
    strSearchFilters=""
    strSearchDate="0000-01-01"
    strSearchTime="00:00:00"
    strSearchOutputFilePath=""

    # counters
    iSearchFileCount=0
    iSearchOpenNum=0

    # 
    bSearchDirectoryFound=false
    bSearchManyFiles=false
    bSearchFilterAccepted=false


# open file through directory
if [ $bParseDirectory = true ] && [ $bEnvErrorMole = false ]; then

    bSearchFilterAccepted=false

    # check if we have any record of the directory in molerc
    while read -r strLine; do

        # get the option argument and the path argument
        strSearchOpt=$(echo "$strLine" | awk '{print $1}')
        strSearchPath=$(echo "$strLine" | awk '{print $2}')
        strSearchDir=$(echo "$strSearchPath" | sed 's/\/[^\/]*$//')

        # check if the directory is in the log
        if [ "$strRewriteOpt" = "#0" ] && [ "$strSearchDir" = "$strParseDirectoryPath" ]; then
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
        strSearchFiles=$(ls "$strParseDirectoryPath")
        strSearchFiles=$(echo "$strSearchFiles" | tr '\n' ' ')

        # get the number of strings from the string and check if there are more than one file
        iDirectoryFilesNum=$(echo "$strSearchFiles" | wc -w)
        
        if [ "$iDirectoryFilesNum" -gt 1 ]; then
            bSearchManyFiles=true
        fi

        # there are more than one file in the directory
        if [ $bSearchManyFiles = true ]; then

            # searching for the right directory
            for (( i=1; i<="$iDirectoryFilesNum"; i++ )); do

                # setting up filter
                bSearchFilterAccepted=true

                # creating the path to the file
                strSearchFile=$(echo "$strSearchFiles" | cut -d ' ' -f $i)
                strSearchFile="$strParseDirectoryPath/$strSearchFile"

                # get line from file molerc which first argument is "#1" and second argument is $strSearchFile]
                strSearchCheckLine=$(grep -E "^#1 $strSearchFile" "$MOLE_RC")

                # filter by group
                if [ $bFilterGroup = true ] && [ $bSearchFilterAccepted = true ]; then
                    # get the groups from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 6-)

                    # the file is in one of the groups
                    if echo " $strSearchFilters " | grep -q " $strFilterGroup "; then
                        bSearchFilterAccepted=true;
                    
                    # the file is not in any of the groups did not pass the filter
                    else
                        bSearchFilterAccepted=false;
                    fi
                fi

                # filter by date after
                if [ $bFilterDateAfter = true ] && [ $bSearchFilterAccepted = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is after the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -gt "$(date -d "$strFilterDateAfter" +%s)" ]; then
                        bSearchFilterAccepted=true;

                    # the date is not after the filter date did not pass the filter
                    else
                        bSearchFilterAccepted=false;
                    fi
                fi

                # filter by date before
                if [ $bFilterDateBefore = true ] && [ $bSearchFilterAccepted = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is before the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -lt "$(date -d "$strFilterDateBefore" +%s)" ]; then
                        bSearchFilterAccepted=true;
                    
                    # the date is not before the filter date did not pass the filter
                    else
                        bSearchFilterAccepted=false;
                    fi
                fi

                # no filters
                if [ $bSearchFilterAccepted = true ]; then
                    
                    # depening on [m] argument save the file path if it is the most opened file
                    if [ $bParseDirectoryMost = true ]; then
                        
                        # find the file which was opened the most
                        iTmp="$(echo "$strSearchCheckLine" | cut -d ' ' -f 3)"
                        if [ "$iTmp" -gt $iSearchOpenNum ]; then
                            
                            # save the data for repeating the check
                            iSearchOpenNum=$(echo "$strSearchCheckLine" | cut -d ' ' -f 3)
                            
                            # set the option to open the file
                            bParseFile=true
                            strParseFilePath=$strSearchFile
                        fi

                    # save the file path which was the last opened
                    else
                        # convert the date and time
                        strTmp1=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)
                        strTmp2=$(echo "$strSearchCheckLine" | cut -d ' ' -f 5)

                        # the dates are the same have to check the time
                        if date -d "$strTmp1" >/dev/null 2>&1 && date -d "$strSearchDate" >/dev/null 2>&1 && [ "$(date -d "$strTmp1" +%s)" -eq "$(date -d "$strSearchDate" +%s)" ]; then

                            # compare the times
                            if [ "$(date -d "$strTmp2" +%s)" -gt "$(date -d "$strSearchTime" +%s)" ]; then
                                # save data for repeating the check
                                strSearchDate=$strTmp1
                                strSearchTime=$strTmp2
                                
                                # set the option to open the file
                                bParseFile=true
                                strParseFilePath=$strSearchFile
                            fi

                        # the dates are not the same
                        else
                            # the date is after the saved date
                            if date -d "$strTmp1" >/dev/null 2>&1 && date -d "$strSearchDate" >/dev/null 2>&1 && [ "$(date -d "$strTmp1" +%s)" -gt "$(date -d "$strSearchDate" +%s)" ]; then
                                # save data for repeating the check
                                strSearchDate=$strTmp1
                                strSearchTime=$strTmp2
                                
                                # set the option to open the file
                                bParseFile=true
                                strParseFilePath=$strSearchFile
                            fi
                        fi
                    fi
                fi

            done
        

        # there is only one file in the directory
        else
            # creating the path to the file
            strSearchFile="$strSearchFiles"
            strSearchFile="$strParseDirectoryPath/$strSearchFile"

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
                        bParseFile=true
                        strParseFilePath=$strSearchFile
                    
                    # the file is not in any of the groups did not pass the filter
                    else
                        echo "- no groups"
                    fi
                fi

                # filter by date after
                if [ $bFilterDateAfter = true ]; then
                    # get the date from the line
                    strSearchFilters=$(echo "$strSearchCheckLine" | cut -d ' ' -f 4)

                    # the date is after the filter date
                    if [ "$(date -d "$strSearchFilters" +%s)" -gt "$(date -d "$strFilterDateAfter" +%s)" ]; then
                        bParseFile=true
                        strParseFilePath=$strSearchFile

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
                        bParseFile=true
                        strParseFilePath=$strSearchFile
                    
                    # the date is not before the filter date did not pass the filter
                    else
                        echo "- invalid date"
                    fi
                fi    
            
            # open the file
            else
                bParseFile=true
                strParseFilePath=$strSearchFile
            fi
            
        fi
    fi
fi




# - - - - - - - - - - - - - - - - - #
#      Open a specific file [1]     #
# - - - - - - - - - - - - - - - - - #

if [ $bParseFile = true ] && [ $bEnvErrorMole = false ]; then
    
    # write to the first line of the file mole_rc accessed through $MOLE_RC
    #echo "## $strParseFilePath" > $MOLE_RC
    
    # variables
    iNum=1                              # line number
    strLine=""                          # the string of theline
    strRewriteOpt=""                    # the option argument ( #[0-9]* )
    strRewritePath=""                   # the path argument
    iRewriteOpenNum=0                   # the number of times the file was opened
    strRewriteDate=$(date +%Y-%m-%d)    # the date of the last time the file was opened
    strRewriteTime=$(date +%H:%M:%S)    # the time of the last time the file was opened
    strRewriteGroups=""                 # the groups of the file

    bRewriteAction=false                # bool value which file was opened the last time
    bRewriteData=false                  # bool value which indicates adding or rewriting the line


    # going through the file and rewriting the log
    while read -r strLine; do

        # get the option argument and the path argument
        strRewriteOpt=$(echo "$strLine" | awk '{print $1}')
        strRewritePath=$(echo "$strLine" | awk '{print $2}')


        #file option [#0]
        # geting the directories of the strParseFilePath and the strRewritePath
        strRewriteDir1=$(echo "$strParseFilePath" | sed 's/\/[^\/]*$//')
        strRewriteDir2=$(echo "$strRewritePath" | sed 's/\/[^\/]*$//')

        # compare the directory of the strParseFilePath with the directory of the strRewritePath
        if [ "$strRewriteOpt" = "#0" ] && [ "$strRewriteDir1" = "$strRewriteDir2" ]; then
            # set bRewriteData to true
            bRewriteAction=true

            # Replace the #0 line with the new updated path
            strRewrite="#0 $strParseFilePath"
            awk -v line="$strRewrite" -v num="$iNum" 'NR==num{print line} NR!=num{print}' "$MOLE_RC" > "$MOLE_RC.tmp" && mv "$MOLE_RC.tmp" "$MOLE_RC"
        fi


        # file option [#1]
        if [ "$strRewriteOpt" = "#1" ] && [ "$strRewritePath" = "$strParseFilePath" ]; then
            # set bRewriteData to true
            bRewriteData=true

            # increase the number of times the file was opened
            iRewriteOpenNum=$(echo "$strLine" | awk '{print $3}')
            iRewriteOpenNum=$((iRewriteOpenNum + 1))

            # rewriting the groups
            strRewriteGroups=$(echo "$strLine" | cut -d ' ' -f 6-)
            if [ $bParseFileGroup = true ]; then
                if ! (echo " $strRewriteGroups " | grep -q " $strParseFileGroup "); then
                    strRewriteGroups="$strParseFileGroup ${strRewriteGroups}"
                fi
            fi 

            # create and replace the line iNum with the new data
            strRewrite="#1 $strParseFilePath $iRewriteOpenNum $strRewriteDate $strRewriteTime $strRewriteGroups"
            awk -v line="$strRewrite" -v num="$iNum" 'NR==num{print line} NR!=num{print}' "$MOLE_RC" > "$MOLE_RC.tmp" && mv "$MOLE_RC.tmp" "$MOLE_RC"
        fi   

        # increase the line number
        iNum=$((iNum+1))
    done < "$MOLE_RC"


    # if the #0 tag does not exist
    if [ $bRewriteAction = false ]; then
        echo "#0 $strParseFilePath" >> "$MOLE_RC"
    fi


    # if the file is not in the log creating a new entry
    if [ $bRewriteData = false ]; then
        echo "#1 $strParseFilePath 1 $strRewriteDate $strRewriteTime $strParseFileGroup" >> "$MOLE_RC"
    fi

    # open the file
    #$strEnvEditor $strParseFilePath
fi




# - - - - - - - - - - - - - #
#           Debug           #
# - - - - - - - - - - - - - #

    # [1] 
    if [ $bParseHelp = true ]; then
        echo "bHelpArg = true  [ ./mole $* ]"
    fi

    # [2]
    if [ $bParseFile = true ]; then

        # main
        # printing the option
        echo "bParseFile = true  [ ./mole $* ]"
        echo "strParseFilePath = $strParseFilePath"

        # group
        # printing the group
        if [ $bParseFileGroup = true ]; then
            echo "strParseFileGroup = $strParseFileGroup"
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
    if [ $bParseDirectory = true ]; then

        # main
        # printing the option
        echo "bParseDirectory = true  [ ./mole $* ]"
        echo "strParseDirectoryPath = $strParseDirectoryPath"

        # most often argument
        if [ $bParseDirectoryMost = true ]; then
            echo "bParseDirectoryMost = true"
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
    if [ $bParseList = true ]; then

        # main
        # printing the option
        echo "bParseList = true  [ ./mole $* ]"
        echo "strParseDirectoryPath = $strParseDirectoryPath"

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
    if [ $bParseLog = true ]; then
        # main
        # printing the option
        echo "bParseLog = true  [ ./mole $* ]"
        echo "strParseDirectoryPath = $strParseDirectoryPath"

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

    if [ $bErrorParseFilters = true ] && [ $bErrorParsePath = true ]; then
        echo "[ ./mole $* ]"
        echo "[error] - wrong use-case"
    fi

    if [ $bErrorParseArgNum = true ]; then
        echo "[ ./mole $* ]"
        echo "[error] - wrong number of arguments"
    fi

    if [ $bErrorParsePath = true ]; then
        echo "[ ./mole $* ]"
        echo "[error] - wrong path"
    fi

    if [ $bErrorParseFilters = true ]; then
        echo "[ ./mole $* ]"
        echo "[error] - wrong filters"
    fi

    if [ $bEnvErrorMole = true ]; then
        echo "[ ./mole $* ]"
        echo "[error] - MOLE_RC is not set"
    fi
