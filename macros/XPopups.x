-- X2 Routines for Popups, ver. 0.1
::requires 'XRoutines.x'

::routine msgBox public
  parse arg title, msg
  'EXTRACT /ESCAPE/'
  NL=ESCAPE.1||'N'
  -- ruleline=copies('-', length(title))
  ruleline=copies('-', 35)
  'MESSAGEBOX' title||NL ruleline||NL||msg
  return result

::routine msgBoxFromStem public
  use arg title, textlines.
  'EXTRACT /SCREEN/'
  'EXTRACT /ESCAPE/'
  NL=ESCAPE.1||'N'
  maxlines=SCREEN.1-5
  msg=''
  do i=1 to textlines.0-1 while i<maxlines
    msg=msg textlines.i||NL
  end i
  msg=msg textlines.i
  if i>=maxlines then msg=msg '...'
  call msgBox title, msg
  return

::routine msgBoxFromCmd public
  parse arg title, command
  if command='' then return
  'EXTRACT /SCREEN/'
  output.=cmdOutputStem(command)
  if output.0>SCREEN.1 then 'MACRO cmdout msgBoxFromCmd.txt' command
  else call msgBoxFromStem title, output.
  return

/* -----------------------------------------------------------------------------
   A message box which provides a Yes/No prompt. Returns boolean value.
   -----------------------------------------------------------------------------
*/
::routine msgYNBox public
  parse arg msg, title
  'EXTRACT /ESCAPE/'
  NL=ESCAPE.1||'N'
  if msg='' then msg='Continue?'
  maxwidth=max(length(msg), length(title))+5
  divline=copies('-', maxwidth)
  choices=centre('(Y)es | (N)o', maxwidth)
  info=' 'msg
  if title='' then
    'MESSAGEBOX' info||NL choices
  else
    'MESSAGEBOX' title||NL divline||NL info||NL choices
  if result='ENTER' then return 1
  else if abbrev(translate(result), 'Y') then return 1
  return 0

::routine ask public
parse arg promptTxt
'PROMPT' promptTxt
if rc=0 then
  if result<>'' then return result
return .nil

/* Search the current file for a search string and return results as stem */
::routine searchfile public
  parse arg searchString
  'EXTRACT /SCREEN/'
  'EXTRACT /WRAP/'
  'EXTRACT /CURSOR/'
  maxcols=SCREEN.2
  ctr=0
  found.0=0
  'TOP'
  'WRAP OFF'
  'LOCATE /'searchString'/'
  do until ctr=SCREEN.1
    if rc<>0 then leave
    'EXTRACT /CURLINE/'
    ctr=ctr+1
    found.ctr=CURLINE.1
    'FIND REPEAT'
  end
  found.0=ctr
  'FIND RESTORE'
  'WRAP' WRAP.1
  'CURSOR' CURSOR.1 CURSOR.2
  return found.

/* Prompt for single choice among items in a stem. */
::routine pick public
  use arg srclist., title
  if title='' then title='Make a selection'
  'EXTRACT /SCREEN/'
  return getDialogChoice(srclist., SCREEN.1, autowidthStem(srclist., SCREEN.2), title)

