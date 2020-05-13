#!/bin/bash
for (( i=1; i<=100; i++ ))
do
  mysqldump -u admin -padmin --all-databases > testtar.sql && tar czf tar-$i.tar.gz testtar.sql  && rm -f testtar.sql
done
