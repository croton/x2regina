/* opensearch -- Open a file and optionally search for a string. */
arg searchmode
'OPENFILE'
needle=value('X2LATESTSEARCH',,'ENVIRONMENT')
if needle<>'' then do
  if abbrev('LOC', searchmode) then 'LOCATE /'needle'/'
  else                              'ALL /'needle'/'
  'REFRESH'
  'MSG Search for' needle
end
exit
