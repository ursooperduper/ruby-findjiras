ruby-findjiras
==============

A simple script that extracts a list of Jiras from its input file and looks up the Jira issue summary for each Jira key it finds.

Setup
----
To use this script, you'll need to install the following gems: 
* json 
*  curb
*  yaml

The first time you run the script, a CONFIG file (.findjiras.yaml) will be created for you in your home directory. Edit that file, then add your Jira username and password, the URL of your Jira installation, and a piped list of Jira project IDs you want to include in your search. For example:

    :username: myusername
    :password: mypassword
    :jira_url: https://myproject.atlassian.net
    :projects: CORE|API|IOS|ANDROID

Usage
-----
This script was built as a way to grab Jiras that are referenced in git logs and format them into a list with the actual Jira summary and key. 
For example: 

    git log deploy/20121025 ^deploy/20121024 --pretty=oneline | ~/code/ruby-findjiras/findjira.rb
