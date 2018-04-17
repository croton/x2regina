/* Highlight word at cursor -- to be a filename or part of filename
   to be used as filespec for a file lookup.
*/
searchPrefix='c:\Development\fs-ui\source\js\app\'
  'CURSOR DATA'
  'INSMODE ON'
  'MARK WORD'
  -- call restrictMark
  -- 'MSG marked=' extractAlphaFromMark()
  call searchForMark
  'MARK CLEAR'
exit

restrictMark: procedure
  'LOCATE /,/m'
  myInfo='RC='rc
  if rc=0 then do
    'MSG exclude comma'
    'MARK EXTEND LEFT'
  end
  else 'msg' myInfo
  return

extractAlphaFromMark: procedure
  'EXTRACT /MARKTEXT/'
  alphaOnly=''
  do i=1 to length(MARKTEXT.1)
    chr=substr(MARKTEXT.1, i, 1)
    if \datatype(chr,'A') then leave i
    alphaOnly=alphaOnly||chr
  end i
  return alphaOnly

searchForMark: procedure expose searchPrefix
  fspec='*'||extractAlphaFromMark()||'*'
  'MACRO cmdout projfiles.txt dir' searchPrefix||fspec '/s /b'
  return
