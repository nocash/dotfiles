#!/bin/bash

# Directory argument is required
[[ -z $1 ]] && exit 1

LATEST="http://wordpress.org/latest.zip"
FILE="./$( basename $LATEST )"

[[ -f $FILE ]] && rm $FILE
wget $LATEST

unzip $FILE -d /tmp | sed "s-/tmp/wordpress-$1-"
mv /tmp/wordpress $1

rm $FILE

cd $1
