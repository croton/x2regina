/* favdir - Show contents of a directory among a stored list */
arg options
select
  when options='?' then do; 'MSG favdir (N)ame-only' directory(); exit; end
  otherwise
    ans=pickFromFile(getFavorites(), 'Quick Directories')
    if ans='' then 'MSG Selection cancelled'
    else do
      if abbrev('NAMEONLY', options, 1) then 'CMDTEXT dir' ans
      else 'MACRO dir' ans
    end
end
exit

getFavorites: procedure
  defaultFile=value('X2HOME',,'ENVIRONMENT')||'\lists\favdir.xfn'
  localFile=directory()||'\favdir.log'
  if SysFileExists(localFile) then return localFile
  return defaultFile

::requires 'XPopups.x'
