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

::routine leadblanks public
  parse arg str
  return max(verify(str, ' ')-1,0)

::routine getindent public
  'EXTRACT /CURLINE/'
  blanks=max(verify(CURLINE.1, ' ')-1,0)
  return copies(' ', blanks)

::routine currentIndent public
  'EXTRACT /CURSOR/'
  return copies(' ', CURSOR.2-1)
