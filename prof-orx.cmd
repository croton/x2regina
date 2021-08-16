@echo off
copy XW32.PRO XDEF.PRO
xprof default.prof cjp.prof colors.prof rexx.prof orexx.prof
pause
:: Rename generated profile
move XW32.PRO ORX.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A rexx.prof
attrib -A orexx.prof
