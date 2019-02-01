/* Underline the current line of text. */
arg uchar +1 .
charlist='-=.'
if pos(uchar, charlist)=0 then uchar='-'
'EXTRACT /CURLINE/'
posNonBlank=verify(CURLINE.1, ' ')  -- find first non-blank
'INPUT' copies(' ',posNonBlank-1)||copies(uchar,length(CURLINE.1)-posNonBlank+1)
'DOWN 2'                            -- move down past the underlining
exit
