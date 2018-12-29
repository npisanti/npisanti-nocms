#!/bin/bash
if [ -z "$1" ]; then
    echo "retry using ftp username as first argument"
else
    ncftpput -R -v -u "$1" ftp.npisanti.com public_html ~/htdocs/npisanti-nocms/html_output/journal/
fi
exit
