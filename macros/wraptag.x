/* wraptag -- wrap a marked area with a given tag. */
parse arg options
if options='' | options='-?' then call help
w=wordpos('-each',options)
if w>0 then do; each=1; options=delword(options,w,1); end; else each=0

tagname=word(options, 1)
open='<'tagname'>'
closed='</'tagname'>'
'EXTRACT /MARK/'
onelineBlockMark=(MARK.0>0 & MARK.4>0 & MARK.2=MARK.3)
select
  when each             then 'MACRO wrapline |'open'|'closed'|'
  when onelineBlockMark then 'MACRO wrapmark |'open'|'closed'|'
  otherwise                 'MACRO wrapblock |'open'|'closed'|'
end
exit

help: procedure
  'MSG wraptag name [-each]'
  exit
