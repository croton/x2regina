::routine log public
parse arg message
logf=value('X2HOME',,'ENVIRONMENT')||'\x2debug.log'
'echo' date() time() message '>>' logf
return

::routine print PUBLIC
parse arg message, logf
call lineout logf, message
call lineout logf
return

