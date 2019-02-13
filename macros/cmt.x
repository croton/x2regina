/* cmt -- Comment out the current line or block. */
arg type params
select
  when type='-?' then 'MSG cmt [B col | C col | O | Q ]'
  when type='C' then call centeredComment params
  when type='CR' then call cursorComment params
  when type='O' then 'MACRO wrapblock /* */'
  when type='Q' then call quickComment params
  when type='B' then call formattedComment params
  otherwise          call samelineComment input
end
exit

samelineComment: procedure
  'EXTRACT /CURLINE/'
  blanks=max(verify(CURLINE.1, ' ')-1,0)
  'REPLACE' insert('/* ', CURLINE.1, blanks) '*/'
  'CURSOR COL1'
  return

/* Insert a single line comment beginning at cursor, rather than at COL1 */
cursorComment: procedure
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  'REPLACE' insert('/* ', CURLINE.1, CURSOR.2-1) '*/'
  return

centeredComment: procedure
  arg pad .
  if \datatype(pad,'W') then pad='80'
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  comment=strip(CURLINE.1)
  -- Minimum for centering pad must be at least length of line + 10
  if pad>=(length(comment)+10) then newline='/*' center(' 'comment' ',pad-6,'-') '*/'
  else                              newline='/*' comment '*/'
  'REPLACE' newline
  'CURSOR' CURSOR.1 verify(newline, ' ')
  return

/* Insert a quick comment into current line(s) */
quickComment: procedure
  arg opt
  'EXTRACT /COMMENTS/'
  qkcomm=COMMENTS.3
  if qkcomm='' then qkcomm='--'
  'MACRO wrapline /'qkcomm '/'
  return

/* Change regular comments to quick comments */
switch2quick: procedure
  arg opt
  if opt='A' then do
    'CHANGE|/*|--|f*'
    'CHANGE|*/||l*'
  end
  else do
    'CHANGE|/*|--|1'
    'CHANGE|*/||l1'
  end
  return

/* Create a formatted multi-line comment for a line or a block */
formattedComment: procedure
  arg linelength opt
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.6=0 then 'MSG Mark exists in another file'
    when MARK.0=0 | MARK.2=MARK.3 then call commentLineFormatted linelength
    when abbrev('ALT', opt, 1)    then call commentLinesFormattedAlt linelength
    otherwise
      call commentLinesFormatted linelength
      'MARK CLEAR'
  end
  return

/* Create a multi-line comment for the current line. */
commentLineFormatted: procedure
  arg linelength
  'EXTRACT /CURLINE/'
  if \datatype(linelength,'W') then linelength=length(CURLINE.1)+5
  barlength=max(linelength-3, 50)
  bar=copies('-', barlength)
  indent=copies(' ', 2)
  'UP'
  'INPUT /*' bar
  'DOWN'  -- Move cursor to original line
  'REPLACE' indent CURLINE.1
  'INPUT' indent bar
  'INPUT */'
  return

/* Create a multi-line comment for the selected block. */
commentLinesFormatted: procedure expose MARK.
  arg linelength
  if \datatype(linelength,'W') then linelength=80
  barlength=max(linelength-3, 50)
  bar=copies('-', barlength)
  indent=copies(' ', 2)
  'CURSOR' mark.2-1 '0'        -- move cursor above first marked line
  'INPUT /*' bar
  -- We have input one line above the mark, so increment mark line variables
  do i=mark.2+1 to mark.3+1
    'CURSOR' i '0'
    'EXTRACT /CURLINE/'
    'REPLACE' indent CURLINE.1
  end i
  'INPUT' indent bar
  'INPUT */'
  return

/* An alternate comment style */
commentLinesFormattedAlt: procedure expose mark.
  linelength=calcEndcol()
  barlength=linelength-6 /* subtract 2 lengths of comment-prefix plus space (6) */
  bar=copies('-',barlength)
  if barlength>0 then indent=' | '
  else                indent=''
  'CURSOR' mark.2-1 '0'                  /* move cursor above first marked line */
  'INPUT /*' bar
  /* Since we have input one line above the mark, increment mark line variables by 1 */
  mark.2=mark.2+1
  mark.3=mark.3+1
  do i=mark.2 to mark.3
    'CURSOR' i '0'
    'EXTRACT /CURLINE/'
    'REPLACE' indent||curline.1
  end i
  if barlength>0 then do; indent='  -'; 'INPUT' indent||bar '*/'; end
  else 'INPUT */'
  return

/* Calculate last column position of comment based on maximum line length. */
calcEndcol: procedure expose mark.
  maxlen=0                /* find max line length within block */
  do i=mark.2 to mark.3
    'CURSOR' i '1'
    'EXTRACT /CURLINE/'
    if length(CURLINE.1)>maxlen then maxlen=length(CURLINE.1)
  end
  /* Add 6 to value for comment prefix and suffix (3+3) */
  endcol=maxlen+6
  /* Now ensure end col is multiple of 5, for consistent comment layout */
  if endcol//5<>0 then return endcol+abs(endcol//5-5)
  return endcol

