#!/bin/bash

GENERAL_THUMB="thumbnails/junk_rituals_thumb.jpg"
MASTERINDEX_THUMB="thumbnails/junk_rituals_thumb.jpg"
HTMLDEST=/home/$USER/htdocs/npisanti-nocms/html_output

THUMBSIZE=80

POSTPERPAGE=8
RSSMAXPOSTS=6

cd ~/htdocs/npisanti-nocms
mkdir -p $HTMLDEST 
rm -rf $HTMLDEST/journal
mkdir -p $HTMLDEST/journal
rm $HTMLDEST/*

# makes the things page -----------------------------------------------
echo "<!DOCTYPE html>" >> $HTMLDEST/things.html
echo "<html>" >> $HTMLDEST/things.html
echo "<head>" >> $HTMLDEST/things.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/things.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/things.html
cat input/base/head.html >> $HTMLDEST/things.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/index.html
echo "<meta property=\"og:image:height\" content=\"230\" />" >> $HTMLDEST/things.html
echo "<meta property=\"og:image:width\" content=\"230\" />" >> $HTMLDEST/things.html
echo "</head>" >> $HTMLDEST/things.html
echo "<body>" >> $HTMLDEST/things.html
cat input/base/thingsheader.html >> $HTMLDEST/things.html
cat input/sections/things.html >> $HTMLDEST/things.html
echo "</body>" >> $HTMLDEST/things.html
echo "</html>" >> $HTMLDEST/things.html

# make the real index page -------------------------------------------
echo "<!DOCTYPE html>" >> $HTMLDEST/xedni.html
echo "<html>" >> $HTMLDEST/xedni.html
echo "<head>" >> $HTMLDEST/xedni.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/xedni.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/xedni.html
cat input/base/head.html >> $HTMLDEST/xedni.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/xedni.html
echo "<meta property=\"og:image:height\" content=\"230\" />" >> $HTMLDEST/xedni.html
echo "<meta property=\"og:image:width\" content=\"230\" />" >> $HTMLDEST/xedni.html
echo "</head>" >> $HTMLDEST/xedni.html
echo "<body>" >> $HTMLDEST/xedni.html
cat input/base/thingsheader.html >> $HTMLDEST/xedni.html
cat input/sections/xedni.html >> $HTMLDEST/xedni.html
echo "</body>" >> $HTMLDEST/xedni.html
echo "</html>" >> $HTMLDEST/xedni.html

# generate contact 
echo "Processing contact file..."
echo "<!DOCTYPE html>" >> $HTMLDEST/contact.html
echo "<html>" >> $HTMLDEST/contact.html
echo "<head>" >> $HTMLDEST/contact.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/contact.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/contact.html
cat input/base/head.html >> $HTMLDEST/contact.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/contact.html
echo "</head>" >> $HTMLDEST/contact.html
echo "<body>" >> $HTMLDEST/contact.html
cat input/sections/contact.html >> $HTMLDEST/contact.html
echo "</body></html>" >> $HTMLDEST/contact.html


cat input/base/rssbase.xml >> $HTMLDEST/journal/rss.xml

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
        echo "<meta charset=\"utf-8\"/>" >> "$HTMLDEST/$filename"
        echo "<title>$name</title>" >> "$HTMLDEST/$filename"
        cat input/base/head.html >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image\" content=\"$image\" />" >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image:width\" content=\"230\" />" >> "$HTMLDEST/$filename"
        echo "<meta property=\"og:image:height\" content=\"230\" />" >> "$HTMLDEST/$filename"
        echo "</head>" >> "$HTMLDEST/$filename"
        
        echo "<body>" >> "$HTMLDEST/$filename"
        cat input/base/thingsheader.html >> "$HTMLDEST/$filename"
        sed -i -e "s|things|[ things ]|g" "$HTMLDEST/$filename"
        #cat input/base/headerblock.html >> "$HTMLDEST/$filename"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$filename"
        cat input/sections/$filename >> "$HTMLDEST/$filename"
        echo "</section>" >> "$HTMLDEST/$filename"
        echo "</body></html>" >> "$HTMLDEST/$filename"
        
done < "$inputlist"

#cp -avr input/data $HTMLDEST/data
cp input/base/style.css $HTMLDEST/style.css

# --------------------------------------------------------------------
# ---------------- MAKES THE JOURNAL ---------------------------------
# --------------------------------------------------------------------
echo "--- REGENERATING JOURNAL ---"

# journalindex head ----------
echo "<!DOCTYPE html>" >> "$HTMLDEST/journal/journalindex.html"
echo "<html>" >> "$HTMLDEST/journal/journalindex.html"
echo "<head>" >> "$HTMLDEST/journal/journalindex.html"
echo "<meta charset=\"utf-8\"/>" >> "$HTMLDEST/journal/journalindex.html"
echo "<title>npisanti.com</title>" >> "$HTMLDEST/journal/journalindex.html"
cat input/base/head.html >> "$HTMLDEST/journal/journalindex.html"
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/journal/journalindex.html"
echo "</head>" >> "$HTMLDEST/journal/journalindex.html"
echo "<body>" >> "$HTMLDEST/journal/journalindex.html"
cat input/base/postpageheader.html >> "$HTMLDEST/journal/journalindex.html"
echo "<section class=\"center fill\">" >> "$HTMLDEST/journal/journalindex.html"
# --------------------------

post=0
page=0
monthcursor=13
yearcursor=1999
lastyear=2014
lastbuild="never"

for f in $(ls -1 input/journal | sort -r)
do
    filename=${f##*/}
    year=${filename:0:4}
    month=${filename:5:2}
    day=${filename:8:2}
    
    title=${filename:12}
    title=${title%".html"}
    title=${title//_/ }

    pagefolder="$HTMLDEST/journal/"
    mkdir -p $pagefolder
    pagepath="$pagefolder/page$page.html"
    
    #generate corresponding page
    if (("$post" == 0)); then 
        page=$(( $page +1 ))
        echo "- generating page $page"
        pagepath="$pagefolder/page$page.html"
        
        # generate head of page
        echo "<!DOCTYPE html>" >> "$pagepath"
        echo "<html>" >> "$pagepath"
        echo "<head>" >> "$pagepath"
        echo "<meta charset=\"utf-8\"/>" >> "$pagepath"
        echo "<title>npisanti.com</title>" >> "$pagepath"
        cat input/base/head.html >> "$pagepath"
        echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$pagepath"
        echo "</head>" >> "$pagepath"
        echo "<body>" >> "$pagepath"
        cat input/base/postpageheader.html >> "$pagepath"
    fi 

    echo "Processing $filename | post $post | page $page"
    
    # ---------------- generate individual page ----------------------
    echo "<!DOCTYPE html>" >> "$HTMLDEST/journal/$filename"
    echo "<html>" >> "$HTMLDEST/journal/$filename"
    echo "<head>" >> "$HTMLDEST/journal/$filename"
    echo "<meta charset=\"utf-8\"/>" >> "$HTMLDEST/journal/$filename"
    echo "<title>npisanti.com</title>" >> "$HTMLDEST/journal/$filename"
    cat input/base/head.html >> "$HTMLDEST/journal/$filename"
    echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/journal/$filename"
    echo "</head>" >> "$HTMLDEST/journal/$filename"
    echo "<body>" >> "$HTMLDEST/journal/$filename"
    cat input/base/postheader.html >> "$HTMLDEST/journal/$filename"
    echo "<section class=\"center fill\">" >> "$HTMLDEST/journal/$filename"
    cat input/journal/$filename >> "$HTMLDEST/journal/$filename"
    echo "</section>" >> "$HTMLDEST/journal/$filename"
    echo "</body></html>" >> "$HTMLDEST/journal/$filename" 
    #sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/$filename" 
    sed -i -e "s|POSTPAGEURLPLACEHOLDER|http://npisanti.com/journal/page$page.html|g" "$HTMLDEST/journal/$filename" 
        
    # ----------------------------------------------------------------
    
    # ------------ adds post to page ----------
    echo "<section class=\"center fill\">" >> "$pagepath"
    cat input/journal/$filename >> "$pagepath"
    echo "<br><br><div style="text-align:right"><a href="http://npisanti.com/journal/$filename">posted on $year/$month/$day</a> </div>" >> "$pagepath"
    echo "</section>" >> "$pagepath"
    # -----------------------------------------

    # ------------ adds post to rss for page 1 ----------
    if (("$page" == 1)); then 
        RFC822TIME=$(date --date=$month/$day/$year -R)
        if (("$post" == 0)); then 
            lastyear="$year"
            lastbuild="$RFC822TIME"
        fi
        if [ "$post" -lt "$RSSMAXPOSTS" ]; then 
            echo -e "\t\t<item>" >> $HTMLDEST/journal/rss.xml
            echo -e "\t\t\t<title>$title</title>" >> $HTMLDEST/journal/rss.xml
            echo -e "\t\t\t<description><![CDATA[" >> $HTMLDEST/journal/rss.xml
            cat input/journal/$filename >> $HTMLDEST/journal/rss.xml
            echo -e "\t\t\t]]></description>" >> $HTMLDEST/journal/rss.xml
            echo -e "\t\t\t<pubDate>$RFC822TIME</pubDate>" >> $HTMLDEST/journal/rss.xml
            echo -e "\t\t\t<guid>http://npisanti.com/journal/$filename</guid>" >> $HTMLDEST/journal/rss.xml
            echo -e "\t\t</item>" >> $HTMLDEST/journal/rss.xml
        fi
    fi
    # -----------------------------------------

    
    if [ "$month" -ne "$monthcursor" ]; then
        echo "<br>" >> "$HTMLDEST/journal/journalindex.html" 
    fi
    monthcursor=$month
    
    if [ "$year" -ne "$yearcursor" ]; then
        echo "<br>" >> "$HTMLDEST/journal/journalindex.html" 
    fi
    yearcursor=$year

    
    echo "<a href="$filename">$year/$month/$day :</a> $title<br>" >> "$HTMLDEST/journal/journalindex.html" 
    
    post=$(( $post +1 ))
    if (("$post" == "$POSTPERPAGE")); then 
        post=0
        # generate tail of page 
        cat input/base/postpagefooter.html >> "$pagepath"
        echo "</body></html>" >> "$pagepath" 
        #sed -i -e "s|style.css|../style.css|g" "$pagepath" 
    fi
done

echo "<br><br>" >> "$HTMLDEST/journal/journalindex.html" 

# generate tail of page for last blog page
if (("$post" != 0)); then 
    cat input/base/postpagefooter.html >> "$pagepath"
    echo "</body></html>" >> "$pagepath" 
    #sed -i -e "s|style.css|../style.css|g" "$pagepath" 
fi

# journalindex tail 
echo "</section>" >> "$HTMLDEST/journal/journalindex.html"
echo "</body></html>" >> "$HTMLDEST/journal/journalindex.html" 
#sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/journalindex.html" 

# rss tail 
echo -e "\t</channel>" >> $HTMLDEST/journal/rss.xml
echo "</rss>" >> $HTMLDEST/journal/rss.xml
sed -i -e "s|LASTYEARPLACEHOLDER|$lastyear|g" "$HTMLDEST/journal/rss.xml"  
sed -i -e "s|LASTBUILDPLACEHOLDER|$lastbuild|g" "$HTMLDEST/journal/rss.xml"  

# generate navigation pages 
echo "generating navigation bars..."
for ((i=1;i<=page;i++)); do
    navigation=""
    navigation="$navigation<a href=\"http://npisanti.com/journal/journalindex.html\">all</a> "

    for ((k=1;k<=page;k++)); do
        if (("$k" == "$i")); then 
            navigation="$navigation<a href=\"http://npisanti.com/journal/page$k.html\">[$k]</a> "
        else
            navigation="$navigation<a href=\"http://npisanti.com/journal/page$k.html\">$k</a> "
        fi
    done

    navigation="$navigation\&nbsp;\&nbsp;"
    
    if [ "$i" -ne "1" ]; then 
        prev=$(( $i - 1 ))
        navigation="$navigation<a href=\"http://npisanti.com/journal/page$prev.html\">prev</a> "
    fi
    if [ "$i" -ne "$page" ]; then 
        next=$(( $i + 1 ))
        navigation="$navigation<a href=\"http://npisanti.com/journal/page$next.html\">next</a> "
    fi
    
    sed -i -e "s|NAVIGATION_PLACEHOLDER_TOKEN|$navigation|g" "$HTMLDEST/journal/page$i.html"
done
echo "...done"

echo "copying and editing first page"
cp "$HTMLDEST/journal/page1.html" "$HTMLDEST/journal/index.html" 
cp "$HTMLDEST/journal/page1.html" "$HTMLDEST/index.html" 

exit
