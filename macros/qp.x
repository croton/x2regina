/* qp -- QuickPick, match the last word typed with items in a list. */
parse arg items
if items='' then do
  'MSG usage: qp item-list'
  exit
end
-- Insert the selected item into a pattern?
parse var items '--p' pattern '--'
key=wordBeforeCursor()
found=lookup(key, items, pattern)
if found='' then 'MSG No lookup value found for' key
exit

lookup: procedure
  parse arg term, items, pattern
  if term='' then return ''
  part=translate(term)
  found=0
  do i=1 to words(items) until found
    curritem=word(items, i)
    if abbrev(translate(curritem), part) then do
      found=1
      'CURSOR DATA'
      'PREVIOUS_WORD'
      'DELWORD'            -- remove abbreviation
      if pattern='' then 'KEYIN' curritem  -- insert matched item from list
      else do
        parse var items '--d' delim '--'
        if delim='' then placeholder='@'
        else             placeholder=strip(delim)
        'KEYIN' changestr(placeholder, strip(pattern), curritem)
      end
      'KEYIN' d2c(32)      -- add a space
    end
  end i
  if found then return curritem
  return ''

::requires 'XEdit.x'
