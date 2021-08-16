/* fnpickdetail - Present a dialog from which to select functions,
   parsing the items into display value and return value.
*/
parse arg filestem propname .
if filestem='?' then do; 'MSG fnpickdetail filestem'; exit; end
if propname='' then propname='transform'

choice=pickFunction(filestem)
if choice='' then call xsay 'Choice cancelled'
else do
  'KEYIN' propname':' choice'()'
  'LOCATE /(/-'
  'CURSOR +0 +1'  -- Place cursor right after open parens
end
exit

pickFunction: procedure
  parse arg filestem
  -- filename=filestem'.xfn'
  filename=getFunctionFile(filestem)
  if \SysFileExists(filename) then return 'oops'
  ifile=.Stream~new(filename)
  map=.directory~new
  do while ifile~lines>0
    func=ifile~linein
    parse var func name '(' params
    map~put(func, name)
  end
  ifile~close
  return pickfrom(map, filestem)

::requires 'XPopups.x'
