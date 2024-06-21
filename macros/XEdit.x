-- X2 basic editing functions, ver. 0.01
::routine getindent PUBLIC
  'EXTRACT /CURLINE/'
  blanks=max(verify(CURLINE.1, ' ')-1,0)
  return copies(' ', blanks)

::routine wordAtCursor PUBLIC
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  return word(substr(CURLINE.1, CURSOR.2),1)

::routine wordBeforeCursor PUBLIC
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  return getWordBefore(CURLINE.1, CURSOR.2)

::routine filterWordBeforeCursor PUBLIC
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  return filterWordBefore(CURLINE.1, CURSOR.2, '"')

::routine getWordBefore PRIVATE
  parse arg currline, colno
  target=left(currline,max(colno-1,1))
  if target='' then return ''
  return subword(target, words(target))

::routine filterWordBefore PRIVATE
  parse arg currline, colno, delim
  target=left(currline,max(colno,1))
  if target='' then return ''
  defaultvalue=subword(target, words(target))
  if delim='' then return defaultvalue
  else do
    haschar=(pos(delim,defaultvalue)>0)
    if haschar then do
      parse var defaultvalue before (delim) after (delim)
      if after='' then return before
      else return after
    end
    return defaultvalue
  end

