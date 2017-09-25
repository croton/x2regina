/* clipper -- Copy contents to the clipboard. */
arg input
select
  when input='-?' then do; 'MSG clipper [FILE | VIS]'; exit; end
  when input='FILE' then call copyfile
  when input='VIS' then call copyvislines
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
  'MACRO marker'
  'CLIP COPY'
  'MARK CLEAR'
  return

/* Copy visible lines only */
copyvislines: procedure
  'EXTRACT /FILENAME/'
  fn=FILENAME.1'.x2tmp'
  'PUT' fn
  -- 'X' fn
  ADDRESS SYSTEM 'type' fn '|gc'
  ADDRESS SYSTEM 'del' fn
  'MSG Visible lines copied to clipboard'
  return
