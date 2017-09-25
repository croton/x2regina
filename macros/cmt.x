/* cmt -- Comment out the current line. */
arg input
select
  when input='-?' then do; 'MSG cmt [B col|C col|Q|QA]'; exit; end
  when word(input,1)='C' then call singleLineComment input
  when left(input,1)='Q' then call cmt2quick input
  when word(input,1)='B' then call cmtBlock input
  otherwise
    call singleLineComment input
end
exit

singleLineComment: procedure
  arg opt pad .
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  select
    when opt='C' then do
      comment=strip(CURLINE.1)
      if \datatype(pad,'W') then pad='80'
      -- Minimum for centering pad must be at least length of line + 10
      if length(comment)>(pad-10) then newline='/*' comment '*/'
      else                             newline='/*' center(' 'comment' ',pad-6,'-') '*/'
    end
    when input='S' then
      newline='/*' strip(CURLINE.1) '*/'  -- Strip leading blanks
    otherwise
      newline=copies(' ',leadingBlanks(CURLINE.1))||'/*' strip(CURLINE.1) '*/'
  end
  'REPLACE' newline
  'CURSOR' CURSOR.1 leadingBlanks(newline)+1
  return

/* Return the number of leading blanks in a given string. */
leadingBlanks: procedure
  arg str
  ctr=0
  strlen=length(str)
  do i=1 to strlen
   if substr(str,i,1)=' ' then ctr=ctr+1
   else return ctr        -- return counter at first non-blank
  end i
  return strlen

/* Convert current or ALL comment(s) to a quick comment */
cmt2quick: procedure
  arg input +1 opt
  if opt='A' then do
    'CHANGE|/*|--|f*'
    'CHANGE|*/||l*'
  end
  else do
    'CHANGE|/*|--|1'
    'CHANGE|*/||l1'
  end
  return

/* Create a multi-line comment for a line or a block */
cmtBlock: procedure
  arg . endcol .
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1 | MARK.6=0) then
      'MSG Mark exists off screen or in another file:' MARK.1
    when MARK.0=0 | MARK.2=MARK.3 then call commentLine endcol     -- block spans only 1 line
    when left(endcol,1)='E'       then call cmtBlockSingle endcol
    otherwise
      call commentBlock endcol
      'MARK CLEAR'
  end
  return

/* Create a multi-line comment for the selected block. */
commentBlock: procedure expose mark.
  arg endcol
  if \datatype(endcol,'w') then endcol=80
  barlength=endcol-3  /* subtract length of comment-prefix plus space (3) */
  if barlength<0 then barlength=0
  bar=copies('-',barlength)
  if barlength>0 then indent=copies(' ',3)
  else                indent=''
  'CURSOR' mark.2-1 '0'        /* move cursor above first marked line */
  'INPUT /*' bar               /* comment prefix plus 'bar' */
  /* Since we have input one line above the mark, increment mark line variables by 1 */
  mark.2=mark.2+1
  mark.3=mark.3+1
  do i=mark.2 to mark.3
    'CURSOR' i '0'
    'EXTRACT /CURLINE/'
    'REPLACE' indent||curline.1
  end i
  if barlength>0 then 'INPUT' indent||bar
  'INPUT */'                   /* comment suffix */
  return

/* An alternate comment style */
commentBlock2: procedure expose mark.
  endcol=calcEndcol()
  barlength=endcol-6 /* subtract 2 lengths of comment-prefix plus space (6) */
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

/* Create a multi-line comment for the current line. */
commentLine: procedure
  arg endcol
  'EXTRACT /CURLINE/'
  if \datatype(endcol,'w') then endcol=length(curline.1)+5
  barlength=endcol-3
  if barlength<0 then barlength=0
  bar=copies('-',barlength)
  'CURSOR -1 0'                 /* move cursor to input text above current line */
  'INPUT /*' bar
  'CURSOR +1 0'                          /* move cursor to original line        */
  'REPLACE' copies(' ',3)||curline.1     /* indent original line                */
  if barlength>0 then 'INPUT' copies(' ',3)||bar
  'INPUT */'
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

/* Add single-line comments to line(s) */
cmtBlockSingle: procedure
  arg input +1 options
  quick=(options='Q')
  'EXTRACT /COMMENTS/'
  if COMMENTS.3='' then cmtstr='/* */'
  else                  cmtstr=COMMENTS.3
  if quick then 'MACRO wrapline |'cmtstr'|'
  else          'MACRO wrapline ||'cmtstr'|P'
  return
