#/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATE=$(date "+%Y%m%d%S")
HN=$(hostname)

$DIR/bench_dd.sh $1 $2 >> ${HN}.dd.stats.${DATE}.csv
$DIR/bench_bonnie.sh $1 $2 >> ${HN}.bonnie.stats.${DATE}
