@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorz.prof graphql.prof
@pause
@move XW32.PRO GQL.PRO
@move XDEF.PRO XW32.PRO
@attrib -A graphql.prof
