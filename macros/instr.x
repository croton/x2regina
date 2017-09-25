/* instr -- Insert specified text and place cursor at the position of a marker character (~).*/
parse arg input
if input='' then do; 'MSG instr /template/'; exit; end

parse var input delim +1 str (delim) options
marker_char='~'
'CURSOR DATA'
'KEYIN' str
if pos(marker_char, str)>0 then do
  'LOCATE /'marker_char'/-'
  'DELCHAR'
end
'FIND RESTORE'
exit
