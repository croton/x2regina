/* hiliteblock -- Mark the current block, or paragraph. */
arg input
if input='-?' then do; 'MSG hiliteblock [HIDE | BRACKET | TAG | INDENT]'; exit; end

select
  when input='HIDE' then call hideblock
  when input='BRACKET' then call hilitebracket
  when word(input,1)='TAG' then call hilitetag input
  when input='INDENT' then call indentblock
  otherwise call hiliteblock
end
exit

hideblock: procedure
  if \hasmark() then call hiliteblock
  'CURSOR BEGMARK'
  'EXTRACT /CURLINE/'
  'ALL /'CURLINE.1'/m'
  'MARK CLEAR'
  return

hilitebracket: procedure
  'CURSOR DATA'
  'INSMODE ON'
  'MARK EXTEND RIGHT'
  'MATCH'
  'Mark BLOCK EXTEND'
  return

hiliteblock: procedure
  'CURSOR DATA'
  'INSMODE ON'
  'MARK LINE'
  'MACRO nav DOWN'
  'MARK LINE'
  'MARK EXTEND UP'
  return

hilitetag: procedure
  arg . blockstart .
  'CURSOR DATA'
  'INSMODE ON'
  if blockstart<>'' then do
    -- 'CURSOR TOGGLE'
    'LOCATE |'blockstart'|'
  end
  'MARK LINE'
  'MATCH'
  'MARK LINE'
  return

/* With cursor on opening tag, create a column mark extending to closing tag indented by 2 */
indentblock: procedure
  'EXTRACT /CURSOR/'
  origrow=CURSOR.1
  'MATCH'
  if RC<>0 then do
    'MSG Cannot match tag!'
    return
  end
  'EXTRACT /CURSOR/'
  'UP'
  'CURSOR +0 +2'
  'MARK BLOCK'
  'CURSOR' CURSOR.1 CURSOR.2
  'MATCH'
  'DOWN'
  'CURSOR +0 +2'
  'MARK BLOCK'
  'MSG Ready to indent'
  return

hasmark: procedure
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.0=0 then return 0                                -- Nothing marked
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then return 0 -- Mark exists off screen
    when MARK.6=0 then return 0                                -- Mark exists in another file mark.1
    otherwise nop
  end
  return 1

