/* wraptag -- wrap a marked area with a given tag. */
parse arg tagname option
if tagname='' then do; 'MSG wraptag name [Mark | Each]'; exit; end

option=translate(option)
open='<'tagname'>'
closed='</'tagname'>'
select
  when abbrev(option,'M') then 'MACRO wrapmark |'open'|'closed'|'
  when abbrev(option,'E') then 'MACRO wrapblock' open closed 'EACH'
  otherwise
    'MACRO wrapblock' open closed
end
exit
