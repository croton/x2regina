/* x2cmds -- Insert an X2 editor variable. */
arg input
if input='-?' then do; 'MSG x2cmds [CMD|VAR opt]'; exit; end

setting=chooser(input)
if abbrev('CMD',input) then 'KEYIN' quote(setting)
else do
  parse upper var input . showvalue
  select
    when showvalue='FILE' then writeVarValues(setting)
    when showvalue='MSG' then 'MESSAGEBOX' setting':' showVarValues(setting)
    otherwise
      'KEYIN' quote('EXTRACT /'setting'/')
  end
end
exit

/* Present a listbox containing commands. */
chooser:
arg input
if abbrev('CMD',input) then do
  call initcmds
  title='Commands'
end
else do
  call initvars
  title='Variables'
end
'WINDOW 15 40' cmds.0 'Editor' title
do i=1 to cmds.0
  'WINLINE' cmds.i'\n SETRESULT' cmds.i
end i
'WINWAIT'
-- Return blank string if user cancels choice
if symbol('RESULT')='LIT' then return ''
return result

/* Retrieve the actual values of a given setting */
showVarValues: procedure
  arg setting
  if setting='' then return ''
  'EXTRACT /ESCAPE/'
  nl=ESCAPE.1||'N'
  'EXTRACT /'setting'/'
  if rc<>0 then return '?'
  varname=word(setting,1)
  response=''
  do i=1 to value(varname'.0')
    response=response||i'=' value(varname'.'i)||nl
  end
  return response

/* Display variable values in temp file */
writeVarValues: procedure
  arg setting
  setting=strip(setting)
  'EXTRACT /'setting'/'
  'EDIT x2-editvar-values.txt'
  'INPUT === Contents of' setting '==='
  do i=1 to value(setting'.0')
    'INPUT' i '=' value(setting'.'i)
  end i
  return

/* Wrap the given argument in quotes. */
quote: procedure
  return "'"arg(1)"'"

/* Initialize the list of X2 variables */
initvars:
cmds.0=51
cmds.1='ALT'
cmds.2='APIFILE'
cmds.3='AUTOSAVE'
cmds.4='BOOKMARK'
cmds.5='CD'
cmds.6='CMDLINE'
cmds.7='CODE_TYPE'
cmds.8='COLOUR'
cmds.9='COLOURS'
cmds.10='COMMENTS'
cmds.11='CURLINE'
cmds.12='CURSOR'
cmds.13='ESCAPE'
cmds.14='EXT'
cmds.15='FIELDTEMPLATE'
cmds.16='FILEINFO'
cmds.17='FILENAME'
cmds.18='FIND'
cmds.19='FLSCREEN'
cmds.20='FT'
cmds.21='FUNCTION'
cmds.22='HELPFILE'
cmds.23='INSERT'
cmds.24='INSMODE'
cmds.25='KEY'
cmds.26='KEYPRESS'
cmds.27='LASTMSG'
cmds.28='LINE'
cmds.29='LINECOLOUR'
cmds.30='LINEFIELDS'
cmds.31='LINEFLAGS'
cmds.32='LINEND'
cmds.33='LINETEXT'
cmds.34='MARGINS'
cmds.35='MARK'
cmds.36='MARKTEXT'
cmds.37='MSGMODE'
cmds.38='NAME'
cmds.39='OS'
cmds.40='PFLINE'
cmds.41='POPUPINFO'
cmds.42='RING'
cmds.43='SCREEN'
cmds.44='SHADOW'
cmds.45='SHADOWTEXT'
cmds.46='SIZE'
cmds.47='STATUSTEXT'
cmds.48='TABS'
cmds.49='VERSION'
cmds.50='WRAP'
cmds.51='X2PATH'
return

