SET mypath=%~dp0
SET WORKINGPATH=%cd%
cd /d"%mypath%"
start "LayoutEditor-Starter" /min LayoutEditor.bat %*
exit

