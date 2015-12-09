#!/bin/sh
set -e;

releasePath=$1
compatPkgPath=$2
dbName=$3

if [ -z ${dbName} ]
then
	echo "Usage <release location> <compatability package location> <db schema name>"
	exit -1
fi

if [ ! -f ${compatPkgPath} ]; then
	echo "Could not find Compatiblity Package: ${compatPkgPath}"
	exit -1
fi

#Unzip the files here, junking the structure
localExtract="tmp_extracted"
rm -rf $localExtract
unzip -j ${releasePath} -d ${localExtract}
unzip -j ${compatPkgPath}  -d ${localExtract}

#Rename any beta files
cd ${localExtract}
for thisFile in *.txt ;do
	if [[ ${thisFile} == x* ]]; then
		newFilename=`echo ${thisFile} | cut -c 2-`
		mv ${thisFile} ${newFilename}
	fi
done
cd ..

#Determine the release date from the filenames
releaseDate=`ls -1 ${localExtract}/*.txt | head -1 | egrep -o '[0-9]{8}'`

mysql -u root  << EOF
	drop database IF EXISTS ${dbName} ;
	create database ${dbName};
	use ${dbName};
	source create_schema.sql;
	source create_populateRF1_procedures.sql
	source create_rf2_utility_procedures.sql
	source create_rf2_extract_snapshot_procedure.sql
	select 'Completed schema setup, now loading RF2 data...' as ' ';
	source rf2_import_20160131.sql
	select 'RF2 import complete.  Now loading compatability pacakge...' as ' ';	
	source compatability_package_import_20160131.sql
	select 'Now populating RF1...' as ' ';	
	source populate_rf1_tables.sql
EOF

mysql -u root  << EOF
	use rf1_conversion;
	source create_rf2_utility_procedures.sql
	source create_populateRF1_procedures.sql
	select 'Now loading compatability package...' as ' ';	
	source compatability_package_import_20160131.sql
	select 'Now populating RF1...' as ' ';	
	source populate_rf1_tables.sql
EOF