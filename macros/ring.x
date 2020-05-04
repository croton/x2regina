/* ring -- Common tasks related to files in the ring. */
'EXTRACT /RING/'
arg cmd options
select
  when cmd='-?' then call help
  when cmd='P' then call printRing options
  when cmd='S' then do
    opt='FILE'
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
    call msgBoxFromStem 'Changed Files', output.
  end
  otherwise call getChangedFiles
end
exit

getChangedFiles: procedure expose RING.
  mesg=''
  do i=1 to RING.0
    'NEXT_FILE'
    'EXTRACT /NAME/'
    -- Add modified files to list
    'EXTRACT /ALT/'
    if ALT.2>0 then mesg=mesg filespec('N', NAME.1)||'*'
  end i
  if mesg='' then 'MSG All files in ring are UNCHANGED.'
  else            'MSG Changed files in ring:' mesg
  return

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

printRing: procedure
  parse arg filename
  if filename='' then filename='recent-files.log'
  'EXTRACT /RING/'
  outp=.stream~new(filename)
  outp~lineout('Files open on' date() time('c'))
  do i=1 to RING.0
    outp~lineout(RING.i)
  end i
  outp~close
  call xsay 'Saved open file list to' filename
  return

help: procedure
  'MSG ring (S)tatus | (P)rint-file-list'
  return

::requires 'XRoutines.x'
