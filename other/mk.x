/* Query mark variable */
call qmark
exit

qmark: procedure
  'EXTRACT /MARK/'
  if mark.0=0 then 'MSG There is no mark'
  else do
    if MARK.4=0 then type='line'
    else             type='block'
    if MARK.2=MARK.3 then mesg=type 'mark exists on line' MARK.2
    else                  mesg=type 'mark exists from line' MARK.2 'to' MARK.3
    if MARK.6=0 then mesg=mesg 'in' filespec('N', MARK.1)
    'MSG' mesg
  end
  return
