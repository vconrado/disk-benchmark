#!/bin/bash


if [ $# -ne 1 ]; then
	echo "Usage: $(basename $0) nohup_output_file"
	exit 1
fi 

FILE=$1


grep "inicio" $FILE | while read -r LINE; do
	ATTR=$(echo $LINE | cut -d' ' -f 3)
	DATAS=$(echo $LINE | awk -F "inicio:" '{print $2}')
	INICIO=$(echo $DATAS | awk -F " fim:" '{print $1}')
	FIM=$(echo $DATAS | awk -F "fim: " '{print $2}')
	INICIO_S=$(date -d "$INICIO" +%s)
	FIM_S=$(date -d "$FIM" +%s)
	TILE=$(echo $LINE | sed -n "s/.*\(h[[0-9][0-9]v[0-9][0-9]\).*/\1/p")
	DIF=$(( ($FIM_S - $INICIO_S)/60 ))
	echo "$TILE|$ATTR: "$INICIO" - "$FIM" ($DIF min)"
done
