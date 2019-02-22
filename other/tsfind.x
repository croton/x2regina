/* Search *.ts files for a given string */
parse arg searchstring fspec
if fspec='' then fspec='*.ts'
'MACRO cmdout findfiles.ts ff' fspec searchstring
exit
