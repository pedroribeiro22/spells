#!/bin/sh

# # Reset
# Color_Off='\033[0m'       # Text Reset

# # Regular Colors
# Black='\033[0;30m'        # Black
# Red='\033[0;31m'          # Red
# Green='\033[0;32m'        # Green
# Yellow='\033[0;33m'       # Yellow
# Blue='\033[0;34m'         # Blue
# Purple='\033[0;35m'       # Purple
# Cyan='\033[0;36m'         # Cyan
# White='\033[0;37m'        # White

# # Bold
# BBlack='\033[1;30m'       # Black
# BRed='\033[1;31m'         # Red
# BGreen='\033[1;32m'       # Green
# BYellow='\033[1;33m'      # Yellow
# BBlue='\033[1;34m'        # Blue
# BPurple='\033[1;35m'      # Purple
# BCyan='\033[1;36m'        # Cyan
# BWhite='\033[1;37m'       # White

# # Underline
# UBlack='\033[4;30m'       # Black
# URed='\033[4;31m'         # Red
# UGreen='\033[4;32m'       # Green
# UYellow='\033[4;33m'      # Yellow
# UBlue='\033[4;34m'        # Blue
# UPurple='\033[4;35m'      # Purple
# UCyan='\033[4;36m'        # Cyan
# UWhite='\033[4;37m'       # White

# # Background
# On_Black='\033[40m'       # Black
# On_Red='\033[41m'         # Red
# On_Green='\033[42m'       # Green
# On_Yellow='\033[43m'      # Yellow
# On_Blue='\033[44m'        # Blue
# On_Purple='\033[45m'      # Purple
# On_Cyan='\033[46m'        # Cyan
# On_White='\033[47m'       # White

# # High Intensity
# IBlack='\033[0;90m'       # Black
# IRed='\033[0;91m'         # Red
# IGreen='\033[0;92m'       # Green
# IYellow='\033[0;93m'      # Yellow
# IBlue='\033[0;94m'        # Blue
# IPurple='\033[0;95m'      # Purple
# ICyan='\033[0;96m'        # Cyan
# IWhite='\033[0;97m'       # White

# # Bold High Intensity
# BIBlack='\033[1;90m'      # Black
# BIRed='\033[1;91m'        # Red
# BIGreen='\033[1;92m'      # Green
# BIYellow='\033[1;93m'     # Yellow
# BIBlue='\033[1;94m'       # Blue
# BIPurple='\033[1;95m'     # Purple
# BICyan='\033[1;96m'       # Cyan
# BIWhite='\033[1;97m'      # White

# # High Intensity backgrounds
# On_IBlack='\033[0;100m'   # Black
# On_IRed='\033[0;101m'     # Red
# On_IGreen='\033[0;102m'   # Green
# On_IYellow='\033[0;103m'  # Yellow
# On_IBlue='\033[0;104m'    # Blue
# On_IPurple='\033[0;105m'  # Purple
# On_ICyan='\033[0;106m'    # Cyan
# On_IWhite='\033[0;107m'   # White

# If the '-e' flag is passed, cells will be three rows high.
if [ "$1" == "-e" ]; then
    expanded=true;
else
    expanded=false
fi

# If the option --sixteen is given, only show the first 16 colors
if [ "$1" == "-16" ]; then
    showall=true;
    sixteen=true;
    expanded=true;
else
    sixteen=false
fi

# Creates a color row.
# Arguments:
#   - width (number)
#   - starting color (number)
#   - ending color (number)
row () {
    # Give the arguments names for scope reasons.
    width=$(($1 - 2))
    start=$2
    end=$3

    # Creates a "slice" (one terminal row) of a row.
    # Can be have number labels or be blank.
    # Arguments:
    #   - label (boolean)
    slice () {
        for ((i=$start; i<=$end; i++))
        do
            # Determine if there will be a label on this cell (this is actually
            # a per slice setting but the title needs to be set on each cell
            # because of the numbering).
            if [ $1 ]; then string=$i; else string=' '; fi

            # Change background to the correct color.
            tput setab $i

            # Print the cell.
            printf "%${width}s " $string
        done

        # Clear the coloring to avoid nasty wrapping colors.
        tput sgr0
        echo
    }

    if [ $expanded == true ]; then
        # Print a blank slice, a labeled one, and then a blank one.
        slice; slice true; slice
    else
        # Just print the labeled slice.
        slice true
    fi
}

display () {

    # Get the widths based on columns.
    cols=$(tput cols)
    sixth=$(($cols/6))
    eighth=$(($cols/8))
    twelfth=$(($cols/12))

    # Give it some room to breathe.
    echo

    # The first sixteen colors.
    row $eighth 0 7
    row $eighth 8 15
    echo

    if [ $sixteen == true ]; then
        exit
    fi

    # 16-231.
    for ((a=0; a<=35; a++))
    do
        row $sixth $((16 + (6 * a))) $((21 + (6 * a)))
    done
    echo

    # Greyscale.
    row $twelfth 232 243
    tput setaf 0
    row $twelfth 244 255

    # Clear before exiting.
    tput sgr0
    echo
}

# Show that table thang!
display
