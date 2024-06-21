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
if codeType='?' then do; 'MSG fnpick [filename][@template][-m]'; exit; end

w=wordpos('-m',template)
if w>0 then do; pickmany=1; template=delword(template,w,1); end; else pickmany=0

/* Optionally, insert many selections into one line (concatenated) rather than
   one choice per line
*/
w=wordpos('-M',template)
if w>0 then do
  pickmany=1
  concat=1
  template=delword(template,w,1)
end

if codeType='' then do
  'EXTRACT /CODE_TYPE/'
  codeType=CODE_TYPE.1
end
leadblanks=getIndent()
call insertFn codeType, template, pickmany, concat, leadblanks
exit

/* Load items from specified file and keyin the selected one within a template.*/
insertFn: procedure
  parse arg filestem, tmpl, pickmany, concat, indent
  fnfile=getFunctionFile(filestem)
  if fnfile='' then do
    'MSG Function file not found:' filestem
    return
  end
  if pickmany then do
    choices=pickManyFromFile(fnfile, filestem)
    if choices~items=0 then 'MSG No selection made'
    else do
      if concat=1 then do
        item=''
        do choice over choices
          item=item choice
        end
        if tmpl='' then 'KEYIN' strip(item)
        else            'KEYIN' changestr('@', tmpl, strip(item))
      end -- concat choices into one line
      else do
        loop item over choices
          if tmpl='' then 'INPUT' indent||item
          else            'INPUT' indent||changestr('@', tmpl, item)
        end
      end
    end -- choices made
  end -- pick many
  else do
    choice=pickFromFile(fnfile, filestem)
    if choice='' then 'MSG Selection cancelled'
    else do
      if tmpl='' then 'KEYIN' choice
      else            'KEYIN' changestr('@', tmpl, choice)
    end
  end
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
