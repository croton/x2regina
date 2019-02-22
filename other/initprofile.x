/* initprofile -- Profile startup macro. */
arg stage
select
  when stage='START' then call go
  when stage='END' then call stop
  otherwise
  'MESSAGEBOX Macro initprofile initialized. Input=['stage']'
end
exit

/* Steps to perform BEFORE an edit session. */
go: procedure
parse arg options
conn=.SQLConnection~new('cjp', 'Salmo~63', 'test')
.environment['ORXDB']=conn
/*
'EDIT initprofile_temp.txt'
'INPUT Environment at edit START'
loop i over .environment
  'INPUT' i '=' .environment[i]
end i
*/
return

/* Steps to perform AFTER an edit session. */
stop: procedure
parse arg options
dbcon=.environment['ORXDB']
if dbcon<>.NIL then do
  drop dbcon
  .environment['ORXDB']=.NIL
  'echo Closing DB connection for X2 Editor!'
end
return

SQLException:
call SQLError Condition("O")

error:
dashes='='~copies(40)
say dashes
say 'Error' rc 'at line' sigl
-- say 'Instruction:' sourceline(sigl)
say dashes
return

::requires 'SQLOBJ.frm'
::requires 'CmdUtils.cls'

