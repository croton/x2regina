/* wrapmark -- Wrap highlighted text of current line in specified tokens. */
parse arg input
if input='' | input='-?' then call help

parse var input delim +1 leftside (delim) rightside (delim) options
'EXTRACT /MARK/'
'EXTRACT /CURLINE/'
currline=CURLINE.1
'CURSOR DATA'

-- No mark or line mark
if MARK.0=0 | MARK.4=0 then do
  'KEYIN' leftside||rightside
  'CURSOR +0 -1'   -- leave the cursor between inserted text
end
else do
  currline=insert(rightside, currline, MARK.5)
  'REPLACE' insert(leftside, currline, MARK.4-1)
  -- Leave the cursor on the last character of inserted text
  'CURSOR ENDMARK'
  'CURSOR +0 +'||(length(leftside)+1)
  'MARK CLEAR'
end
exit

help: procedure
  'MSG wrapmark /prefix/suffix/options'
  exit
