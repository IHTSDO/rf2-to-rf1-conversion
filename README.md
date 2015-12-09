#RF2 to RF1 conversion

Usage: <release location> <compatability package location> <db schema name>

eg  ./do_conversion.sh ~/tmp/20160131_Beta/SnomedCT_RF2Release_INT_20160131_mkxiv.zip ~/Downloads/wb-compatibilityPackage-release-process-1.20-core_Beta_4_\(20151118\).zip rf1_conversion

## Notes

* The script will automatically strip any Beta prefix "x" characters from the filename

## Example output
	...
	...
  inflating: tmp_extracted/res2_cRefset_RefinabilitySnapshot_INT_20160131.txt
  inflating: tmp_extracted/sct2_Qualifier_Snapshot_20160131.txt

Completed schema setup, now loading data...

RF2 import complete.  Now loading compatability pacakge...

Now populating RF1...

Now loading compatability package...

Now populating RF1...