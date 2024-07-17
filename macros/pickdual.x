/* Present a dialog where return values differ from display values, located in curr dir or X2HOME\lists.*/
parse arg sourcename options
if abbrev('?', sourcename) then do
  call xsay 'pickdual dialog-sourcefile [title][-d delim]'
  exit
end
w=wordpos('-d',options)
if w>0 then do; delim=word(options,w+1); options=delword(options,w,2); end; else delim=''
title=options

choice=pickfromDualSort(sourcename, title, delim)
if choice='' then call xsay 'Choice cancelled'
else 'KEYIN' choice
exit

xsay: procedure
  parse arg message
  'REFRESH'; 'MSG' message
  return

::requires 'XPopups.x'
