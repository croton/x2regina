/* bkm - Print or clear bookmarks of the current file. */
arg option .
select
  when abbrev('PRINT', option, 1) then call print
  when abbrev('CLEAR', option, 1) then call clear
  otherwise call help
end
exit

print: procedure
  'EXTRACT /FILENAME/'
  parse value filespec('N', FILENAME.1) with fstem '.' .
  outp=.Stream~new(fstem'-bookmarks.log')
  outp~lineout('Bookmarks for' FILENAME.1 translate(date(),'-',' '))
  outp~lineout('Lines:')
  bms=getBookmarks()
  do w=1 to words(bms)
    outp~lineout(word(bms,w))
  end w
  outp~close
  'MSG Printed bookmarks to' outp
  return

/* Fill an array of bookmarks */
getBookmarks: procedure
  bms=''
  'EXTRACT /BOOKMARK/'
  do i=1 to BOOKMARK.0
    parse value BOOKMARK.i with row ',' col
    if row<>0 then bms=bms row
  end i
  return strip(bms)

clear: procedure
  'EXTRACT /BOOKMARK/'
  do i=1 to BOOKMARK.0
  if BOOKMARK.i<>'0,1' then
    'BOOKMARK' i 0
  end i
  'MSG Bookmarks cleared'
  return

help: procedure
  'MSG bkm (P)rint | (C)lear'
  exit
