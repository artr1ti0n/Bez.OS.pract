#!/bin/bash

# Function to display help
function display_help {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -u, --users           Display list of users and their home directories"
    echo "  -p, --processes       Display list of running processes"
    echo "  -h, --help            Display this help message"
    echo "  -l PATH, --log PATH   Redirect output to file at PATH"
    echo "  -e PATH, --errors PATH Redirect errors to file at PATH"
}

# Function to display users and their home directories
function display_users {
    cut -d: -f1,6 /etc/passwd | sort
}

# Function to display running processes
function display_processes {
    ps -e --sort=pid
}

# Variables for paths
LOG_PATH=""
ERROR_PATH=""

# Parsing command line arguments using getopts
while getopts "uphl:e:-:" opt; do
    case "$opt" in
        -)
            case "${OPTARG}" in
                users) USERS_FLAG=true ;;
                processes) PROCESSES_FLAG=true ;;
                help) display_help; exit 0 ;;
                log) 
                    val="${!OPTIND}"; OPTIND=$((OPTIND + 1))
                    LOG_PATH="$val" 
                    ;;
                errors) 
                    val="${!OPTIND}"; OPTIND=$((OPTIND + 1))
                    ERROR_PATH="$val" 
                    ;;
                *)
                    echo "Unknown option --${OPTARG}"
                    display_help
                    exit 1
                    ;;
            esac
            ;;
        u) USERS_FLAG=true ;;
        p) PROCESSES_FLAG=true ;;
        h) display_help; exit 0 ;;
        l) LOG_PATH="$OPTARG" ;;
        e) ERROR_PATH="$OPTARG" ;;
        *)
            display_help
            exit 1
            ;;
    esac
done

# Check and set up logging and error redirection
if [ -n "$LOG_PATH" ]; then
    if [ -w "$LOG_PATH" ] || touch "$LOG_PATH" 2>/dev/null; then
        exec >"$LOG_PATH"
    else
        echo "Error: Cannot write to log file $LOG_PATH" >&2
        exit 1
    fi
fi

if [ -n "$ERROR_PATH" ]; then
    if [ -w "$ERROR_PATH" ] || touch "$ERROR_PATH" 2>/dev/null; then
        exec 2>"$ERROR_PATH"
    else
        echo "Error: Cannot write to error file $ERROR_PATH" >&2
        exit 1
    fi
fi

# Execute actions based on flags
if [ "$USERS_FLAG" = true ]; then
    display_users
fi

if [ "$PROCESSES_FLAG" = true ]; then
    display_processes
fi

# If no valid flags were provided, display help
if [ -z "$USERS_FLAG" ] && [ -z "$PROCESSES_FLAG" ]; then
    display_help
fi

