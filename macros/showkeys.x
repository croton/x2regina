/* showkeys -- Show key assignments by meta key. */
arg metakey
if metakey='-?' then do; 'MSG showkeys [A|AL|C|CL|S]'; exit; end

'EXTRACT /ESCAPE/'
NL=ESCAPE.1||'N'
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

