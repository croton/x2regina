/* clipper -- Copy contents to the clipboard. */
arg input
select
  when input='?' then do; 'MSG clipper (F)ile | (V)isible lines | (L)ine'; exit; end
  when abbrev('FILE', input, 1) then call copyfile
  when abbrev('VIS', input, 1) then call copyvislines
  otherwise              -- Copy current line
    'CURSOR DATA'
    'INSMODE ON'
    'MARK LINE'
    'CLIP COPY'
    'MARK clear'
end
exit

/* Copy current file */
copyfile: procedure
  'EXTRACT /CURSOR/'
  'MACRO marker'
  'CLIP COPY'
  'MARK CLEAR'
  'CURSOR' CURSOR.1 CURSOR.2 -- restore orig
  return

/* Copy visible lines only */
copyvislines: procedure
  'EXTRACT /FILENAME/'
  fn=FILENAME.1'.x2tmp'
  'PUT' fn
  -- 'X' fn
  ADDRESS CMD 'type' fn '|gc'
  ADDRESS CMD 'del' fn
  'MSG Visible lines copied to clipboard'
  return
