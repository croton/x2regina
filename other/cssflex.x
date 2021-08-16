/* cssflex - Look up a CSS flex attribute on the current line and pop up list of possible values.
   Lookups of attribute names support abbreviations and shortcuts. For example,
     flex-dir ... matches "flex-direction"
     flex-d ..... matches "flex-direction"
     d .......... matches "flex-direction"
*/
parse arg name
if name='?' then do; 'MSG cssflex supports shortcuts: a b c d f g i j l o s w'; exit; end

name=wordBeforeCursor()
if name='' then
  'MSG No attribute on current line!'
else
  call lookupAttribValues name
exit

lookupAttribValues: procedure
  parse arg key
  attribs=loadAttribs()
  attribName=lookupByShortCut(key)
  if attribName='' then do
    if attribs[key]=.NIL then do
      parse value searchByAbbrev(attribs, key) with att values
      if att='' then do; call xsay 'No such css attribute:' key; return; end
      else do
        choice=popup(att, values)
        if choice='' then call xsay 'No choice made.'
        else do
          'CURSOR DATA'
          'PREVIOUS_WORD'
          'DELWORD'            -- remove abbreviation
          'KEYIN' att':' choice';'
        end
      end
    end
    else do
      choice=popup(key, attribs[key])
      if choice='' then call xsay 'No choice made.'
      else              'KEYIN :' choice';'
    end
  end
  else do
    choice=popup(attribName, attribs[attribName])
    if choice='' then call xsay 'No choice made.'
    else do
      'CURSOR DATA'
      'PREVIOUS_WORD'
      'DELWORD'            -- remove abbreviation
      'KEYIN' attribName':' choice';'
    end
  end
  return

lookupByShortCut: procedure
  parse arg key
  select
    when key='d' then return 'flex-direction'
    when key='w' then return 'flex-wrap'
    when key='l' then return 'flex-flow'
    when key='j' then return 'justify-content'
    when key='i' then return 'align-items'
    when key='c' then return 'align-content'
    when key='o' then return 'order'
    when key='g' then return 'flex-grow'
    when key='s' then return 'flex-shrink'
    when key='b' then return 'flex-basis'
    when key='f' then return 'flex'
    when key='a' then return 'align-self'
    otherwise nop
  end
  return ''

-- Search a collection by an abbreviated key, returning first match
searchByAbbrev: procedure
  use arg collection, key
  name=''
  values=''
  sup=collection~supplier
  do while sup~available
    if abbrev(sup~index, key) then do
      name=sup~index
      values=sup~item
      leave
    end
    sup~NEXT
  end
  return name values

/* Present a list selection dialog */
popup: procedure
  parse arg name, values
  choices.0=0
  if values='' then list='initial;inherit'
  else              list=values';initial;inherit'
  do i=1 until list=''
    parse var list item ';' list
    choices.i=item
  end i
  choices.0=i
  return pick(choices., name)

loadAttribs: procedure
  dir=.Directory~new
  dir['flex-direction']='row;column;row-reverse;column-reverse'
  dir['flex-wrap']='wrap;nowrap;wrap-reverse'
  dir['justify-content']='flex-start;flex-end;center;stretch;space-between;space-around;space-evenly'
  dir['align-items']='flex-start;center;flex-end;baseline;stretch'
  dir['align-content']='flex-start;flex-end;center;space-between;space-around;stretch'
  dir['align-self']='flex-start;center;flex-end;baseline;stretch'
  dir['order']='1'
  dir['flex']='1 1 2em'
  dir['flex-flow']='row wrap'
  dir['flex-grow']='1'
  dir['flex-shrink']='1'
  dir['flex-basis']='0;50%;100px'
  return dir

::requires 'XPopups.x'
::requires 'XEdit.x'
