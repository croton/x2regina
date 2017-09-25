/* deleter -- Delete file or part of file. */
arg input
if input='-?' then do; 'MSG deleter option'; exit; end

select
  when input='FILE' then call closedelete
  when input='LASTWORD' then call removeLastWord
  otherwise
    ok=msgYNBox('Ready to remove all lines from current line down?')
    if ok then 'DELETE *'
    else       'MSG Delete cancelled'
end
exit

msgYNBox: procedure
  parse arg msg, title
  'EXTRACT /ESCAPE/'
  CR=ESCAPE.1||'N'
  if msg='' then msg='Continue?'
  maxwidth=max(length(msg), length(title))+5
  divline=copies('-', maxwidth)
  choices=centre('(Y)es | (N)o', maxwidth)
  info=' 'msg
  if title='' then
    'MESSAGEBOX' info||CR choices
  else
    'MESSAGEBOX' title||CR divline||CR info||CR choices
  if result='ENTER' then return 1
  else if abbrev(translate(result), 'Y') then return 1
  return 0


-- Close the current file and delete it
closedelete: procedure
  'EXTRACT /FILENAME/'
  ok=msgYNBox('Remove Current File "'filespec('N',FILENAME.1)'"?')
  if \ok then do
    'MSG Delete cancelled.'
    return
  end
  'QQUIT'
  ADDRESS SYSTEM 'del' filename.1
  'MSG Removed file' filename.1
  return

-- Remove last word on current line
removeLastWord: procedure
  'CURSOR DATA'
  'EXTRACT /CURSOR/'
  'EXTRACT /CURLINE/'
  -- Is cursor at last position in line?
  if CURSOR.2<>length(CURLINE.1)+1 then
    'CURSOR EOL'
  'PREVIOUS_WORD'
  'ERASEEOL'
  return

