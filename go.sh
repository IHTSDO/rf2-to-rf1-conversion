#!/bin/bash
set -e;

memParams="-Xms3g -Xmx8g"

while getopts ":Hbcdivp:u:a:" opt
do
	case $opt in
		a)
			additionalFilesLocation="-a $OPTARG"
		;;
		b)
			betaFlag="-b"
		;;
		c)
			mvn clean package
		;;
		H)
			historyFlag="-H"
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
		p)
			previousRF1="-p $OPTARG"
		;;
		u)
			ramDrive="-u $OPTARG"
		;;
		help|\?)
			echo -e "Usage: [-s] [-l] [-v] [-u <unzip location>] [-a <additional files location>] [-p <filename>] -h [api-host]"
			echo -e "\t a - additional files to be added into the output archive"
			echo -e "\t c - (re)compile the tool"
			echo -e "\t d - debug mode, allows IDE to connect on debug port"
			echo -e "\t H - History, generates JUST the history file"
			echo -e "\t i - Interactive mode allows sql queries to be run on the temporary database before destruction."
			echo -e "\t p - (NOT RECOMMENDED) specify previous RF1 package"
			echo -e "\t u <location> - Specify location to unzip archives to - good if it's a ramdrive."
			echo -e "\t v verbose output"
			exit 0
		;;
	esac
done

runTimeFlags="${verboseFlag} ${betaFlag} ${historyFlag} ${previousRF1} ${interactiveFlag} ${ramDrive} ${additionalFilesLocation}"

archive="/Users/Peter/Backup/SnomedCT_InternationalRF2_Production_20170131T120000.zip"
#archive="/Users/Peter/Backup/SnomedCT_RF2Release_INT_20160731.zip"
java -jar ${memParams} ${debugParams} target/RF2toRF1Converter.jar ${runTimeFlags} ${archive}