/* Prompt for multiple choices among items in a stem. */
::routine pickmany public
  use arg srclist., title
  if title='' then title='Make a selection'
  'EXTRACT /ESCAPE/'
  'EXTRACT /SCREEN/'
  totalitems=srclist.0
  'WINDOW' min((SCREEN.1)%2,totalitems) autowidthStem(srclist., SCREEN.2) totalitems title
  do i=1 to totalitems
    'WINLINE' srclist.i '\nSETRESULT' i
  end i
  pmsg=''            -- keep a running list of picked items as feedback
  picked.=0          -- set all indexes as NOT picked
  do forever
    'WINWAIT GETKEY'
    select
      when rc<>0 then leave
      when wordpos(winwait.1, 'UP DOWN LEFT RIGHT')>0 then 'WINSCROLL' winwait.1
      when winwait.1='ESCAPE' then do; picked.=0; leave; end
      when winwait.1='F2' then do; picked.=1; leave; end     -- select all
      when winwait.1='F3' then leave     -- exit, making no changes to selection
      when winwait.1='ENTER' then do; idx=winwait.2; picked.idx=1; leave; end
      when winwait.1='SPACE' then do
        idx=winwait.2
        picked.idx=\picked.idx -- toggle selection state
        pmsg=''
        do w=1 to srclist.0       -- update picked items list
          if picked.w then pmsg=pmsg left(srclist.w,3)
        end w
      end
      otherwise nop
    end -- process key stroke
    'MSG' pmsg
  end
  'WINCLEAR'
  ctr=0
  do w=1 to totalitems
    if picked.w then do
      ctr=ctr+1
      picks.ctr=srclist.w
    end
  end w
  picks.0=ctr
  return picks.

/* Prompt for multiple choices among items in an array. */
::routine pickManyFromArray public
  use arg srclist, title
  'EXTRACT /SCREEN/'
  return getChoices(srclist, SCREEN.1, autowidth(srclist, SCREEN.2), title)

/* Prompt for single choice among items in an array. */
::routine pickFromArray public
  use arg srclist, title, resultWordIndex
  if title='' then title='Make a selection'
  'EXTRACT /SCREEN/'
  return getChoiceByIndex(srclist, SCREEN.1, autowidthSlim(srclist, SCREEN.2), title, resultWordIndex)

/* Prompt for single choice among items in a map or directory. */
::routine pickfrom public
  use arg map, title
  if title='' then title='Make a selection'
  'EXTRACT /SCREEN/'
  'WINDOW' min((SCREEN.1)%2,map~items) autowidth(map, SCREEN.2) map~items title
  do key over map
    'WINLINE' map[key] '\n SETRESULT' key
  end
  'WINWAIT'
  if symbol('RESULT')='LIT' then return '' -- Return blank string if user cancels choice
  return result

/* Pick from a dialog whose source items are each a return value and a display item. */
::routine pickfromDual public
  parse arg filestem, title, delim, showLabelsOnly
  filename=getFunctionFile(filestem)
  if \SysFileExists(filename) then return 'NOFILE-'filename
  ifile=.Stream~new(filename)
  map=.directory~new
  if delim='' then do while ifile~lines>0
    data=ifile~linein
    parse var data displayVal returnVal
    if showLabelsOnly=1 then map~put(displayVal, returnVal)
    else                     map~put(data, returnVal)
  end -- No delimiter specified
  else do while ifile~lines>0
    data=ifile~linein
    parse var data displayVal (delim) returnVal
    if showLabelsOnly=1 then map~put(displayVal, returnVal)
    else                     map~put(displayVal returnVal, returnVal)
  end -- Use delimiter to parse each entry
  ifile~close
  if title='' then title=filestem
  return pickfrom(map, title)

::routine pickfromDualSort public
  parse arg filestem, title, delim
  'EXTRACT /SCREEN/'
  if delim='' then delim=';'
  if title='' then title=filestem
  filename=getFunctionFile(filestem)
  if \SysFileExists(filename) then return 'NOFILE-'filename
  ifile=.Stream~new(filename)
  arr=ifile~makearray~sort
  ifile~close
  maxval=30
  loop item over arr
    parse var item displayvalue (delim) .
    maxval=max(maxval, length(displayvalue))
  end
  return getChoice(arr, SCREEN.1, maxval, title, delim)

/* Prompt for single choice among items in a file listing. */
::routine pickFile public
  use arg srclist., title, fileListOption
  if title='' then title='Pick a file'
  'EXTRACT /SCREEN/'
  displaytext.=getDisplayNames(srclist., fileListOption)
  winwidth=autowidthStem(displaytext., SCREEN.2)
  -- call log 'MxDW='SCREEN.2-2 'MedDW='(SCREEN.2)%2 'TW='length(title)+15 'MxIW='mxIW 'winW='winwidth 'opt='option
  return getDialogChoice(srclist., SCREEN.1, winwidth, title, displaytext.)

