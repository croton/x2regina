/* xpandmac - Template for expand macros. */
parse arg indent argval
terms='a b c'
if indent='?' then do
  call xsay 'xpandmac - expand macro for these terms:' terms
  exit
end

-- 'MESSAGEBOX Expand macro args: indent='indent 'argval='argval
-- The character "~" is used to place the cursor
call insertline 'BEFORE~->'parseEndPattern(argval)'<-AFTER'
exit

/* Parse the expander when the trigger is the first word.
   Example : expand_keyword = align \1
             pattern "align" is the trigger
*/
parseStartPattern: procedure
  parse arg input
  return subword(input, 2)


/* Parse the expander when the trigger is the last word.
   Example : expand_keyword = "\1 -n"
             pattern "-n" is the trigger
*/
parseEndPattern: procedure
  parse arg input
  return delword(input, words(input))

-- Place the cursor on the newly inserted line
cursorPostInsert: procedure
  parse arg text, searchDirection, marker
  if marker='' then marker='~'
  if searchDirection=1 then searchCmd='LOCATE /'marker'/'
  else                      searchCmd='LOCATE /'marker'/-'
  if pos(marker, text)>0 then do
    searchCmd
    'DELCHAR'
    'FIND RESTORE'
  end
  return

-- Insert the specified text optionally specifying a line break (INPUT) or not (KEYIN)
insertline: procedure
  parse arg text, doInput
  useNewline=abbrev('INPUT', translate(doInput))
  if useNewline then 'INPUT' text
  else               'KEYIN' text
  call cursorPostInsert text, useNewline
  return

::requires 'XPopups.x'
