#!/bin/bash

param=$1

top5ip () {
    echo "1. Top 5 IP from which were the most requests"
    local result=$(cat $param | awk '{print $1}' | sort | uniq -c | sort -nr | awk '{print "From IP " $2 "\t were " $1 " requests" }' | head -n 5)
    echo -e "$result\n"
}

top5pages () {
    echo "2. Top 5 the most requested pages"
    result=$(cat $param | cut -d\" -f2 | awk '{print $2}' | egrep -iv "ico$|woff|ttf" | sort | uniq -c | sort -nr | head -n 5 | sed -e 's/^[ \t]*//')
    echo -e "$result\n"
}

requestIpCount () {
    # 3. How many requests were there from each ip?
    cat $1 | awk '{print $1}' | sort | uniq -c | sort -nr | awk '{ip = $2; r = $1; printf "From IP %-15s - %d request%s\n", ip, r, r == 1 ? "" : "s"}'
}

nonExistPages () {
    # 4. What non-existent pages were clients reffered to?
    cat $1 | grep " 404 " | cut -d\" -f2 | awk '{print $2}' | sort | uniq
}

mostTimeRequest () {
    # 5. What time did site get the most requests?
    echo
}

showSearchBot () {
    # 6. What search bots have accessed the site (UA + IP)?
    echo
}

if [[ $# -ne 1 ]]
then
    echo -e "For running script it needs one argument - \nlog file name with full path"
else
    #cat $1
    top5ip
    top5pages
fi