/* Find files with an external command. */
parse arg fspec searchString
if fspec='' then do
  'MSG f filespec [searchString]'
  exit
end
if searchString='' then do
  'MACRO cmdout findfiles.txt f' fspec
end
else do
  call value 'X2LATESTSEARCH', searchString, 'ENVIRONMENT'
  'MACRO cmdout findInFiles.txt ff' fspec searchString
end
exit
