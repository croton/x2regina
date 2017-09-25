/* repeatkey -- Repeat the currently defined keystrokes as many times as
   there are lines in the marked area or remaining in the current file.
*/
'EXTRACT /MARK/'
'EXTRACT /FLSCREEN/'

select
  when mark.0=0 then 'KEYS_PLAY' linesLeft()
  when (mark.2>flscreen.2 | mark.3<flscreen.1) then 'MSG Mark exists off screen.'
  when mark.6=0 then 'MSG Mark exists in another file:' mark.1
  otherwise
    'CURSOR BEGMARK' -- Ensure cursor is at beginning of mark before repeating keys
    'KEYS_PLAY' (mark.3-mark.2+1)
end
exit

/* Determine how many lines left in the file from the current cursor position. */
linesLeft: procedure
  'EXTRACT /CURSOR/'
  'EXTRACT /SIZE/'
  return (size.1-cursor.1+1)
