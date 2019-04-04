REM call compc -load-config+=confs/resources-config.xml
REM -runtime-shared-library-path=lib/framework.swc,framework_4.0.0.5902.swz,,framework_4.0.0.5902.swf 
REM -link-report resources-link-report.xml
DEL lib\ResourceLibrary.swc
SET normalstuff=--namespace+=http://ns.adobe.com/mxml/2009,${flexlib}/mxml-2009-manifest.xml --namespace+=http://www.adobe.com/2006/mxml,${flexlib}/mxml-manifest.xml --namespace+=library://ns.adobe.com/flex/spark,${flexlib}/spark-manifest.xml -external-library-path lib -external-library-path+=${flexlib}/libs/player/10.0
REM -external-library-path+=${flexlib}/libs -library-path+=data/characters -library-path+=data/characters/promOutfits 
call compc -source-path src/ -output lib/ResourceLibrary.swc -include-namespaces+=http://PromWeek -namespace+=http://PromWeek,confs/ResourceLibrary-manifest.xml %normalstuff% -library-path+=data/menus -library-path+=data/icons/relationships -library-path+=data/characters/skins -include-lookup-only=true