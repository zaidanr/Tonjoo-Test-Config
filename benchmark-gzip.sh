#!/bin/bash
for (( c=1; c<=100; c++ ))
do
  mysqldump -u admin -padmin --all-databases | gzip -c > gzip-$c.gz
done
