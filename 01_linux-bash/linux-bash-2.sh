#!/bin/bash

# 1. Top 5 IP from which were the most requests
cat example_log.log | awk '{print $1}' | sort | uniq -c | sort -nr | awk '{print "From IP " $2 "\t were " $1 " requests" }' | head -n 5

# 2. Top 5 the most requested pages
cat example_log.log | cut -d\" -f2 | awk '{print $2}' | egrep -iv "ico$|woff|ttf" | sort | uniq -c | sort -nr | head -n 5