#!/bin/bash

bkname='bk'`date "+%Y%m%d_%H%M"`
workdir=~/backup/$bkname

tomcatdir=/var/lib/tomcat7
apachedir=/var/www

echo "Backup name: $bkname"
echo "Working dir: $workdir"
echo "Tomcat dir: $tomcatdir"
echo "Apache dir: $apachedir"
echo ""
echo "Starting backup script..."
echo ""

function err() {
        echo $1
        exit 1
}


if [ -d $workdir ]; then
        err "ERROR Director $workdir already exists..."
fi

#tar c /var/lib/tomcat7/webapps/ | bzip2 > webapps


echo ""
echo "DONE OK"
exit 0

