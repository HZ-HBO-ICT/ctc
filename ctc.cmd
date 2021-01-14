@ECHO OFF

REM ======================== READ CONFIG FROM .ENV ============================
setlocal EnableDelayedExpansion
FOR /f "delims=" %%x IN (.env) DO (
  REM Set the loop param into a variable
  SET "var=%%x"
  REM Skip all lines that start with "#"
  IF NOT "!var:~0,1!"=="#" (
    REM Set the variable  
    SET "!var!"
  )
)

REM ========================= Validate user input =============================
IF "%1"=="" GOTO HelpBasic

REM Assign and validate student folder
SET Student=%1
SET StudentFolder=%StudentsBaseFolder%\%Student%
REM GOTO End
IF NOT EXIST %StudentFolder% GOTO HelpFolderNotExist

REM Remember the current folder
SET StartFolder=%__CD__%

REM ================= Pull code from student repository =======================
ECHO Pull latest code from %Student% github repository 
CD %StudentFolder%
git pull origin %Branch%
IF %ERRORLEVEL% GEQ 1 GOTO Error
CD %ProjectFolder%

REM =================== Use GIT to reset the project ==========================
REM Switch to the project folder
CD %ProjectFolder%
ECHO Reset the base project folder to the HEAD version in git
git reset --hard
IF %ERRORLEVEL% GEQ 1 GOTO Error
REM also remove untracked files and folders
git clean -fd
IF %ERRORLEVEL% GEQ 1 GOTO Error

REM ================= Remove and copy files and folders =======================
ECHO.
ECHO Copy files and folders from %Student% working copy
FOR %%f IN (%FileArray%) DO (
    SET "var=%%f"
    ECHO !var! 

    REM Set source and destination folders
    CALL SET SourceFile=%StudentFolder%\!var!
    CALL SET DestFile=!var!

    REM Check whether SourceFile is a file or folder
    IF EXIST !SourceFile!\* (
        REM Clear old destination folder
        IF EXIST !DestFile! (
            RD /S /Q !DestFile!
            MD !DestFile!
        )
        REM Copy from source to destination
        XCOPY !SourceFile! !DestFile! /E /H /C /R /Q /Y
    ) ELSE (
        REM Remove old destination file
        IF EXIST !DestFile! (
            DEL !DestFile!
        )
        REM Copy from source to destination
        COPY !SourceFile! !DestFile!
    )
)

REM =================== Open student repo in browser ==========================
ECHO.
ECHO Launching Chrome for Github repository...
START Chrome %GithubBaseURL%%Student%

REM ======= Run some composer and artisan commands to reset the app ===========
ECHO.
CD %LaradockFolder%
ECHO Update autoload file
docker-compose exec workspace composer dump-autoload
IF %ERRORLEVEL% GEQ 1 GOTO Error
ECHO.
ECHO Make fresh database and seed it
docker-compose exec workspace php artisan migrate:fresh --seed
IF %ERRORLEVEL% GEQ 1 GOTO Error
ECHO.
ECHO Clear all the compiled views
docker-compose exec workspace php artisan view:clear
IF %ERRORLEVEL% GEQ 1 GOTO Error

REM ============ Change to the folder that was on the start of the ============
CD %StartFolder%

REM ============= Start Chrome browser with localhost URL =====================
ECHO.
ECHO Launching Chrome for localhost...
START Chrome localhost 

ECHO.
ECHO Done setting up %Student%! Enjoy Grading
GOTO End

REM ================ HELP MESSAGES ============================================
:HelpBasic
    ECHO No folder name specified
    ECHO usage: ctc valid-folder-name
GOTO End

:HelpFolderNotExist
    ECHO %StudentFolder% does not exist
GOTO End

:Error
ECHO The last command failed with error code %ERRORLEVEL%
REM ============================= END OF BATCH FILE ===========================
:End
CD %StartFolder%