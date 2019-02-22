/* tsdeps - Work with typescript dependencies. */
call on error
parse arg pfx params
select
  when translate(pfx)='M' then call pickMember
  when translate(pfx)='L' then call loadFile
  otherwise call tester params
  -- call help
end
exit

tester: procedure
  parse arg any
  if any='' then 'MSG Must provide search string.'
  else do
    items.=searchfile(any)
    call xsay 'Found' items.0 'items containing "'any'"'
  end
  return

pickMember: procedure
  fn=chooseImportedFile()
  if fn<>'' then do
    res=cmdoutput('fi' fn'.* public')
    count=res~items
    if count=0 then do
      call xsay fn 'has no public members'
      return
    end
    -- Select from public functions
    members=.directory~new
    do i=1 to count
      parse value res[i] with . 'public ' member
      if pos('(', member)>0 then delim='('
      else                       delim=':'
      parse var member mname (delim) .
      key=word(mname, words(mname))
      members[key]=member
    end i
    fnc=pickfrom(members, 'Public Members')
    if fnc<>'' then 'KEYIN' fnc
  end -- find filenames through a search
  return

loadFile: procedure
  fn=chooseImportedFile()
  if fn<>'' then do
    'MACRO f' fn'.*'
  end
  return

/* Parse import statements for filespecs of dependencies. */
chooseImportedFile: procedure
  items.=searchfile('import ')
  if items.0=0 then return ''
  -- Extract filenames from text found in file
  filenames.0=items.0
  do i=1 to items.0
    parse var items.i . '"' fspec '"'
    filenames.i=substr(fspec, lastpos('/', fspec)+1)
  end i
  return pick(filenames., 'Pick a class')

help: procedure
  'MSG Options: (M)ember (L)oadFile'
  exit

error:
  call log 'Error' rc 'at line' sigl
  call log 'Instruction:' value(sourceline(sigl))
  return

::requires 'XRoutines.x'
::requires 'XTester.x'
