/* Present a dialog where return values differ from display values, located in curr dir or X2HOME\lists.*/
parse arg sourcefile options
if abbrev('?', sourcefile) then do
  call xsay 'pickdual dialog-sourcefile [pattern][-d delim][-r fieldIndexReturned][-(h)ide return value]'
  exit
end
w=wordpos('-d',options)
if w>0 then do; delim=word(options,w+1); options=delword(options,w,2); end; else delim=''

w=wordpos('-r',options)
if w>0 then do
  returnIndex=word(options,w+1)
  if \datatype(returnIndex,'W') then returnIndex=2
  options=delword(options,w,2)
end
else returnIndex=2

w=wordpos('-h',options)
if w>0 then do; hideReturnval=1; options=delword(options,w,1); end; else hideReturnval=0
pattern=strip(options)
title=filespec('N',sourcefile)

choice=pickfromdual(sourcefile, title, returnIndex, delim, hideReturnval)
-- 'MESSAGEBOX f='sourcefile 'tmpl='pattern 'idx='returnIndex 'delim='delim 'hideRC?' hideReturnval
select
  when choice='' then call xsay 'Ok, no choice.'
  when abbrev(choice, 'NOFILE') then call xsay 'File not found:' sourcefile
  otherwise
    if pattern='' then 'KEYIN' choice
    else do
      'KEYIN' applyPattern(choice, pattern, '@')
      call reposCursor delim
    end
end
exit

xsay: procedure
  parse arg message
  'CURSOR DATA'
  'REFRESH'; 'MSG' message
  return

applyPattern: procedure
  parse arg selection, pattern, delim
  if delim='' then placeholder='@'
  else             placeholder=strip(delim)
  if pattern='' then return selection
  return changestr(placeholder, strip(pattern), selection)

reposCursor: procedure
  parse arg term, xpos
  if term='(' then do
    -- Place cursor right after open parens
    'LOCATE /(/-'
    'CURSOR +0 +1'
  end
  else 'CURSOR +0 +0'
  return

::requires 'XPopups.x'
