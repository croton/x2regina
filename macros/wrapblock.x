/* wrapblock -- Wrap a block with starting text and ending text, to be inserted on
   separate lines or optionally on every line.
*/
parse arg startTxt endTxt options
if startTxt='' then do; 'MSG wrapblock prefix suffix [EACH | OUTDENT]'; exit; end

options=translate(options)
select
  when abbrev('EACH', options, 1) then
    call wrapEachLine startTxt, endTxt
  when abbrev('OUTDENT', options, 1) then
    call insertTopBottom startTxt, endTxt, -2
  otherwise
    call insertTopBottom startTxt, endTxt
end
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

wrapEachLine: procedure
  parse arg before, after
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.6=0 then 'MSG Mark exists in another file:' MARK.1
    when MARK.0=0 then do
      'EXTRACT /CURLINE/'
      'REPLACE' padtags(before, after, CURLINE.1)
    end
    otherwise
      do i=MARK.2 to MARK.3
        'CURSOR' i '1'
        'EXTRACT /CURLINE/'
        'REPLACE' padtags(before, after, CURLINE.1)
      end
      'CURSOR BEGMARK'
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

