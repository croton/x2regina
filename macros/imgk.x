/* imgk -- Run Imagemagick commands in a separate process. */
parse arg input
if showHelp(input, 'imgk') then exit

fn='imgktemp.bat'
ok=saveMarkedLines(fn)
if ok then 'SHELL start "ImgK" cmd /K imgktemp'
else 'MSG Unable to create Imagemagick script' fn
exit

getlastword: procedure
'EXTRACT /MARK/'
'EXTRACT /FLSCREEN/'
if MARK.0=0 | MARK.6=0 | MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1 then do
  -- Get current line if there is NO mark, or mark is off screen
  'EXTRACT /CURLINE/'
  lastline=CURLINE.1
end
else do
  'EXTRACT /MARKTEXT/'
  lineno=MARKTEXT.0
  lastline=MARKTEXT.lineno
end
if lastline='' then return ''
else return lastline~word(lastline~words)

saveMarkedLines: procedure
parse arg filename
if SysFileExists(filename) then 'del' filename
'EXTRACT /MARK/'
'EXTRACT /FLSCREEN/'
if MARK.0=0 | MARK.6=0 | MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1 then do
  -- Get current line if there is NO mark, or mark is off screen
  'EXTRACT /CURLINE/'
  lastline=CURLINE.1
  MARKTEXT.1=CURLINE.1
  MARKTEXT.0=1
end
else do
  'EXTRACT /MARKTEXT/'
  lineno=MARKTEXT.0
  lastline=MARKTEXT.lineno
end
imgfile=''
if lastline~words>0 then imgfile=lastline~word(lastline~words)
LC=d2c(94) -- line continuation char is the caret symbol
outp=.stream~new(filename)
do i=1 to MARKTEXT.0-1
  outp~lineout(MARKTEXT.i LC)
end i
outp~lineout(MARKTEXT.i)

xtra.1='IF %ERRORLEVEL% NEQ 0 ('
xtra.2='echo Error code %ERRORLEVEL% & pause'
xtra.3=') else ('
xtra.4='start imdisplay' imgfile
xtra.5=')'
xtra.0=5
do i=1 to xtra.0
  outp~lineout(xtra.i)
end i
outp~close
return SysFileExists(filename)

::requires 'XRoutines.x'