/* Prompt for single choice among lines in a given file. */
::routine pickFromFile public
  parse arg filename, title
  if \SysFileExists(filename) then return ''
  ifile=.Stream~new(filename)
  contents=ifile~arrayin
  ifile~close
  return pickFromArray(contents, title)

/* Prompt for multiple choices among lines in a given file. */
::routine pickManyFromFile public
  parse arg filename, title
  if \SysFileExists(filename) then return ''
  ifile=.Stream~new(filename)
  contents=ifile~arrayin
  ifile~close
  return pickManyFromArray(contents, title)

/* Show open files in a dialog, displaying [F]ilename only (default) or [P]artial path */
::routine filering public
  parse arg title, option
  'EXTRACT /RING/'
  return pickFile(RING., title, option)

/* Display a dialog and return selection */
::routine getDialogChoice PRIVATE
  use arg returnValues., maxrows, winWidth, title, displayValues.
  totalItems=returnValues.0
  'WINDOW' min(maxrows%2, totalItems) winWidth totalItems title
  if datatype(displayValues.0,'W') then do i=1 to totalItems
    'WINLINE' displayValues.i '\n SETRESULT' returnValues.i
  end i
  else do i=1 to totalItems
    'WINLINE' returnValues.i '\n SETRESULT' returnValues.i
  end i
  'WINWAIT'
  if symbol('RESULT')='LIT' then return ''
  return result

/* Display a dialog and return a selection, using arrays */
::routine getChoiceByIndex PRIVATE
  use arg returnValues, maxrows, winWidth, title, resultWordIndex
  totalItems=returnValues~items
  'WINDOW' min(maxrows%2, totalItems) winWidth totalItems title
  if datatype(resultWordIndex,'W') then do
    if resultWordIndex>0 & resultWordIndex<=words(returnValues[1]) then
      do i=1 to totalItems
        'WINLINE' returnValues[i] '\n SETRESULT' word(returnValues[i], resultWordIndex)
      end i
    else do i=1 to totalItems
      'WINLINE' returnValues[i] '\n SETRESULT' returnValues[i]
      end i
  end
  else
    do i=1 to totalItems
      'WINLINE' returnValues[i] '\n SETRESULT' returnValues[i]
    end i
  'WINWAIT'
  if symbol('RESULT')='LIT' then return ''
  return result

::routine getChoice PRIVATE
  use arg returnValues, maxrows, winWidth, title, delim
  totalItems=returnValues~items
  'WINDOW' min(maxrows%2, totalItems) winWidth totalItems title
  do i=1 to totalItems
    parse value returnValues[i] with displayVal (delim) returnVal
    'WINLINE' displayVal '\n SETRESULT' returnVal
  end i
  'WINWAIT'
  if symbol('RESULT')='LIT' then return ''
  return result

/* Display a dialog and return one or more selections, using arrays */
::routine getChoices PRIVATE
  use arg returnValues, maxrows, winWidth, title
  totalItems=returnValues~items
  'WINDOW' min(maxrows%2, totalItems) winWidth totalItems title
  do i=1 to totalItems
    'WINLINE' returnValues[i] '\n SETRESULT' i   -- returnValues[i]
  end i
  pmsg=''            -- keep a running list of picked items as feedback
  picked.=0          -- set all indexes as NOT picked
  do forever
    'WINWAIT GETKEY'
    select
      when rc<>0 then leave
      when wordpos(winwait.1, 'UP DOWN LEFT RIGHT')>0 then 'WINSCROLL' winwait.1
      -- ESC = exit and ignore any selections
      when winwait.1='ESCAPE' then do; picked.=0; leave; end
      -- F2 = select all
      when winwait.1='F2' then do; picked.=1; leave; end
      -- F3 = exit and maintain any selections
      when winwait.1='F3' then leave
      -- ENTER = pick current and exit
      when winwait.1='ENTER' then do; idx=winwait.2; picked.idx=1; leave; end
      -- SPACE = toggle current
      when winwait.1='SPACE' then do
        idx=winwait.2
        picked.idx=\picked.idx
        pmsg=''
        do w=1 to totalItems       -- update picked items list
          if picked.w then pmsg=pmsg left(returnValues[w],3)
        end w
      end
      otherwise
        newidx=findFirstMatch(returnValues, winwait.1)
        if newidx>=0 then 'WINSELECT' newidx
    end -- process key stroke
    'MSG' pmsg
  end
  'WINCLEAR'
  picks=.Array~new
  do w=1 to totalItems
    if picked.w then picks~append(returnValues[w])
  end w
  return picks

