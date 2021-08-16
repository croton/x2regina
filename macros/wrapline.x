/* wrapline -- Add a prefix and/or suffix to each of the selected lines, or current line.
   Usage ... wrapline |before|after|options
*/
parse arg input
if abbrev('?', input) then call help

parse var input delim +1 before (delim) after (delim) options
'EXTRACT /MARK/'
select
  when MARK.6=0 then 'MSG Mark exists in another file:' MARK.1
  when MARK.0=0 then call wrapCurrentLine before, after, options
  otherwise          call wrapMarkedLines before, after, options
end
exit

/* Add a prefix or suffix to the current line. */
wrapCurrentLine: procedure
  parse arg prefix, suffix, suffixOffset
  if \datatype(suffixOffset, 'W') then suffixOffset=0
  'EXTRACT /CURLINE/'
  blanks=max(verify(CURLINE.1, ' ')-1,0)
  'REPLACE' insert(prefix, CURLINE.1, blanks)||copies(' ',suffixOffset)||suffix
  if suffix<>'' then do
    'CURSOR EOL'
    if words(prefix)>1 then 'PREVIOUS_WORD'
  end
  return

wrapMarkedLines: procedure expose MARK.
  parse arg prefix, suffix, options
  if options='' then
    call wrapNoAlign prefix, suffix
  else
    call wrapWithAlign prefix, suffix, options
  return

/* Add a prefix or suffix to the marked lines. */
wrapNoAlign: procedure expose MARK.
  parse arg prefix, suffix
  do i=MARK.2 to MARK.3
    'CURSOR' i '1'
    'EXTRACT /CURLINE/'
    blanks=max(verify(CURLINE.1, ' ')-1,0)
    'REPLACE' insert(prefix, CURLINE.1, blanks)||suffix
  end i
  'MARK CLEAR'
  return

/* Append a given string to each of the marked lines at the max line
   length position, or at a specified distance from this position.
*/
wrapWithAlign: procedure expose MARK.
  parse arg prefix, suffix, offset
  suffixlen=length(suffix)
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
    blanks=max(verify(CURLINE.1, ' ')-1,0)
    pad=maxlen-length(CURLINE.1)
    'REPLACE' insert(prefix, CURLINE.1, blanks)||right(suffix, pad+offset+suffixlen)
  end
  'CURSOR' MARK.2 '1'     -- move to first block line, then to EOL
  'CURSOR EOL STAY'
  'MARK CLEAR'
  return

help: procedure
  'MSG wrapline /prefix/suffix/[n|A]'
  exit
