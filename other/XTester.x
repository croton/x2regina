::requires 'XRoutines.x'

::routine showmsg public
  use arg title, message
  'EXTRACT /ESCAPE/'
  CR=ESCAPE.1||'N'
  msg=''
  select
    when (message~class=.Array) then
      loop item over message
        msg=msg item||CR
      end
    when (message~class=.Stem) then
      do i=1 to message~items-1
        msg=msg message[i]||CR
      end i
    otherwise
      if \(message~class=.String) then msg='Unknown'
      else msg=message
  end
  ctxt=copies('-', length(title))
  ctxtAlt='---------|---------|---------|---------|'
  'MESSAGEBOX' title||CR ctxt||CR msg
  return result

