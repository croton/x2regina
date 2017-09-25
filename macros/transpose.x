/* transpose -- Transpose two characters on the current line. */
'extract /CURLINE/'
'extract /CURSOR/'

if cursor.2>=length(curline.1) | length(curline.1)<2 then do
  'CURSOR' cursor.1 cursor.2
  return
end

left_ch=substr(curline.1,cursor.2,1)
right_ch=substr(curline.1,cursor.2+1,1)

newline=overlay(left_ch, curline.1, cursor.2+1)
newline=overlay(right_ch, newline, cursor.2)

'REPLACE' newline
'CURSOR' cursor.1 cursor.2
exit
