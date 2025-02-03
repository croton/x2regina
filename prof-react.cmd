:: Backup existing default profile
@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorz.prof reactjs.prof html.prof css.prof cssxtra.prof
@pause
:: Rename generated profile
@move XW32.PRO REACTJS.PRO
:: Restore previous default
@move XDEF.PRO XW32.PRO
attrib -A reactjs.prof
attrib -A html.prof
attrib -A css.prof
