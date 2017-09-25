/* wraptag -- wrap a marked area with a given tag. */
parse arg tagname options
if tagname='' then do; 'MSG wraptag name [LINE | ALL]'; exit; end

options=translate(options)
open='<'tagname'>'
closed='</'tagname'>'
select
  when wordpos('LINE', options)>0 then 'MACRO wrapmark |'open'|'closed'|'
  when wordpos('ALL', options)>0  then 'MACRO wrapblock' open closed 'ALL'
  otherwise
    'MACRO wrapblock' open closed
end
exit
