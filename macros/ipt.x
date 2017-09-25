/* ipt -- Interpret an expression and insert into current location. */
parse arg expression
interpret 'result =' expression
'CURSOR DATA'
'KEYIN' result
exit
