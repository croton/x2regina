/* cmdout -- Display the output of a given command in a file. */
parse arg filename cmds
if filename='' then do; 'MSG cmdout filename command'; exit; end

tempfile='cmdout.x.temp'
-- Redirect output of command to tempfile including data from STDERR
ADDRESS CMD cmds '>' tempfile '2>&1'

'EDIT' filename
'TOP'
'DELETE *'                    -- Make sure we start clean
if getLineCount(tempfile)=0 then
  'INPUT No output from command:' cmds
else
  'GET' tempfile
'ALT 0 0'                     -- Allow user to quit

ADDRESS CMD 'del' tempfile -- Cleanup
exit

getLineCount: procedure
  parse arg filename
  ctr=0
  do while lines(filename)<>0
    ctr=ctr+1
    data=linein(filename)
  end
  call lineout filename -- close the file
  return ctr
