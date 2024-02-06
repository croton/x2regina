/* twinit -- Tailwind profile startup macro. */
arg stage options
select
  when stage='START' then call go
  when stage='END' then call stop
  when stage='SHOW' then call showEnv options
  otherwise
  'MESSAGEBOX Macro twinit, step=['stage']'
end
exit

/* Steps to perform BEFORE an edit session. */
go: procedure
  parse arg options
  call loadClasses 'TWClasses'
  return

/* Steps to perform AFTER an edit session. */
stop: procedure
  parse arg options
  call unload 'TWClasses'
  return

unload: procedure
  parse arg key
  dir=.environment[key]
  if dir<>.NIL then do
    drop dir
    .environment[key]=.NIL
  end
  return

showEnv: procedure
  arg showcount .
  if showcount=1 then do
    'REFRESH'
    'MSG TW Classes loaded:' .environment['TWClasses']~items
  end
  else do
    'EDIT twinit.txt'
    'INPUT REXX Environment:'
    loop i over .environment
      'INPUT' i '=' .environment[i]
    end i
  end
  return

loadClasses: procedure
  parse arg key
  filename=value('X2HOME',,'ENVIRONMENT')'\lists\twclasses.xfn'
  if \SysFileExists(filename) then return 0
  inp=.Stream~new(filename)
  if inp=.nil then list=.array~of('p', 'm')
  else             list=inp~arrayin
  inp~close
  .environment[key]=list
  return
