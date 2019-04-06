/* Parse a CSV string and place each item on a separate line.
   Use case - highlight parameters in a function definition to
   then use each one in its own statement.
*/
'EXTRACT /MARKTEXT/'
if MARKTEXT.0=0 then call help
else do
  csv=MARKTEXT.1
  do until csv=''
    parse var csv item ',' csv
    'INPUT' item
  end
end
exit

help: procedure
  'REFRESH'
  'MSG Place each word of a highlighted CSV string on its own line.'
  exit
