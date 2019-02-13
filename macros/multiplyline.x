/* multiplyline -- Current line is 'multiplied' for each word in wordlist as it
   replaces a given wildcard character.
   The word list may also be just a single numeric parameter, prefixed with '='
   which indicates that an incremented number is to replace each wildcard
   up to this value.
   Usage: multiplyline delim expression delim wordlist
   Examples: multiplyline /@/fish stream rock
             multiplyline /#/=5
*/
parse arg input
if input='-?' then call help

parse var input delim +1 wildcard (delim) tokens
'extract /CURLINE/'

-- Does word list indicate a numeric substitution?
tokenCount=words(tokens)
if (tokenCount=1 & left(tokens,1)='=') then do
  parse var tokens '=' xn
  if datatype(xn, 'W') then do
    do w=1 to xn
      -- Replace the wildcard with the current numeral
      'INPUT' changestr(wildcard, curline.1, w)
    end w
  'ALT 0 0'  -- Set file changes to zero to quit without confirm
   return
  end
end

do w=1 to tokenCount
  -- Replace the wildcard with the current word
  'INPUT' changestr(wildcard, curline.1, word(tokens,w))
end w
'ALT 0 0'    -- Set file changes to zero to quit without confirm
exit

help: procedure
  'MSG multiplyline /wildcard/wordlist'
  exit
