/* nav - Perform common navigation commands. */
arg input
'CURSOR DATA'
select
  when input='BOT' then do
    'BOTTOM'
    'CURSOR EOL'
  end
  -- Move cursor up one line at EOL position
  when input='ENDUP' then do
    'CURSOR COL1'
    'PREVIOUS_WORD'
    'CURSOR EOL'
  end
  when input='UP' then call nextBlankLine UP
  when input='DOWN' then call nextBlankLine DOWN
  when input='FWD' then call endwordFwd
  when input='REV' then call endwordRev
  when input='HOME' then call homechar
  when input='?' then 'MSG nav TOP* | BOT | ENDUP | UP | DOWN | FWD | REV | HOME'
  otherwise
    'TOP'
    'CURSOR COL1'
end
exit

nextBlankLine: procedure
  arg direction
  if wordpos(direction, 'UP DOWN')=0 then direction='DOWN'
  'EXTRACT /CURLINE/'
  if CURLINE.1='' then direction
  do until rc>0
    'EXTRACT /CURLINE/'
    if CURLINE.1='' then leave
    direction
  end
  'CURSOR +0 1'  -- move cursor to col 1 of curr line
  if direction='DOWN' then do
    'EXTRACT /CURSOR/'
    'EXTRACT /SIZE/'
    if CURSOR.1<SIZE.1 then direction
    else                    'MSG End of file!'
  end
  return

/* Move cursor to the end of the next word. */
endwordFwd: procedure
  'CURSOR DATA'
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  -- Find char at cursor; if blank then move to next word
  if substr(curline.1,cursor.2,1)='' then 'NEXT_WORD'
  'NEXT_WORD'     -- Now advance to next word
  'CURSOR +0 -1'  -- Back up to first blank
  'REFRESH'
  return

/* Move cursor to the end of the previous word. */
endwordRev: procedure
  'CURSOR DATA'
  'PREVIOUS_WORD' -- Move to previous word
  'CURSOR +0 -1'  -- Back up to first blank
  'REFRESH'
  return

/* scrollcurr2top -- Shift cursor to move current line to screen top  */
scroll2top: procedure
  'EXTRACT /CURSOR/'
  'BOTTOMSCREEN'
  'DOWN' CURSOR.6
  'TOPSCREEN'
  return

/* Move cursor to first non-blank char */
homechar: procedure
  'EXTRACT /CURSOR/'
  'EXTRACT /CURLINE/'
  if cursor.2>1 then 'CURSOR COL1'
  -- If current char is a blank move to next word
  if (left(curline.1,1)='' & curline.1<>'') then 'NEXT_WORD'
  return

