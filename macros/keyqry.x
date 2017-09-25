/* keyqry -- Query key assignment unitl ESCAPE is pressed. */
'EXTRACT /ESCAPE/'
nl=ESCAPE.1'N'                                    -- Newline escape sequence
do forever
  msg = 'X2 Editor Key Query Utility' || nl || nl 'Press Escape to end'
  'MESSAGEBOX' msg ||nl
  if rc<>0 then leave
  'EXTRACT /key' messagebox.1'/'
  if key.1=0 then key.1='undefined'
  'MSG key name='left(messagebox.1,12) 'function='key.1
  if result='1b'x | result='ESCAPE' then leave   -- Escape key
end
exit
