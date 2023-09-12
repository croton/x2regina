/* csspop - provide a list of CSS classes in a popup */
parse arg pickMany sourcefile useHtml useTagHelper .
if pickMany='?' then do; 'MSG csspop [pickMany][src][useHtml][useTagHelper]'; exit; end

-- tagname shall be last word on current line
'EXTRACT /CURLINE/'
'EXTRACT /CURSOR/'
tagname=getWordBefore(CURLINE.1, CURSOR.2)
if tagname='' then tagname='div'
lastWordRemoved=delword(CURLINE.1, max(words(CURLINE.1), 1))

if sourcefile='' then sourcefile='classes-bulma'
fnFile=getFunctionFile(sourcefile)
if pickMany='' then
  choice=pickFromFile(fnFile, 'CSS class')
else do
  choices=pickManyFromFile(fnFile, 'CSS class')
  choice=stringify(choices)
end

if useHtml=1 then htmlattrib='class'
else              htmlattrib='className'

if useTagHelper=1 then do
  -- Generate a new html tag
  open='<'tagname htmlattrib'="'choice'">'
  closed='</'tagname'>'
  leadblanks=getIndent()
  if lastWordRemoved='' then 'DELETE'
  else                       'REPLACE' lastWordRemoved
  'INPUT' leadblanks||open
  'INPUT' leadblanks||closed
end
else do
  'KEYIN' choice
end
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
