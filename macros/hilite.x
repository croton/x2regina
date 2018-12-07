/* hilite -- Mark a paragraph or block. */
arg input
if input='-?' then do; 'MSG hiliteblock [BL | BB | HIDE | INDENT]'; exit; end

select
  when input='BL' then call markbrackets
  when input='BB' then call markbrackets 'block'
  when input='HIDE' then call hideblock
  when input='INDENT' then call indentblock
  otherwise call markparag
end
exit

/* Mark a paragraph, a block of text delimited by blank line */
markparag: procedure
  'CURSOR DATA'
  'INSMODE ON'
  'MARK LINE'
  'MACRO nav DOWN'
  'MARK LINE'
  'MARK EXTEND UP'
  return

/* Mark a block within brackets with a line mark (default) or block mark */
markbrackets: procedure
  arg marktype
  linemark=abbrev('LINE', marktype)
  if linemark then xcmd='MARK LINE'
  else             xcmd='MARK BLOCK EXTEND'  -- may also use 'MARK EXTEND RIGHT'
  'CURSOR DATA'
  'INSMODE ON'
  xcmd
  'MATCH'
  xcmd
  return

hideblock: procedure
  if \hasmark() then call markparag
  'CURSOR BEGMARK'
  'EXTRACT /CURLINE/'
  'ALL /'CURLINE.1'/m'
  'MARK CLEAR'
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

