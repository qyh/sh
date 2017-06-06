#!/bin/sh

gsub() {
    if [ "$#" -lt 3 ]; then
        echo " "
    fi
    src=$1
    ostr=$2
    nstr=$3
    rst=${src//"$ostr"/"$nstr"} 
    echo $rst
}

s=`gsub 'xxxx' 'x' 'o'`
echo $s
