#/bin/bash


DATE=$(date "+%Y%m%d%S")
HN=$(hostname)


echo "Testando disco RAID 5"
date
bonnie -b -d /data/raid5/test -x2 >> ${HN}.bonnie.stats.${DATE}.raid5.csv
date
