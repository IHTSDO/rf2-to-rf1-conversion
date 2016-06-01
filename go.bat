@echo off

SET "memParams=-Xms4g -Xmx10g"
SET debugParams=
SET "rf2Archive=G:\incoming\SnomedCT_RF2Release_INT_20160131.zip"
SET "secondDrive=D:\"

SET newMemory=
set /p newMemory="How much memory do you have available? [10g]: "
IF NOT [%newMemory%]==[] SET "memParams=-Xms4g -Xmx%newMemory%"

SET driveParam=
set /p driveAvailable="Do you have a 2nd drive (eg %secondDrive%) Y/N: "
IF /I "%driveAvailable%"=="Y" SET "driveParam=-u %secondDrive%"

SET newLocation=
SET /p newLocation="Where is the RF2 Archive? [%rf2Archive%]: "
IF NOT [%newLocation%]==[] SET "rf2Archive=%newLocation%"

FOR %%a IN (%*) DO (
  IF /I "%%a"=="-d" SET "debugParams=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8080"
)

@echo on
java -jar %memParams% %debugParams% target\RF2toRF1Converter.jar %driveParam% %* %rf2Archive%
