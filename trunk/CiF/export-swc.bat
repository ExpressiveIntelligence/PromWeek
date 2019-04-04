@echo off
call compc -load-config+=CiF-config.xml -source-path src/ -output lib/CiF-test.swc -namespace http://CiF CiF-manifest.xml -include-namespaces http://CiF
copy /Y lib\CiF-test.swc lib\CiF.swc
copy /Y lib\CiF-test.swc ..\DesignTool\lib\CiF.swc
copy /Y lib\CiF-test.swc ..\TheProm\lib\CiF.swc
copy /Y lib\CiF-test.swc ..\MLProject\lib\CiF.swc
copy /Y lib\CiF-test.swc ..\MLAirProject\lib\CiF.swc
copy /Y lib\CiF-test.swc ..\LibraryMerger\lib\CiF.swc
copy /Y lib\CiF-test.swc ..\ResourceLibrary\lib\CiF.swc
copy /Y lib\CiF-test.swc ..\LevelTraceAnalyzer\lib\CiF.swc