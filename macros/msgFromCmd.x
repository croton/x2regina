/* msgFromCmd -- Create a message box from output of a command */
parse arg options

if wordpos('--t', options)>0 then
  parse var options '--t' title '--'
else title='Message of' time('c')
if wordpos('--c', options)>0 then
  parse var options '--c' command '--'
else command=''

if command='' then call xsay 'title=' title 'command='command
else call msgBoxFromCmd title, command
exit

::requires 'XPopups.x'
