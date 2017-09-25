/* miscmenu -- Set up a single menu for the current file. */
'EXTRACT /CD/'
'MENU Misc'
'MENUITEM Mark , CMDTEXT mark'
'MENUITEM Cursor , CMDTEXT CURSOR +0 +0'
'MENUITEM Get output , CMDTEXT cmdin'
'MENUITEM Get RX output , CMDTEXT cmdin rexx'
'MENUITEM Replay keys , CMDTEXT keys_play '

'MENU Keys'
'MENUITEM Num ,     MACRO showkeys'
'MENUITEM Alt-Fn ,  MACRO showkeys A'
'MENUITEM Ctrl-Fn , MACRO showkeys C'
'MENUITEM Shift-Fn ,MACRO showkeys S'
'MENUITEM Alt A-Z , MACRO showkeys LA'
'MENUITEM Ctrl A-Z ,MACRO showkeys L'

'MENU Wrap'
'MENUITEM Curr line , CMDTEXT wrapmark |||'
'MENUITEM Brackets , CMDTEXT wrapit {'
'MENUITEM Brackets for block , CMDTEXT wrapit [ BLOCK'
'MENUITEM Block , CMDTEXT wrapblock'
'MENUITEM Multiple lines , CMDTEXT wrapline |||'
'MENUITEM Tags , CMDTEXT wraptag'

'MSG Misc menu active for working dir' CD.1
exit
