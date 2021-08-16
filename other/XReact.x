/* Macros and functions for ReactJS */

::routine importCurrentTag PUBLIC
  'EXTRACT /CURSOR/'
  tagname=getTagName()
  statement='import' tagname "from './"tagname"';"
  'TOP'
  'INPUT' statement
  -- Advance cursor to 3rd word
  do 3
    'NEXT_WORD'
  end
  'CURSOR' CURSOR.1+1 CURSOR.2  -- Increment row since we inserted a line
  'MSG Imported "'tagname'"'
  return

::routine getTagName PRIVATE
  'EXTRACT /CURLINE/'
  'EXTRACT /CURSOR/'
  parse value left(CURLINE.1, CURSOR.2) with '<' tagpart
  alphaOnly=''
  do i=1 to length(tagpart)
    chr=substr(tagpart, i, 1)
    if \datatype(chr,'A') then leave i
    alphaOnly=alphaOnly||chr
  end i
  return alphaOnly

