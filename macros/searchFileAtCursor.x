/* Highlight word at cursor, to be a filename or part of filename
   to be used as filespec for a file lookup. Optionally may be a
   text string within the file.
*/
arg fileExtension
'CURSOR DATA'
'INSMODE ON'
'MARK WORD'
if fileExtension='' then call findFiles extractAlphaFromMark()||'*'
else                     call findFilesContaining extractAlphaFromMark(), fileExtension
'MARK CLEAR'
exit

restrictMark: procedure
  'LOCATE /,/m'
  myInfo='RC='rc
  if rc=0 then do
    'MSG exclude comma'
    'MARK EXTEND LEFT'
  end
  else 'MSG' myInfo
  return

showFileList: procedure
  'CMDTEXT cmdout projfiles.txt ff' extractAlphaFromMark()||'*'
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

findFiles: procedure
  parse arg fspec
  rc=SysFileTree(fspec,'files.','FSO')
  if files.0=0 then do
    call xsay 'No files named' fspec
    return 1
  end
  if files.0=1 then
    'EDIT' files.1
  else do
    choice=pickFile(files., 'Edit which file?')
    if choice='' then call xsay 'Selection cancelled'
    else 'EDIT' choice
  end
  return 0

findFilesContaining: procedure
  parse arg searchstring, extension
  xcmd='dir *.'extension '/s /b|asarg grep -l "'searchstring'"'
  files.0=0
  ctr=0
  ADDRESS CMD xcmd '|RXQUEUE'
  do while queued()>0
    parse pull entry
    ctr=ctr+1
    files.ctr=entry
  end
  files.0=ctr
  if files.0=0 then do
    call xsay 'No *.'extension 'files found containing "'searchstring'".'
    return 1
  end
  if files.0=1 then
    'EDIT' files.1
  else do
    choice=pickFile(files., 'Edit which file?')
    if choice='' then call xsay 'Selection cancelled'
    else 'EDIT' choice
  end
  return 0

::requires 'XRoutines.x'
