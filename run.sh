#!/bin/bash

# VARIABLES
TODAY=$(date "+%Y%m%d")
TODAY_LABEL=$(date "+%d/%m/%Y")
DIR=$1
TASK=$2
TITLE=$4
FILENAME=$DIR/$TODAY".md"
NOW=$(date "+%H:%M:%S")

# ASSETS VARIABLES
WARNING='\e[31m'
SUCCESS='\e[32m'
INFO='\e[36m'
HIGHLIGHT='\e[33m'
NOCOLOR='\e[97m'

help() {
    echo "Usage: $(basename $0)"
    echo "[First parameter]: directory"
    echo "[Second parameter]: task description"
    echo "[example]: ./run.sh ciandt \"daily\""
    exit 0
}

create_title() {
    if [ -z "$TITLE" ]; then
        echo "# Daily $TODAY_LABEL" >>$FILENAME # create file
    else
        echo "# $TITLE" >>$FILENAME
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
    if [ -f $FILENAME ]; then # check if file exists
        echo -e "${INFO}File $FILENAME already exists."
    else
        touch $FILENAME && create_title
        echo -e "${SUCCESS}File $FILENAME was created."
    fi
}

add_task() {
    # ADD HOUR AND TASK
    if [ -z "$TASK" ]; then # check if task is empty
        echo -e "${WARNING}You need to pass the task description"
    else
        echo -e -n "[$NOW] - $TASK / " $(day_period_emotion) "<br />\n" >>$FILENAME

        echo -e "${SUCCESS}Time-Task was added in ${HIGHLIGHT} $FILENAME"
    fi
}

day_period_emotion() {
    noon=$(date -d 12:00:00 +"%H%M%S")
    night=$(date -d 18:00:00 +"%H%M%S")

    if [[ "$NOW" > "$night" ]]; then
        echo -n "🌃"

    elif [[ "$NOW" > "$noon" ]]; then
        echo -n "🌇"

    else
        echo -n "🌅"
    fi
}

while getopts "t:" flag; do
    echo "penis"
    case "${flag}" in
    t) TITLE=${OPTARG} ;;
    esac
done

# HELP
if [ "$1" = "-h" ]; then
    help
fi

if [ "$3" = "-t" ]; then
    create_title
    add_task
    exit 0
fi

create_directory
create_file
add_task

echo -e "----------------- START -----------------"$NOCOLOR

cat "$FILENAME"

echo -e "\n${HIGHLIGHT}----------------- END -----------------"
