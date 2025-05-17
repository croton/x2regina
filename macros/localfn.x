/* localfn - Select from locally defined REXX functions. */
parse arg category libkey
homedir=value('cjp',,'ENVIRONMENT')
x2home=value('x2home',,'ENVIRONMENT')

rxlib.U=homedir'\bin\UtilRoutines.rex'
rxlib.C=homedir'\bin\console.cls'
rxlib.R=homedir'\bin\registry.cls'
rxlib.H=homedir'\bin\gfx\colorlib.rex'
rxlib.KEYS='C H R U'

x2lib.D=x2home'\macros\XDebug.x'
x2lib.E=x2home'\macros\XEdit.x'
x2lib.P=x2home'\macros\XPopups.x'
x2lib.R=x2home'\macros\XReact.x'
x2lib.X=x2home'\macros\XRoutines.x'
x2lib.KEYS='D E P R X'

if abbrev('?', category) then do
  info.1='category = (R)exx | (X)2Editor'
  info.2='library-key = library filename abbreviation'
  ctr=2
  libkeys=rxlib.KEYS
  do w=1 to words(libkeys)
    ctr=ctr+1
    idx=word(libkeys,w)
    info.ctr=' ' idx '=' rxlib.idx
  end w
  libkeys=x2lib.KEYS
  do w=1 to words(libkeys)
    ctr=ctr+1
    idx=word(libkeys,w)
    info.ctr=' ' idx '=' x2lib.idx
  end w
  info.0=ctr
  call msgboxFromStem 'localfn category library-key', info.
  exit
end

type=filter(category)
sub=filterKey(type, libkey)

if type='R' then do
  if filespec('E', rxlib.sub)='cls' then do
    xcmd='grep -i :method' rxlib.sub'|wordf 2'
    'MACRO chooser --c' xcmd '--t' filespec('N', rxlib.sub)
  end
  else do
    xcmd='grep -i :routine' rxlib.sub'|wordf 2'
    'MACRO chooser --c' xcmd '--t' filespec('N', rxlib.sub)
  end
end
else do
  xcmd='grep -i :routine' x2lib.sub'|wordf 2'
  'MACRO chooser --c' xcmd '--t' filespec('N', x2lib.sub)
end
exit

filter: procedure
  arg key +1
  if pos(key, 'RX')=0 then return 'R'
  return key

filterKey: procedure expose rxlib. x2lib.
  arg category, key +1
  if category='R' then do
    if pos(key, strip(rxlib.KEYS))=0 then return 'U'
    return key
  end
  else if category='X' then do
    if pos(key, strip(x2lib.KEYS))=0 then return 'X'
    return key
  end
  return

::requires 'XPopups.x'
