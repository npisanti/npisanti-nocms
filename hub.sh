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
        
        sed -i -e "s|NAVIGATION_PLACEHOLDER_TOKEN|$navigation|g" "$HTMLDEST/$navfold/page$i.html"
    done
    echo "...done"    
}


# --------------------------------------------------------------------
# ---------------- SCRIPT --------------------------------------------
# --------------------------------------------------------------------

GENERAL_THUMB="thumbnails/junk_rituals_thumb.jpg"
MASTERINDEX_THUMB="thumbnails/junk_rituals_thumb.jpg"
HTMLDEST=/home/$USER/htdocs/npisanti-nocms/html_output/hub

datapath="../../data/"

THUMBSIZE=80
POSTPERPAGE=8
RSSMAXPOSTS=6

cd ~/htdocs/npisanti-nocms
mkdir -p $HTMLDEST 
rm -rf $HTMLDEST/*
mkdir -p $HTMLDEST/feed

# generate users
echo "processing users file..."
echo "<!DOCTYPE html>" >> $HTMLDEST/feed/users.html
echo "<html>" >> $HTMLDEST/feed/users.html
echo "<head>" >> $HTMLDEST/feed/users.html
echo "<meta charset=\"utf-8\"/>" >> $HTMLDEST/feed/users.html
echo "<title>[ users ]</title>" >> $HTMLDEST/feed/users.html
cat input/base/head.html >> $HTMLDEST/feed/users.html
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> $HTMLDEST/feed/users.html
echo "</head>" >> $HTMLDEST/feed/users.html
echo "<body>" >> $HTMLDEST/feed/users.html
cat input/hub/users.html >> $HTMLDEST/feed/users.html
echo "</body></html>" >> $HTMLDEST/feed/users.html

#cp -avr input/data $HTMLDEST/data
cp input/base/style.css $HTMLDEST/style.css

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
inputlist=input/hub/feed.list
while read line
do
    if [ ! -z "$line" -a "$line" != " " ]; then 
    
        postpath="input/hub/$line"  
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

        pagefolder="$HTMLDEST/feed/"
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
            echo "<title>[ the hub ]</title>" >> "$pagepath"
            cat input/base/head.html >> "$pagepath"
            echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$pagepath"
            echo "</head>" >> "$pagepath"
            echo "<body>" >> "$pagepath"
            cat input/hub/base/feedheader.html >> "$pagepath"
        fi 

        echo "Processing $postpath | post $post | page $page"
        
        # ------------ adds post to page ----------
        echo "<section class=\"center fill\">" >> "$pagepath"
        cat $postpath >> "$pagepath"

        echo "<br><br><div style="text-align:right"><a href="../$user/$pagelink">posted</a> by <a href="../$user/index.html">$user</a></div>" >> "$pagepath"
        
        echo "</section>" >> "$pagepath"
        # -----------------------------------------

        post=$(( $post +1 ))
        if (("$post" == "$POSTPERPAGE")); then 
            post=0
            # generate tail of page 
            cat input/base/postpagefooter.html >> "$pagepath"
            echo "</body></html>" >> "$pagepath" 
            sed -i -e "s|DATAPATH|$datapath|g" "$pagepath" 
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

build_navigation_footer "feed" $page

#echo "copying and editing first page"
cp "$HTMLDEST/feed/page1.html" "$HTMLDEST/feed/index.html" 
#cp "$HTMLDEST/feed/page1.html" "$HTMLDEST/index.html" 

# -------------- generates individual feeds ---------------

for d in input/hub/*/ ; do

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
            echo "- generating page $page"
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
            cat input/hub/base/userheader.html >> "$pagepath"
        fi 

        echo "Processing $postpath | post $post | page $page"
        
        # ------------ adds post to page ----------
        echo "<section class=\"center fill\">" >> "$pagepath"
        cat "input/hub/$dirname/$postpath" >> "$pagepath"

        # this has to be edited to point to users, and don't use time
        echo "<br><br><div style="text-align:right"><a href="../$dirname/$pagelink">posted</a> by <a href="../$dirname/index.html">$dirname</a></div>" >> "$pagepath"
        
        echo "</section>" >> "$pagepath"
        # -----------------------------------------

        post=$(( $post +1 ))
        if (("$post" == "$POSTPERPAGE")); then 
            post=0
            # generate tail of page 
            cat input/base/postpagefooter.html >> "$pagepath"
            echo "</body></html>" >> "$pagepath" 
            sed -i -e "s|DATAPATH|$datapath|g" "$pagepath" 
        fi
    done 

    # generate tail of page for last blog page
    if (("$post" != 0)); then 
        cat input/base/postpagefooter.html >> "$pagepath"
        echo "</body></html>" >> "$pagepath" 
        sed -i -e "s|DATAPATH|$datapath|g" "$pagepath" 
    fi

    build_navigation_footer $dirname $page yes
    
    cp "$HTMLDEST/$dirname/page1.html" "$HTMLDEST/$dirname/index.html" 
done


# -------------- generates archives ---------------
for d in input/hub/*/ ; do
    dirname=$(echo $d | cut -d '/' -f3)
    echo "---- generating $dirname's archive and posts ----"

    post=0
    page=0
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
    cat input/hub/base/userheader.html >> "$HTMLDEST/$dirname/archive.html"
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
        echo "<title>[ $dirname ]</title>" >> "$HTMLDEST/$dirname/$postlink"
        cat input/base/head.html >> "$HTMLDEST/$dirname/$postlink"
        echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/$dirname/$postlink"
        echo "</head>" >> "$HTMLDEST/$dirname/$postlink"
        echo "<body>" >> "$HTMLDEST/$dirname/$postlink"
        cat input/hub/base/postheader.html >> "$HTMLDEST/$dirname/$postlink"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$dirname/$postlink"
        cat input/hub/$dirname/$postpath >> "$HTMLDEST/$dirname/$postlink"
        echo "</section>" >> "$HTMLDEST/$dirname/$postlink"
        echo "</body></html>" >> "$HTMLDEST/$dirname/$postlink" 
        #sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/$dirname/$postlink" 
        sed -i -e "s|HUBUSERNAME|$dirname|g" "$HTMLDEST/$dirname/$postlink"         
        sed -i -e "s|DATAPATH|$datapath|g" "$HTMLDEST/$dirname/$postlink" 

        post=$(( $post +1 ))
        if (("$post" == "$POSTPERPAGE")); then 
            post=0
        fi
    done 
    
    # archive tail 
    echo "<br><br></section>" >> "$HTMLDEST/$dirname/archive.html"
    echo "</body></html>" >> "$HTMLDEST/$dirname/archive.html"
 
done

echo "copyng redirect"
cp input/hub/base/redirect.html $HTMLDEST/index.html

exit

# memo : sobstitute relative links in hub index.html or redirect to feed/index.html
