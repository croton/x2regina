/* xpandmac - Template for expand macros. */
parse arg indent argval

'INPUT -- Expansion macro arg ['argval'] Indent='indent
newpattern='class="~">'
call insertline parseStartPattern(argval) newpattern
exit

/* Parse the expander when the trigger is the first word.
   Example : expand_keyword = align \1
             pattern "align" is the trigger
*/
parseStartPattern: procedure
  parse arg input
  return subword(input, 2)


/* Parse the expander when the trigger is the last word.
   Example : expand_keyword = "\1 ?n"
             pattern "?n" is the trigger
*/
parseEndPattern: procedure
  parse arg input
  return delword(input, words(input))

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

insertline: procedure
  parse arg text, doInput
  useNewline=abbrev('INPUT', translate(doInput))
  if useNewline then 'INPUT' text
  else               'KEYIN' text
  call cursorPostInsert text, useNewline
  return

