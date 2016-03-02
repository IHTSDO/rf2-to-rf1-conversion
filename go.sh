#!/bin/sh
set -e;

memParams="-Xms512m -Xmx4g"

if [ "$1" == "-d" ] || [ "$2" == "-d" ] || [ "$3" == "-d" ]
then
  debugParams="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080"
fi

if [ "$1" == "-v" ] || [ "$2" == "-v" ] || [ "$3" == "-v" ]
then
  verboseFlag="-v"
fi

if [ "$1" == "-h" ] || [ "$2" == "-h" ] || [ "$3" == "-h" ]
then
  historyFlag="-h"
fi


 
#java -jar ${memParams} ${debugParams} target/RF2toRF1Converter.jar ${verboseFlag} ${historyFlag} ~/Backup/SnomedCT_RF2Release_INT_20160131.zip
java -jar ${memParams} ${debugParams} target/RF2toRF1Converter.jar ${verboseFlag} ${historyFlag} ~/Backup/SnomedCT_RF2Release_INT_20150731.zip ~/Backup/SnomedCT_SpanishRelease-es_INT_20151031.zip
