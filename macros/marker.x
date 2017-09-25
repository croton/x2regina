/*  marker -- Shortcuts for marking commands. */
arg input
if input='-?' then do; 'MSG marker [INT | BRACKET]'; exit; end

select
  when input='INT' then call markintegerplus
  when input='BRACKET' then call markbracket
  otherwise call markfile input
end
exit

/* Mark the contents of the current file, starting at current line, unless 'top' is specified. */
markfile: procedure
  arg startAtTop .
  if abbrev('TOP', startAtTop) then 'TOP'
  'MARK LINE'
  'BOTTOM'
  'MARK LINE EXTEND'
  return

/* Add some convenience to MARK_INTEGERS feature. */
markintegerplus: procedure
  'EXTRACT /INSMODE/'
  orig=INSMODE.1
  'MARK INTEGERS'
  'CURSOR BEGMARK'
  'INSMODE' orig
  return

/* Highlight bracketed text */
markbracket: procedure
  -- 'MARK SHIFT RIGHT'
  'MARK BLOCK EXTEND'
  'MATCH'
  'MARK BLOCK EXTEND'
  return
