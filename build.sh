#!/bin/bash

THUMBSIZE=80

GENERAL_THUMB="outpost_thumb.jpg"
HTMLDEST=/home/$USER/htdocs/npisanti-nocms/html_output

#scriptdir=`dirname "$BASH_SOURCE"`
#echo "scriptdir is $scriptdir"
#cd $scriptdir

mkdir -p $HTMLDEST 
rm -rf $HTMLDEST/journal
rm $HTMLDEST/*

#make the index page
echo "<!DOCTYPE html>" >> $HTMLDEST/index.html
echo "<html>" >> $HTMLDEST/index.html
echo "<head>" >> $HTMLDEST/index.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/index.html
cat input/base/head.html >> $HTMLDEST/index.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/index.html
echo "<meta property=\"og:image:height\" content=\"230\" />" >> $HTMLDEST/index.html
echo "<meta property=\"og:image:width\" content=\"230\" />" >> $HTMLDEST/index.html
echo "</head>" >> $HTMLDEST/index.html
echo "<body>" >> $HTMLDEST/index.html
cat input/base/index.html >> $HTMLDEST/index.html
echo "</body>" >> $HTMLDEST/index.html
echo "</html>" >> $HTMLDEST/index.html

#generate pages
inputlist=input/base/thumbs.list
while read line
do
        name=$(echo $line | cut -d ';' -f1)
        image=$(echo $line | cut -d ';' -f2)
        link=$(echo $line | cut -d ';' -f3)

        #generate corresponding page
        filename=$link
        echo "Processing $filename file..."
        echo "<!DOCTYPE html>" >> "$HTMLDEST/$filename"
        echo "<html>" >> "$HTMLDEST/$filename"
        
        echo "<head>" >> "$HTMLDEST/$filename"
        echo "<title>$name</title>" >> "$HTMLDEST/$filename"
        cat input/base/head.html >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image\" content=\"$image\" />" >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image:width\" content=\"230\" />" >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image:height\" content=\"230\" />" >> "$HTMLDEST/$filename"
        echo "</head>" >> "$HTMLDEST/$filename"
        
        echo "<body>" >> "$HTMLDEST/$filename"
        cat input/base/sectionheader.html >> "$HTMLDEST/$filename"
        #cat input/base/headerblock.html >> "$HTMLDEST/$filename"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$filename"
        cat input/sections/$filename >> "$HTMLDEST/$filename"
        echo "</section>" >> "$HTMLDEST/$filename"
        echo "</body></html>" >> "$HTMLDEST/$filename"
        
done < "$inputlist"


# make the about / contact / etc pages
for f in input/extra/*
do
    filename=${f##*/}
    #generate corresponding page
        echo "Processing $filename file..."
        echo "<!DOCTYPE html>" >> "$HTMLDEST/$filename"
        echo "<html>" >> "$HTMLDEST/$filename"
        
        echo "<head>" >> "$HTMLDEST/$filename"
        echo "<title>npisanti.com</title>" >> "$HTMLDEST/$filename"
        cat input/base/head.html >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/$filename"
        echo "</head>" >> "$HTMLDEST/$filename"
        
        echo "<body>" >> "$HTMLDEST/$filename"
        #cat input/base/headerblock.html >> "$HTMLDEST/$filename"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$filename"
        cat input/extra/$filename >> "$HTMLDEST/$filename"
        echo "</section>" >> "$HTMLDEST/$filename"
        echo "</body></html>" >> "$HTMLDEST/$filename"
done

#cp -avr input/data $HTMLDEST/data
cp input/base/style.css $HTMLDEST/style.css

exit
