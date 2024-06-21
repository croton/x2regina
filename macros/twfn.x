/* twfn - Access TW classes. */
parse arg input
if input='?' then do; 'MSG twfn - look up a TW class'; exit; end

-- Cursor needs to be between the following delimiters
s='class="'
e='"'
found=filterWordBeforeCursor()
if found='' then xsay 'Please specify part of a TW class.'
else do
  cls=pickClass(found)
  if cls='' then call xsay 'No such TW class: "'found'".'
  else do
    'CURSOR DATA'
    'KEYIN' cls
    do length(cls); 'CURSOR LEFT'; end  -- place cursor before new item
    do length(found); 'BACKSPACE'; end  -- remove abbreviation
  end
end
exit

pickClass: procedure
  parse arg part
  classes=.environment['TWClasses']
  if classes=.nil then return ''
  found=.array~new
  loop item over classes
    if abbrev(item, part) then found~append(item)
  end
  if found~items=0 then return ''
  return pickFromArray(found, 'TW classes')

::requires 'XEdit.x'
::requires 'XPopups.x'
