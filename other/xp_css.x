/* xp_css - Expand macro for CSS profile. */
parse arg indent argval
if left(strip(argval),1)='?' then do
  call help
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
    when trigger='abs' then call insertlines setAbs(params)
    when trigger='ins' then call insertlines string2stem(params)
    when trigger='pse' then call insertlines pseudoElem(params)
    otherwise call help
  end
  return

help: procedure
  prefix.1='pse selector pseudo-element - declare pseudo element'
  prefix.2='abs [direction] - declare class for absolute placement'
  prefix.3='ins wordlist - insert specified word list'
  prefix.4='span - set grid row/col span'
  prefix.5='auto - set grid auto row/col'
  prefix.6='gap - set grid row/col gap'
  prefix.0=6
  call msgBoxFromStem 'Profile macro: prefix [options] -x', prefix.
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

string2stem: procedure
  parse arg text
  -- Last word of argument will be the expand-macro trigger
  count=words(text)-1
  do w=1 to count
    lines.w=word(text,w)
  end w
  lines.0=count
  return lines.

pseudoElem: procedure
  parse arg text
  -- Remove last word of argument, the expand-macro trigger
  parse value delword(text, words(text)) with selector pse .
  if pse='' then do
    pse=pick(string2stem('before after first-line first-letter marker'), 'Pseudo elements')
    if pse='' then pse='before'
  end
  lines.1=selector'::'pse '{'
  lines.2="  content: '';"
  lines.3='}'
  lines.0=3
  return lines.

setAbs: procedure
  arg text
  -- Remove last word of argument, the expand-macro trigger
  params=delword(text, words(text))
  parse var text direction offset .
  select
    when direction='NW' then srcarg='nw top left 0 0'
    when direction='NC' then srcarg='nc top left 0 50%'
    when direction='C' then srcarg='c top left 50% 50%'
    when direction='SW' then srcarg='sw bottom left 0 0'
    when direction='SC' then srcarg='sc bottom left 0 50%'
    when direction='SE' then srcarg='se bottom right 0 0'
    when direction='EC' then srcarg='ec top right 50% 0'
    when direction='WC' then srcarg='wc top left 50% 0'
    otherwise srcarg='ne top right 0 0'
  end
  parse var srcarg place y x yOff xOff
  lines.1='.'place '{'
  lines.2='  position: absolute;'
  lines.3=' ' y':' yOff';'
  lines.4=' ' x':' xOff';'
  lines.5='}'
  lines.0=5
  return lines.

insertline: procedure
  parse arg text, doInput
  useNewline=abbrev('INPUT', translate(doInput))
  if useNewline then 'INPUT' text
  else               'KEYIN' text
  call cursorPostInsert text, useNewline
  return

insertlines: procedure
  use arg text.
  do i=1 to text.0
    'INPUT' text.i
  end i
  return text.0

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
