# CasusToets Test environment
#!/bin/sh
NC='\033[0m'
CYAN='\033[0;36m'
RED='\033[0;31m'

# Usage info
function show_help {
cat << EOF
Usage: ${0##*/} [-cfhlv] [FOLDER]
Set the case exam template app state using git and cp and optional Laravel commands.
It can also run PHP_CodeSniffer to preset a feedback md file in the students project 
root directory
    -c          always run PHP_CodeSniffer even when the -f switch is off
    -f          also creates a fresh feedback file with phpcs output in the
                student folder and opens it with VSCode
    -h          display this help and exit
    -l          include Laravel commands like migrations and cache clearing
    -v          verbose mode. Can be used multiple times for increased
                verbosity.

[FOLDER] specifies the source folder of the students project to copy from. If
         omitted, ctc will only reset the case exam to the latest commit.

NOTE: Normal usage when grading is: -fl
EOF
}

function exec_command {
    ((verbose >= 3)) && set -x
    ${1}
    exit_status=$?
    { set +x; } 2>/dev/null
    return $exit_status
}

function log {
    ((verbose >= $1)) && echo -e $2
}

# Initialize our own variables:
feedback=0
include_laravel=0
run_phpcs=0
verbose=1
quiet=0
folder=""

# Resetting OPTIND is necessary if getopts was used previously in the script.
# It is a good idea to make OPTIND local if you process options in a function.
OPTIND=1
while getopts :cfhlv opt; do
    case $opt in
        c ) run_phpcs=1
            ;;
        f ) feedback=1
            ;;
        h ) show_help
            exit 0
            ;;
        l ) include_laravel=1
            ;;
        v ) verbose=$((verbose+1))
            ;;
        * ) echo -e "${RED}Invalid option: $OPTARG${NC}" 1>&2
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --

# Remember the start folder on startup
StartFolder=$(pwd)
log 3 "${CYAN}Will return to folder $StartFolder${NC}"

# Read the environment variables file
log 3 "Reading .env file"
set -o allexport
source .env
set +o allexport

# Grab and validate the student project source folder
StudentAccountName=$1
if [ ! -z "$StudentAccountName" ] 
then
    # Assign and validate student folder
    StudentFolder="$StudentsBaseFolder/$StudentsBasePrefix$StudentAccountName"
    if [ ! -d $StudentFolder ]
    then
        echo -e "${RED}$StudentFolder does not exist${NC}" 1>&2
        exit 1
    fi
fi

if [ ! -z "$StudentAccountName" ]
then
    log 2 "${CYAN}Student account name set to:${NC} $StudentAccountName"
else
    log 2 "No student account name specified. Will only reset the template folder"
fi

# =================== Use GIT to reset the project ==========================
log 1 "${CYAN}Switch to Case Exam Template folder:${NC} $ProjectFolder"
exec_command "cd $ProjectFolder"

log 1 "${CYAN}Reset the folder to the HEAD version in git${NC}"
OPTIONS="--hard"
(( verbose < 1 )) && OPTIONS="${OPTIONS} --quiet"
exec_command "git reset ${OPTIONS}"

log 1 "${CYAN}Git-clean the folder${NC}"
OPTIONS="-d --force "
(( verbose < 1 )) && OPTIONS="${OPTIONS} --quiet"
exec_command "git clean ${OPTIONS}"

# ======================== Copy files and folders ===========================
if [ ! -z "$StudentAccountName" ] 
then
    log 1 "${CYAN}Copy files and folders from $StudentFolder${NC}"
    # Parse $FileArray into an array
    IFS=' ' read -r -a FileArray <<< "$Files"
    # Loop through each element in the array
    for Filename in "${FileArray[@]}"
    do
        # log 2 "${CYAN}Remove all files/folders from: ${NC}$Filename"
        # exec_command "rm -rf $Filename"
        log 2 "${CYAN}Copy file/folder: ${NC}$Filename"
        OPTIONS="--recursive"
        ((verbose >=3)) && OPTIONS="${OPTIONS} -v"
        exec_command "cp ${OPTIONS} $StudentFolder/$Filename ."
    done
fi

# ======= Run some composer and artisan commands to reset the app ===========
if ((include_laravel > 0)) 
then
    OPTIONS=""
    ((verbose >=3)) && OPTIONS="-vvv"

    log 1 "${CYAN}Update autoload file${NC}"
    exec_command "./vendor/bin/sail composer ${OPTIONS} dump-autoload"

    log 1 "${CYAN}Clear all the compiled views${NC}"
    exec_command "./vendor/bin/sail artisan view:clear ${OPTIONS}"
    
    log 1 "${CYAN}Make fresh database${NC}"
    exec_command "./vendor/bin/sail artisan migrate:fresh ${OPTIONS}"
    
    if (($?<=0))
    then
        log 1 "${CYAN}Seed the database${NC}"
        exec_command "./vendor/bin/sail artisan db:seed ${OPTIONS}"
    else
        log 1 "${RED}Error during migration. Skipping database seeding${NC}"
    fi
