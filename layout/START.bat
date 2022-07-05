
echo off
set mypath=%~dp0
echo using LayoutEditor installation at '%mypath%'
set "pycell=no"
for /f %%i in ('"%mypath%bin\getsetup.exe" pycell') do set "pycell=%%i"
set "addPATH="
echo "not found" > "%TMP%\oa.txt"
if "%pycell%"=="default"  (
   echo "using pycell set by enviourment"
   echo 22.50 > "%TMP%\oaver.txt"
   oaGetVersion.exe > "%TMP%\oa.txt" 2> nul
   where cnversion || goto error
) else (
  :cont
  echo "using shipped oa library"
  echo 22.50 > "%TMP%\oaver.txt"
  if exist "%mypath%oa\bin\x64\opt" (
     echo "OpenAccess found at %mypath%oa"
     set "addPATH=%mypath%oa\bin\x64\opt"
     "%mypath%oa\bin\x64\opt\oaGetVersion.exe" > "%TMP%\oa.txt"
   ) else (
         if exist "%mypath%oa\bin\win32\opt" (
           echo "OpenAccess found at %mypath%oa (32bit)"
           set "addPATH=%mypath%oa\bin\win32\opt"
           "%mypath%oa\bin\win32\opt\oaGetVersion.exe" > "%TMP%\oa.txt"
         )
         else (
             echo "OpenAccess without PyCell not found, try to activate PyCell"
             echo 22.50 > "%TMP%\oaver.txt"
             oaGetVersion.exe > "%TMP%\oa.txt" 2> nul
         )
   )
)

 findstr /C:"22.60" %TMP%\oa.txt
 if NOT errorlevel 1 echo 22.60 > "%TMP%\oaver.txt"
 findstr /C:"22.50" %TMP%\oa.txt
 if NOT errorlevel 1 echo 22.50 > "%TMP%\oaver.txt"
 findstr /C:"22.43" "%TMP%\oa.txt"
 if NOT errorlevel 1 echo 22.43 > "%TMP%\oaver.txt"
 findstr /C:"22.42" "%TMP%\oa.txt"
 if NOT errorlevel 1 echo 22.42 > "%TMP%\oaver.txt"
 findstr /C:"22.41" "%TMP%\oa.txt"
 if NOT errorlevel 1 echo 22.41" > "%TMP%\oaver.txt"
 findstr /C:"22.04" "%TMP%\oa.txt"
 if NOT errorlevel 1 echo 22.04 > "%TMP%\oaver.txt"
 set /P oaver=<%TMP%\oaver.txt
 echo use OpenAccess %oaver%

set "Path=%addPATH%;%path%;%mypath%openroad/bin"
set "LD_LIBRARY_PATH=%mypath%openroad/lib"
cd /d%WORKINGPATH% 2> nul
start "LayoutEditor" /B "%mypath%bin/layout" --oa%oaver% %*
set pr=LayoutEditor
set pr=!pr:"=!
echo CreateObject("wscript.shell").appactivate "!pr!" > "%tmp%\focus.vbs"
call "%tmp%\focus.vbs"
exit
goto:eof
:error
    echo *
    echo ********************************************************************
    echo *
    echo * no PyCell installation found on your system!
    echo * please install it and set enviourment correctly
    echo *
    echo * fall back on oa package without PyCell
    echo *
    echo *
    echo ********************************************************************
    echo *
    echo 22.50 > "%TMP%\oaver.txt"
    ping 127.0.0.1 -n 6 > nul
    goto cont
goto:eof
