/* wrapblock -- Wrap a block with start text and end text, to
   be inserted on separate lines.
*/
parse arg delim +1 topline (delim) bottomline (delim) options
if abbrev('-?',delim) | topline='' then do
  'MSG wrapblock /topline/bottomline/(I)ndent'
  exit
end

if abbrev('INDENT', translate(options), 1) then
  call insertTopBottom topline, bottomline, 2
else
  call insertTopBottom topline, bottomline
exit

insertTopBottom: procedure
  parse arg topline, bottomline, offset
  'CURSOR DATA'
  'EXTRACT /MARK/'
  'EXTRACT /CURLINE/'
  if datatype(offset,'W') then indents=min(offset,10)
  else                         indents=0
  hasmark=\(MARK.6=0 | MARK.0=0)
  if hasmark then do
    'CURSOR BegMark'
    if indents>0 then do indents
      'MARK SHIFT RIGHT'
    end -- Indent the marked line(s) if specified
  end
  else do
    if indents>0 then 'REPLACE' copies(' ',indents)||CURLINE.1
  end

  'CURSOR UP'
  'INPUT' indentLine(topline, CURLINE.1)
  if bottomline<>'' then do
    if hasmark then 'CURSOR ENDMARK'
    else            'CURSOR DOWN'
    'INPUT' indentLine(bottomline, CURLINE.1)
  end
  return

/* Left-pad a given string with blanks according to indent of current line. */
indentLine: procedure
  parse arg tag, currentline
  blanks=max(verify(currentline, ' ')-1,0)
  return copies(' ', max(blanks,0))||tag

