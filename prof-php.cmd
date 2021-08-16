:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colors.prof phphtml.prof tags.prof espana.prof php.prof
@pause
:: Rename generated profile
@move XW32.PRO PHP.PRO 2>nul
:: Restore previous default
@move XDEF.PRO XW32.PRO 2>nul
@attrib -A phphtml.prof
@attrib -A tags.prof
@attrib -A espana.prof
@attrib -A cssxtra.prof
@attrib -A php.prof
