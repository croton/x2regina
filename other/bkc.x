/* Clear the bookmarks. */
'EXTRACT /BOOKMARK/'
do i=1 to BOOKMARK.0
 if BOOKMARK.i<>'0,1' then
   'BOOKMARK' i 0
end i
'MSG Bookmarks cleared'
exit
