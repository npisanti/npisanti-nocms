#!/bin/bash

while true; do
    read -p "the ftp transfer used in this script is not encrypted, are you behind a trusted connection? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "goodbye!"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

read -p "Username: " ftpuser
read -s -p "Password: " ftppass

ncftpput -R -v -u "$ftpuser" -p "$ftppass" ftp.npisanti.com public_html ~/htdocs/npisanti-nocms/html_output/journal/

echo "uploading index page..."

ncftpput -u "$ftpuser" -p "$ftppass" ftp.npisanti.com public_html ~/htdocs/npisanti-nocms/html_output/index.html

exit
