#!/bin/bash

TINY_SIZE=512
SMALL_SIZE=100M
BIG_SIZE=1G

REPEAT=1

if [ $# -ge 1 ]; then
	REPEAT=$1
fi

OUTPUT_FILE=/tmp/tempfile

export LC_NUMERIC=en.UTF-8

function test(){
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
  
 for i in $(seq 1 $REPEAT); do
  rm -rf ${OUTPUT_FILE}
   RESULT=$($CMD 2>&1 | tail -n 1)
   PARSED=$(echo $RESULT | awk 'BEGIN { FS = ",";OFS = ", " } ; { print $3, $4 }')
   echo "$TEST_NAME,$BS,$COUNT,$OPTS_F,$PARSED"
 done 
}


####################################################################
# Throughput (Streaming I/O)

# Com Cache
test $REPEAT throughput.cached.small $SMALL_SIZE 1 ""
# Sincroniza antes de terminar
test $REPEAT throughput.sync.small $SMALL_SIZE 1 "conv=fdatasync"
# Sem cache e I/O direto (by-pass fs)
test $REPEAT thoughput.sync.direct.small $SMALL_SIZE 1 "conv=fdatasync oflag=direct"

# BIG FILES
# Com Cache
test $REPEAT throughput.cached.big $BIG_SIZE 1 ""
# Sincroniza antes de terminar
test $REPEAT throughput.sync.big $BIG_SIZE 1 "conv=fdatasync"
# Sem cache e I/O direto (by-pass fs)
test $REPEAT thoughput.sync.direct.small $BIG_SIZE 1 "conv=fdatasync oflag=direct"
 

####################################################################
# Latency
test $REPEAT latency.cache $TINY_SIZE 1000 
test $REPEAT latency.sync $TINY_SIZE 1000  "conv=fdatasync"
test $REPEAT latency.sync.direct $TINY_SIZE 1000  "conv=fdatasync oflag=direct"





