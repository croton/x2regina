/* fssrc2cfg - Show a file listing of config files associated with a given page template */
arg options

projectConfigs='C:\development\fs-ui\source\config\configs\'

'EXTRACT /FILENAME/'
parse value filespec('N', FILENAME.1) with filestem '.' .
parsedName=parseByCapitalization(filestem)

if options='-?' then do
  'MSG File' parsedName '->' deriveConfigName(parsedName)
end
else do
  fileListingCmd='dir' projectConfigs||deriveConfigName(parsedName) '/s /b'
  'MACRO cmdout configs-listing.txt' fileListingCmd
end

exit

parseByCapitalization: procedure
  parse arg input
  blank_delimited=''
  maxCodeUppercase=90
  do i=1 to length(input)
    ch=substr(input,i,1)
    if c2d(ch)>maxCodeUppercase then blank_delimited=blank_delimited||ch
    else                             blank_delimited=blank_delimited lower(ch)
  end i
  return blank_delimited

deriveConfigName: procedure
  parse arg input
  wordcount=words(input)
  if wordcount=1 then return input'.json'
  return space(subword(input, wordcount) delword(input, wordcount), 1, '_')||'.json'
