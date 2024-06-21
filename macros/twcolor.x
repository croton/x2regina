/* twcolor - Insert a TW color. */
parse arg input
if input='?' then do; 'MSG twcolor input'; exit; end

twcolors=.array~of('black', 'white', 'gray', 'green', 'blue', 'red', 'yellow', 'indigo', 'purple', 'pink', 'transparent', 'current')
choice=pickFromArray(twcolors, 'Pick a color')
if choice<>'' then do
  'CURSOR DATA'
  'KEYIN' choice'-100'
  'CURSOR +0 -3'
end
exit

::requires 'XPopups.x'
