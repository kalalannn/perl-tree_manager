# TreeManager App
See Tree_manager-OA_Task.pdf for task description

## Requirements
MySQL > 10.2.1

Perl

## Usage
```
$ mysql < db_mysql/db_init.sql
$ mysql < db_mysql/db_insert_test_data.sql

$ perl Makefile.PL

$ ./script/treemanager_server.pl
```

manager_sql     is using WITH RECURSIVE

manager_perl    is using Perl recursive
