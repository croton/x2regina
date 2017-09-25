/* fnpick -- Pull up a dialog from which to select functions.
   The first argument, if provided, is the filestem of the text file and
   will be searched in two places - the current directory and
   in X2HOME\lists. If not provided, the X2 variable CODE_TYPE
   will be retrieved and a filename <code_type>.xfn will be searched.
*/
parse arg input template .
if input='-?' then do; 'MSG fnpick [filename]'; exit; end

if input='' then do
  'EXTRACT /CODE_TYPE/'
  input=CODE_TYPE.1
end
call insertFn input, template
exit

/* Load items from specified file and keyin the selected one within a template.*/
insertFn: procedure
  parse arg filestem, tmpl
  fnfile=getFunctionFile(filestem)
  if fnfile='' then 'MSG Function file not found:' filestem
  else do
    ans=getchoice(fnfile, filestem)
    if ans='' then
      'MSG Selection cancelled'
    else do
      if tmpl='' then 'KEYIN' ans
      else            'KEYIN' changestr('@', tmpl, ans)
    end
    -- 'KEYIN ng-'ans'=""'
  end
  return

/* Load items from specified file and keyin the selected one. */
insertFn1: procedure
  arg filestem
  fnfile=getFunctionFile(filestem)
  if fnfile='' then 'MSG Function file not found:' filestem
  else do
    ans=getchoice(fnfile, filestem)
    if ans='' then
      'MSG Selection cancelled'
    else
      'KEYIN' ans
  end
  return

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