/* Initialize list of X2 commands */
initcmds:
cmds.0=172
cmds.1='ACCENT'
cmds.2='ADD'
cmds.3='ALL'
cmds.4='ALT'
cmds.5='APPEND'
cmds.6='ASCII'
cmds.7='AUTOBOOKMARK'
cmds.8='AUTOSAVE'
cmds.9='BACKSPACE'
cmds.10='BACKTAB'
cmds.11='BACKWARD'
cmds.12='BOOKMARK'
cmds.13='BOTTOM'
cmds.14='BOTTOMSCREEN'
cmds.15='BROWSE'
cmds.16='C'
cmds.17='CHANGE'
cmds.18='CASECHAR'
cmds.19='CASEWORD'
cmds.20='CD'
cmds.21='CENTRELINE'
cmds.22='CENTRETEXT'
cmds.23='CHANGES'
cmds.24='CLIP'
cmds.25='CMDLINE'
cmds.26='CMDTEXT'
cmds.27='COMMAND'
cmds.28='COMMENTLINE'
cmds.29='COMMENT_STYLE'
cmds.30='COMPARE'
cmds.31='CONDITIONAL'
cmds.32='COPYLINE'
cmds.33='COPYTOCMD'
cmds.34='COUNT'
cmds.35='CURR_ALT_PFLINE'
cmds.36='CURR_CTRL_PFLINE'
cmds.37='CURR_PFLINE'
cmds.38='CURR_SHIFT_PFLINE'
cmds.39='CURSOR'
cmds.40='DATE'
cmds.41='DELCHAR'
cmds.42='DELDUPES'
cmds.43='DELETE'
cmds.44='DELSYM'
cmds.45='DELWORD'
cmds.46='DIAG'
cmds.47='DOWN'
cmds.48='DUPLICATES'
cmds.49='E'
cmds.50='EDIT'
cmds.51='X'
cmds.52='EA'
cmds.53='EOF_TEXT'
cmds.54='ERASEEOL'
cmds.55='ERRORS'
cmds.56='EXCLUDE'
cmds.57='EXITRC'
cmds.58='EXPAND'
cmds.59='EXT'
cmds.60='EXTRACT'
cmds.61='FFILE'
cmds.62='FIELDTEMPLATE'
cmds.63='FILE'
cmds.64='FIND_WORD'
cmds.65='FORWARD'
cmds.66='FT'
cmds.67='FUNCWIN'
cmds.68='GET'
cmds.69='HELP'
cmds.70='HEX'
cmds.71='HIDEFILE'
cmds.72='INPUT'
cmds.73='INPUT_ERRORLINE'
cmds.74='INSMODE'
cmds.75='JOIN'
cmds.76='KEY'
cmds.77='KEYIN'
cmds.78='KEYIN_NAME'
cmds.79='KEYS_PLAY, PLAYBACK'
cmds.80='KEYS_RECORD'
cmds.81='KEYS_WRITE'
cmds.82='L'
cmds.83='LOCATE'
cmds.84='LINECOLOUR'
cmds.85='LINEFIELDS'
cmds.86='LINEMACRO'
cmds.87='LINEND'
cmds.88='LINETEXT'
cmds.89='MA'
cmds.90='MARGINS'
cmds.91='MACRO'
cmds.92='MARK'
cmds.93='MATCH'
cmds.94='MESSAGEBOX'
cmds.95='MSG'
cmds.96='MSGMODE'
cmds.97='NAME'
cmds.98='NEXT'
cmds.99='NEXT_FILE'
cmds.100='NEXT_ERROR'
cmds.101='NEXT_FUNC'
cmds.102='NEXT_PARA'
cmds.103='NEXT_SENTENCE'
cmds.104='NEXT_SYM'
cmds.105='NEXT_WORD'
cmds.106='NOP'
cmds.107='NUMFILES'
cmds.108='OPENFILE'
cmds.109='PAGEDOWN'
cmds.110='PAGEUP'
cmds.111='PASSWORD'
cmds.112='PFLINE'
cmds.113='PRESSKEY'
cmds.114='PREVIOUS_FILE'
cmds.115='PREVIOUS_FUNC'
cmds.116='PREVIOUS_PARA'
cmds.117='PREVIOUS_SYM'
cmds.118='PREVIOUS_WORD'
cmds.119='PROMPT'
cmds.120='PUT'
cmds.121='QQ'
cmds.122='QQUIT'
cmds.123='QUIT'
cmds.124='REDO'
cmds.125='REFORMAT'
cmds.126='REFRESH'
cmds.127='RENAME'
cmds.128='REPEAT_FIND'
cmds.129='REPFIND'
cmds.130='REPLACE'
cmds.131='RESOLVE_FN'
cmds.132='RESTORE_FIND'
cmds.133='REVERSE_FIND'
cmds.134='RINGWIN'
cmds.135='SAVE'
cmds.136='SCROLL'
cmds.137='SETRESULT'
cmds.138='SHADOW'
cmds.139='SHADOWTEXT'
cmds.140='SHELL'
cmds.141='SHOW'
cmds.142='SHOWLINE'
cmds.143='SORT'
cmds.144='SPAN'
cmds.145='SPLIT'
cmds.146='SPLITJOIN'
cmds.147='STATUS'
cmds.148='STATUSTEXT'
cmds.149='STYLE'
cmds.150='SYNTAX'
cmds.151='TAB'
cmds.152='TABLINE'
cmds.153='TABS'
cmds.154='TIMER'
cmds.155='TITLE'
cmds.156='TOFEOF'
cmds.157='TOF_TEXT'
cmds.158='TOP'
cmds.159='TOPLINE'
cmds.160='TOPSCREEN'
cmds.161='UNDO'
cmds.162='UNDO_BLOCK'
cmds.163='UNDO_LIMIT'
cmds.164='UP'
cmds.165='WINCLEAR'
cmds.166='WINDOW'
cmds.167='WINLINE'
cmds.168='WINSCROLL'
cmds.169='WINSELECT'
cmds.170='WINSORT'
cmds.171='WINWAIT'
cmds.172='WRAP'
return

/* Insert one or more settings */
pickmany: procedure
parse arg spec
matchlist=findmatch(spec)
do i=1 to words(matchlist)
  cmd=word(matchlist,i)
  'INPUT' quote('EXTRACT /'cmd'/')
end i
if matchlist<>'' then 'MSG Extract variable(s) inserted.'
return

/* Create a space-delimited list of all matching values. */
findmatch:
arg key
if key='' then return chooser()
list=''
do i=1 to cmds.0
  if abbrev(cmds.i,key) then list=list cmds.i
end i
return list
