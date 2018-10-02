/* wraptag -- wrap a marked area with a given tag. */
parse arg options
if options='' | options='-?' then call help
w=wordpos('-mark',options)
if w>0 then do; wmark=1; options=delword(options,w,1); end; else wmark=0
w=wordpos('-each',options)
if w>0 then do; each=1; options=delword(options,w,1); end; else each=0

tagname=word(options, 1)
open='<'tagname'>'
closed='</'tagname'>'
select
  when wmark then 'MACRO wrapmark |'open'|'closed'|'
  when each  then 'MACRO wrapblock' open closed 'EACH'
  otherwise       'MACRO wrapblock' open closed
end
exit

help: procedure
  'MSG wraptag name [-mark | -each]'
  exit
