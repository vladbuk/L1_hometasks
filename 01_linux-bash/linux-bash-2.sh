#!/bin/bash

# 1. Top 5 IP from which were the most requests
cat example_log.log | awk '{print $1}' | sort | uniq -c | sort -nr | awk '{print "From IP " $2 "\t were " $1 " requests" }' | head -n 5

# 2. Top 5 the most requested pages
cat example_log.log | cut -d\" -f2 | awk '{print $2}' | egrep -iv "ico$|woff|ttf" | sort | uniq -c | sort -nr | head -n 5

# 3. How many requests were there from each ip?
cat example_log.log | awk '{print $1}' | sort | uniq -c | sort -nr | awk '{ip = $2; r = $1; printf "From IP %-15s - %d request%s\n", ip, r, r == 1 ? "" : "s"}'

# 4. What non-existent pages were clients reffered to?
cat example_log.log | grep " 404 " | cut -d\" -f2 | awk '{print $2}' | sort | uniq

# 5. What time did site get the most requests?

# 6. What search bots have accessed the site (UA + IP)?

