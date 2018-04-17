:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorsblue.prof jsreact.prof
@pause
:: Rename generated profile
move XW32.PRO jsreact.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A jsreact.prof
