/* navIndent - Navigate or filter file by indentation.
  [S]ibling = Collapse all lines that are indented differently than current one
  [P]arent = Find line whose indent is less than that of current one
*/
arg option .
select
  when abbrev('SIBLING', option, 1) then call findCurrIndent
  when abbrev('PARENT', option, 1) then call findupLesserIndent
  otherwise call help
end
exit

findCurrIndent: procedure
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  'EXTRACT /MARK/'
  if mark.0=0 then opt='/f'
  else             opt='/fm'
  -- Go to col 1 if not already there
  if CURSOR.2>1 then 'CURSOR COL1'
  'NEXT_WORD'
  'EXTRACT /CURSOR/'
  'CURSOR TOGGLE'
  'KEYIN ALL/'left(CURLINE.1, CURSOR.2)||opt
  return

findupLesserIndent: procedure
   'EXTRACT /CURSOR/'
   row=CURSOR.1
   if row=1 then do
     'MSG Already at top line.'
     return
   end
   char1=moveToFirstChar()
   'CURSOR +0 -1' -- backup 1 column
   do while CURSOR.1>1
     'UP'
     'EXTRACT /CURLINE/'
     'EXTRACT /CURSOR/'
     blankAtCursor=(substr(CURLINE.1, CURSOR.2, 1)=' ')
     if blankAtCursor then do
       data2left=(strip(left(CURLINE.1, CURSOR.2-1))<>'')
       if data2left then do
         'MSG Found parent, orig line='row
         call moveToFirstChar
         leave
       end
     end
     else do
       -- goback=msgYNBox('Return to orig line,' row'?', 'Find Parent')
       -- if goback then row; else 'MSG Found parent, orig line='row
       'MSG Found parent, orig line='row
       'CMDTEXT' row
       leave
     end
   end
   return

moveToFirstChar: procedure
   'EXTRACT /CURLINE/'
   parse var CURLINE.1 firstword .
   firstCharPos=pos(left(firstword,1), CURLINE.1)
   if firstCharPos>1 then
     'CURSOR +0 'firstCharPos
   -- 'MSG First char at col' firstCharPos 'line len='length(CURLINE.1)
   return firstCharPos

help:
  'MSG navIndent [SIBLING | PARENT]'
  return

-- ::requires 'XRoutines.x'
