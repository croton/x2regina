/* xp_htm - Expand macro for HTML tags. */
parse arg indent argval
terms='a b c'
if indent='?' then do
  call xsay 'xp_htm - expand macro for these terms:' terms
  exit
end

-- 'MESSAGEBOX Expand macro args: indent='indent 'argval='argval
-- The character "~" is used to place the cursor
-- call insertline 'BEFORE~->'parseStartPattern(argval)'<-AFTER'
call makeReactTag parseEndPattern(argval), indent
exit

/* -----------------------------------------------------------------------------
   Take current line as parameters to create a React component tag.
   tagName prop1 prop2 propN -> <tagName  prop1={} prop2={} propN={} />
   -----------------------------------------------------------------------------
*/
makeReactTag: procedure
  parse arg name attribs, indentation
  propslist.=''
  do w=1 to words(attribs)
    -- propslist=propslist word(attribs,w)||'={}'
    propslist.w=word(attribs,w)||'={}'
  end w
  propslist.0=w-1
  sp=copies(' ', indentation)
  if propslist.0>2 then do
    call insertline sp'<'name '~'
    do i=1 to propslist.0
      'INPUT' sp||propslist.i
    end i
    'INPUT' sp'/>'
  end
  else do
    props=''
    do i=1 to propslist.0
      props=props propslist.i
    end i
    call insertline sp'<~'name strip(props) '/>'
  end
  return

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
