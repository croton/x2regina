/* wrapblock -- Wrap a block with starting text and ending text, to be inserted on
   separate lines or optionally on every line.
*/
parse arg startTxt endTxt options
if startTxt='' then do; 'MSG wrapblock prefix suffix [ALL]'; exit; end

options=translate(options)
if options='ALL' then call wrapeveryline startTxt endTxt
else                  call insertTopBottom startTxt endTxt
exit

insertTopBottom: procedure
  parse arg startTxt endTxt
  'CURSOR DATA'
  'EXTRACT /MARK/'
  hasmark=\(MARK.6=0 | MARK.0=0)
  if hasmark then 'CURSOR BegMark'
  'CURSOR UP'
  'INPUT' startTxt
  if endTxt<>'' then do
    if hasmark then 'CURSOR ENDMARK'
    else            'CURSOR DOWN'
    'INPUT' endTxt
  end
  return

wrapeveryline: procedure
  parse arg before after
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then 'MSG Mark exists off screen.'
    when MARK.6=0 then 'MSG Mark exists in another file:' mark.1
    when MARK.0=0 then do
      'EXTRACT /CURLINE/'
      'REPLACE' before||curline.1||after
    end
    otherwise
      do i=MARK.2 to MARK.3
        'CURSOR' i '1'
        'EXTRACT /CURLINE/'
        'REPLACE' before||CURLINE.1||after
      end
  end
  return
