#!/bin/bash

source ./.env

# Feed arguments -d -t -k in run script without interactive mode
while getopts ":d:t:k:s:n:" option; do
    case $option in
    d) DIR="$OPTARG" ;;
    t) TITLE="$OPTARG" ;;
    k) TASK="$OPTARG" ;;
    n) NUMBER_TASK="$OPTARG" ;;
    s) STATUS="$OPTARG" ;;
    esac
done

# File variables
TODAY=$(date "+%Y%m%d")
TODAY_LABEL=$(date "+%d/%m/%Y")
NOW=$(date "+%H:%M:%S")
FILENAME=$DIR/$TODAY".md"
IS_NEW_FILE=false

# Colors variables
WARNING='\e[31m'
SUCCESS='\e[32m'
INFO='\e[36m'
HIGHLIGHT='\e[33m'
NOCOLOR='\e[97m'

help() {
    echo -e "${INFO}[Usage]${NOCOLOR}: $(basename $0)"
    printf "${INFO}[Parameters]${NOCOLOR}:\n -d directory\n -t \"title\"\n -k \"task description\"\n -s \"status\" (open, close, breakfast, lunch, dinner) \n"
    echo -e "${INFO}[Example]${NOCOLOR}: ./run.sh -d example -k \"my first task\" -s open"
    echo -e "${INFO}[Help]${NOCOLOR}: ./run.sh -h"
    echo -e "${INFO}[Interactive mode]${NOCOLOR}: ./run.sh -i"
    echo -e "${HIGHLIGHT}[Warning]: Important to use 'space' remember of quotes \"hello world\"${NOCOLOR}"
    exit 0
}

if [[ -z "$@" ]]; then
    echo -e "${WARNING}[Error] - Please check the arguments below:${NOCOLOR}"
    help
    exit 0
fi

# ------------ FUNCTIONS ------------
interactive() {
    if [[ -z $DIR ]]; then
        echo "Directory: "
        read DIR
    fi

    echo "Title: (press 'enter' to skip)"
    read TITLE

    echo "Task: (input a creative task description)"
    read TASK

    echo "ID: "
    read NUMBER_TASK

    echo "Status: (press 'enter' to skip)"
    echo "[ o / open 📖 | do / done ✅ | c / close ❌ | b / breakfast 🍞 | l / lunch 🍛 | di / dinner 🍜 | p / pause ⏸️ ]"
    read STATUS

    format_space_to_underscore

    FILENAME=$DIR/$TODAY".md"
}

format_space_to_underscore() {
    DIR="${DIR// /_}"
}

create_title() {
    if [[ -z $TITLE ]] && [ $IS_NEW_FILE = true ]; then
        echo "# Daily $TODAY_LABEL" >>$FILENAME
    elif [[ -n $TITLE ]]; then
        echo "# $TITLE" >>$FILENAME
        if [[ $DISPLAY_STYLE = "table" ]]; then
            echo "" >>$FILENAME
            echo "|ID|Description|Status|Time|" >>$FILENAME
            echo "|--|-----------|------|----|" >>$FILENAME
        fi
    fi
}

create_directory() {
    # CREATE DIRECTORY
    if [ -d $DIR ]; then
        echo -e "${INFO}Directory $DIR already exists."
    else
        mkdir -p $DIR
        echo -e "${SUCCESS}Directory $DIR was created."
    fi
}

create_file() {
    # CREATE FILE
    if [ ! -f $FILENAME ]; then # check if file exists
        touch $FILENAME
        echo -e "${SUCCESS}File $FILENAME was created."
        IS_NEW_FILE=true
    fi
}

add_task() {
    # ADD HOUR AND TASK
    if [ -z "$TASK" ]; then # check if task is empty
        echo -e "${WARNING}You need to pass the task description"
    else
        display_number_task="[$NUMBER_TASK]"

        if [[ $DISPLAY_STYLE = "table" ]]; then
            echo -e "|$NUMBER_TASK|$TASK|$STATUS|$NOW|" >>$FILENAME
        else
            echo -e -n "$(day_period_emotion)$STATUS[$NOW]$display_number_task -" $TASK "<br />\n" >>$FILENAME
        fi

        echo -e "${SUCCESS}Time-Task was added in ${HIGHLIGHT} $FILENAME"
    fi
}

day_period_emotion() {
    noon=$(date -d 12:00:00 +"%H%M%S")
    night=$(date -d 18:00:00 +"%H%M%S")
    midnight=$(date -d 03:00:00 +"%H%M%S")

    if [[ "$NOW" > "$night" ]] || [[ "$NOW" < "$midnight" ]]; then
        echo -n "[🌃]"

    elif [[ "$NOW" > "$noon" ]]; then
        echo -n "[🌇]"

    else
        echo -n "[🌅]"
    fi
}

file_output() {
    echo -e "----------------- START -----------------"$NOCOLOR

    cat "$FILENAME"

    echo -e "\n${HIGHLIGHT}----------------- END -----------------"
}

status() {
    case $STATUS in
    "open" | "o") STATUS="[📖]" ;;
    "done" | "do") STATUS="[✅]" ;;
    "close" | "c") STATUS="[❌]" ;;
    "breakfast" | "b") STATUS="[🍞]" ;;
    "lunch" | "l") STATUS="[🍛]" ;;
    "dinner" | "di") STATUS="[🍜]" ;;
    "pause" | "p") STATUS="[⏸️]" ;;
    esac
}

# ------------ RUN ------------
if [ "$1" = "-i" ]; then # Interactive mode
    interactive
fi

if [ "$1" = "-h" ]; then # Help
    help
fi

format_space_to_underscore # Format DIR 'spaces' to 'underscore'

create_directory
create_file
create_title
status
add_task
file_output
