#/bin/bash


DATE=$(date "+%Y%m%d%S")
HN=$(hostname)


echo "Testando disco RAID 10"
date
bonnie -b -d /data/raid10/test -x2 >> ${HN}.bonnie.stats.${DATE}.raid10.csv
date
