#!/bin/bash

#===================== INITIAL CONFIGURATION ==================================
# Validate the user input (should be done first)
if [ ! $# == 1 ] 
then
    echo "No arguments specified"
    echo "usage: $0 [valid/folder/name]"
    exit 1
fi
StudentAccountName=$1

# Remember the start folder on startup
set StartFolder=pwd

# Read the environment variables file
set -o allexport
source .env
set +o allexport


# Assign and validate student folder
StudentFolder="$StudentsBaseFolder/$StudentAccountName"
# IF NOT EXIST %StudentFolder% GOTO HelpFolderNotExist
if [ ! -d $StudentFolder ]
then
    echo "$StudentFolder does not exist"
    exit 1
fi
echo "Student code folder is: $StudentFolder"

# ================= Pull code from student repository =======================
echo ""
StudentRepo="$GithubBaseURL$StudentAccountName"
echo "Pull latest code from github repository: $StudentRepo $Branch" 
# cd $StudentFolder
# git pull origin $Branch

# =================== Use GIT to reset the project ==========================
# Switch to the project folder
echo ""
cd $ProjectFolder
echo "Reset the base project folder to the HEAD version in git"
git reset --hard
# also remove untracked files and folders
git clean -fd

# ======================== Copy files and folders ===========================
echo ""
echo "Copy files and folders from $StudentAccountName working copy"
# Parse $FileArray into an array
IFS=' ' read -r -a FileArray <<< "$Files"
# Loop through each element in the array
for Filename in "${FileArray[@]}"
do
    echo "Copying $Filename"
    cp -r $StudentFolder/$Filename .
done

# =================== Open student repo in browser ==========================
echo ""
echo "Launching Chrome for Github repository..."
if explorer.exe $StudentRepo; then
    explorer.exe $StudentRepo
elif  [ -n $BROWSER ]; then
  $BROWSER $StudentRepo
elif which xdg-open > /dev/null; then
  xdg-open $StudentRepo
elif which gnome-open > /dev/null; then
  gnome-open $StudentRepo
else
  echo "Could not detect the web browser to use."
fi


# ======= Run some composer and artisan commands to reset the app ===========
echo ""
cd $ProjectFolder
echo "Update autoload file"
./vendor/bin/sail composer dump-autoload

echo ""
echo "Clear all the compiled views"
./vendor/bin/sail artisan view:clear

echo ""
echo "Make fresh database"
./vendor/bin/sail artisan migrate:fresh

echo "Seed the database"
./vendor/bin/sail artisan db:seed

# Finally, return to the start folder
cd $StartFolder