/* infile - Find instances of a string in the current file and provide a popup.*/
parse arg searchtype options
if abbrev('?', searchtype) then do
  call msgbox 'infile - Search current file for a string', 'infile [at(S)tart | (B)etween] /beginExpr/endExpr/name-of-search'
  exit
end
'EXTRACT /LINETEXT/'
parse var options delim +1 beginExpr (delim) endExpr (delim) options
if options='' then popupLabel='Search Results'
else               popupLabel=options

select
  when translate(searchtype)='B' then do
    found=findBetween(beginExpr, endExpr)
    if found~items=0 then 'MSG Found 0 items'
    else do
      choice=pickFromArray(found~makearray~sort, popupLabel)
      if choice<>'' then 'KEYIN' choice
    end
  end
  when translate(searchtype)='S' then do
    found=findAtStart(beginExpr)
    if found~items=0 then 'MSG Found 0 items'
    else do
      parse var endExpr delim fieldIndex pattern
      if delim='' then delim=':'
      if \datatype(fieldIndex,'W') then fieldIndex=1
      choice=pickFromArrayDual(found~makearray~sort, popupLabel, fieldIndex, delim)
      if choice<>'' then do
        'KEYIN' merge(choice, pattern)
      end
    end
  end
  otherwise
    'MSG Please specify as search type one of: B, S'
    exit
end
exit

findBetween: procedure expose LINETEXT.
  parse arg before, after
  subset=.set~new
  if (before='' & after='') then return subset
  do i=1 to LINETEXT.0
    curr=LINETEXT.i
    if curr='' then iterate
    else if pos(before, curr)=0 then iterate
    do until curr=''
      parse var curr leading (before) between (after) curr
      do w=1 to words(between)
        subset~put(word(between,w))
      end w
    end
  end i
  return subset

findAtStart: procedure expose LINETEXT.
  parse arg prefix
  subset=.set~new
  if prefix='' then return subset
  do i=1 to LINETEXT.0
    curr=strip(LINETEXT.i)
    if abbrev(curr, prefix) then subset~put(curr)
  end i
  return subset

::requires 'XPopups.x'
