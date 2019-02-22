/* tsedit - An edit synonym for tscript files. */
parse arg commandline
if commandline='' & lines()>0 then do
  'MSG Lines exist in STDIN'
  do while lines()>0
    parse pull entry
    say 'from STDIN:' entry
  end
/*
  'COMMAND edit STDIN.TEMP'          -- edit temp file
  'TOP'                              -- go to top
  'DELETE *'                         -- remove any contents
  do while lines()>0          -- while there is STDIN
    parse pull myline
   'INPUT' myline             -- input it line by line
  end
  'TOP'                              -- back to top
  'ALT 0 0'                          -- allow user to quit
*/
end
else 'COMMAND EDIT' commandline
exit

'MSG Macro tsedit done.'
exit
