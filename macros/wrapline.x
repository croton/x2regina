/* wrapline -- Add a prefix and/or suffix to each of the selected lines, or current line.
   Usage - wrapline |before|after|options
           wrapline |before|options
*/
parse arg input
if input='' | input='-?' then call help

parse var input delim +1 before (delim) after (delim) +0 options
-- To specify suffix, must include third delim, otherwise taken as options
if options='' then do; options=after; after=''; end
else                   options=substr(options,2)

'EXTRACT /MARK/'
'EXTRACT /FLSCREEN/'
select
  when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then
    'MSG Mark exists off screen.'
  when MARK.6=0 then
    'MSG Mark exists in another file:' MARK.1
  when MARK.0=0 then
    call wrapCurrentLine before, after, options -- no mark
  otherwise
    if translate(left(options,1))='P' then
      call appendalign before, after, options
    else
      call wrapMarkedLines before, after, options
end
exit

/* Add a prefix or suffix to the current line. */
wrapCurrentLine: procedure
parse arg before, after, mode
'EXTRACT /CURLINE/'
select
  when translate(left(mode,1))='P' then do
    offset=word(mode,2)
    if \datatype(offset, 'w') then offset=2
    'REPLACE' before||curline.1||copies(' ',offset)||after
  end
  otherwise
    'REPLACE' before||curline.1||after
end
if after<>'' then do
  'CURSOR EOL'
  if words(before)>1 then do
    'PREVIOUS_WORD'
  end
end
return

/* Add a prefix or suffix to the marked lines. */
wrapMarkedLines: procedure expose MARK.
  parse arg before, after, keepLeadingBlanks
  do i=MARK.2 to MARK.3
    'CURSOR' i '1'
    'EXTRACT /CURLINE/'
    if keepLeadingBlanks=1 then
      'REPLACE' copies(' ',leadingBlanks(curline.1))||before||strip(curline.1)||after
    else
      'REPLACE' before||curline.1||after
  end
  'MARK CLEAR'
  return

/* Append a given string to each of the marked lines at a column position
   determined by finding the longest line within mark, or at a specified
   distance from this position.
*/
appendalign: procedure expose MARK.
  parse arg before, after, . offset
  if \datatype(offset, 'W') then offset=2
  maxlen=0
  do i=MARK.2 to MARK.3
    'CURSOR' i '1'
    'EXTRACT /CURLINE/'
    if length(CURLINE.1)>maxlen then maxlen=length(CURLINE.1)
  end
  do i=MARK.2 to MARK.3
    'CURSOR' i '1'
    'EXTRACT /CURLINE/'
    pad=maxlen-length(CURLINE.1)
    'REPLACE' curline.1||copies(' ',pad+offset)||after
  end
  'CURSOR' MARK.2 '1'     -- move to first block line, then to EOL
  'CURSOR EOL STAY'
  'MARK CLEAR'
  return

/* Return the number of leading blanks in a given string. */
leadingBlanks: procedure
  parse arg str
  ctr=0
  strlen=length(str)
  do i=1 to strlen
   if substr(str,i,1)=' ' then ctr=ctr+1
   else return ctr        -- return counter at first non-blank
  end i
  return strlen

help: procedure
  'MSG wrapline /prefix[/suffix/options]'
  exit
