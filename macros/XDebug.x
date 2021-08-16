::routine log public
parse arg message
logf=value('X2HOME',,'ENVIRONMENT')||'\x2debug.log'
'echo' date() time() message '>>' logf
return
