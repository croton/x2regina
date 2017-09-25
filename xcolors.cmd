@echo off
:: Show distinct color settings for an X2 profile
if "%1"=="" goto noargs
if "%2"=="-s" goto schemes
if "%2"=="-u" goto unused
goto default

:noargs
echo xcolors - Show distinct color settings for an X2 profile
echo Usage: xcolors xprofile [options]
echo options
echo   -c = show distinct colors
echo   -s = show distinct schemes
echo   -u = show unused colors
goto end

:unused
SETLOCAL
set fn=dtcolor.temp
set xcolor=%x2home%\lists\x2colors.txt
call cat %1 |grep -i colour |cut -d"=" -f2- |sed "s/ ON/,/ig" |c2nl |sort |uniq > %fn%
:: -w ignore space
call diff %xcolor% %fn% -w
del %fn%
ENDLOCAL
goto end

:schemes
cat %1 |grep -i " ON" |cut -d"=" -f2- |sort |uniq
goto end

:default
if "%2"=="-c" (
  cat %1 |grep -i colour |cut -d"=" -f2- |sed "s/ ON/,/ig" |c2nl |sort |uniq
) else (
  cat %1 |grep -i colour
)
goto end

:end
