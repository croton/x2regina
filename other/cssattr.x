/* cssattr - Look up a CSS attribute on the current line and pop up list of possible values.*/
arg option
if option='?' then do; 'MSG cssattr - lookup values for attribute on current line'; exit; end

'EXTRACT /CURLINE/'
name=getAttrib(CURLINE.1)
if name='' then
  'MSG No attribute on current line!'
else
  call lookupAttribValues name
exit

lookupAttribValues: procedure
  parse arg name
  attribs=.environment['cssattribs']
  if attribs=.nil then call xsay 'No css attributes list available'
  else do
    if attribs[name]=.NIL then call xsay 'Unrecognized css attribute:' name
    else do
      choice=popup(name, attribs[name])
      if choice='' then call xsay 'No choice made'
      else              'KEYIN' choice
    end
  end
  return

getAttrib: procedure
  parse arg text
  if pos(':', text)=0 then return ''
  parse var text attrib ':' .
  return strip(attrib)

popup: procedure
  parse arg name, values
  choices.0=0
  if values='' then list='initial;inherit'
  else              list=values';initial;inherit'
  do i=1 until list=''
    parse var list item ';' list
    choices.i=item
  end i
  choices.0=i
  return pick(choices., name)

::requires 'XPopups.x'
-- ::requires 'XRoutines.x'
