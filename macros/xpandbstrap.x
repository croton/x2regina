/* xpandmac.x - template for expand macros. */
parse arg indent argval
call expandText indent, argval
exit

expandText: procedure
  parse arg indent, argval
  -- For expand_keyword of "/1 -v", matching pattern is "-v"
  -- Remove character 'trigger' from argument
  currtext=delword(argval, words(argval))
  prefix='class="'
  suffix='">'

  'INPUT' currtext||prefix
  'CURSOR EOL'
  'MACRO fnpick bootstrap'
  'KEYIN' suffix
  return
