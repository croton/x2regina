/* cssattrib - Provide a popup of options for a given attribute. */
parse arg name
if name='-?' then do; 'MSG cssattrib name'; exit; end

call lookupAttrib
exit

lookupAttrib: procedure
  key=wordBeforeCursor()
  if key='' then 'MSG No attribute on current line!'
  else do
    attribs=loadAttribs()
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
  return

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
  dir['font-family']='Georgia;Palatino Linotype;Book Antiqua;Times New Roman;Arial;Helvetica;Arial Black;Impact;Lucida Sans Unicode;Tahoma;Verdana;Lucida Console;Courier New'
  dir['font-style']='normal;italic;oblique'
  dir['font-variant']='normal;small-caps'
  dir['font-weight']='normal;bold;bolder;lighter;700'
  dir['font-size']='medium;xx-small;x-small;small;large;x-large;xx-large;smaller;larger;10px;100%'
  dir['background-color']=''
  dir['background-image']=''
  dir['flex-direction']='row;column;row-reverse;column-reverse'
  dir['flex-wrap']='wrap;nowrap;wrap-reverse'
  dir['justify-content']='flex-start;flex-end;center;space-between;space-around;space-evenly'
  dir['align-items']='flex-start;center;flex-end;baseline;stretch'
  dir['align-content']='flex-start flex-end center space-between space-around stretch'
  dir['align-self']='flex-start;center;flex-end;baseline;stretch'
  return dir

::requires 'XEdit.x'
::requires 'XRoutines.x'
