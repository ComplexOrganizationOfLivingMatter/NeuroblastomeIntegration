#usr/bin/sh
#Developed by Pablo Vicente-Munuera
rm stats.csv
ls | grep stats | while read f; do echo "$f" >> stats.csv; tail -1 "$f" >> stats.csv ; done