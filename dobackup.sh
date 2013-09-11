#!/bin/bash

bkname='bk'`date "+%Y%m%d_%H%M"`
workdir=~/backup/$bkname
onrundir=`pwd`

tomcatdir=/var/lib/tomcat7
apachedir=/var/www
extradirs=('' '')

mysql_host=localhost
mysql_login=root
mysql_pass=

echo "Backup name: $bkname"
echo "Working dir: $workdir"
echo "Tomcat dir: $tomcatdir"
echo "Apache dir: $apachedir"
echo "MySQL host[$mysql_host], user[$mysql_login] with password[$mysql_pass]"
echo "Extra dirs: ${extradirs[@]}"
echo ""
echo "Starting backup script..."

# Error method
function err() {
    echo "ERROR $1"
    cd $onrundir
    exit 1
}

# Try to create working dir if possible
if [ -d $workdir ]; then
	err "Directory $workdir already exists..."
fi

# Navigate to working dir or fail
mkdir -p $workdir
cd $workdir
if [ $? -ne 0 ]; then
	err "Cannot go to work directory [$workdir]"
fi
echo "In " `pwd` " directory now"


#
# Helpers

function enable_console_log() {
	set -x
}
function disable_console_log() {
	set +x
}


#
# Actual backup scripts

function backup_tomcat() {
	echo ""
	echo "Backing up TOMCAT for [$1]"
	enable_console_log
	
	tar c $1/webapps/ | bzip2 > webapps.tar.bz2
	
	disable_console_log
	echo "TOMCAT backed up OK"
}

function backup_apache() {
	echo ""
	echo "Backing up Apache HTTPD for [$1]"
	enable_console_log
	
	tar c $1 | bzip2 > www.tar.bz2
	
	disable_console_log
	echo "Apache HTTPD backed up OK"
}

function backup_mysql() {
	echo ""
	echo "Backing up MySQL for host[$1] user[$2] with password[$3]"
	enable_console_log
	
	mysqldump -h $1 -u $2 --password="$3" --all-databases | gzip > dump.sql.gz
	
	disable_console_log
	echo "MYSQL backed up OK"
}

function backup_extra_dirs() {
	echo ""
	echo "Backing up $# Extra Dirs"
	enable_console_log
	
	i=0
	for edir in $*; do
		if [ -z $edir ]; then
			echo "  extra dir has empty path [$edir]"
		else
			i=`expr $i + 1`
			echo "  extra dir $i: $edir"
			tar c $edir | bzip2 > extra$i.tar.bz2
		fi
	done
	
	disable_console_log
	echo "Extra Dirs backed up OK"
}


#
# Run app

backup_tomcat $tomcatdir
backup_apache $apachedir
backup_mysql $mysql_host $mysql_login $mysql_pass
backup_extra_dirs ${extradirs[@]}

echo ""
echo "DONE OK"
cd $onrundir
exit 0

