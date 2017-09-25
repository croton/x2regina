/* cmdout -- Display the output of a given command in a file. */
parse arg filename cmds
if filename='' then do; 'MSG cmdout filename command'; exit; end

tempfile='cmdout.x.temp'
-- Redirect output of command to tempfile including data from STDERR
ADDRESS SYSTEM cmds '>' tempfile '2>&1'

'EDIT' filename
'TOP'
'DELETE *'                    -- Make sure we start clean
'GET' tempfile
'ALT 0 0'                     -- Allow user to quit

ADDRESS SYSTEM 'del' tempfile -- Cleanup
exit
