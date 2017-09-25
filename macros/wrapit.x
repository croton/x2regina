/* wrapit -- Wrap highlighted text in specified character set. */
arg leftside options
if leftside='' then do; 'MSG wrapit prefix [BLOCK]'; exit; end

options=translate(options)
select
  when leftside='(' then rightside=')'
  when leftside='[' then rightside=']'
  when leftside='{' then rightside='}'
  when leftside='<' then rightside='>'
  when leftside='/*' then rightside='*/'
  otherwise               rightside=leftside
end
if wordpos('BLOCK',options)=0 then
  'MACRO wrapmark |'leftside'|'rightside'|'
else
  'MACRO wrapblock' leftside rightside

exit
