/* rjstools -- macros for ReactJS dev */
parse arg options
select
  when options='it' then call importCurrentTag
  otherwise call help
end
exit

help: procedure
  call xsay 'rjstools [it]'
  return

::requires 'XReact.x'
::requires 'XRoutines.x'
