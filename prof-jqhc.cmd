@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colors.prof es6.prof jquery.prof html.prof tags.prof css.prof
@pause
@move XW32.PRO JQHC.PRO
@move XDEF.PRO XW32.PRO
@attrib -A es6.prof
@attrib -A jquery.prof
@attrib -A html.prof
@attrib -A tags.prof
@attrib -A css.prof
