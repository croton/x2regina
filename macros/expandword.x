/* expandword -- Expand the current word regardless of the position of the
   word within the line. Removes restriction that expansion expression be
   the first word in the line.
*/
'CURSOR DATA'
'PREVIOUS_WORD'    -- move cursor to just before last word entered
if arg(1)<>'' then -- back space again if specified by parameter
  'PREVIOUS_WORD'  -- when expansion expression is composed of two words
'SPLIT'            -- split the line here
'CURSOR DOWN'      -- move cursor to the end of new line
'CURSOR EOL'
'KEYIN' " "        -- enter a space to expand expression
'CURSOR UP'        -- move cursor back to end of original line
'CURSOR EOL'
'SPLITJOIN'        -- rejoin the lines
'KEYIN' " "        -- add a space between the two joined lines
'CURSOR EOL'
exit
