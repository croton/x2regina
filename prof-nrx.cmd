@echo off
:: Backup existing default profile
copy XW32.PRO XDEF.PRO
xprof default.prof cjp.prof colorsblue.prof nrx.prof
pause
:: Rename generated profile
move XW32.PRO NRX.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A nrx.prof
