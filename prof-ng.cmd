@echo off
:: Backup existing default profile
copy XW32.PRO XDEF.PRO
:: First argument if present would be another profile
xprof default.prof cjp.prof colorsblue.prof %1 ng.prof
pause
:: Rename generated profile
move XW32.PRO NG.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A ng.prof
if exist %1 attrib -A %1
