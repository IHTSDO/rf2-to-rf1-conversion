SET "memParams=-Xms512m -Xmx2g"
rem SET "debugParams=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080"
SET debugParams=
java -jar %memParams% %debugParams% target\RF2toRF1Converter.jar ^
 -u e:\ ^
 -v C:\backup\SnomedCT_RF2Release_INT_20150731.zip ^
 C:\backup\SnomedCT_SpanishRelease-es_INT_20151031.zip
