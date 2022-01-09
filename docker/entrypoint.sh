#!/bin/bash
set -Eeuo pipefail

if [ -f /data/db/WiredTiger  ]; then
    echo "Found /data/db/WiredTiger - assuming migration to WiredTiger already completed..."
    exit 0
fi

mmapArgs="mongod --smallfiles --oplogSize 128 --replSet rs0 --storageEngine=mmapv1 --bind_ip_all"
mmapArgsArr=($mmapArgs)
echo "Start mmap instance in background..."
exec $mmapArgsArr > /dev/null 2>&1 &
mmapPid="$!"

echo "Wait until mmap instance is ready..."
while ! mongo --eval "db.runCommand( { serverStatus: 1 } )"; do
    sleep 1;
done;

echo "Create dump from running mmap instance..."
mongodump --archive=/tmp/mmap --gzip

echo "Kill mmap instace gracefully"
kill $mmapPid

echo "Wait until mmap instace is shut down"
while kill -0 $mmapPid; do
    sleep 1
done

echo "Remove existing mmap database files"
rm -rf /data/db/*

wiredTigerArgs="mongod --smallfiles --oplogSize 128 --replSet rs0 --storageEngine=wiredTiger --bind_ip_all"
wiredTigerArgsArr=($wiredTigerArgs)
echo "Start wiredTiger instance in background..."
exec $wiredTigerArgsArr &
wiredTigerPid="$!"

echo "Wait until wiredTiger instance is ready..."
while ! mongo --eval "db.runCommand( { serverStatus: 1 } )"; do
    sleep 1;
done

echo "preparing empty db so we can restore"
mongo --eval "rs.initiate()"

echo "Restore dump into wiredTiger instance..."
mongorestore --drop --archive=/tmp/mmap --gzip --noIndexRestore

echo "Repair database to restore indices"
mongo --eval 'db.repairDatabase()' 

echo "Kill wiredTiger instace gracefully"
kill $wiredTigerPid

echo "Wait until wiredTiger instace is shut down"
while kill -0 $wiredTigerPid; do
    sleep 1
done

echo "wiredTiger instance gracefully shut down"
exit 0
