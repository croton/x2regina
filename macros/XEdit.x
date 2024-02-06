-- X2 basic editing functions, ver. 0.01
::routine wordAtCursor public
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  return word(substr(CURLINE.1, CURSOR.2),1)

::routine getword public
  parse arg currline, colno
  return word(substr(currline, colno),1)

::routine wordBeforeCursor public
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  return getWordBefore(CURLINE.1, CURSOR.2)

::routine getWordBefore public
  parse arg currline, colno
  target=left(currline,max(colno,1))
  if target='' then return ''
  return subword(target, words(target))

::routine getindent public
  'EXTRACT /CURLINE/'
  blanks=max(verify(CURLINE.1, ' ')-1,0)
  return copies(' ', blanks)

/* Get word before cursor between delimiters. */
::routine wbcBetween public
  parse arg sdelim, edelim
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  csrLeft=left(CURLINE.1, CURSOR.2-1)
  startDelim=lastpos(sdelim, csrLeft)
  if startDelim=0 then return ''
  startTarget=startDelim+length(sdelim)
  if cursor<startTarget then return ''
  endDelim=pos(edelim, CURLINE.1, startTarget)
  if CURSOR.2>endDelim then return ''
  parse var csrLeft (sdelim) term
  if term='' then return term
  return word(term, words(term))

