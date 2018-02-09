#!/bin/bash
# Usage: benchmark.sh [n_of_reps [temp_file_name]]

# Source: https://www.thomas-krenn.com/en/wiki/Linux_I/O_Performance_Tests_using_dd

TINY_SIZE=512
SMALL_SIZE=100M
BIG_SIZE=10G

REPEAT=1

if [ $# -ge 1 ]; then
	REPEAT=$1
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

OUTPUT_FILE="${OUTPUT_DIR}/tempfile"

function write_test(){
	REPEAT=$1
  TEST_NAME=$2
	BS=$3
	COUNT=$4
	OPTS=$5

	if [[ $OPTS = "" ]]; then
		OPTS_F="-"
	else
		OPTS_F="$OPTS"
	fi
 
	CMD="dd if=/dev/zero of=${OUTPUT_FILE} bs=$BS count=$COUNT $OPTS"
	#echo $CMD
  
	for i in $(seq 1 $REPEAT); do
		rm -rf ${OUTPUT_FILE}
		RESULT=$($CMD 2>&1 | tail -n 1)
		#echo $RESULT
		PARSED=$(echo $RESULT | awk 'BEGIN { FS = ",";OFS = ", " } ; { print $3, $4 }')
		echo "$TEST_NAME, $BS, $COUNT, $OPTS_F,$PARSED"
 	done 
}


function read_test(){
	REPEAT=$1
  TEST_NAME=$2
	BS=$3
	FILE=$4
	OPTS_F=""

	CMD="dd of=/dev/null if=${FILE} bs=$BS"
	for i in $(seq 1 $REPEAT); do
		#echo $CMD
		RESULT=$($CMD 2>&1 | tail -n 1)
		#echo $RESULT
		PARSED=$(echo $RESULT | awk 'BEGIN { FS = ",";OFS = ", " } ; { print $3, $4 }')
		echo "$TEST_NAME, $BS, $COUNT, $OPTS_F,$PARSED"
 	done 
}



####################################################################
# Throughput (Streaming I/O)

# Com Cache
write_test $REPEAT throughput.cached.small $SMALL_SIZE 1 ""
# Sincroniza antes de terminar
write_test $REPEAT throughput.sync.small $SMALL_SIZE 1 "conv=fdatasync"
# Sem cache e I/O direto (by-pass fs)
write_test $REPEAT thoughput.sync.direct.small $SMALL_SIZE 1 "conv=fdatasync oflag=direct"

# BIG FILES
# Com Cache
write_test $REPEAT throughput.cached.big $BIG_SIZE 1 ""
# Sincroniza antes de terminar
write_test $REPEAT throughput.sync.big $BIG_SIZE 1 "conv=fdatasync"
# Sem cache e I/O direto (by-pass fs)
write_test $REPEAT thoughput.sync.direct.small $BIG_SIZE 1 "conv=fdatasync oflag=direct"

####################################################################
# Latency
write_test $REPEAT latency.cache $TINY_SIZE 1000 
write_test $REPEAT latency.sync $TINY_SIZE 1000  "conv=fdatasync"
write_test $REPEAT latency.sync.direct $TINY_SIZE 1000  "conv=fdatasync oflag=direct"

# Lendo arquivos pequenos
dd if=/dev/zero of=${OUTPUT_FILE} bs=$SMALL_SIZE count=1 > /dev/null 2>&1
# 4k
read_test $REPEAT read.small.4k 4k ${OUTPUT_FILE}
# 8k
read_test $REPEAT read.small.8k 8k ${OUTPUT_FILE}
# 16k
read_test $REPEAT read.small.16k 16k ${OUTPUT_FILE}
# 32k
read_test $REPEAT read.small.32k 32k ${OUTPUT_FILE}
# 64k
read_test $REPEAT read.small.64k 64k ${OUTPUT_FILE}
# 128k
read_test $REPEAT read.small.128k 128k ${OUTPUT_FILE}

rm ${OUTPUT_FILE}

# Lendo arquivos grandes
dd if=/dev/zero of=${OUTPUT_FILE} bs=$BIG_SIZE count=1 > /dev/null 2>&1
# 4k
read_test $REPEAT read.big.4k 4k ${OUTPUT_FILE}
# 8k
read_test $REPEAT read.big.8k 8k ${OUTPUT_FILE}
# 16k
read_test $REPEAT read.big.16k 16k ${OUTPUT_FILE}
# 32k
read_test $REPEAT read.big.32k 32k ${OUTPUT_FILE}
# 64k
read_test $REPEAT read.big.64k 64k ${OUTPUT_FILE}
# 128k
read_test $REPEAT read.big.128k 128k ${OUTPUT_FILE}

rm ${OUTPUT_FILE}
