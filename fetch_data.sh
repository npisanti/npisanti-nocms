#!/bin/bash
echo "clearing destination folder..."
mkdir -p /home/$USER/htdocs/npisanti-nocms/html_output/data
rm -rf /home/$USER/htdocs/npisanti-nocms/html_output/data
echo "getting data..."
wget -r -np  http://npisanti.com/data/
echo "moving data..."
mv npisanti.com/data/ /home/$USER/htdocs/npisanti-nocms/html_output
echo "clearing..."
rm -rf npisanti.com
echo "done"
exit
