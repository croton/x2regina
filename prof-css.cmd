@echo off
:: Backup existing default profile
copy XW32.PRO XDEF.PRO 2>nul
xprof default.prof cjp.prof colorsblue.prof html.prof tags.prof css.prof
pause
:: Rename generated profile
move XW32.PRO CSS.PRO
:: Restore previous default
move XDEF.PRO XW32.PRO
attrib -A html.prof
attrib -A tags.prof
attrib -A css.prof
