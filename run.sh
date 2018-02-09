#/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DATE=$(date "+%Y%m%d%S")
HN=$(hostname)

if [ $# -ne 2 ]; then
	echo "Usage: $0 n_rep dir"
	exit 1
fi

re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
	echo "error: '$1' is not a number" >&2; exit 1
	exit 2
fi

if [ ! -d $2 ]; then
	echo "error: '$2' is not a directory"
	exit 3
fi

@$DIR/bench_dd.sh $1 $2 >> ${HN}.dd.stats.${DATE}.csv
$DIR/bench_bonnie.sh $1 $2 >> ${HN}.bonnie.stats.${DATE}.csv
