/* prof-any -- Generate an X2 profile for the given configuration(s). */
parse arg newprof proflist
if newprof='' then call help
if proflist='' then proflist=newprof'.prof'
profiles=validate(proflist)
if profiles='' then call help

doSave=(wordpos('-s', proflist)>0)
if askYN('Create profile "'newprof'" from' translate(profiles,',',' ')) then
  call build newprof, profiles, doSave
else
  say 'Command cancelled'
exit

build: procedure
  parse arg name, profiles, doSave
  XH=value('X2HOME',,'ENVIRONMENT')
  defProf='XW32.PRO'
  defaultExists=SysFileExists(defProf)
  if doSave then do
    baseprofs='default.prof cjp.prof colorz.prof'
    outp=.Stream~new('prof-'name'.cmd')
    outp~lineout('@copy' defProf 'XDEF.PRO 2>nul')
    outp~lineout('xprof' baseprofs profiles)
    outp~lineout('@pause')
    outp~lineout('@move XW32.PRO' translate(name)'.PRO')
    outp~lineout('@move XDEF.PRO' defProf)
    do w=1 to words(profiles)
      outp~lineout('@attrib -A' word(profiles,w))
    end w
    outp~close
    say 'Saved script:' outp
  end
  else do
    baseprofs=XH'\default.prof' XH'\cjp.prof' XH'\colorsblue.prof'
    if defaultExists then '@copy' defProf 'XDEF.PRO 2>nul'
    'xprof' baseprofs profiles
    '@pause'
    'move XW32.PRO' translate(name)'.PRO'
    if defaultExists then 'move XDEF.PRO' defProf
  end
  return

validate: procedure
  parse arg filelist
  validated=''
  do w=1 to words(filelist)
    fn=word(filelist,w)
    if SysFileExists(fn) then validated=validated fn
  end w
  return strip(validated)

help:
  say 'makeprof - Generate an X2 profile for the given configuration(s).'
  say 'usage: makeprof name profiles [-s]'
  say 'option -s = save commands into script'
  say 'example: makeprof web html.prof jscript.prof jquery.prof'
  exit

::requires 'UtilRoutines.rex'
