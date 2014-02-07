#!/bin/bash

#
#
#
#

#COUNT_MD=`ls -l /dev/md* | grep -E '^-' | awk '{print $9}' wc -l`

STATE=0	# ERROR, WARN, OK
STATE_LINE=''

# Exit codes
STATE_OK=0
STATE_WARNING=1
STATE_ERROR=2
STATE_UNKNOWN=3

#ls -l /dev/md* | grep -E '^b' | awk '{print $10}' | \
while read line; do

	RAID_DEVICES=`mdadm -D ${line} | grep 'Raid Devices' | awk -F":" '{print $2 }'`
	TOTAL_DEVICES=`mdadm -D ${line} | grep 'Total Devices' | awk -F":" '{print $2 }'`
	ACTIVE_DEVICES=`mdadm -D ${line} | grep 'Active Devices' | awk -F":" '{print $2 }'`
	WORKING_DEVICES=`mdadm -D ${line} | grep 'Working Devices' | awk -F":" '{print $2 }'`
	FAILED_DEVICES=`mdadm -D ${line} | grep 'Failed Devices' | awk -F":" '{print $2 }'`
	SPARE_DEVICES=`mdadm -D ${line} | grep 'Spare Devices' | awk -F":" '{print $2 }'`
	STATE_RAID=`mdadm -D ${line} | grep 'State :' | awk -F":" '{print $2 }'`

	# Checkeds
	if [ $FAILED_DEVICES -ne 0 ]; then
		STATE=STATE_ERROR
		STATE_LINE=$STATE_LINE' ERROR '
	else
		STATE_LINE=$STATE_LINE' OK '
	fi
	STATE_LINE=$STATE_LINE" Raid Devices=${RAID_DEVICES}, Total Devices=${TOTAL_DEVICES}, \
Active Devices=${ACTIVE_DEVICES}, Working Devices=${WORKING_DEVICES}, \
Failed Devices=${FAILED_DEVICES}, Spare Devices=${SPARE_DEVICES}, State=${STATE_RAID} "
done < <( ls -l /dev/md* | grep -E '^b' | awk '{print $10}' )

echo $STATE_LINE
exit $STATE


