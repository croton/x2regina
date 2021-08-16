@copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorz.prof jest.prof
@pause
@move XW32.PRO JEST.PRO
@move XDEF.PRO XW32.PRO
@attrib -A jest.prof
