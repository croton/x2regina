/* Present a dialog where return values differ from display values, located in curr dir or X2HOME\lists.*/
parse arg sourcename .
if sourcename='' then do
  call xsay 'No dialog source file specified'
  return
end
choice=pickfromDual(sourcename)
if choice='' then call xsay 'Choice cancelled'
else 'KEYIN' choice
exit

xsay: procedure
  parse arg message
  'REFRESH'; 'MSG' message
  return

::requires 'XPopups.x'
