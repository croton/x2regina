/* wrapblock -- Wrap a block with start text and end text, to
   be inserted on separate lines.
*/
parse arg startTxt endTxt options
if startTxt='' then do; 'MSG wrapblock prefix suffix [OUTDENT]'; exit; end

options=translate(options)
if abbrev('OUTDENT', options, 1) then call insertTopBottom startTxt, endTxt, -2
else                                  call insertTopBottom startTxt, endTxt
exit

insertTopBottom: procedure
  parse arg startTxt, endTxt, offset
  'CURSOR DATA'
  'EXTRACT /MARK/'
  'EXTRACT /CURLINE/'
  hasmark=\(MARK.6=0 | MARK.0=0)
  if hasmark then do
    'CURSOR BegMark'
    -- Indent the marked line(s)
    if offset='' then do 2
      'MARK SHIFT RIGHT'
    end
  end
  else do
    if offset='' then 'REPLACE' "  "CURLINE.1
  end
  'CURSOR UP'
  'INPUT' padtag(startTxt, CURLINE.1, offset)

  if endTxt<>'' then do
    if hasmark then 'CURSOR ENDMARK'
    else            'CURSOR DOWN'
    'INPUT' padtag(endTxt, CURLINE.1, offset)
  end
  return

/* Left-pad a given string with blanks according to indent of current line. */
padtag: procedure
  parse arg tag, currentline, indentLevel
  if \datatype(indentLevel,'W') then indentLevel=0
  blanks=max(verify(currentline, ' ')-1,0)
  return copies(' ', max(blanks+indentLevel,0))||tag

/* Insert specified tags into a given line */
padtags: procedure
  parse arg prefix, suffix, currentline
  blanks=max(verify(currentline, ' ')-1,0)
  return insert(prefix, currentline, blanks)||suffix

