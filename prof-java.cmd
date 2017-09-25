@echo off
:: Backup existing default profile
copy XW32.PRO XDEF.PRO
xprof default.prof cjp.prof colorstd.prof java.prof
pause
:: Rename generated profile
move XW32.PRO JAVA.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A java.prof
