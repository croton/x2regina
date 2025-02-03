/* cc - A wrapper for macro IPT. */
arg input
if abbrev('?', input,1) then do
  'MESSAGEBOX cc - Move cursor to the line containing expression to evaluate.'
  exit
end
'CURSOR DATA'
'COPYTOCMD'
'KEYIN ipt '
'CURSOR EOL'
exit
