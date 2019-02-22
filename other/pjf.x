/* Search for a given file from a specified base directory. */
parse arg input
projdir='c:\SAES\esbu_dev_saes_6_cpp\build\share\smartmatic\vebd\src\'

select
  when input='-?' then call help
  when input='' then call listfiles getmark()
  when input='json' then 'EDIT c:\SAES\dev\esbu_dev_saes_6_cpp\plugins\voting-experience\vebd\scripts\html\get-data\index.html'
  otherwise          call listfiles input
end
exit

getmark: procedure
  'EXTRACT /MARK/'
  'EXTRACT /FLSCREEN/'
  select
    when MARK.0=0 then return ''                                -- Nothing marked
    when (MARK.2>FLSCREEN.2 | MARK.3<FLSCREEN.1) then return '' -- Mark exists off screen
    when MARK.6=0 then return ''                                -- Mark exists in another file mark.1
    otherwise
      'EXTRACT /MARKTEXT/'
      return MARKTEXT.1
  end

listfiles: procedure expose projdir
  parse arg fspec
  if fspec='*' | fspec=' ' then 'MSG No filespec specified'
  else do
    if right(fspec,1)<>'*' then fspec=fspec'*'
    'MACRO cmdout projfiles.txt dir' projdir||fspec '/s /b'
  end
  return

help: procedure
  'MSG Usage: pjf filespec'
  exit
