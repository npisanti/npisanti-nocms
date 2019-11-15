#!/bin/bash

# --------------------------------------------------------------------
# ---------------- FUNCTIONS -----------------------------------------
# --------------------------------------------------------------------
build_navigation_footer(){
    # generate navigation pages 
    navfold="$1"
    numpage="$2"
    archive_enable="$3"

    echo "generating navigation bars..."
    for ((i=1;i<=numpage;i++)); do
        navigation=""
        
        if [ ! -z "$archive_enable" ]; then 
            navigation="$navigation<a href=\"archive.html\">all</a> "        
        fi

        for ((k=1;k<=numpage;k++)); do
            if (("$k" == "$i")); then 
                navigation="$navigation<a href=\"page$k.html\">[$k]</a> "
            else
                navigation="$navigation<a href=\"page$k.html\">$k</a> "
            fi
        done

        navigation="$navigation\&nbsp;\&nbsp;"
        
        if [ "$i" -ne "1" ]; then 
            prev=$(( $i - 1 ))
            navigation="$navigation<a href=\"page$prev.html\">prev</a> "
        fi
        if [ "$i" -ne "$numpage" ]; then 
            next=$(( $i + 1 ))
            navigation="$navigation<a href=\"page$next.html\">next</a> "
        fi
        
        sed -i -e "s|NAVIGATION_PLACEHOLDER_TOKEN|$navigation|g" "$navfold/page$i.html"
    done
    echo "...done"    
}

# --------------------------------------------------------------------
# ---------------- SCRIPT --------------------------------------------
# --------------------------------------------------------------------

GENERAL_THUMB="avatars/avatar_og.png"
MASTERINDEX_THUMB="avatars/avatar_og.png"
HTMLDEST=/home/$USER/htdocs/npisanti-nocms/html_output

THUMBSIZE=80
POSTPERPAGE=8
RSSMAXPOSTS=6

THUMBSIZE=80

POSTPERPAGE=8
RSSMAXPOSTS=6

cd ~/htdocs/npisanti-nocms
mkdir -p $HTMLDEST 
rm -rf $HTMLDEST/journal
rm -rf $HTMLDEST/main

echo "REMOVING FOLDERS"
for d in input/journal/*/ ; do
    dirname=$(echo $d | cut -d '/' -f3)
    rm -rf "$HTMLDEST/$dirname"
done

rm $HTMLDEST/*

mkdir -p $HTMLDEST/main

for d in input/journal/*/ ; do
    dirname=$(echo $d | cut -d '/' -f3)
    mkdir -p "$HTMLDEST/$dirname"
done

cp input/base/style.css $HTMLDEST/style.css


# makes the tools page -----------------------------------------------
echo "<!DOCTYPE html>" >> $HTMLDEST/tools.html
echo "<html>" >> $HTMLDEST/tools.html
echo "<head>" >> $HTMLDEST/tools.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/tools.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/tools.html
cat input/base/head.html >> $HTMLDEST/tools.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/index.html
echo "<meta property=\"og:image:height\" content=\"230\" />" >> $HTMLDEST/tools.html
echo "<meta property=\"og:image:width\" content=\"230\" />" >> $HTMLDEST/tools.html
echo "</head>" >> $HTMLDEST/tools.html
echo "<body>" >> $HTMLDEST/tools.html
cat input/base/toolsheader.html >> $HTMLDEST/tools.html
cat input/pages/tools.html >> $HTMLDEST/tools.html
echo "</body>" >> $HTMLDEST/tools.html
echo "</html>" >> $HTMLDEST/tools.html

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
cat input/pages/contact.html >> $HTMLDEST/contact.html
echo "</body></html>" >> $HTMLDEST/contact.html

