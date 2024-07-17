-- X2 Routines Library, ver. 0.14

-- Return a stem of search results for the current file
::routine searchfile public
  parse arg searchString
  'EXTRACT /SCREEN/'
  'EXTRACT /WRAP/'
  'EXTRACT /CURSOR/'
  maxrows=SCREEN.1
  maxcols=SCREEN.2
  ctr=0
  found.0=0
  'TOP'
  'WRAP OFF'
  'LOCATE /'searchString'/'
  do until ctr=maxrows
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

/* Pass a given command to the external environment and return results as array */
::routine cmdOut public
  parse arg command
  if arg(1,'O') then return .nil
  myresults=.Array~new
  ADDRESS CMD command '|RXQUEUE'
  do while queued()<>0
    parse pull entry
    if entry='' then iterate
    myresults~append(entry)
  end
  return myresults

/* Pass a given command to the environment and return results as stem */
::routine cmdOutStem public
  parse arg command
  myresults.0=0
  if arg(1,'O') then return myresults.
  ctr=0
  ADDRESS CMD command '|RXQUEUE'
  do while queued()<>0
    parse pull entry
    if entry='' then iterate
    ctr=ctr+1
    myresults.ctr=entry
  end
  myresults.0=ctr
  return myresults.

/* -----------------------------------------------------------------------------
   Pass a given command to the external environment and return first line of
   output as a string.
   -----------------------------------------------------------------------------
*/
::routine cmdTop public
  parse arg command
  if arg(1,'O') then return ''
  output=cmdOutput(command)
  if output=.NIL then return ''
  return output[1]

-- Replace a string containing embedded placeholders with specified values.
::routine mergevalues public
  use arg str, values, PH
  if arg(3,'O') then PH='?'
  posPH=str~pos(PH)
  if posPH=0 then return str
  newstr=''
  do item over values until posPH=0
    parse var str before (PH) str
    newstr=newstr||before||item
    posPH=str~pos(PH)
    if posPH=0 then newstr=newstr||str
  end
  return newstr

-- Alternate pattern .. replace ?1,?2,?n with space delimited string
::routine merge public
  parse arg str, values
  newstr=str
  do w=1 to values~words
    PH='?'w
    newstr=newstr~changestr('?'w,values~word(w))
  end w
  return newstr

::routine hasmark public
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.0=0 then return 0                                -- Nothing marked
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then return 0 -- Mark exists off screen
    when MARK.6=0 then return 0                                -- Mark exists in another file mark.1
    otherwise nop
  end
  return 1

::routine hasblockmark public
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  rc=0
  select
    when MARK.0=0 then return rc                                -- Nothing marked
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then return rc -- Mark exists off screen
    when MARK.6=0 then return rc                                -- Mark exists in another file mark.1
    when MARK.4=0 then return rc                                -- Line mark NOT OK
    otherwise rc=1
  end
  return rc

::routine log public
  parse arg message
  logf=value('X2HOME',,'ENVIRONMENT')||'\x2debug.log'
  -- 'echo' date() time() message '>>' logf
  outp=.stream~new(logf)
  outp~lineout(date() time() message)
  outp~close
  return

::routine xsay public
  parse arg message
  'REFRESH'
  'MSG' message
  return

