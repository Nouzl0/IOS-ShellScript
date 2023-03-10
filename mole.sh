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
    
    echo " - FilterNum = $#"
    echo " - FiltersString = $@"

    # the check will depend on how many filters are there
    if [ $# -eq 2 ] || [ $# -eq 4 ] || [ $# -eq 6 ]; then
        local num=$#/2

        # check all the filters in pairs of 2           
        for (( i=1; i<=num; i++ )); do

            # check if the filter is -g
            if [ $1 = "-g" ] && [ $bFilterGroup = false ]; then
                bFilterGroup=true
                strFilterGroup=$2
                shift
                shift
            
            # check if the filter is -a
            else 
                if [ $1 = "-a" ] && [ $bFilterDateAfter = false ]; then
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
                    if [ $1 = "-b" ] && [ $bFilterDateBefore = false ]; then
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

# script argdata
strFilePath=""                    # [2] FILE argument
strFileGroup=""                   # [2] [-g GROUP] argument
strDirectoryPath=""               # [3] [DIRECTORY] argument







# - - - - - - - - - - - - - #
#    Checking Arguments     #
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
                    if check_filters_args ${*: -$#+1:$#-2}; then
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
                        if check_filters_args ${*: -$#+1:$#}; then
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
                    if check_filters_args ${*: -$#+1:$#-2}; then
                        bListOpt=true
                    else
                        bErrorFilters=true
                        bListOpt=false
                    fi
                fi
            else

                #  check if the other arguments are filters
                if [ $bErrorPath = false ]; then
                    if check_filters_args ${*: -$#+1:$#}; then
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
        if [ -z "${$#}" ] || [ $# -gt 6 ]; then
            bErrorPath=true
        fi


        # checking first argument
        if [ "$(date -d "$3" +%Y-%m-%d 2> /dev/null)" = "$3" ] && [ $# -gt 2 ]; then
            
            # checking second argument
            if [ "-a" = $2 ]; then
                bFilterDateAfter=true
                strFilterDateAfter=$3

            else
                if [ "-b" = $2 ]; then
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
            if [ "-a" = $4 ]; then
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
                        if check_filters_args ${*: -$#:$#-1}; then
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
                            if check_filters_args ${*: -$#:$#}; then
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