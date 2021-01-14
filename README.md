![Logo of the project](https://avatars3.githubusercontent.com/u/40756580?s=200&v=4)

# CasusToetsCopy (ctc)

Copies all the relevant folders from one specific student repository folder to a base project folder
and resets the app so that the students elaboration can be tested.

## Features

What's all the bells and whistles this project can perform?
* Resets the project folder to HEAD in git
* Pulls latest code from student repository
* Copies app, database, resources and other relevant folders
* Regenerates autoload files
* Drop database tables and performs migration and seed
* Clears compiled views

## Installation

Make sure the base repository of the casustoets project is correctly set up 
with laradock and the laradock workspace is up.

Copy the ctc.bat anywhere on your harddrive

Create a .env file in the same path. You can use the .env.example file.

Edit .env:
* Set ProjectFolder to the base project folder
* Set StudentsBaseFolder to the folder where all student repositories are 
located
* Set Laradock folder to the folder (relative to ProjectFolder) where 
docker-compose commands can be executed
* Set FileArray to a list of file and folder names in the root of the project 
that should be copied


## Usage

Open a cmd in the folder where ctc.bat is located, and type:

```shell script
> ctc student-repo-folder-name
```

## Authors

* **Daan de Waard** - *Initial work* - [dwaard](https://github.com/dwaard)

See also the list of [contributors](https://github.com/HZ-HBO-ICT/ctc/graphs/contributors) who 
participated in this project.

## Licensing

The code in this project is licensed under MIT license.
