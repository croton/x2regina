/* dif - Show results of git diff on current file. */
arg saveInFile
if saveInFile='-?' then do; 'MSG dif [F]'; exit; end

'EXTRACT /CD/'
'EXTRACT /NAME/'
partialpath=abbrevPath(NAME.1, CD.1)
output='git-diff-out'
xcmd='git diff' partialpath

if abbrev('FILE', saveInFile, 1) then
  'MACRO cmdout' output xcmd
else
  'SHELL start "Git-Diff" cmd /C' xcmd
exit

::requires 'XRoutines.x'
