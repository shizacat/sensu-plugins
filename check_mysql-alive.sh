#!/bin/bash
#
# MySQL Alive Plugin
# =====
#
# Этот плагин пытается залогиниться в mysql с представленной учетной записью
#
# ShizaCat 2014

# Exit codes
STATE_OK=0
STATE_WARNING=1
STATE_ERROR=2
STATE_UNKNOWN=3


if [ $# -lt 2 ]; then
	echo 'Uses: user_name password [host, default=localhost]'
	exit 1
else
	DB_USER=$1
	DB_PASS=$2
	if [ $# -ge 3 ]; then
		DB_HOST=$3
	else
		DB_HOST='localhost'
	fi
fi


mysql -u ${DB_USER} -p${DB_PASS} ${DB_HOST} -e 'status' | grep Uptime
status=$?

if [ $status -ne 0 ]; then
	exit ${STATE_ERROR}
else
	exit ${STATE_OK}
fi