# RF2 to RF1 conversion by IHTSDO

Based on work by Jeremy Rogers which was marked as Crown Copyright
and covered by the Open Government License http://www.nationalarchives.gov.uk/doc/open-government-licence/

This RF2 to RF1 conversion works solely from the data available in an RF2 archive.  As such, some items such as qualifier relationships are not available.

The tools is also currently able to handle the Spanish Edition by specifying an optional additional zip archive.

Usage:<code>java -jar [JVM Options] RF2toRF1Converter.jar [Processing Flags] <RF2 international archive location>  [<RF2 extension archive location>]</code>

eg  <code>java -jar -Xmx4g RF2toRF1Converter.jar /Backup/SnomedCT_RF2Release_INT_20160131.zip</code>

### Flags

-h	Also generate the history file

-v	Show all queries being run (verbose)

-u	Specify location for unzip eg difference physical drive to avoid trying to read/write at the same time.

JVM debugParams -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080

## Output

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

In addition, work has progressed on producing the component history file eg sct1_ComponentHistory_Core_INT_20160131.txt but this still requires additional development effort.  This file is not produced by default as it adds 20 minutes to the existing run time, but can be produced using the "-h" flag.

### System Requirements

* Java Runtime Environment.  Download from http://www.oracle.com/technetwork/java/javase/downloads/index.html
* Suggested Memory - 8Gb

### Notes

* The output archive will appear in the current working directory with the name SnomedCT_RF1Release_INT_<DATE>.zip where DATE is that of the input RF2 archive.  If an existing file of that name exists then the new file will be named with _1.zip suffix, or higher as required.

