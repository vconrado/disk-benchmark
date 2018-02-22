#/bin/bash


DATE=$(date "+%Y%m%d%S")
HN=$(hostname)


echo "Testando disco RAID 0"
date
bonnie -b -d /data/raid0/test -x2 >> ${HN}.bonnie.stats.${DATE}.raid0.csv
date
echo "Testando disco RAID 1"
date
bonnie -b -d /data/raid1/test -x2 >> ${HN}.bonnie.stats.${DATE}.raid1.csv
date
