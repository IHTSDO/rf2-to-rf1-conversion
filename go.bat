@echo off

SET "memParams=-Xms4g -Xmx8g"
SET debugParams=
SET "rf2Archive=G:\incoming\SnomedCT_RF2Release_INT_20160131.zip"
SET "secondDrive=D:\"

SET driveParam=
set /p driveAvailable="Do you have a 2nd drive (%secondDrive%) Y/N: "
IF /I "%driveAvailable%"=="Y" SET "driveParam=-u %secondDrive%"

SET newLocation=
SET /p newLocation="Where is the RF2 Archive? [%rf2Archive%]: "
IF /I NOT [%newLocation%]==[] SET "rf2Archive=%newLocation%"

FOR %%a IN (%*) DO (
  IF /I "%%a"=="-d" SET "debugParams=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080"
)

@echo on
java -jar %memParams% %debugParams% target\RF2toRF1Converter.jar %driveParam% %* %rf2Archive%
