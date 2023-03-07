#!/bin/bash

CONFFILE=../../../../config/open5gs.env 
TMPFILE=addSubscribers.mongosh

function help()
{
	echo "Usage: $0 [<from>] <num>"
	echo ""
	echo "   where: "
	echo "      - from is the starting id (Default = 1);"
	echo "      - num is the number of subscribers to be added to the database."
	echo 
	echo "Subscribers are generated with incremental numbers from <from> to <from>+<num>."
}

if [ "$#" -eq "1" ]; then 
	from=1;
	num=$1;
else
	if [ "$#" -eq "2" ]; then
		from=$1;
		num=$2;
	else
		help;
		exit 1;
	fi
fi
max=$(( $from + $num - 1 ))

if ! [[ $from =~ ^[0-9]+$ || $num =~ ^[0-9]+$  ]] ; then
   echo "Error: number expected as argument" >&2; 
	help;
	exit 1;
fi


echo "db.subscribers.insertMany( [" > $TMPFILE
for s in `seq $from 1 $max`; do
	ueid=`printf "%010d" $s`;
	echo "Adding UE: " $ueid;
	item=`sed -e "s/_UEID_/$ueid/" template.json` 
	if [ "$s" -ne $max ]; then
		item=$item","
	fi
	echo $item >> $TMPFILE;
done
echo "] )" >> $TMPFILE
