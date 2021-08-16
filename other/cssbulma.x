/* cssbulma - provide a list of Bulma CSS classes in a popup */
parse arg pickMany
if pickMany='?' then do; 'MSG cssbulma [pickMany]'; exit; end

-- tagname shall be last word on current line
'EXTRACT /CURLINE/'
'EXTRACT /CURSOR/'
tagname=getWordBefore(CURLINE.1, CURSOR.2)
if tagname='' then tagname='div'
lastWordRemoved=delword(CURLINE.1, max(words(CURLINE.1), 1))

fnFile=getFunctionFile('classes-bulma')
if pickMany='' then
  choice=pickFromFile(fnFile, 'CSS class')
else do
  choices=pickManyFromFile(fnFile, 'CSS class')
  choice=stringify(choices)
end
open='<'tagname' class="'choice'">'
closed='</'tagname'>'
leadblanks=getIndent()
if lastWordRemoved='' then 'DELETE'
else                       'REPLACE' lastWordRemoved
'INPUT' leadblanks||open
'INPUT' leadblanks||closed
exit

stringify: procedure
  use arg collection
  item=''
  do choice over collection
    item=item choice
  end
  return strip(item)

::requires 'XPopups.x'
::requires 'XEdit.x'
-- ::requires 'XRoutines.x'
