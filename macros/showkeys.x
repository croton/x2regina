/* showkeys -- Show key assignments by meta key. */
arg metakey
if metakey='-H' then do; 'MSG showkeys [?|A|AL|C|CL|S|H]'; exit; end

'EXTRACT /ESCAPE/'
NL=ESCAPE.1||'N'
if abbrev('??',metakey,1) then do
  if metakey='?' then call queryAnyKey
  else                call queryAnyKeyReport
  exit
end
select
  when metakey='A' then mykeys=altfn()
  when metakey='C' then mykeys=ctrlfn()
  when metakey='S' then mykeys=shiftfn()
  when substr(metakey,2,1)='L' then mykeys=letterkeys(metakey)
  otherwise mykeys=numkeys()
end
'MESSAGEBOX' mykeys
exit

/* Alt-0 through Alt-9 */
numkeys: procedure expose NL
msgtxt='Alt Keys 0 to 9'NL
do k=0 to 9
  'EXTRACT /KEY a-'k'/'
  msgtxt=msgtxt 'Alt-'k ':' KEY.1||NL
end k
return msgtxt

/* Alt-F1 through F12 */
altfn: procedure expose NL
msgtxt='Alt Keys F1-F12'NL
do k=1 to 12
  'EXTRACT /KEY a-f'k'/'
  msgtxt=msgtxt 'Alt-f'k ':' KEY.1||NL
end k
return msgtxt

/* Ctrl-F1 through F12  */
ctrlfn: procedure expose NL
msgtxt='Ctrl Keys F1-F12'NL
do k=1 to 12
  'EXTRACT /KEY c-f'k'/'
  msgtxt=msgtxt 'Ctrl-f'k ':' KEY.1||NL
end k
return msgtxt

/* Shift-F1 through F12  */
shiftfn: procedure expose NL
msgtxt='Shift Keys F1-F12'NL
do k=1 to 12
  'EXTRACT /KEY s-f'k'/'
  msgtxt=msgtxt 'Shift-f'k ':' KEY.1||NL
end k
return msgtxt

/* Ctrl or Alt-A through Z */
letterkeys: procedure expose NL
arg metakey +1 .
if metakey='C' then do
  msgtxt='Ctrl Keys A to Z'NL
end
else do
  msgtxt='Alt Keys A to Z'NL
  metakey='A'
end
letters=xrange('A','Z')
do k=1 to length(letters)
  ch=substr(letters,k,1)
  'EXTRACT /KEY' metakey'-'ch'/'
  msgtxt=msgtxt metakey'-'ch ':' KEY.1||NL
end k
return msgtxt

-- Query key assignment until ESCAPE is pressed
queryAnyKey: procedure expose NL
  do forever
    msg = 'X2 Editor Key Query Utility' br(2) 'Press ESC to end'
    'MESSAGEBOX' msg NL
    if rc<>0 then leave
    'EXTRACT /key' messagebox.1'/'
    if key.1=0 then key.1='undefined'
    'MSG key name='left(messagebox.1,12) 'function='key.1
    if result='1b'x | result='ESCAPE' then leave   -- Escape key
  end
  return

queryAnyKeyReport: procedure expose NL
  'EDIT querykey.rpt'
  'BOTTOM'
  do 30
    msg='X2 Editor Key Tester Utility' br(2)
    msg=msg' Use this program to determine the key name for any ' br()
    msg=msg' key on your keyboard.  You can then configure it in ' br()
    msg=msg' the profile to whatever function you desire. ' br(2)
    msg=msg' Press any key *except* Ctrl-C, or ESC to end'
    'MESSAGEBOX' msg br() 'rc' rc 'result' result
    if rc<>0 then leave
    if messagebox.1<>'/' then 'EXTRACT /key' messagebox.1'/'
    else                      'EXTRACT +key' messagebox.1'+'
    if key.1 = 0 then key.1='undefined'
    'INPUT key name='Left(messagebox.1,12) 'function='key.1
    if result='1b'x | result='ESCAPE' then leave    -- Escape key
  end                                               -- End
  return

br: procedure expose NL
  arg count .
  if datatype(count,'W') then count=min(count,5)
  else                        count=1
  return copies(NL,count)
