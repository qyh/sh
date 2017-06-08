#!/bin/sh

requirepass="fish3d"
pidfiledir="."
logfiledir="."

if [ $# -lt 1 ]; then
    echo "usage: $0 filename "
    exit 1
fi
configfile="$1"

prefix=${configfile%%.*}
suffix=${configfile#*.}

echo $prefix
echo $suffix

ports=(10000 20000 30000)
for port in ${ports[*]}; do
    newfilename=$prefix"_$port"".""$suffix"
    rm -rf $newfilename
    echo "generating new config file:$newfilename"
    cp $configfile $newfilename  
    sed -i "s/^port.*$/port $port/" $newfilename
    sed -i "s/^requirepass.*$/requirepass $requirepass/" $newfilename
    pfile=$pidfiledir"/""redis_$port"".pid"
    tmp=${pfile/\//\\\/}
    sed -i "s/^pidfile.*$/pidfile $tmp/" $newfilename
    logfile=$logfiledir"/""redis_$port"".log"
    tmp=${logfile/\//\\\/}
    sed -i "s/^logfile.*$/logfile $tmp/" $newfilename
    dbfilename="redis_$port"".rdb"
    sed -i "s/^dbfilename.*$/dbfilename $dbfilename/" $newfilename
done
