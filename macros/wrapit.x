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
if abbrev('BLOCK',options,1) then do
  'MARK CLEAR'
  'MACRO wrapblock |'leftside'|'rightside'|'
end
else
  'MACRO wrapmark |'leftside'|'rightside'|'
exit
