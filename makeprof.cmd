@echo off
if "%1"=="" goto help
if "%1"=="-?" goto help
goto default

:help
echo makeprof - Create script to generate a given profile
echo usage: makeprof name profiles
echo example: makeprof web html.prof jscript.prof jquery.prof
goto end

:default
SETLOCAL
set fn=prof-%1.cmd
call merge %X2HOME%\makeprof.tmpl %* >> %fn%
echo Created %fn%
ENDLOCAL
goto end

:end
