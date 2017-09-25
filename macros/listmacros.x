/* listmacros -- Display X2 macros or classes in a list box. */
arg action ext .
if action='-?' then do; 'MSG listmacros [RUN]'; exit; end

dorun=abbrev('RUN',action)
defaultext='x'
macrodir=value('X2HOME',,'ENVIRONMENT')||'\macros'
ecmd='dir' macrodir'\*.'defaultext '/b'
if \dorun then do  -- LOAD option supports other extensions
  if ext<>'' then ecmd='dir' macrodir'\*.'ext '/b'
end
'MACRO chooser --c' ecmd '--t Macros'

/* Run the macro or load it in the editor
if dorun then do
  parse var choice fname '.' .
  'CMDTEXT' fname
end
else
  'EDIT' macrodir'\'choice
*/
exit
