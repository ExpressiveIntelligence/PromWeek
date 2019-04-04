SET path_to_unzipper="C:\Program Files\7-Zip\7z.exe"
SET args="x"
SET extract=%path_to_unzipper% %args%
chdir ..\CiF
call export-swc.bat
CHDIR ..\ResourceLibrary
CALL export-resources.bat
CHDIR ..\AuthoringLibrary
CALL export-authoring.bat
CHDIR ..\TheProm\lib
CALL %extract% AuthoringLibrary.swc
MOVE library.swf ../bin/AuthoringLibrary.swf
DEL catalog.xml
CALL %extract% ResourceLibrary.swc
MOVE library.swf ../bin/ResourceLibrary.swf
DEL catalog.xml
RMDIR /S /Q locale
RMDIR /S /Q spark
RMDIR /S /Q mx
PAUSE