# PRACTICA18
PRACTICA 18 - PROJECTE 03 Tasca

Exercise 03 - Deleting Local Users - Script 3
Goal:
The goal of this exercise is to create a shell script that allows for a local Linux account to be
disabled, deleted, and optionally archived.
Scenario:
Today the help desk team received a request to delete an account for a person who has changed
departments. This person doesn't have time to log into Linux systems -- they're in management
now!
The help desk team also wants to save the contents of this person's home directory just in case this
person returns to their original department and job.
They realize this is just going to be the first of these types of requests. They know they're eventually
going to receive requests to disable accounts for when people are on extended leave.
Of you course you know it's going to be way easier to write a script and hand it off than it is for you
to do all the work.
Shell Script Requirements:
You think about what the shell script must do and how you would like it operate. You come up with
the following list.
The script:
● Is named "disable-local-user.sh".
● Enforces that it be executed with superuser (root) privileges. If the script is not executed with
superuser privileges it will not attempt to create a user and returns an exit status of 1. All
messages associated with this event will be displayed on standard error.
● Provides a usage statement much like you would find in a man page if the user does not
supply an account name on the command line and returns an exit status of 1. All messages
associated with this event will be displayed on standard error.
● Disables (expires/locks) accounts by default.
● Allows the user to specify the following options:
○ -d Deletes accounts instead of disabling them.
○ -r Removes the home directory associated with the account(s).
○ -a Creates an archive of the home directory associated with the accounts(s) and stores
the archive in the /archives directory. (NOTE: /archives is not a directory that exists by
default on a Linux system. The script will need to create this directory if it does not
exist.)
○ Any other option will cause the script to display a usage statement and exit with an exit
status of 1.
● Accepts a list of usernames as arguments. At least one username is required or the script will
display a usage statement much like you would find in a man page and return an exit status of
1. All messages associated with this event will be displayed on standard error.
● Refuses to disable or delete any accounts that have a UID less than 1,000.
○ Only system accounts should be modified by system administrators. Only allow the
help desk team to change user accounts.
● Informs the user if the account was not able to be disabled, deleted, or archived for some
reason.
● Displays the username and any actions performed against the account.
