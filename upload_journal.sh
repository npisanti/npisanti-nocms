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

echo ""

for d in input/journal/*/ ; do
    dirname=$(echo $d | cut -d '/' -f3)
    echo "uploading folder $dirname"
    ncftpput -R -v -u "$ftpuser" -p "$ftppass" ftp.npisanti.com public_html "~/htdocs/npisanti-nocms/html_output/$dirname/"
done

echo "uploading main"
ncftpput -R -v -u "$ftpuser" -p "$ftppass" ftp.npisanti.com public_html "~/htdocs/npisanti-nocms/html_output/main/"

echo "uploading index page..."
ncftpput -u "$ftpuser" -p "$ftppass" ftp.npisanti.com public_html ~/htdocs/npisanti-nocms/html_output/index.html

echo "uploading channels page..."
ncftpput -u "$ftpuser" -p "$ftppass" ftp.npisanti.com public_html ~/htdocs/npisanti-nocms/html_output/channels.html

exit
