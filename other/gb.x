/* gb -- GatsbyJs dev utility tools. */
parse arg pfx options
select
  when pfx='css' then call css2jsx
  when pfx='il' then call loadFromImport
  when pfx='it' then call importCurrentTag
  when pfx='r' then call showRecent options
  when pfx='usedby' then call usedBy options
  otherwise call help
end
exit

loadFromImport: procedure
  impfile=getFilenameFromImport()
  if impfile='' then do
    'REFRESH'
    'MSG Not an import statement -- unable to look up filename!'
  end
  else 'EDIT' impfile
  return

css2jsx: procedure
  'CHANGE /class=/className=/'
  return

usedBy: procedure
  arg option
  'EXTRACT /FILENAME/'
  parse var FILENAME.1 fstem '.' .
  lastDelim=lastpos('\', fstem)
  srcDirPos=pos('\src\', fstem)
  baseDir=delstr(fstem, srcDirPos)
  comp=substr(fstem, lastDelim+1)
  xcmd='ffi' baseDir'\src\*.js' '/'comp 'import'
  results.=cmdOutputStem(xcmd)
  if results.0=0 then call xsay 'No components found which use' comp
  else do
    if abbrev(option, 'P') then do
      -- Load a selected file into editor
      call xsay 'Pick a file to edit from' results.0
    end
    else call msgBoxFromStem 'Components using' comp, results.
  end
  return

help: procedure
  helpmsg.1='gb prefix [options]'
  helpmsg.2='  css = change class to className'
  helpmsg.3='  il = load a file from an IMPORT statement'
  helpmsg.4='  it = import current tag'
  helpmsg.5='  r = show recent files'
  helpmsg.6='  usedby = show components using this file'
  helpmsg.0=6
  call msgBoxFromStem 'gb -- GatsbyJs dev utility tool', helpmsg.
  return

::requires 'XReact.x'
::requires 'XRoutines.x'
::requires 'XPopups.x'