# generate tcatnoc 
echo "Processing tcatnoc file..."
echo "<!DOCTYPE html>" >> $HTMLDEST/tcatnoc.html
echo "<html>" >> $HTMLDEST/tcatnoc.html
echo "<head>" >> $HTMLDEST/tcatnoc.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/tcatnoc.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/tcatnoc.html
cat input/base/head.html >> $HTMLDEST/tcatnoc.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/tcatnoc.html
echo "</head>" >> $HTMLDEST/tcatnoc.html
echo "<body>" >> $HTMLDEST/tcatnoc.html
cat input/pages/tcatnoc.html >> $HTMLDEST/tcatnoc.html
echo "</body></html>" >> $HTMLDEST/tcatnoc.html

# generate channels page 
echo "Processing channels file..."
echo "<!DOCTYPE html>" >> $HTMLDEST/channels.html
echo "<html>" >> $HTMLDEST/channels.html
echo "<head>" >> $HTMLDEST/channels.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/channels.html
echo "<title>npisanti.com</title>" >> $HTMLDEST/channels.html
cat input/base/head.html >> $HTMLDEST/channels.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/channels.html
echo "</head>" >> $HTMLDEST/channels.html
echo "<body>" >> $HTMLDEST/channels.html
cat input/pages/channels.html >> $HTMLDEST/channels.html
echo "</body></html>" >> $HTMLDEST/channels.html

echo "--- generating pages ---"
#generate pages
inputlist=input/base/thumbs.list
while read line
do
        name=$(echo $line | cut -d ';' -f1)
        image=$(echo $line | cut -d ';' -f2)
        link=$(echo $line | cut -d ';' -f3)

        #generate corresponding page
        filename=$link
        #echo "Processing $filename file..."
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
        cat input/base/toolsheader.html >> "$HTMLDEST/$filename"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$filename"
        cat input/pages/$filename >> "$HTMLDEST/$filename"
        echo "</section>" >> "$HTMLDEST/$filename"
        echo "</body></html>" >> "$HTMLDEST/$filename"
        
        sed -i -e "s|SITEROOTPATH/||g" "$HTMLDEST/$filename"
done < "$inputlist"

# --------------------------------------------------------------------
# ---------------- MAKES THE FEED ------------------------------------
# --------------------------------------------------------------------
echo "--- REGENERATING FEED ---"

post=0
page=0
monthcursor=13
yearcursor=1999
lastyear=2014
lastbuild="never"

