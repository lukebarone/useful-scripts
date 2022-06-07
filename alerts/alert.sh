#!/bin/bash
# Shuts down or restarts at a certain time, and emails Responsible People with
# status or warnings.
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi
DEFAULT_ACTION=reboot
# Default action to take if no arguements are given.
DEFAULT_DELAY=8
# Default delay to wait before action.
RESPONSIBLE_PEOPLE=("tech@example.com" "users@example.com")
# List of email addresses to alert to server interruptions.
SERVER_ROLES=("Samba File Server" "NextCloud Remote Access" "Roundcube Email"
              "DNS/DHCP" "Booked")
# List of roles the current server is responsible for.
FROM_EMAIL="tech@example.com"
SUBJECT="Service Interruption for $(hostname) server"

# Check command line arguments. Print the Help screen if none or there's an error.

function generate_message() {
    message="Attention! The $(hostname) server is going offline in ${DELAY}
hour(s) for a ${ACTION}. Please save your work before then. The following
services will be affected:
"
    for i in "${SERVER_ROLES[@]}"; do
        message+="\n\t- ${i}"
    done
    message+="\n\nPlease contact your tech for more information."
    echo -e "${message}"
}
function mail_it() {
    for email in "${RESPONSIBLE_PEOPLE[@]}"; do
        echo "${MESSAGE_BODY}" | mail --return-address="${FROM_EMAIL}" --subject="${SUBJECT}" "${email}"
        echo "Mail sent to ${email}"
    done
    
}
function action_server() {
    MINUTES_TO_DO_IT=$(( 60 * DELAY ))
    if [ "${ACTION}" == "shutdown" ]; then
        /usr/sbin/shutdown -h +"${MINUTES_TO_DO_IT}"
    else
        /usr/sbin/shutdown -r +"${MINUTES_TO_DO_IT}"
    fi
}
function show_help() {
    cat - <<EOF
Alerter Help
Version 0.1 - Debian Edition
(C) 2022 by Luke Barone (lukebarone@gmail.com)

Arguments:
    -? -h --help                      Displays this help screen and exits
    -a --action {shutdown | reboot}   Performs the action
    -d --delay <int>                  Delay by <int> hours
    --debug                           Enables debug mode (shows variables)
EOF
    exit 0
}
POSITIONAL_ARGS=()
ACTION=$DEFAULT_ACTION
DELAY=$DEFAULT_DELAY
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help|-\?)
            show_help
            exit 0
            ;;
        -a|--action)
            if [ -z "$2" ] || ! [[ "${2}" =~ ^(shutdown|reboot)$ ]]; then
                echo "Error! Invalid action (got ${2}; expected either shutdown or reboot)"
                exit 2
            fi
            ACTION="$2"
            shift
            shift
            ;;
        -d|--delay)
            if [ -z "$2" ] || ! [[ "${2}" == ?([[:digit:]]) ]]; then
                echo "Error! Invalid delay (got ${2}; expected integer > 0)"
                exit 3
            fi
            DELAY="$2"
            shift
            shift
            ;;
        --debug)
            DEBUG=true
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done
set -- "${POSITIONAL_ARGS[@]}"

MESSAGE_BODY=$(generate_message)
# DEBUG statements
if [[ "${DEBUG}" == "true" ]]; then
    echo "DEBUG: DELAY=${DELAY} | DEFAULT_DELAY=${DEFAULT_DELAY}"
    echo "DEBUG: ACTION=${ACTION} | DEFAULT_ACTION=${DEFAULT_ACTION}"
    echo "DEBUG: RESPONSIBLE_PEOPLE=${RESPONSIBLE_PEOPLE[*]}"
    echo "DEBUG: ${MESSAGE_BODY}"
fi
mail_it
action_server
