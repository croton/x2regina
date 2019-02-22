/* Test XRoutines */
arg test params

select
  when test='RING'  then call try_filering 'P'
  when test='WRING' then call print_ring 'sample-open-files-list.txt'
  when test='PICK'  then call try_pick 'Pick a fish'
  when test='PICKF' then call try_pickfrom 'Fish directory'
  when test='PICKMANY' then call try_pickmany 'Pick one or more fish'
  when test='FIND'     then call try_searchfile 'import '
  when test='PICKFA'   then call try_pickfromfile params
  when test='PICKMO'   then call try_pickManyfromfile params
  otherwise
    call msgBox 'Supported options', 'RING, WRING, PICK, PICKF, PICKMANY, FIND'
end
exit

try_filering: procedure
  parse arg options
  fn=filering('Open files', options)
  'REFRESH'
  'MSG filering with options' options':' fn
  return

print_ring: procedure
  parse arg filename
  if filename='' then return
  'EXTRACT /RING/'
  outp=.stream~new(filename)
  outp~lineout('Files open on' date() time('c'))
  do i=1 to RING.0
    outp~lineout(RING.i)
  end i
  outp~close
  call xsay 'Saved open file list to' filename
  return

try_pickmany: procedure
  parse arg title
  fish.1='golden trout'
  fish.2='arctic char'
  fish.3='black nosed dace'
  fish.4='johnny darter'
  fish.0=4
  items.=pickmany(fish., title)
  do i=1 to items.0
    'INPUT pick no.'i items.i
  end i
  return

try_pick: procedure
  parse arg title
  fish.1='golden trout'
  fish.2='arctic char'
  fish.3='black nosed dace'
  fish.4='johnny darter'
  fish.0=4
  item=pick(fish., title)
  call xsay 'Your pick: "'item'"'
  return

try_pickfrom: procedure
  parse arg title
  fish=.directory~new
  fish['Salmo']='golden trout'
  fish['Salvelinus']='arctic char'
  fish['Rhinichthys']='black nosed dace'
  fish['Etheostoma']='johnny darter'
  item=pickfrom(fish, title)
  call xsay 'Your pick: "'item'"'
  return

try_pickfromfile: procedure
  parse arg fn
  choice=pickFromFile(fn, 'Pick a line from this file')
  call xsay 'Your choice from file' fn': "'choice'"'
/* if contents=.NIL then call xsay 'Unable to load file "'fn'"'
   else                  call xsay 'File' fn 'has' contents~items 'lines' */
  return

try_pickManyfromfile: procedure
  parse arg fn
  choices=pickManyFromFile(fn, 'Pick a line from this file', 'M')
  csv=''
  loop item over choices
    csv=csv item','
  end
  call msgBox 'Your choices from file' fn, '['csv']'
  return

try_searchfile: procedure
  parse arg token
  items.=searchfile(token)
  if items.0=0 then call xsay 'No items found in current file containing "'token'"'
  else do
    filenames.0=items.0
    -- Extract filenames from text found in file
    do i=1 to items.0
      parse var items.i . '"' fspec '"'
      filenames.i=substr(fspec, lastpos('/', fspec)+1)
    end i
    fn=pick(filenames., 'Pick a class')
    if fn<>'' then do
      res=cmdoutput('fi' fn'.* public')
      count=res~items
      if count=0 then call xsay fn 'has no public members'
      else do
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
      end -- select from public functions
    end -- look up functions from a file
  end -- find filenames through a search
  return

searchFile: procedure
  parse arg searchString
  'EXTRACT /SCREEN/'
  'EXTRACT /WRAP/'
  maxrows=SCREEN.1
  maxcols=SCREEN.2
  ctr=0
  found.0=0
  'TOP'
  'WRAP OFF'
  'LOCATE /'searchString'/'
  do until ctr=maxrows
    if rc<>0 then do
      'WRAP' WRAP.1  -- restore setting
      found.0=ctr
      return found.
    end
    'EXTRACT /CURLINE/'
    ctr=ctr+1
    found.ctr=CURLINE.1
    'FIND REPEAT'
  end
  found.0=ctr
  'FIND RESTORE'
  'WRAP' WRAP.1
  return found.

try_cmdOut: procedure
  parse arg params
  xcmd='dir w* /b'
  data.=cmdOutputStem(xcmd)
  if data.0=0 then call xsay 'Cmd' xcmd 'yields no results'
  else do
    item=pick(data., 'Choose from' data.0 'results')
    call xsay 'choice='item
  end
  return

::requires 'XRoutines.x'
