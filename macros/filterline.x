/* filterline -- Macro to show/exclude lines based on custom criteria. */
parse arg option params
helpmsg='filterline (I)ndent | (P)refix [params]'
if option='-?' then do; 'MSG' helpmsg; exit; end

select
  when abbrev('INDENT', translate(option), 1) then call showByIndent params
  when abbrev('PREFIX', translate(option), 1) then call showByPrefix params
  otherwise 'MSG' helpmsg
end
exit

/* Display lines according to indentation. */
showByIndent: procedure
  arg amount
  if \datatype(amount,'W') then amount=2
  'EXTRACT /SIZE/'
  'TOP'
  do line=1 to SIZE.1
    'EXTRACT /CURLINE/'
    blanks=leadblanks(CURLINE.1)
    if blanks=amount then 'SHOW'
    else 'EXCLUDE'
  end
  'MSG Done searching' SIZE.1 'lines'
  return

showByPrefix: procedure
  parse arg searchfor
  'EXTRACT /SIZE/'
  'TOP'
  do line=1 to SIZE.1
    'EXTRACT /CURLINE/'
    if pos(searchfor, CURLINE.1)>0 then 'SHOW'
    else 'EXCLUDE'
  end
  'MSG Done searching' SIZE.1 'lines'
  return

::requires 'XEdit.x'
