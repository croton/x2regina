/* Wrapper to multiplyline; merge a template with values. */
arg input
select
  when input='-?' then do; 'MSG mgl [limit]'; exit; end
  when datatype(input,'W') then 'MACRO multiplyline /@/='abs(input)
  otherwise
    'CURSOR -1 0'                 -- move cursor up 1 line for argument data
    'EXTRACT /CURLINE/'           -- get line contents
    'CURSOR +1 0'                 -- move cursor back down to template line
    'MACRO multiplyline /@/'CURLINE.1
end
exit