/* Return the index of the first match of an array item search */
::routine findFirstMatch private
  use arg collection, searchStr
  iter=collection~supplier
  match=-1
  do while iter~available
    if abbrev(iter~item, searchStr) then do
      match=iter~index
      leave
    end
    iter~next
  end
  return match

::routine autowidthStem PRIVATE
  use arg datasource., screenwidth
  halfscreenw=screenwidth%2
  maxItemWidth=0
  do i=1 to datasource.0
    currlen=length(datasource.i)
    if currlen>maxItemWidth then maxItemWidth=currlen
  end i
  if maxItemWidth<halfscreenw then return maxItemWidth+2
  return min(maxItemWidth, screenwidth-2)

::routine autowidth PRIVATE
  use arg datasource, screenwidth
  sourcetype=datasource~class
  maxItemWidth=0
  if sourcetype=.Array  then loop item over datasource
    currlen=length(item)
    if currlen>maxItemWidth then maxItemWidth=currlen
  end
  else if sourcetype=.Directory then do key over datasource
    currlen=length(datasource[key])
    if currlen>maxItemWidth then maxItemWidth=currlen
  end key
  return min(screenwidth-2, max(maxItemWidth, screenwidth%2))

-- Alternate calculation that provides for slimmer popups
::routine autowidthSlim PRIVATE
  use arg datasource, screenwidth
  sourcetype=datasource~class
  maxItemWidth=0
  if sourcetype=.Array  then loop item over datasource
    currlen=length(item)
    if currlen>maxItemWidth then maxItemWidth=currlen
  end
  else if sourcetype=.Directory then do key over datasource
    currlen=length(datasource[key])
    if currlen>maxItemWidth then maxItemWidth=currlen
  end key
  if maxItemWidth<(screenwidth%2) then return maxItemWidth+2
  return min(maxItemWidth, screenwidth-2)

/* Transform a file listing to show either name-only or partial path */
::routine getDisplayNames private
  use arg srclist., option
  if abbrev('FILENAME', option) then do i=1 to srclist.0
    newlist.i=filespec('N', srclist.i)
  end i
  else do
    'EXTRACT /CD/'
    do i=1 to srclist.0
      newlist.i=abbrevPath(srclist.i, CD.1)
    end i
  end
  newlist.0=srclist.0
  return newlist.

/* Shorten a full path if it is in the current working directory */
::routine abbrevPath PRIVATE
  parse arg fullpath, currdir
  if abbrev(fullpath, currdir) then partial='.'substr(fullpath,length(currdir))
  else                              partial=fullpath
  return translate(partial, '/', '\')

/* Get full path of a file used as datasource for a dialog.
   As convention, dialog datasource files have extension 'XFN'.
*/
::routine getFunctionFile PUBLIC
  parse arg filestem
  fnfile=filestem'.xfn'
  x2home=value('X2HOME',,'ENVIRONMENT')
  filepaths='.\'fnfile x2home'\lists\'fnfile '.\'filestem
  do w=1 to words(filepaths)
    fn=word(filepaths,w)
    if SysFileExists(fn) then return fn
  end w
  return ''
