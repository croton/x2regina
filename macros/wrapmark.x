/* wrapmark -- Wrap highlighted text of current line in specified tokens. */
parse arg input
if input='' | input='-?' then call help

parse var input delim +1 leftside (delim) rightside (delim) options
'EXTRACT /MARK/'
'EXTRACT /CURLINE/'

'CURSOR DATA'

-- No mark or line mark
if MARK.0=0 | MARK.4=0 then do
  'KEYIN' leftside||rightside
  'CURSOR +0 -1'   -- leave the cursor between inserted text
end
else do
  newline=insert(rightside, CURLINE.1, MARK.5)
  'REPLACE' insert(leftside, newline, MARK.4-1)
  -- Leave the cursor on the last character of inserted text
  'CURSOR ENDMARK'
  'CURSOR +0 +'||(length(leftside)+1)
  'MARK CLEAR'
end
exit

help: procedure
  'MSG wrapmark /prefix/suffix/options'
  exit
