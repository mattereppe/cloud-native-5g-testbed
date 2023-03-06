#!/bin/bash

CONFFILE=../../../../config/open5gs.env 
TMPFILE=addSubscribers.mongosh

function help()
{
	echo "Usage: $0 <num>"
	echo "   where num is the number of subscribers to be added to the database."
	echo 
	echo "Subscribers are generated with incremental numbers from 1 to <num>+1."
}

if [ "$#" -ne "1" ]; then 
	help;
	exit 1;
fi

if ! [[ $1 =~ ^[0-9]+$ ]] ; then
	echo $1
   echo "Error: number expected as argument" >&2; 
	help;
	exit 1;
fi

max=( $1 + 1 )

echo "db.subscribers.insertMany( [" > $TMPFILE
for s in `seq 1 1 $max`; do
	ueid=`printf "%010d" $s`;
	echo "Adding UE: " $ueid;
	item=`sed -e "s/_UEID_/$ueid/" template.json` 
	if [ "$s" -ne $max ]; then
		item=$item","
	fi
	echo $item >> $TMPFILE;
done
echo "] )" >> $TMPFILE
