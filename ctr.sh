#!/bin/bash
# Clean the project repository

#===================== INITIAL CONFIGURATION ==================================
# Remember the start folder on startup
set StartFolder=pwd

# Read the environment variables file
set -o allexport
source .env
set +o allexport

# =================== Use GIT to reset the project ==========================
# Switch to the project folder
cd $ProjectFolder
echo "Reset the base project folder to the HEAD version in git"
git reset --hard
# also remove untracked files and folders
git clean -fd

# ======= Run some composer and artisan commands to reset the app ===========
echo ""
cd $ProjectFolder
echo "Update autoload file"
./vendor/bin/sail composer dump-autoload

echo ""
echo "Clear all the compiled views"
./vendor/bin/sail artisan view:clear

echo ""
echo "Make fresh database and seed it"
./vendor/bin/sail artisan migrate:fresh --seed

# ===================== Finishing up ==========================================
# Finally, return to the start folder
cd $StartFolder