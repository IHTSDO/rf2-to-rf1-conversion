# RF2 to RF1 conversion by IHTSDO

This stand alone RF2 to RF1 converter has been developed to meet the suggested criteria set out in [IHTSDO's RF1 Deprecation Plan](http://www.ihtsdo.org/news-articles/rf1-deprecation-and-withdrawal-of-support-request-for-feedback).

## Scope

This RF2 to RF1 conversion works solely from the data available in an RF2 archive and also introduces some of the restrictions suggested as part of [IHTSDO's RF1 Deprecation Plan](http://www.ihtsdo.org/news-articles/rf1-deprecation-and-withdrawal-of-support-request-for-feedback).  As such the following restrictions exist:

* Qualifying relationships are not included, with the exception of Laterality Qualifying relationships which are always generated.  The reference data required to support Laterality Relationships are included in the tool for 2016 and will be taken from a Laterality Refset included in the International Edition from 2017 onwards.
* Refineablity indicator is not being set (0 in all cases).
* Relationship identifiers have been set to null.
* Then Subset Version is being incremented by an amount linked to the year and month.
* A unsupported option (-p) has been added whereby the previous RF1 zip file can be specified.  Using this flag will cause relationship IDs to be included and the subset version will be more accurately calculated (ie +1) from the previous version used.

The tool is also currently able to handle the Spanish Edition by specifying an optional additional zip archive.

UPDATE: Support has now been added for the US Edition, but this is experimental and has yes to be validated against previous releases.

The US Edition conversion has the following caveats:
* History prior to 20140131 is limited to that of the International Edition.  As such, some concepts may be missing their creation dates.
* The US Edition contains a number of inactivation indicators for the same component when an inactivated component is only expected to have one active inactivation reason against it.  In this case, an inactivation indicator has been chosen at random (effectively, actually the highest UUID is used).


## Licence and Acknowledgements

Based on work by Jeremy Rogers which was marked as Crown Copyright
and covered by the Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/

## Issues
Please log any issues encountered through the GitHub Issues page:  https://github.com/IHTSDO/rf2-to-rf1-conversion/issues

## System Requirements

* Java Runtime Environment (make sure to get 64bit).  Download from http://www.oracle.com/technetwork/java/javase/downloads/index.html
* Maven is required to build the tool: 
  * Windows - http://maven.apache.org/guides/getting-started/windows-prerequisites.html
  * Mac - most easily installed using 'brew' - http://brewformulas.org/Maven
* Suggested Memory - 8Gb.   It scraped through with 6Gb.  Jury is still out on 4Gb.

## Building

Build the tool (a java jar file) using the command:
<code>mvn clean package</code>

You'll need to have installed Maven on your computer for this to work.
Once the self contained jar file has been created, it can either be transferred to another location to run, or called directly eg 

<code>java -jar  target/RF2toRF1Converter.jar  ~/Backup/SnomedCT_RF2Release_INT_20160731.zip</code>

## Usage

Usage:<code>java -jar [JVM Options] RF2toRF1Converter.jar [Processing Flags] <RF2 international archive location>  [<RF2 extension archive location>]</code>

eg  <code>java -jar -Xmx8g RF2toRF1Converter.jar /Backup/SnomedCT_RF2Release_INT_20160131.zip</code>

eg <code>java -jar -Xms512m -Xmx8g -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080 RF2toRF1Converter.jar -v  -u /Volumes/ram_disk ~/Backup/SnomedCT_RF2Release_INT_20160131.zip ~/Backup/SnomedCT_SpanishRelease-es_INT_20160430.zip </code>

### Flags
-a	Additional files.  Passing a directory path after this flag will cause all the files in that directory to be included in the resulting zip archive.  Some files will be recognised and put in specific subdirectories.

-b	Beta flag.  Causes an x to be prepended to all content files and the package name (addition files such as documentation are not affected)

-u	Specify location for unzip eg different physical drive (or, optimally, a ram drive) to avoid trying to read/write at the same time.

-v	Show all queries being run (verbose)

JVM debugParams<code> -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080 </code>

### Running on a MAC / Unix (tested with Ubuntu)
A script file go.sh has been provided to simplify the crafting of the java jar file call with a large number of parameters.   This script should be edited as required to suit the location of the various files on the user's own machine.

An example of the command used to create the 20160731 release is:

<code>./go.sh -a /Users/Peter/tmp/additionalFiles/ -u /Volumes/ram_disk/ </code>

The beta for the Spanish Edition was produced with: 
<code>./go.sh -u /Volumes/ram_disk/ -b -a ~/tmp/es_additionalFiles/ -v</code>

### Running on a Windows PC
A script file go.bat has been provided to simplify the crafting of the java jar file call with a large number of parameters. This script asks a number of questions, some of which have a default (just press return to accept the default).
 
It is suggested that the batch script file be edited to make the default responses suitable for the user's own machine.  eg in line 5 change
<code>SET "rf2Archive=G:\incoming\SnomedCT_RF2Release_INT_20160131.zip"</code>
to
<code>SET "rf2Archive=C:\User\YourName\Dowloads\xSnomedCT_RF2Release_INT_20160731.zip"</code>

The script will also pass through any command line arguments to the jar file call so for example it could be called as follows:

NOTE the use of the -p option which causes relationship ids to be populated is not recommended and it was not the intention of the IHTSDO to offer this facility as stated in the RF1 Deprecation documentation.   It should work, however.

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

### Notes

* The output archive will appear in the current working directory with the name SnomedCT_RF1Release_INT_&lt;DATE&gt;.zip where DATE is that of the input RF2 archive.  If an existing file of that name exists then the new file will be named with _1.zip suffix, or higher as required.

