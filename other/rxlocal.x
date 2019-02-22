/* Convenience macro for local REXX functions */
arg type
if abbrev('PUBLIC', type, 1) then
  xcmd='grep -i "::routine" %x2home%\macros\XRoutines.x|grep -i public|wordf 2'
else
  xcmd='grep -i "::routine" %x2home%\macros\XRoutines.x|grep -i private|wordf 2'
'MACRO chooser --t XRoutines --c' xcmd
exit
