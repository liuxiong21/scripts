et -e
dateStr=`date +%Y_%m_%d`
seconds=`date +%s`
millis=$((seconds*1000))
dirpath=/alidata1/backup/$dateStr/$millis

mkdir -p $dirpath

millis=$((seconds*1000-4*31*24*60*60*1000))
echo dump data to dir $dirpath
queryParams="{date:{\$lte:Date("$millis")}}"
mongodump --host xxxx:27017 --db xxx -u xxxx -p xxx -c trackModel -q $queryParams -out $dirpath

#if [[ $? -ne 0 ]];then
#echo exec command fail
#exit 1
#fi

target_file=/alidata1/backup/$dateStr/trackModel_$dateStr_$millis.tgz

tar -czf $target_file $dirpath

ssh data2.souche "mkdir -p /alidata1/backup/$dateStr"
scp $target_file souche@data2.souche:/alidata1/backup/$dateStr

mongo xxxx:27017 <<EOF
use xxxx;
db.auth("xxx","xxx");
curDate=new Date($millis);
db.trackModel.count({date:{\$lt:curDate}});
EOF
