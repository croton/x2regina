@echo off
if "%1"=="-?" goto help
goto default

:help
echo prof-batch - Generate an X2 profile for Batch (default) or Bash
echo usage: prof-batch [-b]
goto end

:default
SETLOCAL
set myprof=batch
if "%1"=="-b" set myprof=bash
:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorsblue.prof %myprof%.prof
pause
:: Rename generated profile
move XW32.PRO %myprof%.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A %myprof%.prof
ENDLOCAL
goto end

:end
