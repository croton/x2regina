/* Wrapper to multiplyline; merge a template with values. */
parse arg input
select
  when input='-?' then do; 'MSG mgl [digit|wordlist]'; exit; end
  when datatype(input,'W') then 'MACRO multiplyline /@/='abs(input)
  otherwise
    if input='' then do
      'UP'                   -- move cursor up 1 line for argument data
      'EXTRACT /CURLINE/'    -- get line contents
      'DOWN'                 -- move cursor back down to template line
      'MACRO multiplyline /@/'CURLINE.1
    end
    else 'MACRO multiplyline' input
end
exit
