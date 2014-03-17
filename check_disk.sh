#!/bin/bash
#
# Check Disk Plugin
# =====
#
# Проверяет оставшееся свободное место на дисках
#
# ShizaCat 2014

USAGE="Usage: `basename $0` [-w rate] "

RATE_W=70
RATE_E=90
FS_EXCLUDE="devtmpfs,tmpfs"

STATUS=0
STATUS_LINE=""
STATUS_W=""
STATUS_E=""

while getopts w: OPT; do
    case "$OPT" in
        w)
            RATE_W=$OPTARG
            ;;
        \?)
            # getopts вернул ошибку
            echo $USAGE
            exit 1
            ;;
    esac
done

shift `expr $OPTIND - 1`



# Main
containElement(){
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

IFS=', ' read -a FS_EXCLUDE <<< "$FS_EXCLUDE"
#echo "${FS_EXCLUDE[@]}"
#containElement "ext2" "${FS_EXCLUDE[@]}"
#echo $?

while read line; do
	FS=`echo $line | awk '{print $1}'`
	TYPE=`echo $line | awk '{print $2}'`
	CAPACITY=`echo $line | awk '{print substr($6, 1, length($6)-1) }'`
	MNT=`echo $line | awk '{print $7}'`

	containElement "$TYPE" "${FS_EXCLUDE[@]}" && continue

	if [[ $CAPACITY -ge $RATE_E ]] ; then
		STATUS_E="${STATUS_E} $FS, $TYPE, ${CAPACITY}%, $MNT \n"
	elif [[ $CAPACITY -ge $RATE_W ]] ; then
		STATUS_W="${STATUS_W} \n $FS, $TYPE, ${CAPACITY}%, $MNT"
	fi

done < <( df -PT | tail -n +2 )

if [[ -n $STATUS_W ]] ; then
	echo -e $STATUS_W
	STATUS=1
fi
if [[ -n $STATUS_E ]] ; then
	echo -e $STATUS_E
	STATUS=2
fi

exit $STATUS

