/* togglefile - Choose a pair of files between which to toggle */
arg doPick
'EXTRACT /CURSOR/'
'EXTRACT /CODE_TYPE/'
CURRQ=newq(CODE_TYPE.1'_'FILEQ)
if doPick=1 then call jump2new filering('Open files'), CURSOR.1, CURSOR.2
else             call jump2previous CURSOR.1, CURSOR.2
exit

jump2new: procedure
  parse arg newfilename, row, col
  if newfilename='' then return
  curr=pushCurrentFile(row, col)
  'EDIT' newfilename
  'REFRESH'
  return

jump2previous: procedure expose CURRQ
  arg row, col
  if queued()=0 then
    'MSG No previous file specified (using' CURRQ')'
  else do
    parse pull prevfile prevrow prevcol
    curr=pushCurrentFile(row, col)
    if curr<>prevfile then do
      'EDIT' prevfile
      'CURSOR' prevrow prevcol
    end
  end
  return

pushCurrentFile: procedure
  arg row, col
  'EXTRACT /FILENAME/'
  push FILENAME.1 row col
  'MSG Jump from' filespec('N', FILENAME.1) '('row',' col')'
  return FILENAME.1

newq: procedure
  arg qname
  newq = RXQUEUE('Create', qname)
  if newq<>qname then rxqueue('Delete', newq)
  rxqueue('Set',qname)
  return qname

::requires 'XPopups.x'
