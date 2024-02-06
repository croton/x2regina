/* csscolor - Choose colors */
arg option
if option='?' then do; 'MSG csscolor [RGB|HEX]'; exit; end

select
  when abbrev('RGB', option, 1) then call pickColor 2
  when abbrev('HEX', option, 1) then call pickColor 3
  otherwise call pickColor
end
exit

pickColor: procedure
  arg index
  colors=.environment['colors']
  if colors=.nil then call xsay 'No colors list available'
  else do
    if index='' then choice=pickFromArray(colors, 'Colors')
    else             choice=pickFromArray(colors, 'Colors', index)
    if choice='' then call xsay 'No choice made'
    else              'KEYIN' choice
  end
  return

::requires 'XPopups.x'