fi

# ========== Run PHP_CodeSniffer fixer for line endings =============
log 1 "${CYAN}Run PHP_CodeSniffer fixer for line endings${NC}"
docker-compose exec -T laravel.test ./vendor/bin/phpcbf --sniffs=Generic.Files.LineEndings

# ======= Run PHPCodeSniffer and create the feedback file ===========
if ((feedback>0))
then
    filename="$StudentFolder/feedback.md"
    log 1 "${CYAN}Create feedback file from template${NC}"
    cp $StartFolder/FEEDBACK_TEMPLATE.md $filename
    sed -i "s/{{STUDENT_ACCOUNT_NAME}}/$StudentAccountName/" $filename
    
    log 1 "${CYAN}Run PHP_CodeSniffer${NC}"
    docker-compose exec -T laravel.test ./vendor/bin/phpcs | tee -a $filename
    log 1 "${CYAN}This output is also written to feedback.md${NC}"

    echo '```' >> $filename
    code $filename
else
    if ((run_phpcs>0))
    then
        log 1 "${CYAN}Run PHP_CodeSniffer${NC}"
        docker-compose exec -T laravel.test ./vendor/bin/phpcs
    else
        log 2 "Skipping PHP_CodeSniffer"
    fi
fi

# =============== Check for watermarks =================
# Function to check if a file exists
check_file_presence() {
    if [ -f "$1" ]; then
        log 1 "✅ File '$1' is present."
    else
        log 1 "❌ File '$1' is missing!"
    fi
}

# Function to check if a file is NOT present
check_file_absence() {
    if [ ! -f "$1" ]; then
        echo "✅ File '$1' is NOT present as expected."
    else
        echo "❌ File '$1' SHOULD NOT be present but was found!"
    fi
}

check_file_renamed() {
    if [ ! -f "$1" ] && [ -f "$2" ]; then
        echo "✅ File '$1' has been renamed to '$2'."
    else
        echo "❌ File rename check failed! Either '$1' still exists or '$2' is missing."
    fi
}

# Function to check if content is present in a file
check_content_presence() {
    if grep -q "$2" "$1"; then
        log 1 "✅ Content '$2' found in '$1'."
    else
        log 1 "❌ Content '$2' NOT found in '$1'."
    fi
}

# Function to check if content is absent in a file
check_content_absence() {
    if grep -q "$2" "$1"; then
        log 1 "❌ Content '$2' SHOULD NOT be in '$1' but was found!"
    else
        log 1 "✅ Content '$2' is NOT present in '$1' as expected."
    fi
}

log 1 "${CYAN}Checking the watermarks${NC}"

# Loop through each check in the CHECKS variable
while IFS= read -r check; do
    # Ignore empty lines
    [[ -z "$check" ]] && continue

    # Split the string using the delimiter "|"
    TYPE=$(echo "$check" | cut -d '|' -f 1)
    PARAM0=$(echo "$check" | cut -d '|' -f 2)
    PARAM1=$(echo "$check" | cut -d '|' -f 3)

    # Trim leading and trailing spaces using sed
    TYPE=$(echo "$TYPE" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    PARAM0=$(echo "$PARAM0" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    PARAM1=$(echo "$PARAM1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    case "$TYPE" in
        "file_presence")
            check_file_presence "${PARAM0}"
            ;;
        "content_presence")
            check_content_presence "${PARAM0}" "${PARAM1}"
            ;;
        "file_absence")
            check_file_absence "${PARAM0}"
            ;;
        "content_absence")
            check_content_absence "${PARAM0}" "${PARAM1}"
            ;;
        "file_renamed")
            check_file_renamed "${PARAM0}" "${PARAM1}"
            ;;
        *)
            echo "❌ Unknown check type: '$TYPE'. Please set a valid TYPE."
            ;;
    esac
done <<< "$Watermarks"


# Print the latest git commit log to check the timestamp of the last commit
log 2 "Echoing the log of the latest commit."
if [ ! -z "$StudentAccountName" ]
then
    log 1 "${CYAN}Latest Git commit timestamp: ${NC}"
    exec_command "cd $StudentFolder"
    exec_command "git log -1"
else
    log 2 "No students account name specified. Skipped this check"
fi

# Finally, return to the start folder
log 1 "${CYAN}Return to the start folder${NC}"
cd $StartFolder
# End of file