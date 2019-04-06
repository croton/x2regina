/* cmdin -- Display the output of a given command in the current file. */
parse arg cmds
if cmds='' then do; 'MSG cmdin command'; exit; end

tempfile='cmdin.x.temp'
ADDRESS CMD cmds '>' tempfile

'GET' tempfile
-- 'ALT 0 0'        -- Allow user to quit
ADDRESS CMD 'del' tempfile
exit
