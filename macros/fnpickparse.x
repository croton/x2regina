/* fnpickparse - Present a dialog from which to select items from a
   specified list.
   filestem - stem of a list data file in X2HOME\lists
*/
parse arg filestem options
if abbrev('?', filestem) then do; 'MSG fnpickparse filestem [-d delim][pattern]'; exit; end

w=wordpos('-d',options)
if w>0 then do; delim=word(options,w+1); options=delword(options,w,2); end; else delim=' '
pattern=strip(options)

-- 'MESSAGEBOX Use delim "'delim'" and pattern=['pattern']'
choice=pickItem(filestem, delim)
'CURSOR DATA'

if choice='NOFILE' then call xsay 'File not found:' filestem
else if choice='' then call xsay 'Ok, no choice.'
else do
  if pattern='' then 'KEYIN' choice
  else do
    'KEYIN' applyPattern(choice, pattern, '@')
    call reposCursor delim
  end
end
exit

pickItem: procedure
  parse arg filestem, delim
  filename=getFunctionFile(filestem)
  if \SysFileExists(filename) then do
    if SysFileExists(filestem) then filename=filestem
    else return 'NOFILE'
  end
  ifile=.Stream~new(filename)
  map=.directory~new
  if delim='' then do while ifile~lines>0
    data=ifile~linein
    parse var data name rest
    map~put(data, name)
  end
  else do while ifile~lines>0
    data=ifile~linein
    parse var data name (delim) rest
    if delim='(' then displayvalue=data
    else              displayvalue=translate(data, ' ', delim)
    map~put(displayvalue, name)
  end
  ifile~close
  return pickfrom(map, filestem)

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
