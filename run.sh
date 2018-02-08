#/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATE=$(date "+%Y%m%d%S")


$DIR/bench_dd.sh $1 $2 >> dd.stats.${DATE}
$DIR/bench_bonnie.sh $1 $2 >> bonnie.stats.${DATE}
