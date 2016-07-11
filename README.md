# RF2 to RF1 conversion by IHTSDO

This stand alone RF2 to RF1 converter has been developed to meet the suggested criteria set out in [IHTSDO's RF1 Deprecation Plan](http://www.ihtsdo.org/news-articles/rf1-deprecation-and-withdrawal-of-support-request-for-feedback).

## Scope

This RF2 to RF1 conversion works solely from the data available in an RF2 archive and also introduces some of the restrictions suggested as part of [IHTSDO's RF1 Deprecation Plan](http://www.ihtsdo.org/news-articles/rf1-deprecation-and-withdrawal-of-support-request-for-feedback)..  As such the following restrictions exist:

* Qualifying relationships are not included, with the exception of Laterality Qualifying relationships which are optionally generated if a laterality references file can be provided.
* Refineablity indicator is not being set (0 in all cases).
* Relationship identifiers have been set to null.
* The Subset ID is an incrementing integer that's not an SCTID.  As such, it has been set to a number based on the release date to allow for stateless but consistent calculation.
* Then Subset Version is being incremented by an amount linked to the year and month
* A unsupported option (-p) has been added whereby the previous RF1 zip file can be specified.  Using this flag will cause relationship IDs to be included and the subset version will be more accurately +1 from the previous version used.

The tools is also currently able to handle the Spanish Edition by specifying an optional additional zip archive.

## Licence and Acknowledgements

Based on work by Jeremy Rogers which was marked as Crown Copyright
and covered by the Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/

## Usage

Usage:<code>java -jar [JVM Options] RF2toRF1Converter.jar [Processing Flags] <RF2 international archive location>  [<RF2 extension archive location>]</code>

eg  <code>java -jar -Xmx8g RF2toRF1Converter.jar /Backup/SnomedCT_RF2Release_INT_20160131.zip</code>

eg <code>java -jar -Xms512m -Xmx8g -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080 RF2toRF1Converter.jar -v  -u /Volumes/ram_disk ~/Backup/SnomedCT_RF2Release_INT_20160131.zip ~/Backup/SnomedCT_SpanishRelease-es_INT_20160430.zip </code>

### Flags
-a	Additional files.  Passing a directory path after this flag will cause all the files in that directory to be included in the resulting zip archive.  Some files will be recognised and put in specific subdirectories.

-b	Beta flag.  Causes an x to be prepended to all content files and the package name (addition files such as documentation are not affected)

-u	Specify location for unzip eg different physical drive to avoid trying to read/write at the same time.

-v	Show all queries being run (verbose)

JVM debugParams<code> -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080 </code>

### Running on a MAC
A script file go.sh has been provided to simplify the crafting of the java jar file call with a large number of parameters.   This script should be edited as required to suit the location of the various files on the user's own machine.

An example of the command used to create the 20160731 release is:

<code>./go.sh -a /Users/Peter/tmp/additionalFiles/ -u /Volumes/ram_disk/ <code>

### Running on a Windows PC
A script file go.bat has been provided to simplify the crafting of the java jar file call with a large number of parameters. This script asks a number of questions, some of which have a default (just press return to accept the default).
 
It is suggested that the batch script file be edited to make the default responses suitable for the user's own machine.  eg in line 5 change
<code>SET "rf2Archive=G:\incoming\SnomedCT_RF2Release_INT_20160131.zip"</code>
to
<code>SET "rf2Archive=C:\User\YourName\Dowloads\xSnomedCT_RF2Release_INT_20160731.zip"</code>

The script will also pass through any command line arguments to the jar file call so for example it could be called as follows:

NOTE the use of the -p option which causes relationship ids to be populated is not supported.

<code>go.bat -b -p g:\incoming\SnomedCT_RF1Release_INT_20160131.zip</code>

<code>How much memory do you have available? [10g]: </code>

<code>Do you have a 2nd drive? (eg D:\) Y/N: Y</code>

<code>Where is the RF2 Archive? [G:\incoming\xSnomedCT_RF2Release_INT_20160731.zip]: </code>

The full output of running this command is provided here as an example:  https://gist.github.com/pgwilliams/fd35537f49d7581f0e42ae365685c9c6

## Output

### International Edition

The following files are populated in the conversion process (the release date used will be as per the RF2 file used as input):

* sct1_Concepts_Core_INT_20160131.txt
* sct1_Descriptions_en_INT_20160131.txt
* sct1_References_Core_INT_20160131.txt
* sct1_Relationships_Core_INT_20160131.txt
* sct1_TextDefinitions_en-US_INT_20160131.txt
* der1_SubsetMembers_en-GB_INT_20160131.txt
* der1_SubsetMembers_en-US_INT_20160131.txt
* der1_Subsets_en-GB_INT_20160131.txt
* der1_Subsets_en-US_INT_20160131.txt
* res1_StatedRelationships_Core_INT_20160131.txt
* sct1_ComponentHistory_Core_INT_20160131.txt

The appropriate structure - Resources, Subsets, Terminology/Content, etc - is used for the resulting archive

### Spanish Edition

For a conversion of the Spanish Edition, the following files would be produced:

* res1_StatedRelationships_Core_INT_20160430.txt
* sct1_TextDefinitions_es_INT_20160430.txt
* der1_SubsetMembers_es_INT_20160430.txt
* der1_Subsets_es_INT_20160430.txt
* sct1_Concepts_Core_INT_20160131.txt
* sct1_Descriptions_es_INT_20160430.txt
* sct1_Relationships_Core_INT_20160131.txt
* sct1_References_Core_INT_20160430.txt

## System Requirements

* Java Runtime Environment.  Download from http://www.oracle.com/technetwork/java/javase/downloads/index.html
* Suggested Memory - 8Gb

### Notes

* The output archive will appear in the current working directory with the name SnomedCT_RF1Release_INT_&lt;DATE&gt;.zip where DATE is that of the input RF2 archive.  If an existing file of that name exists then the new file will be named with _1.zip suffix, or higher as required.

