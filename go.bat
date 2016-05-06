SET "memParams=-Xms4g -Xmx8g"
rem SET "debugParams=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080"
SET debugParams=

java -jar %memParams% %debugParams% target\RF2toRF1Converter.jar -u D:\ -v G:\incoming\SnomedCT_RF2Release_INT_20160131.zip
