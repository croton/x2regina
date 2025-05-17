/* ring -- Common tasks related to files in the ring. */
'EXTRACT /RING/'
arg cmd options
if cmd='?' then do
  optionhelp.1='P = show partial path'
  optionhelp.2='PF = show full path'
  optionhelp.3='PFO = show filename only'
  optionhelp.4='R [logfile] = print current file ring to a file'
  optionhelp.5='S = show changed status of file ring'
  optionhelp.6='E = edit first changed file in ring'
  optionhelp.0=6
  call msgboxFromStem 'Ring - select files, log current file ring, or edit changed', optionhelp.
  exit
end

select
  when cmd='P' then call pickFromRing
  when cmd='PF' then 'RINGWIN'
  when cmd='PFO' then call pickFromRing 'FO'
  when cmd='R' then call printRing options
  when cmd='S' then call showChangeStatus
  otherwise call editChangedFile
end
exit

/* Pick a file from the ring. Display or partial path (default) or filenames only. */
pickFromRing: procedure
  arg options
  fn=filering('Open files', options)
  'REFRESH'
  if fn<>'' then 'EDIT' fn
  return

printRing: procedure expose RING.
  parse arg filename
  if filename='' then filename='recent-files.log'
  outp=.stream~new(filename)
  outp~lineout('Files open on' date() time('c'))
  do i=1 to RING.0
    outp~lineout(RING.i)
  end i
  outp~close
  call xsay 'Saved open file list to' filename
  return

showChangeStatus: procedure expose RING.
  arg opt
  if opt='' then opt='FILE'
  'EXTRACT /CD/'
  status.=getRingStatus()
  output.0=RING.0
  do i=1 to RING.0
    filepath=RING.i
    if abbrev('FILENAME', opt) then fn=filespec('N', filepath)
    else                            fn=filepath -- abbrevPath(filepath, CD.1)
    if status.filepath then output.i=fn '*'
    else                    output.i=fn
  end i
  call msgBoxFromStem 'Open Files', output.
  'CURSOR DATA'
  return

editChangedFile: procedure expose RING.
  changedFiles.=getChangedFiles()
  select
    when changedFiles.0=0 then 'MSG All files in ring are UNCHANGED.'
    when changedFiles.0=1 then 'EDIT' changedFiles.1
    otherwise
      choice=pickFile(changedFiles., 'Changed Files')
      if choice='' then call xsay 'Selection cancelled'
      else              'EDIT' choice
  end
  return

getChangedFiles: procedure expose RING.
  status.=getRingStatus()
  ctr=0
  changed.0=0
  do i=1 to RING.0
    fn=RING.i
    if status.fn then do
      ctr=ctr+1
      changed.ctr=fn
    end
  end i
  changed.0=ctr
  return changed.

/* Get changed status for each file in the ring. */
getRingStatus: procedure expose RING.
  do i=1 to RING.0
    'NEXT_FILE'
    'EXTRACT /NAME/'
    'EXTRACT /ALT/'
    fullpath=NAME.1
    changed.fullpath=(ALT.2>0)
  end i
  return changed.

::requires 'XPopups.x'
