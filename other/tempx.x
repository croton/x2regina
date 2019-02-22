/* temporary module-specific macro */
anyword=wordAtCursor()
currpad=getindent()
call xsay 'Word at cursor:' anyword
'INPUT' currpad||'This line is indented same as previous line'
exit

/* module-specific macro */
mylist: procedure
  list='onVotingTypeChanged votingTypeChangeRequest VotingType SelectedVotingTypeState'
  'MACRO chooser' list '--t Voting-Type'
  'REFRESH'
  return

::requires 'XEdit.x'
::requires 'XRoutines.x'
