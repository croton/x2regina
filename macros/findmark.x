/* findmark -- Perform a search and replace for marked text. */
arg doreplace .
if doreplace='' then do
  cmd='L/'
  delim='/'
end
else do
  cmd='C/'
  delim='//'
end
'CURSOR BEGMARK'             -- move cursor to start of block
'COPYTOCMD'                  -- copy line or mark to cmd line
'CURSOR CMDLINE'             -- move cursor to cmd line
'KEYIN' cmd                  -- enter command to search and replace
'CURSOR EOL'
'KEYIN' delim
'CURSOR LEFT'                -- leave cursor in appropriate spot
'MARK CLEAR'
exit
