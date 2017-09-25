/* xpandmac.x - template for expand macros. */
parse arg indent argval
'INPUT -- Expansion macro arg ['argval'] Indent='indent

-- For expand_keyword of "/1 -v", matching pattern is "-v"
pattern_len=3
-- Extract part of argument which will be re-output
prefix=left(argval,length(argval)-pattern_len)
newpattern='ng-click="">'

'INPUT' prefix newpattern
'NEXT_WORD'
exit
