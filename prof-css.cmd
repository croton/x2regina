@echo off
:: Backup existing default profile
copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorz.prof html.prof tags.prof css.prof cssxtra.prof
pause
:: Rename generated profile
move XW32.PRO CSS.PRO 2>nul
:: Restore previous default
move XDEF.PRO XW32.PRO 2>nul
attrib -A html.prof
attrib -A tags.prof
attrib -A css.prof
