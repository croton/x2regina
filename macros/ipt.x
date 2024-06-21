/* ipt -- Interpret an expression and insert into current location. */
parse arg expression
w=wordpos('-i',expression)
if w>0 then do; inline=1; expression=delword(expression,w,1); end; else inline=0

interpret 'result =' expression
'CURSOR DATA'
if inline then 'KEYIN' result
else           'INPUT' result
exit
