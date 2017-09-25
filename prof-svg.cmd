:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorsblue.prof svg.prof
@pause
:: Rename generated profile
move XW32.PRO svg.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A svg.prof
