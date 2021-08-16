/* simple -- For use with expansion macro */
parse arg items
if items='' then do
  'MSG usage: simple item-list'
  exit
end
key=wordBeforeCursor()
found=lookup(key, items)
if found='' then 'MSG No lookup value found for' key
exit

lookup: procedure
  parse arg term, items
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
      'KEYIN' curritem     -- insert matched item from list
      'KEYIN' d2c(32)      -- add a space
    end
  end i
  if found then return curritem
  return ''

::requires 'XEdit.x'
