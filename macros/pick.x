/* pick -- Present a dialog from which to select functions.
   The first argument, if provided, is the filestem of the text file and
   will be searched in two places - the current directory and
   in X2HOME\lists.
   The choice retrieved from dialog will be inserted into a template
   if provided.
   Multiple selections are supported by specifying option -m or
   -M for pick-many-and-concatenate
*/
parse arg codeType template
if abbrev('?', codeType) then do; 'MSG pick [filename][@template][-m]'; exit; end

w=wordpos('-m',template)
if w>0 then do; pickmany=1; template=delword(template,w,1); end; else pickmany=0

--  Optionally, insert many selections into one line (concatenated)
w=wordpos('-M',template)
if w>0 then do
  pickmany=1
  concat=1
  template=delword(template,w,1)
end

if pickmany then do
  choices=pickMulti(codeType, template)
  if choices~items=0 then 'MSG No selection'
  else call insertMany choices, template, concat
end
else do
  choice=pickOne(codeType, template)
  if choice='' then 'MSG No selection'
  else call reposCursor choice, template, '@'
end
exit

pickOne: procedure
  parse arg filestem, tmpl
  fnfile=getFunctionFile(filestem)
  if fnfile='' then do
    'MESSAGEBOX Function file not found:' filestem
    return ''
  end
  return pickFromFile(fnfile, filestem)

pickMulti: procedure
  parse arg filestem, tmpl
  fnfile=getFunctionFile(filestem)
  if fnfile='' then do
    'MESSAGEBOX Function file not found:' filestem
    return ''
  end
  return pickManyFromFile(fnfile, filestem)

insertMany: procedure
  use arg choices, tmpl, concat
  if concat=1 then do
    item=''
    do choice over choices
      item=item choice
    end
    if tmpl='' then 'KEYIN' strip(item)
    else            'KEYIN' changestr('@', tmpl, strip(item))
  end -- concat choices into one line
  else do
    leadblanks=getIndent()
    loop item over choices
      if tmpl='' then 'INPUT' leadblanks||item
      else            'INPUT' leadblanks||changestr('@', tmpl, item)
    end
  end
  return

reposCursor: procedure
  parse arg choice, tmpl, delim
  if tmpl='' then 'KEYIN' choice
  else            'KEYIN' changestr('@', tmpl, choice)
  if pos('(',choice)>0 then do
    -- Place cursor right after open parens
    'LOCATE /(/-'
    'CURSOR +0 +1'
  end -- reposition cursor
  return

/* Choose from values in specified file, alternate method. */
getchoice: procedure
  parse arg fnfile, filestem
  'MACRO chooser --f' fnfile '--t' filestem '--q'
  entry=''
  if queued()>0 then parse pull entry
  return entry

::requires 'XEdit.x'
::requires 'XPopups.x'
