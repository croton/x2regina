/* xpandmac.x - template for expand macros. */
parse arg indent argval
-- For expand_keyword of "/1 -v", matching pattern is "-v"
pattern_len=3
-- Extract part of argument which will be re-output
prefix=left(argval,length(argval)-pattern_len)
newpattern='class="'
endtag='">'

'INPUT' prefix newpattern
'MACRO fnpick bootstrap'
'INPUT' endtag
-- 'NEXT_WORD'
exit
