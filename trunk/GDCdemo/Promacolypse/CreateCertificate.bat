@echo off

:: AIR certificate generator
:: More information:
:: http://livedocs.adobe.com/flex/3/html/help.html?content=CommandLineTools_5.html#1035959
:: http://livedocs.adobe.com/flex/3/html/distributing_apps_4.html#1037515

:: Path to Flex SDK binaries
set PATH=%PATH%;C:\flex_sdk_3\bin

:: Certificate information
set NAME=SelfSigned
set PASSWORD=fd
set CERTIFICATE=SelfSigned.pfx

call adt -certificate -cn %NAME% 1024-RSA %CERTIFICATE% %PASSWORD%
if errorlevel 1 goto failed

echo.
echo Certificate created: %CERTIFICATE%
echo With password: %PASSWORD%
echo.
echo Hint: you may have to wait a few minutes before using this certificate to build your AIR application setup.
echo.
goto end

:failed
echo.
echo Certificate creation FAILED.
echo.
echo Troubleshotting: did you configure the Flex SDK path in this Batch file?
echo.

:end
pause