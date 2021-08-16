/* xp_css - Expand macro for CSS profile. */
parse arg indent argval
if indent='?' then do
  call xsay 'xp_css - css expand macro for these terms: span auto gap'
  exit
end
call parseStartPattern argval
exit

/* Parse the expander when the trigger is the first word.
   Example : expand_keyword = align \1
             pattern "align" is the trigger
*/
parseStartPattern: procedure
  parse arg trigger params
  select
    when trigger='span' then call insertline getSpan(params)
    when trigger='auto' then call insertline getAuto(params)
    when trigger='gap' then call insertline getGap(params)
    otherwise nop
  end
  return

/* Parse the expander when the trigger is the last word.
   Example : expand_keyword = "\1 ?n"
             pattern "?n" is the trigger
*/
parseEndPattern: procedure
  parse arg input
  trigger=word(input, words(input))
  params=delword(input, words(input))
  select
    when trigger='?n>' then do
      fn=getFunctionFile('bootstrap')
      if fn='' then leave
      choice=pickFromFile(fn, 'Bootstrap')
      call insertline params 'class="~'choice'">'
    end
    otherwise nop
  end
  return

getAuto: procedure
  arg text
  if abbrev('ROW', text) then
    return 'grid-auto-flow: row; grid-auto-rows: ~25px;'
  else
    return 'grid-auto-flow: column; grid-auto-columns: ~25px;'

getGap: procedure
  arg text
  if abbrev('ROW', text) then return 'grid-row-gap: ~15px;'
  else                        return 'grid-column-gap: ~15px;'

getSpan: procedure
  arg text
  if abbrev('ROW', text) then return 'grid-row: span ~;'
  else                        return 'grid-column: span ~;'

insertline: procedure
  parse arg text, doInput
  useNewline=abbrev('INPUT', translate(doInput))
  if useNewline then 'INPUT' text
  else               'KEYIN' text
  call cursorPostInsert text, useNewline
  return

cursorPostInsert: procedure
  parse arg text, searchDirection, marker
  if marker='' then marker='~'
  if pos(marker, text)>0 then do
    if searchDirection=1 then 'LOCATE /'marker'/'
    else                      'LOCATE /'marker'/-'
    'DELCHAR'
    'FIND RESTORE'
  end
  return

::requires 'XPopups.x'
