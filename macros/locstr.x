/* locstr -- Locate a given string and place the cursor. */
parse arg str
howfar=length(str)
'LOCATE /'str'/'
'CURSOR +0 +'howfar
exit
