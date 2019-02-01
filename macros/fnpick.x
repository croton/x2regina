/* fnpick -- Present a dialog from which to select functions.
   The first argument, if provided, is the filestem of the text file and
   will be searched in two places - the current directory and
   in X2HOME\lists. If not provided, the X2 variable CODE_TYPE
   will be retrieved and a filename <code_type>.xfn will be searched.
   The choice retrieved from dialog will be inserted into a template
   if provided.
   Multiple selections are supported by specifying an option, -m
*/
parse arg codeType template
if codeType='-?' then do; 'MSG fnpick [filename][@template][-m]'; exit; end

w=wordpos('-m',template)
if w>0 then do; pickmany=1; template=delword(template,w,1); end; else pickmany=0

if codeType='' then do
  'EXTRACT /CODE_TYPE/'
  codeType=CODE_TYPE.1
end
call insertFn codeType, template, pickmany
exit

/* Load items from specified file and keyin the selected one within a template.*/
insertFn: procedure
  parse arg filestem, tmpl, pickmany
  fnfile=getFunctionFile(filestem)
  if fnfile='' then do
    'MSG Function file not found:' filestem
    return
  end
  if pickmany then do
    ans=pickManyFromFile(fnfile, filestem)
    if ans~items=0 then 'MSG No selection made'
    else loop item over ans
      if tmpl='' then 'INPUT' item
      else            'INPUT' changestr('@', tmpl, item)
    end
  end
  else do
    ans=pickFromFile(fnfile, filestem)
    if ans='' then 'MSG Selection cancelled'
    else do
      if tmpl='' then 'KEYIN' ans
      else            'KEYIN' changestr('@', tmpl, ans)
    end
  end
  return

/* Choose from values in specified file (non-OO) */
getchoice: procedure
  parse arg fnfile, filestem
  'MACRO chooser --f' fnfile '--t' filestem '--q'
  entry=''
  if queued()>0 then parse pull entry
  return entry

/* Search for a matching file given a filespec */
getFunctionFile: procedure
  parse arg filestem
  fnfile=filestem'.xfn'
  x2home=value('X2HOME',,'ENVIRONMENT')
  filepaths='.\'fnfile x2home'\lists\'fnfile
  do w=1 to words(filepaths)
    fn=word(filepaths,w)
    if stream(fn,'c','query exists')<>'' then return fn
  end w
  return ''

::requires 'XRoutines.x'
