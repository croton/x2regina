/* chooser -- Make a selection from a list. The options in the list are filled from the contents
   of a file or from the output of a command.
   Options
     --c command
     --f filename
     --t title
     --multi
     --q
     --p
     --d
*/
parse arg params
if params='?' then call help
paramsUC=translate(params)

select
  when wordpos('--C', paramsUC)>0 then do
    parse var params '--c' mycmd '--'
    call initListFromCmd mycmd
  end
  when wordpos('--F', paramsUC)>0 then do
    parse var params '--f' filespec '--'
    call initListFromCmd 'type' filespec
  end
  otherwise
    parse var params list '--' .
    if list='' then call help
    call initListStatic space(list)
end
parse var params '--t' title '--'
parse var params '--p' pattern '--'
parse var params '--d' delim '--'

if wordpos('--MULTI', paramsUC)>0 then do
  choicemade=chooseMulti(title)
  if choicemade then do while queued()>0
    parse pull entry
    'KEYIN' applyPattern(entry, pattern, delim)
    'INPUT'
  end
  else 'MSG No choice made'
end
else do
  choice=choose(title)
  if choice='' then 'MSG No choice made'
  else do
    xcmd='KEYIN'
    if wordpos('--CT', paramsUC)>0 then do
      parse var params '--ct' cmdtxtArgs '--'
      xcmd='CMDTEXT' cmdtxtArgs
    end
    if wordpos('--Q', paramsUC)>0 then push choice
    else do
      xcmd applyPattern(choice, pattern, delim)
      -- Uncomment to place cursor at beginning of entry
      -- 'CURSOR +0 -'length(choice)
    end
  end
end
exit

/* ------------------------------ SUBROUTINES ------------------------------- */
/* Present a listbox containing items in compound variable. */
choose:
  parse arg title
  if title='' then title='Make a selection'
  'EXTRACT /SCREEN/'
  maxrows=SCREEN.1
  maxcols=SCREEN.2
  -- Max width of popup will be length of max entry or half screen width
  mxlen=cmds.MAXENTRYLENGTH
  if \datatype(cmds.MAXENTRYLENGTH, 'W') then mxlen=maxcols%2

  /* debugging
  lastidx=cmds.0
  newlast=lastidx+1
  cmds.newlast=min(maxrows%2,cmds.0) max(mxlen,length(title)+15) cmds.0 'MXlen='mxlen
  cmds.0=newlast
  */

  'WINDOW' min(maxrows%2,cmds.0) max(mxlen,length(title)+15) cmds.0 title
  do i=1 to cmds.0
    'WINLINE' cmds.i'\n SETRESULT' cmds.i
  end i
  'WINWAIT'
  -- Return blank string if user cancels choice
  if symbol('RESULT')='LIT' then return ''
  return result

/* Present a listbox that allows multiple choices. */
chooseMulti:
  parse arg title
  if title='' then title='Make a selection'
  'EXTRACT /SCREEN/'
  maxrows=SCREEN.1
  maxcols=SCREEN.2
  'EXTRACT /ESCAPE/'
  'WINDOW' min(maxrows-2,cmds.0) min(maxcols-2,length(title)+5) cmds.0 title
  do i=1 to cmds.0
    'WINLINE' cmds.i || '\nSETRESULT' i
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
        do w=1 to cmds.0       -- update picked items list
          if picked.w then pmsg=pmsg left(cmds.w,3)
        end w
      end
      otherwise nop
    end -- process key stroke
    'MSG' pmsg
  end
  'WINCLEAR'
  pickmade=0
  do w=1 to cmds.0  -- Put choices onto the stack
    if picked.w then do; pickmade=1; queue cmds.w; end
  end w
  return pickmade

/* Initialize the list of items from the output of a command. */
initListFromCmd:
  parse arg command
  cmds.0=0
  ctr=0
  maxlen=0
  ADDRESS CMD command '|RXQUEUE'
  do while queued()<>0
    parse pull entry
    if entry='' then iterate
    ctr=ctr+1
    if length(entry)>maxlen then maxlen=length(entry)
    cmds.ctr=entry
  end
  cmds.0=ctr
  cmds.MAXENTRYLENGTH=maxlen
  return

/* Initialize the list of items from a space delimited string of words. */
initListStatic:
  parse arg items
  cmds.=''           -- Load entries into a stem
  cmds.0=0
  if items='' then call help
  maxlen=0
  count=words(items)
  do i=1 to count
    cmds.i=word(items, i)
    if length(cmds.i)>maxlen then maxlen=length(cmds.i)
  end
  cmds.0=count
  cmds.MAXENTRYLENGTH=maxlen
  return

applyPattern:
  parse arg selection, pattern, delim
  if delim='' then placeholder='@'
  else             placeholder=strip(delim)
  if pattern='' then return selection
  return changestr(placeholder, strip(pattern), selection)

help:
  'MSG chooser [--c cmd | --f file | wordlist][--multi][--q][--p][--d]'
  exit
