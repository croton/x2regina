:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorstd.prof reactjs.prof tags.prof
@pause
:: Rename generated profile
@move XW32.PRO REACTJS.PRO
:: Restore previous default
@move XDEF.PRO XW32.PRO
attrib -A tags.prof
attrib -A reactjs.prof