#generate pages
inputlist=input/journal/feed.list
while read line
do
    if [ ! -z "$line" -a "$line" != " " ]; then 
    
        postpath="input/journal/$line"  
        filename=$(echo $line | cut -d '/' -f2)
        user=$(echo $line | cut -d '/' -f1)
        
        #filename=${f##*/}
        year=${filename:0:4}
        month=${filename:5:2}
        day=${filename:8:2}
        
        title=${filename:12}
        title=${title%".html"}
        title=${title//_/ }
        
        pagelink=${filename:12}

        pagefolder="$HTMLDEST/main/"
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
            cat input/journal/feedheader.html >> "$pagepath"
        fi 

        #echo "Processing $postpath | post $post | page $page"
        
        # ------------ adds post to page ----------
        echo "<section class=\"center fill\">" >> "$pagepath"
        cat $postpath >> "$pagepath"

        echo "<br><br><div style=\"text-align:right\"><a href=\"../$user/$pagelink\">posted</a> in <a href=\"../$user/index.html\">$user</a></div>" >> "$pagepath"
        
        echo "</section>" >> "$pagepath"
        # -----------------------------------------

        post=$(( $post +1 ))
        if (("$post" == "$POSTPERPAGE")); then 
            post=0
            # generate tail of page 
            cat input/base/postpagefooter.html >> "$pagepath"
            echo "</body></html>" >> "$pagepath" 
        fi
    fi
done < "$inputlist"

# generate tail of page for last blog page
if (("$post" != 0)); then 
    cat input/base/postpagefooter.html >> "$pagepath"
    echo "</body></html>" >> "$pagepath" 
    sed -i -e "s|DATAPATH|$datapath|g" "$pagepath" 
fi

echo "FINISHED BUILDING FEED"

build_navigation_footer "$HTMLDEST/main" $page

#echo "copying and editing first page"
cp "$HTMLDEST/main/page1.html" "$HTMLDEST/main/index.html" 

echo "TWEAKING SITE INDEX"

cp "$HTMLDEST/main/page1.html" "$HTMLDEST/index.html" 
sed -i -e "s|../index|index|g" "$HTMLDEST/index.html" 
sed -i -e "s|../tools|tools|g" "$HTMLDEST/index.html" 
sed -i -e "s|../channels|channels|g" "$HTMLDEST/index.html" 
sed -i -e "s|../contact|contact|g" "$HTMLDEST/index.html" 
sed -i -e "s|../rss|rss|g" "$HTMLDEST/index.html" 
sed -i -e "s|href=\"page|href=\"main/page|g" "$HTMLDEST/index.html" 
sed -i -e "s|style=\"text-align:right\"><a href=\"../|style=\"text-align:right\"><a href=\"|g" "$HTMLDEST/index.html" 
sed -i -e "s|in <a href=\"|in <a href=\"main/|g" "$HTMLDEST/index.html" 

# -------------- generates individual journals ---------------

for d in input/journal/*/ ; do

    dirname=$(echo $d | cut -d '/' -f3)
    echo "---- generating $dirname's feed ----"

    post=0
    page=0
    monthcursor=13
    yearcursor=1999
    lastyear=2014
    lastbuild="never"
    
    for f in $(ls -1 "$d" | sort -r)
    do
        postpath="$f"  
        filename=${f##*/}
        year=${filename:0:4}
        month=${filename:5:2}
        day=${filename:8:2}
        
        title=${filename:12}
        title=${title%".html"}
        title=${title//_/ }    
        
        pagelink=${filename:12}
        
        pagefolder="$HTMLDEST/$dirname/"
        mkdir -p $pagefolder
        pagepath="$pagefolder/page$page.html"
        
        #generate corresponding page
        if (("$post" == 0)); then 
            page=$(( $page +1 ))
            #echo "- generating page $page"
            pagepath="$pagefolder/page$page.html"
            
            # generate head of page
            echo "<!DOCTYPE html>" >> "$pagepath"
            echo "<html>" >> "$pagepath"
            echo "<head>" >> "$pagepath"
            echo "<meta charset=\"utf-8\"/>" >> "$pagepath"
            echo "<title>[ $dirname ]</title>" >> "$pagepath"
            cat input/base/head.html >> "$pagepath"
            echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$pagepath"
            echo "</head>" >> "$pagepath"
            echo "<body>" >> "$pagepath"
            cat input/journal/channelheader.html >> "$pagepath"
        fi 

        #echo "Processing $postpath | post $post | page $page"
        
        # ------------ adds post to page ----------
        echo "<section class=\"center fill\">" >> "$pagepath"
        cat "input/journal/$dirname/$postpath" >> "$pagepath"

        echo "<br><br><div style="text-align:right"><a href="../$dirname/$pagelink">posted</a> in <a href="../$dirname/index.html">$dirname</a></div>" >> "$pagepath"
        
        echo "</section>" >> "$pagepath"
        # -----------------------------------------

        post=$(( $post +1 ))
        if (("$post" == "$POSTPERPAGE")); then 
            post=0
            # generate tail of page 
            cat input/base/postpagefooter.html >> "$pagepath"
            echo "</body></html>" >> "$pagepath" 
        fi
    done 

    # generate tail of page for last blog page
    if (("$post" != 0)); then 
        cat input/base/postpagefooter.html >> "$pagepath"
        echo "</body></html>" >> "$pagepath" 
    fi

    build_navigation_footer "$HTMLDEST/$dirname" $page yes
    
    cp "$HTMLDEST/$dirname/page1.html" "$HTMLDEST/$dirname/index.html" 
done


# -------------- generates archives ---------------
for d in input/journal/*/ ; do
    dirname=$(echo $d | cut -d '/' -f3)
    echo "---- generating $dirname's archive and posts ----"

    post=0
    page=1
    monthcursor=13
    yearcursor=1999
    lastyear=2014
    lastbuild="never"
    
    # archive head ----------
    echo "<!DOCTYPE html>" >> "$HTMLDEST/$dirname/archive.html"
    echo "<html>" >> "$HTMLDEST/$dirname/archive.html"
    echo "<head>" >> "$HTMLDEST/$dirname/archive.html"
    echo "<meta charset=\"utf-8\"/>" >> "$HTMLDEST/$dirname/archive.html"
    echo "<title>npisanti.com</title>" >> "$HTMLDEST/$dirname/archive.html"
    cat input/base/head.html >> "$HTMLDEST/$dirname/archive.html"
    echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/$dirname/archive.html"
    echo "</head>" >> "$HTMLDEST/$dirname/archive.html"
    echo "<body>" >> "$HTMLDEST/$dirname/archive.html"
    cat input/journal/channelheader.html >> "$HTMLDEST/$dirname/archive.html"
    echo "<section class=\"center fill\"><br>" >> "$HTMLDEST/$dirname/archive.html"
    
    echo "$dirname's archive<br><br>" >> "$HTMLDEST/$dirname/archive.html"
    
    # --------------------------

    for f in $(ls -1 "$d" | sort -r)
    do
        postpath="$f"  
        filename=${f##*/}
        year=${filename:0:4}
        month=${filename:5:2}
        day=${filename:8:2}
        
        title=${filename:12}
        title=${title%".html"}
        title=${title//_/ }    
        
        postlink=${filename:12}
    
        pagefolder="$HTMLDEST/$dirname/"
        
        echo "<a href="$postlink">$title</a><br>" >> "$HTMLDEST/$dirname/archive.html" 

        # ----------- generate individual page ----------------------
        echo "<!DOCTYPE html>" >> "$HTMLDEST/$dirname/$postlink"
        echo "<html>" >> "$HTMLDEST/$dirname/$postlink"
        echo "<head>" >> "$HTMLDEST/$dirname/$postlink"
        echo "<meta charset=\"utf-8\"/>" >> "$HTMLDEST/$dirname/$postlink"
        echo "<title>[ $title ]</title>" >> "$HTMLDEST/$dirname/$postlink"
        cat input/base/head.html >> "$HTMLDEST/$dirname/$postlink"
        
        POST_OG_THUMB=`cat input/journal/$dirname/$postpath | grep og_thumb=`
        
        if [ ! -z "$POST_OG_THUMB" -a "$POST_OG_THUMB" != " " ]; then 
            OG_THUMBFILE=$(echo $POST_OG_THUMB | cut -d '=' -f2)
            echo "    <meta property=\"og:image\" content=\"http://npisanti.com/data/$OG_THUMBFILE\" />" >> "$HTMLDEST/$dirname/$postlink"            
        else
            echo "    <meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/$dirname/$postlink"
        fi
        
        echo "</head>" >> "$HTMLDEST/$dirname/$postlink"
        echo "<body>" >> "$HTMLDEST/$dirname/$postlink"
        cat input/journal/postheader.html >> "$HTMLDEST/$dirname/$postlink"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$dirname/$postlink"
        cat input/journal/$dirname/$postpath >> "$HTMLDEST/$dirname/$postlink"
        echo "</section>" >> "$HTMLDEST/$dirname/$postlink"
        echo "</body></html>" >> "$HTMLDEST/$dirname/$postlink" 
        #sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/$dirname/$postlink" 
        sed -i -e "s|HUBUSERNAME|$dirname|g" "$HTMLDEST/$dirname/$postlink"         
        sed -i -e "s|POSTPAGEURLPLACEHOLDER|page$page.html|g" "$HTMLDEST/$dirname/$postlink"         

        post=$(( $post +1 ))
        if (("$post" == "$POSTPERPAGE")); then 
            post=0
            page=$(( $page +1 ))
        fi
    done 
    
    # archive tail 
    echo "<br><br></section>" >> "$HTMLDEST/$dirname/archive.html"
    echo "</body></html>" >> "$HTMLDEST/$dirname/archive.html"
done

echo "BUILDING RSS..."

cat input/base/rssbase.xml >> $HTMLDEST/rss.xml

inputlist=input/journal/rss.list
while read line
do
    if [ ! -z "$line" -a "$line" != " " ]; then 
    
        postpath="input/journal/$line"  
        filename=$(echo $line | cut -d '/' -f2)
        user=$(echo $line | cut -d '/' -f1)
        
        #filename=${f##*/}
        year=${filename:0:4}
        month=${filename:5:2}
        day=${filename:8:2}
        
        title=${filename:12}
        title=${title%".html"}
        title=${title//_/ }
        
        pagelink=${filename:12}
        
        RFC822TIME=$(date --date=$month/$day/$year -R)

        echo -e "\t\t<item>" >> $HTMLDEST/rss.xml
        echo -e "\t\t\t<title>$title</title>" >> $HTMLDEST/rss.xml
        echo -e "\t\t\t<description><![CDATA[" >> $HTMLDEST/rss.xml
        cat $postpath >> $HTMLDEST/rss.xml
        echo -e "\t\t\t]]></description>" >> $HTMLDEST/rss.xml
        echo -e "\t\t\t<pubDate>$RFC822TIME</pubDate>" >> $HTMLDEST/rss.xml
        echo -e "\t\t\t<guid>http://npisanti.com/$user/$pagelink</guid>" >> $HTMLDEST/rss.xml
        echo -e "\t\t</item>" >> $HTMLDEST/rss.xml

    fi
done < "$inputlist"

# rss tail 
echo -e "\t</channel>" >> $HTMLDEST/rss.xml
echo "</rss>" >> $HTMLDEST/rss.xml
sed -i -e "s|LASTYEARPLACEHOLDER|$lastyear|g" "$HTMLDEST/rss.xml"  
sed -i -e "s|LASTBUILDPLACEHOLDER|$lastbuild|g" "$HTMLDEST/rss.xml"  

echo "FINISHED BUILDING RSS"

# --------------------------------------------------------------------
# ---------------- DATAPATHS -----------------------------------------
# --------------------------------------------------------------------

#sed -i -e "s|DATAPATH|$datapath|g" "$pagepath" 
for d in input/journal/*/ ; do
    dirname=$(echo $d | cut -d '/' -f3)
    for f in $(ls -1 "$HTMLDEST/$dirname" | sort -r)
    do
        #echo "operating on $HTMLDEST/$dirname/$f"
        sed -i -e "s|SITEROOTPATH|..|g" "$HTMLDEST/$dirname/$f" 
    done
done

for f in $(ls -1 "$HTMLDEST/main" | sort -r)
do
    sed -i -e "s|SITEROOTPATH|..|g" "$HTMLDEST/main/$f" 
done

sed -i -e "s|SITEROOTPATH/||g" "$HTMLDEST/index.html" 
sed -i -e "s|SITEROOTPATH/||g" "$HTMLDEST/tools.html" 
sed -i -e "s|SITEROOTPATH/||g" "$HTMLDEST/contact.html" 
sed -i -e "s|SITEROOTPATH/||g" "$HTMLDEST/tcatnoc.html" 
sed -i -e "s|SITEROOTPATH/||g" "$HTMLDEST/channels.html" 

# absolute urls to RSS 
sed -i -e "s|SITEROOTPATH|http://npisanti.com|g" "$HTMLDEST/rss.xml" 

# --------------------------------------------------------------------
# ---------------- RETROCOMPATIBILITY --------------------------------
# --------------------------------------------------------------------

mkdir -p $HTMLDEST/journal 
cp $HTMLDEST/rss.xml $HTMLDEST/journal/rss.xml 

exit
