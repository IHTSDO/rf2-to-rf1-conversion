#!/bin/sh
set -e;

memParams="-Xms512m -Xmx4g"

while getopts ":hdivu:" opt
do
	case $opt in
		h)
 			historyFlag="-h"
		;;
		d)
  			debugParams="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080"
		;;
		v)
 			verboseFlag="-v"
		;;
		i)
			interactiveFlag="-i"
		;;
		u)
			ramDrive=$OPTARG
		;;
		help|\?)
			echo -e "Usage: [-s] [-l] [-a] [-v] [-u <unzip location>] [-p <filename>] -h [api-host]"
			echo -e "\t d - debug mode, allows IDE to connect on debug port"
			echo -e "\t h - history, generates the history file (takes longer)"
			echo -e "\t i - Interactive mode allows sql queries to be run on the temporary database before destruction."
			echo -e "\t u <location> - Specify location to unzip archives to - good if it's a ramdrive."
			echo -e "\t v verbose output"
			exit 0
		;;
	esac
done

ramDrive="-u /Volumes/ram_disk"
runTimeFlags="${verboseFlag} ${historyFlag} ${interactiveFlag} ${ramDrive}"
 
java -jar ${memParams} ${debugParams} target/RF2toRF1Converter.jar ${runTimeFlags} ~/Backup/SnomedCT_RF2Release_INT_20160131.zip
#java -jar ${memParams} ${debugParams} target/RF2toRF1Converter.jar ${runTimeFlags} ~/Backup/SnomedCT_RF2Release_INT_20150731.zip ~/Backup/SnomedCT_SpanishRelease-es_INT_20151031.zip
