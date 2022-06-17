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

::routine getFilenameFromImport PUBLIC
  'EXTRACT /CURLINE/'
  'EXTRACT /FILEINFO/'
  parse value CURLINE.1 with keyword others
  if keyword='import' then do
    -- Parse the filename from the IMPORT statement and construct a valid file path
    filespec=word(others, words(others))
    fn=changestr("'", changestr(';', filespec, ''), '')||'.js'
    fullpath=delstr(FILEINFO.1, lastpos('\', FILEINFO.1)+1)||translate(fn, '\', '/')
    return fullpath
  end
  return ''

::routine showRecent PUBLIC
  parse arg ext
  if ext='' then ext='*.js'
  'MACRO cmdin fd -d src -dy 2 -x' ext '|wordf'
  return
