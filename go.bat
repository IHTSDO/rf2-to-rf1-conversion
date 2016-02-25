SET "memParams=-Xms512m -Xmx2g"

java -jar %memParams% target\RF2toRF1Converter.jar -u E:\ -v C:\incoming\SnomedCT_RF2Release_INT_20160131.zip
