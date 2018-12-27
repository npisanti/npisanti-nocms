#!/bin/bash

THUMBSIZE=80

GENERAL_THUMB="thumbnails/outpost_thumb.jpg"
MASTERINDEX_THUMB="thumbnails/junk_rituals_thumb.jpg"
HTMLDEST=/home/$USER/htdocs/npisanti-nocms/html_output

POSTPERPAGE=6

mkdir -p $HTMLDEST 
rm -rf $HTMLDEST/journal
mkdir -p $HTMLDEST/journal
rm $HTMLDEST/*

#make the index page
echo "<!DOCTYPE html>" >> $HTMLDEST/index.html
echo "<html>" >> $HTMLDEST/index.html#!/bin/bash

THUMBSIZE=80

GENERAL_THUMB="thumbnails/outpost_thumb.jpg"
MASTERINDEX_THUMB="thumbnails/junk_rituals_thumb.jpg"
HTMLDEST=/home/$USER/htdocs/npisanti-nocms/html_output

POSTPERPAGE=8

mkdir -p $HTMLDEST 
rm -rf $HTMLDEST/journal
mkdir -p $HTMLDEST/journal
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
        cat input/base/sectionheader.html >> "$HTMLDEST/$filename"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$filename"
        cat input/extra/$filename >> "$HTMLDEST/$filename"
        echo "</section>" >> "$HTMLDEST/$filename"
        echo "</body></html>" >> "$HTMLDEST/$filename"
done

#cp -avr input/data $HTMLDEST/data
cp input/base/style.css $HTMLDEST/style.css

# -------------------------------------------------------------------------
# ---------------- MAKES THE JOURNAL --------------------------------------
# -------------------------------------------------------------------------
echo "--- REGENERATING JOURNAL ---"

# masterindex head ----------
echo "<!DOCTYPE html>" >> "$HTMLDEST/journal/masterindex.html"
echo "<html>" >> "$HTMLDEST/journal/masterindex.html"
echo "<head>" >> "$HTMLDEST/journal/masterindex.html"
echo "<title>npisanti.com</title>" >> "$HTMLDEST/journal/masterindex.html"
cat input/base/head.html >> "$HTMLDEST/journal/masterindex.html"
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/journal/masterindex.html"
echo "</head>" >> "$HTMLDEST/journal/masterindex.html"
echo "<body>" >> "$HTMLDEST/journal/masterindex.html"
cat input/base/sectionheader.html >> "$HTMLDEST/journal/masterindex.html"
echo "<section class=\"center fill\">" >> "$HTMLDEST/journal/masterindex.html"
# --------------------------

post=0
page=1
lastmonth=13
lastyear=1999
for f in $(ls -1 input/journal | sort -r)
do
    filename=${f##*/}
    year=${filename:0:4}
    month=${filename:5:2}
    day=${filename:8:2}
    
    title=${filename:11}
    title=${title%".html"}
    title=${title//_/ }

    pagefolder="$HTMLDEST/journal/"
    mkdir -p $pagefolder
    pagepath="$pagefolder/page$page.html"
    
    #generate corresponding page
    echo "Processing $filename | post $post | page $page"

    if (("$post" == 0)); then 
        # generate head of page
        echo "<!DOCTYPE html>" >> "$pagepath"
        echo "<html>" >> "$pagepath"
        echo "<head>" >> "$pagepath"
        echo "<title>npisanti.com</title>" >> "$pagepath"
        cat input/base/head.html >> "$pagepath"
        echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$pagepath"
        echo "</head>" >> "$pagepath"
        echo "<body>" >> "$pagepath"
        cat input/base/postpageheader.html >> "$pagepath"
    fi 


    
    # ---------------- generate individual page -----------------------------
    echo "<!DOCTYPE html>" >> "$HTMLDEST/journal/$filename"
    echo "<html>" >> "$HTMLDEST/journal/$filename"
    echo "<head>" >> "$HTMLDEST/journal/$filename"
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
    sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/$filename" 
    sed -i -e "s|POSTPAGEURLPLACEHOLDER|page$page.html|g" "$HTMLDEST/journal/$filename" 
        
    # -----------------------------------------------------------------------
    
    # ------------ adds post to page ----------
    echo "<section class=\"center fill\">" >> "$pagepath"
    cat input/journal/$filename >> "$pagepath"
    echo "<br><br><div style="text-align:right"><a href="../$filename">posted on $year/$month/$day</a> </div>" >> "$pagepath"
    echo "</section>" >> "$pagepath"
    # -----------------------------------------
    
    if [ "$year" -ne "$lastyear" ] || [ "$month" -ne "$lastmonth" ]; then
        echo "<br>" >> "$HTMLDEST/journal/masterindex.html" 
    fi
    lastyear=$year
    lastmonth=$month
    
    echo "<a href="$filename">$year/$month/$day :</a> $title<br>" >> "$HTMLDEST/journal/masterindex.html" 
    
    post=$(( $post +1 ))
    if (("$post" == "$POSTPERPAGE")); then 
        post=0
        page=$(( $page +1 ))
        # generate tail of page 
        cat input/base/postpageheader.html >> "$pagepath"
        echo "</body></html>" >> "$pagepath" 
        sed -i -e "s|style.css|../style.css|g" "$pagepath" 
    fi
done

# generate tail of page for last blog page
if (("$post" != 0)); then 
    cat input/base/postpageheader.html >> "$pagepath"
    echo "</body></html>" >> "$pagepath" 
    sed -i -e "s|style.css|../style.css|g" "$pagepath" 
fi

# masterindex tail 
echo "</section>" >> "$HTMLDEST/journal/masterindex.html"
echo "</body></html>" >> "$HTMLDEST/journal/masterindex.html" 
sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/masterindex.html" 

# generate navigation pages 
echo "generating navigation bars..."
for ((i=1;i<=page;i++)); do
    navigation=""
    for ((k=1;k<=page;k++)); do
        if (("$k" == "$i")); then 
            navigation="$navigation<a href=\"page$k.html\">[$k]</a> "
        else
            navigation="$navigation<a href=\"page$k.html\">$k</a> "
        fi
    done
    sed -i -e "s|NAVIGATION_PLACEHOLDER_TOKEN|$navigation|g" "$HTMLDEST/journal/page$i.html"
done
echo "...done"

echo "copying and editing first page"
cp "$HTMLDEST/journal/page1.html" "$HTMLDEST/journal/index.html" 

exit

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
        cat input/base/sectionheader.html >> "$HTMLDEST/$filename"
        echo "<section class=\"center fill\">" >> "$HTMLDEST/$filename"
        cat input/extra/$filename >> "$HTMLDEST/$filename"
        echo "</section>" >> "$HTMLDEST/$filename"
        echo "</body></html>" >> "$HTMLDEST/$filename"
done

#cp -avr input/data $HTMLDEST/data
cp input/base/style.css $HTMLDEST/style.css

# -------------------------------------------------------------------------
# ---------------- MAKES THE JOURNAL --------------------------------------
# -------------------------------------------------------------------------
echo "--- REGENERATING JOURNAL ---"

# masterindex head ----------
echo "<!DOCTYPE html>" >> "$HTMLDEST/journal/masterindex.html"
echo "<html>" >> "$HTMLDEST/journal/masterindex.html"
echo "<head>" >> "$HTMLDEST/journal/masterindex.html"
echo "<title>npisanti.com</title>" >> "$HTMLDEST/journal/masterindex.html"
cat input/base/head.html >> "$HTMLDEST/journal/masterindex.html"
echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$HTMLDEST/journal/masterindex.html"
echo "</head>" >> "$HTMLDEST/journal/masterindex.html"
echo "<body>" >> "$HTMLDEST/journal/masterindex.html"
cat input/base/sectionheader.html >> "$HTMLDEST/journal/masterindex.html"
echo "<section class=\"center fill\">" >> "$HTMLDEST/journal/masterindex.html"
# --------------------------

post=0
page=1
lastmonth=13
for f in $(ls -1 input/journal | sort -r)
do
    filename=${f##*/}
    year=${filename:0:4}
    month=${filename:5:2}
    day=${filename:8:2}
    
    title=${filename:11}
    title=${title%".html"}
    title=${title//_/ }

    pagefolder="$HTMLDEST/journal/"
    mkdir -p $pagefolder
    pagepath="$pagefolder/page$page.html"
    
    #generate corresponding page
    echo "Processing $filename | post $post | page $page"

    if (("$post" == 0)); then 
        # generate head of page
        echo "<!DOCTYPE html>" >> "$pagepath"
        echo "<html>" >> "$pagepath"
        echo "<head>" >> "$pagepath"
        echo "<title>npisanti.com</title>" >> "$pagepath"
        cat input/base/head.html >> "$pagepath"
        echo "<meta property=\"og:image\" content=\"http://npisanti.com/data/$GENERAL_THUMB\" />" >> "$pagepath"
        echo "</head>" >> "$pagepath"
        echo "<body>" >> "$pagepath"
        cat input/base/postpageheader.html >> "$pagepath"
    fi 


    
    # ---------------- generate individual page -----------------------------
    echo "<!DOCTYPE html>" >> "$HTMLDEST/journal/$filename"
    echo "<html>" >> "$HTMLDEST/journal/$filename"
    echo "<head>" >> "$HTMLDEST/journal/$filename"
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
    sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/$filename" 
    sed -i -e "s|POSTPAGEURLPLACEHOLDER|page$page.html|g" "$HTMLDEST/journal/$filename" 
        
    # -----------------------------------------------------------------------
    
    # ------------ adds post to page ----------
    echo "<section class=\"center fill\">" >> "$pagepath"
    cat input/journal/$filename >> "$pagepath"
    echo "<br><br><div style="text-align:right"><a href="../$filename">posted on $year/$month/$day</a> </div>" >> "$pagepath"
    echo "</section>" >> "$pagepath"
    # -----------------------------------------
    
    #if (("$month" != "$lastmonth")); then
    #    echo "<br>" >> "$HTMLDEST/journal/masterindex.html" 
    #fi
    lastmonth=$month
    
    echo "<a href="$filename">$year/$month/$day :</a> $title<br>" >> "$HTMLDEST/journal/masterindex.html" 
    
    post=$(( $post +1 ))
    if (("$post" == "$POSTPERPAGE")); then 
        post=0
        page=$(( $page +1 ))
        # generate tail of page 
        cat input/base/postpageheader.html >> "$pagepath"
        echo "</body></html>" >> "$pagepath" 
        sed -i -e "s|style.css|../style.css|g" "$pagepath" 
    fi
done

# generate tail of page for last blog page
if (("$post" != 0)); then 
    cat input/base/postpageheader.html >> "$pagepath"
    echo "</body></html>" >> "$pagepath" 
    sed -i -e "s|style.css|../style.css|g" "$pagepath" 
fi

# masterindex tail 
echo "</section>" >> "$HTMLDEST/journal/masterindex.html"
echo "</body></html>" >> "$HTMLDEST/journal/masterindex.html" 
sed -i -e "s|style.css|../style.css|g" "$HTMLDEST/journal/masterindex.html" 

# generate navigation pages 
echo "generating navigation bars..."
for ((i=1;i<=page;i++)); do
    navigation=""
    for ((k=1;k<=page;k++)); do
        if (("$k" == "$i")); then 
            navigation="$navigation<a href=\"page$k.html\">[$k]</a> "
        else
            navigation="$navigation<a href=\"page$k.html\">$k</a> "
        fi
    done
    sed -i -e "s|NAVIGATION_PLACEHOLDER_TOKEN|$navigation|g" "$HTMLDEST/journal/page$i.html"
done
echo "...done"

echo "copying and editing first page"
cp "$HTMLDEST/journal/page1.html" "$HTMLDEST/journal/index.html" 

exit
