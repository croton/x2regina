/* runjs -- Run a nodejs module. */
arg options
if options='-?' then do; 'MSG runjs [runner | -SAVE]'; exit; end

'EXTRACT /FILENAME/'
'EXTRACT /ALT/'
if ALT.2>0 then 'SAVE'  -- save any pending changes

runner='njs'
xcmd='CMDTEXT SHELL'
select
  when options='' then nop
  when abbrev('-SAVE',options) then xcmd='CMDTEXT cmdout JS.OUT'
  otherwise runner=word(options, 1)
end
xcmd runner filename.1
exit
