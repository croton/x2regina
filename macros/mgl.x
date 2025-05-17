/* Wrapper to multiplyline; merge a template with values. */
parse arg input
select
  when input='?' then do; 'MSG mgl [digit|X|wordlist]'; exit; end
  when datatype(input,'W') then 'MACRO multiplyline /@/='abs(input)
  when translate(input)='X' then call mergeMultiply
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

/* -----------------------------------------------------------------------------
   USE CASE
   above-current> blue orange ; solid dashed         -- merge values
   current-line> .bd-?1-?2 { border: 1px ?2 ?1; }    -- the template
   generates this output...
     .bd-blue-solid { border: 1px solid blue; }
     .bd-blue-dashed { border: 1px dashed blue; }
     .bd-orange-solid { border: 1px solid orange; }
     .bd-orange-dashed { border: 1px dashed orange; }
   -----------------------------------------------------------------------------
*/
mergeMultiply: procedure
  'UP'                   -- move cursor up 1 line for argument data
  'EXTRACT /CURLINE/'    -- get line contents
  mergevals=CURLINE.1
  'DOWN'                 -- move cursor back down to template line
  'EXTRACT /CURLINE/'    -- get line contents
  parse var mergevals leftside ';' rightside
  do w=1 to words(leftside)
    left=word(leftside,w)
    do r=1 to words(rightside)
      right=word(rightside,r)
      'INPUT' merge(CURLINE.1, left right)
    end r
  end w
  return

::requires 'UtilRoutines.rex'
