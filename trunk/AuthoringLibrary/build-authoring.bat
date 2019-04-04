REM call compc -load-config+=confs/resources-config.xml
REM -runtime-shared-library-path=lib/framework.swc,framework_4.0.0.5902.swz,,framework_4.0.0.5902.swf 
REM -link-report resources-link-report.xml
DEL lib\AuthoringLibrary.swc
SET normalstuff=--namespace+=http://ns.adobe.com/mxml/2009,${flexlib}/mxml-2009-manifest.xml --namespace+=http://www.adobe.com/2006/mxml,${flexlib}/mxml-manifest.xml --namespace+=library://ns.adobe.com/flex/spark,${flexlib}/spark-manifest.xml -external-library-path lib -external-library-path+=${flexlib}/libs/player/10.0 -external-library-path ../ResourceLibrary/lib/ResourceLibrary.swc
call compc -source-path src/ -output lib/AuthoringLibrary.swc -include-namespaces+=http://PromWeek -namespace+=http://PromWeek,conf/AuthoringLibrary-manifest.xml %normalstuff% -link-report linkreport.xml