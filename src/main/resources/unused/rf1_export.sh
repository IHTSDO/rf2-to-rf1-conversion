#!/bin/sh
set -e;

dbName=$1
releaseDate=$2

if [ -z ${releaseDate} ]
then
	echo "Usage  <db schema name> <release date>"
	exit -1
fi

generatedExportScript="tmp_exporter.sql"
currentDir=`pwd`
outputDirectory="${currentDir}/SnomedCT_RF1Release_INT_${releaseDate}"
rm -rf ${outputDirectory}

function doJoin { 
	separator=$1
	sepLen=${#separator}
	shift
	arrayItems=("${@}")
	sepLen=`echo "${sepLen} + 1" | bc`
	#Need to trim off the final delimiter
	printf "%s${separator}" "${arrayItems[@]}" | rev | cut -c ${sepLen}- | rev
}

function exportTable() {
	tableName=$1
	fileName=$2
	shift 2
	headersArray=("${@}")
	headers=`doJoin "','" ${headersArray[@]}`
	columns=`doJoin "," ${headersArray[@]}`
	
	#Ensure the parent directory exists
	fullFilePath="${outputDirectory}/${fileName}"
	parentDir=${fullFilePath%/*}
	if [ ! -d "${parentDir}" ]; then
		echo "Creating directory structure: ${parentDir}"
		mkdir -p ${parentDir}
	fi
	
	echo "Select 'Exporting data from ${tableName}' as ''; \n"  >> ${generatedExportScript}

	echo  "SELECT '${headers}'" >> ${generatedExportScript}
	echo " UNION " >> ${generatedExportScript}
	echo " SELECT ${columns} " >> ${generatedExportScript} 
	echo " FROM $tableName " >> ${generatedExportScript}
	echo " INTO OUTFILE '${fullFilePath}' " >> ${generatedExportScript} 
	echo " FIELDS TERMINATED BY '\\\t'  " >> ${generatedExportScript}
	echo " LINES TERMINATED BY '\\\r\\\n'; \n" >> ${generatedExportScript}
}

now=`date +"%Y%m%d_%H%M%S"`
echo "\nGenerating RF1 Export script"
echo "/* Export Script Generated Automatically by rf1_export.sh ${now} */" > ${generatedExportScript}

thisHeader=( "CONCEPTID" "CONCEPTSTATUS" "FULLYSPECIFIEDNAME" "CTV3ID" "SNOMEDID" "ISPRIMITIVE" )
exportTable rf21_concept Terminology/Content/sct1_Concepts_Core_INT_${releaseDate}.txt "${thisHeader[@]}"

thisHeader=( "DESCRIPTIONID" "DESCRIPTIONSTATUS" "CONCEPTID" "TERM" "INITIALCAPITALSTATUS" "DESCRIPTIONTYPE" "LANGUAGECODE")
exportTable rf21_term Terminology/Content/sct1_Descriptions_en_INT_${releaseDate}.txt  "${thisHeader[@]}"

thisHeader=("RELATIONSHIPID" "CONCEPTID1" "RELATIONSHIPTYPE" "CONCEPTID2" "CHARACTERISTICTYPE" "REFINABILITY" "RELATIONSHIPGROUP")
exportTable rf21_rel Terminology/Content/sct1_Relationships_Core_INT_${releaseDate}.txt  "${thisHeader[@]}"

thisHeader=("CONCEPTID" "SNOMEDID" "FULLYSPECIFIEDNAME" "DEFINITION")
exportTable rf21_def Terminology/Content/sct1_TextDefinitions_en-US_INT_${releaseDate}.txt  "${thisHeader[@]}"

echo "\nPassing Generated RF1 Export script to MYSQL"

mysql -u root  << EOF
	use ${dbName};
	source ${generatedExportScript}
EOF