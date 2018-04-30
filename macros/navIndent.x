/* navIndent - Navigate or filter file by indentation.
  C = Collapse all lines that are indented differently than current one
  F = Find line whose indent is less than that of current one
*/
arg option .
select
  when option='C' then call findCurrIndent
  when option='F' then call findupLesserIndent
  otherwise
    'MSG navIndent [C | F]'
end
exit

findCurrIndent: procedure
  arg ?
  'NEXT_WORD'
  'MARK COL1'
  'CopyToCmd'
  'KEYIN ALL/'
  'CURSOR EOL'
  'KEYIN /f'
  'Mark clear'
  -- 'CURSOR COL1'
  -- 'NEXT_WORD'
  return

collapseUnlikeIndent: procedure
  'CURSOR DATA'
  'INSMODE ON'
  'NEXT_WORD'
  'MARK COL1'
  'CopyToCmd'
  'all/'
  'CURSOR EOL'
  '/f'
  'CURSOR TOGGLE'
  'Mark clear'
  'NEXT_WORD'
  return

findUpLesserIndent: procedure
   'EXTRACT /CURSOR/'
   row=CURSOR.1
   if CURSOR.1=1 then do
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
         'MSG Found at line' CURSOR.1 'col' CURSOR.2 'orig indent='char1
         call moveToFirstChar
         leave
       end
     end
     else do
       'MSG Found at line' CURSOR.1 'col' CURSOR.2 'ORIG indent='char1
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

