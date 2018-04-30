/* wrapblock -- Wrap a block with starting text and ending text, to be inserted on
   separate lines or optionally on every line.
*/
parse arg startTxt endTxt options
if startTxt='' then do; 'MSG wrapblock prefix suffix [EACH]'; exit; end

options=translate(options)
if options='EACH' then call wrapEachLine startTxt endTxt
else                   call insertTopBottom startTxt endTxt
exit

insertTopBottom: procedure
  parse arg startTxt endTxt
  'CURSOR DATA'
  'EXTRACT /MARK/'
  'EXTRACT /CURLINE/'
  hasmark=\(MARK.6=0 | MARK.0=0)
  if hasmark then 'CURSOR BegMark'
  'CURSOR UP'
  'INPUT' insertTag(startTxt, CURLINE.1)

  if endTxt<>'' then do
    if hasmark then 'CURSOR ENDMARK'
    else            'CURSOR DOWN'
    'INPUT' insertTag(endTxt, CURLINE.1)
  end
  return

wrapEachLine: procedure
  parse arg before after
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.6=0 then 'MSG Mark exists in another file:' MARK.1
    when MARK.0=0 then do
      'EXTRACT /CURLINE/'
      'REPLACE' insertTags(before, after, CURLINE.1)
    end
    otherwise
      do i=MARK.2 to MARK.3
        'CURSOR' i '1'
        'EXTRACT /CURLINE/'
        'REPLACE' insertTags(before, after, CURLINE.1)
      end
      'CURSOR BEGMARK'
  end
  return

/* Insert specified tag and reverse indent if possible */
insertTag: procedure
  parse arg tag, currentline
  indentLevel=2
  blanks=leadingBlanks(currentline)
  if blanks>=indentLevel then return copies(' ',blanks-indentLevel)||tag
  return copies(' ',blanks)||tag

/* Insert specified tags into a given line */
insertTags: procedure
  parse arg prefix, suffix, currentline
  blanks=leadingBlanks(currentline)
  if blanks=0 then return prefix||currentline||suffix
  return insert(prefix, currentline, blanks)||suffix

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

