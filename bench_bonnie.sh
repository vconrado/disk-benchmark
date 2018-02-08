#/bin/bash
#
# Source: https://www.jamescoyle.net/how-to/599-benchmark-disk-io-with-dd-and-bonnie
#

if [ $# -ge 1 ]; then
	REPEAT=$1
else
	REPEAT=1
fi

if [ $# -ge 2 ]; then
        OUTPUT_DIR=$2
else
        OUTPUT_DIR=/tmp
fi

if [ ! -d $OUTPUT_DIR ]; then
	echo "'$OUTPUT_DIR' is an invalid directory"
	exit
fi

N=10
SIZE=2

CMD="bonnie -d $OUTPUT_DIR -x $REPEAT"
echo $CMD
$CMD

