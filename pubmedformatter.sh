#!/bin/bash
# Process pubmed links and convert them to html pre-formatted list.
# input file should contains ONLY pubmed indexes separated by commas.
# No extra spaces nor html address
# outputfile is generated in two versions:
#	outputfile - formatted citation as plain text
#	outputfile.html - formatted citations as html list 

if [ "$#" -ne 2 ]; then
    echo "Requires two parameters:"
    echo -e "\tpubmedformatter.sh inputfile outputfile"
    exit 0
fi

HEAD="http://www.ncbi.nlm.nih.gov/pubmed/"
REFS=$1

# current yera to reverse the array
currenty=$(date +'%Y') 

# convert comma separated list to array (no spaces anywhere!)
references=$(cat $REFS | tr "," "\n")
# delete out files
rm $2 && touch $2
rm $2.html && touch $2.html


# iterate over array and get every reference separately
for ID in $references
do
	echo "> Doing $ID"
    # save to temporary file
    curl -s "$HEAD$ID?report=medline&format=text" > out.out
    # get title
    TITLE=$(grep -w TI out.out | sed 's/\(TI  - \)//g')
    # get authors as comma separated list
    AUTHORS=$(grep -w AU out.out | sed 's/\(AU  - \)//g' | awk -vORS="," '{ print $1, $2 }' | sed 's/,$/\n/' | sed 's/,/, /g')
    # get journal name
    JOU=$(grep -w SO out.out | sed 's/\(SO  - \)//g') 
    # get publication year
    DP=$(grep -w "DP  -" out.out | sed 's/\(DP  - \)//g' | awk '{ print $1 }') && echo $DP

    # form and save text string
    echo "$AUTHORS", $TITLE, $JOU >> $2

    #form and save HTML
    
    F=$(echo \<li\>\<span style=\""word-spacing: normal;"\"\>"$AUTHORS", \</span\>\<span style=\""word-spacing: normal;"\"\>\</span\>\<a href=\"$HEAD$ID\" style=\""word-spacing: normal;"\"\>$TITLE\</a\>\<span style=\""word-spacing: normal;"\"\>, $JOU\</span\>\</li\>)
    # reverse table, last papers go first
    revi=$(($currenty+1-$DP)) 
    # concentrate yearly in form pub1|pub2|..., array index stands for year of publication, reversed that latest goes first
    YEARS[$revi]=${YEARS[$revi]}\|$F

done

# go through table and split publication to separate lines
for i in "${!YEARS[@]}"; do
    # $i is the index (numeric) and year
    if [ ! -z "${YEARS[$i]}" ]; then
        echo \<h3\>$(($currenty-$i+1))\</h3\> >> $2.html
        echo \<ul\> >> $2.html
        echo "${YEARS[$i]}" | tr "|" "\n" >> $2.html
        echo \</ul\> >> $2.html
    fi
done


