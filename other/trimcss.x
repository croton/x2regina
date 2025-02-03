/* trimcss - Find and remove from current CSS file a list of classes.
   This macro will create 2 files: a backup file and a file containing
   the css classes removed.
*/
parse arg classlist
'EXTRACT /FILENAME/'
currfile= filespec('N', FILENAME.1)

if abbrev('?', classlist) then do
  call msgbox 'trimcss - Trim css classes from' currfile, 'Please provide filename where css classes to remove are listed.'
  exit
end
css2remove=arrayfromfile(classlist)

-- Backup the current file
parse var currfile fstem '.' ext
backupfile=fstem'--before-remove.'ext
trimsfile=fstem'--removed.'ext
ADDRESS CMD '@copy' FILENAME.1 backupfile

ctr=0
loop cssclass over css2remove
  cname=moveclass(cssclass, trimsfile)
  if cname<>'' then do
    ctr=ctr+1
    found.ctr=cname
  end
  -- found.ctr=verifyclass(cssclass)
end
found.0=ctr
if found.0=0 then
  call msgbox 'Trim css classes listed in' classlist 'from' currfile, 'Removed classes saved to' trimsfile '('css2remove~items 'classes)'
else
  call msgboxFromStem 'These CSS classes were NOT found', found.
exit

moveclass: procedure
  parse arg classname, logfile
  'CURSOR DATA'
  'INSMODE ON'
  'LOCATE /.'classname'/f'
  if rc=7 then return classname
  'LOCATE /{/'
  if rc=7 then return classname'{'
  'MACRO hilite BL'
  'edit' logfile
  'Mark move'
  'Mark clear'
  'PREVIOUS_FILE'
  return ''

verifyclass: procedure
  parse arg classname
  'CURSOR DATA'
  'INSMODE ON'
  'LOCATE /.'classname'/f'
  if rc=7 then return 'NF' classname
  'LOCATE /{/'
  if rc=7 then return 'NF' classname 'open-brace'
  return 'OK' classname

::requires 'iolib.rex'
::requires 'XPopups.x'
