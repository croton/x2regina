/* toggleline - Choose a pair of lines between which to toggle */
arg lineno
if datatype(lineno,'W') then call linkPair lineno
else                         call jump2previous
exit

linkPair: procedure
  arg lineno
  'EXTRACT /CURSOR/'
  push CURSOR.1
  lineno
  'MSG Jump to' lineno 'prev='CURSOR.1
  return

jump2previous: procedure
  if queued()=0 then
    'MSG No previous line number specified.'
  else do
    pull prevline
    'EXTRACT /CURSOR/'
    push CURSOR.1
    prevline
    'MSG Jump to' prevline 'prev='CURSOR.1
  end
  return
