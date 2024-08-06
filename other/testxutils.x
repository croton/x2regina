/* Test XRoutines */
arg test params

select
  when test='RING'  then call try_filering 'P'
  when test='WRING' then call print_ring 'sample-open-files-list.txt'
  when test='FIND'     then call try_searchfile 'import '
  when test='MERGE'   then call try_merge params
  when test='MSGCMD'   then call try_msgFromCmd params
  when test='PICK'  then call try_pick 'Pick a fish', params
  when test='PICKF' then call try_pickfrom 'Fish directory'
  when test='PICKMANY' then call try_pickmany 'Pick one or more fish'
  when test='PICKFA'   then call try_pickfromfile params
  when test='PICKMO'   then call try_pickManyfromfile params
  when test='PICKD'   then call try_pickfromDual params
  otherwise
    call msgBox 'Supported options', 'RING, WRING, FIND, MERGE, MSGCMD, PICK, PICKF, PICKMANY, PICKFA, PICKMO, PICKD'
end
exit

try_merge: procedure
  parse arg values
  tmpl='The ?1 fox jumped over the ?2 ?3'
  tmplA='The ? fox jumped over the ? ?'
  mrg=merge(tmpl, values)
  call msgBox 'Replace values ['values'] into', tmpl '=' mrg
  value_array=.array~new
  do w=1 to words(values)
    value_array~append(word(values,w))
  end w
  mrg=mergevalues(tmplA, value_array)
  call msgBox 'Replace values ['values'] into', tmplA '=' mrg
  return

try_msgFromCmd: procedure
  parse arg options
  'EXTRACT /SCREEN/'
  if options='' then call xsay 'Please specify a command'
  else do
    call msgBoxFromCmd 'My X2 Keys', options
    /*
    output.=cmdOutputStem(options)
    call msgBoxFromStem 'My MsgBox from Cmd', output.
    */
  end
  return

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
  fish.5='rainbow darter'
  fish.0=5
  items.=pickmany(fish., title)
  do i=1 to items.0
    'INPUT pick no.'i items.i
  end i
  return

try_pick: procedure
  parse arg title, useClipboard
  if useClipboard=1 then do
    ADDRESS CMD 'pc|RXQUEUE'
    ctr=0
    do while queued()>0
      parse pull entry
      if entry='' then iterate
      ctr=ctr+1
      fish.ctr=entry
    end
    fish.0=ctr
  end -- use clip board items
  else do
    fish.1='golden trout'
    fish.2='arctic char'
    fish.3='black nosed dace'
    fish.4='johnny darter'
    fish.0=4
  end
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
  fish['Lepomis']='bluegill'
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

-- usage: pickfromdual(filestem, title, returnfield, delim, showReturnval)
try_pickfromDual: procedure
  arg sourcefile options
  originaloptions=options
  if sourcefile='' then do
    call msgBox 'Please specify parameters:', 'filename [-t title][-r fieldIndexReturned][-d delim][-(h)ide return value]'
    return
  end
  w=wordpos('-T',options)
  if w>0 then do; title=word(options,w+1); options=delword(options,w,2); end; else title=''
  w=wordpos('-R',options)
  if w>0 then do; returnIndex=word(options,w+1); options=delword(options,w,2); end; else returnIndex=2
  if \datatype(returnIndex,'W') then returnIndex=2
  w=wordpos('-D',options)
  if w>0 then do; delim=word(options,w+1); options=delword(options,w,2); end; else delim=''
  w=wordpos('-H',options)
  if w>0 then do; hideReturnval=1; options=delword(options,w,1); end; else hideReturnval=0
  if hideReturnval=1 then setting='show-display-values-only'; else setting='show-return-values'
  choice=pickfromdual(sourcefile, title, returnIndex, delim, hideReturnval)
  'INPUT Call pickfromdual' sourcefile originaloptions '-> "'choice'"'
  'INPUT file='sourcefile 't='title 'r='returnIndex 'd='delim 's='setting '->' choice
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

::requires 'XPopups.x'
::requires 'XRoutines.x'
