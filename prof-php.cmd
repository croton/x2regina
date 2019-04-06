:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorsblue.prof php.prof
@pause
:: Rename generated profile
@move XW32.PRO PHP.PRO
:: Restore previous default
@move XDEF.PRO XW32.PRO
attrib -A php.prof
