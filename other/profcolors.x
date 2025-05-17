/* -----------------------------------------------------------------------------
   This will throw all combos of fore/background colors into the file
   by Gerry Janssen
   -----------------------------------------------------------------------------
*/
arg options
if abbrev('?', options, 1) then do
  data.1=' C = show color combos'
  data.2=' U = show profile colors unsorted'
  data.3=' default = show profile colors sorted'
  data.0=3
  call msgboxFromStem 'profcolors [options]', data.
  exit
end
'extract /flscreen'
'extract /cursor'

palette.1='Black'
palette.2='Blue'
palette.3='Brown'
palette.4='Cyan'
palette.5='Dark Grey'
palette.6='Green'
palette.7='Light Blue'
palette.8='Light Cyan'
palette.9='Light Green'
palette.10='Light Grey'
palette.11='Light Magenta'
palette.12='Light Red'
palette.13='Magenta'
palette.14='Red'
palette.15='White'
palette.16='Yellow'
palette.0=16

if options='C' then call colorCombos options
else if options='U' then call profileColorsNoSort
else call profileColorsSorted
exit

/* Write ALL color information to the current file. */
colorCombos:
do b=1 to palette.0
  bg=palette.b
  'input' '-'~copies(80)
  do f=1 to palette.0
    fg=palette.f
    'input' ' ' fg 'on' bg
     'linecolour 1 80' fg 'ON' bg
     -- 'linecolour 1 20' fg 'ON' bg '21 80' palette.2 'on' palette.15
  end f
end b
'input' '='~copies(80)
'topline' flscreen.1
'cursor' cursor.1 cursor.2
return

profileColorsNoSort: procedure
'EXTRACT /colours/'
'INPUT X2 Color Mapping'
'INPUT' '='~copies(80)
do c=1 to colours.0
  parse var colours.c xarea colorinfo
  'INPUT' c~right(2) xarea~left(30) colorinfo
  'LINECOLOUR 1 80' colorinfo
end c
return

profileColorsSorted: procedure
  'EXTRACT /colours/'
  do i=1 to COLOURS.0
    parse value COLOURS.i with zone fgbg
    scheme.zone=fgbg
  end i

  top_section='FILENAME MOD_FILENAME STATUS COMMAND COMMAND_STACK'
  main_section='DATA QUOTES BRACKETS COMMENT KEYWORDS MARK HIGHLIGHT CSR_LINE MESSAGE PFLINE'
  popups='WINDOW_TITLE WINDOW_DATA WINDOW_BOLD WINDOW_EMPHASIS PROMPT PROMPT_INPUT'
  'INPUT *** X2 Color Mapping ***'
  'INPUT Top Section'
  do w=1 to words(top_section)
    section=word(top_section,w)
    parse value scheme.section with fg ' ON ' bg
    'INPUT' left(section,30) left(fg, 15) 'on' bg
    'LINECOLOUR 1 80' scheme.section
  end w

  'INPUT'; 'INPUT Pop ups'
  do w=1 to words(popups)
    section=word(popups,w)
    parse value scheme.section with fg ' ON ' bg
    'INPUT' left(section,30) left(fg, 15) 'on' bg
    'LINECOLOUR 1 80' scheme.section
  end w

  'INPUT'; 'INPUT Main Section'
  do w=1 to words(main_section)
    section=word(main_section,w)
    parse value scheme.section with fg ' ON ' bg
    'INPUT' left(section,30) left(fg, 15) 'on' bg
    'LINECOLOUR 1 80' scheme.section
  end w
  return

::requires 'XPopups.x'
