@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colors.prof yml.prof
@pause
@move XW32.PRO YML.PRO
@move XDEF.PRO XW32.PRO
@attrib -A yml.prof
