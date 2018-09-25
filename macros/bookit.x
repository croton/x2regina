/* bookit -- Set bookmarks based on a given search string. */
parse arg searchstr
if searchstr='' then do; 'MSG bookit searchstr [CLEAR]'; exit; end

if abbrev('CLEAR', translate(searchstr)) then do
  call clearbkmarks
  'MSG Bookmarks cleared'
  exit
end

'EXTRACT /WRAP/'   -- restore WRAP setting when done
'EXTRACT /CURSOR/' -- restore cursor
'WRAP OFF'
ctr=0
'LOCATE' searchstr
do while rc=0
  ctr=ctr+1
  'BOOKMARK SET'
  'REPEAT_FIND'
end

-- Restore previous settings
'WRAP' WRAP.1
'CURSOR' CURSOR.1 CURSOR.2
'MSG Set' ctr 'bookmarks.'
-- 'BOOKMARK GO'
exit

clearbkmarks: procedure
'EXTRACT /BOOKMARK/'
do i=1 to BOOKMARK.0
 if BOOKMARK.i<>'0,1' then
   'BOOKMARK' i 0
end i
return
