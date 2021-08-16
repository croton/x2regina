/* initcss -- CSS profile startup macro. */
arg stage
select
  when stage='START' then call go
  when stage='END' then call stop
  otherwise
  'MESSAGEBOX Macro initcss, step=['stage']'
end
exit

/* Steps to perform BEFORE an edit session. */
go: procedure
  parse arg options
  call loadColors 'colors'
  call loadAttribs 'cssattribs'
  return

/* Steps to perform AFTER an edit session. */
stop: procedure
  parse arg options
  call unload 'colors'
  call unload 'cssattribs'
  return

loadColors: procedure
  parse arg key
  colorsfile=value('X2HOME',,'ENVIRONMENT')'\lists\imgk-colors.xfn'
  if \SysFileExists(colorsfile) then return 0
  inp=.Stream~new(colorsfile)
  if inp=.nil then colors=.array~of('white rgb(255,255,255) #FFFFFF', 'black rgb(0,0,0) #000000')
  else             colors=inp~arrayin
  inp~close
  .environment[key]=colors
  return 1

loadAttribs: procedure
  parse arg key
  colors='#ffffff;rgb(255,255,128);rgba(5,5,5,.5);hsl(50,33%,25%);hsla(50,33%,25%,.75);transparent'
  spacing='normal;0px'
  valpct='10px;10%;auto'
  marpad='Tpx Rpx;Tpx Rpx Bpx;Tpx Rpx Bpx Lpx;'valpct
  wids='thin;medium;thick;10px'
  bords='width style color'
  imgs='url();none'
  dir=.Directory~new
  dir['font']='style variant weight size family'
  dir['font-family']='Georgia;Palatino Linotype;Book Antiqua;Times New Roman;Arial;Helvetica;Arial Black;Impact;Lucida Sans Unicode;Tahoma;Verdana;Lucida Console;Courier New'
  dir['font-style']='normal;italic;oblique'
  dir['font-variant']='normal;small-caps'
  dir['font-weight']='normal;bold;bolder;lighter;700'
  dir['font-size']='medium;xx-small;x-small;small;large;x-large;xx-large;smaller;larger;10px;100%'
  dir['background-color']=colors
  dir['background-image']=imgs
  dir['background-repeat']='repeat;repeat-x;repeat-y;no-repeat'
  dir['background-attachment']='scroll;fixed;local'
  dir['background-position']='50% 50%;0px 0px;left top;left center;left bottom;right top;right center;right bottom;center top;center center;center bottom'
  dir['background']='color;image;repeat;attachment;position'
  dir['box-sizing']='content-box;padding-box;border-box'
  dir['color']=colors
  dir['word-spacing']=spacing
  dir['white-space']='normal;nowrap;pre;pre-line;pre-wrap'
  dir['letter-spacing']=spacing
  dir['text-decoration']='none;underline;overline;line-through'
  dir['vertical-align']='baseline;10px;10%;sub;super;top;text-top;middle;bottom;text-bottom'
  dir['text-shadow']='10px 10px 10px blue'
  dir['text-transform']='none;capitalize;uppercase;lowercase'
  dir['text-align']='left;right;center;justify'
  dir['text-indent']='10px;10%'
  dir['line-height']='normal;2;10px;100%'
  dir['margin-top']=valpct
  dir['margin-right']=valpct
  dir['margin-bottom']=valpct
  dir['margin-left']=valpct
  dir['margin']=marpad
  dir['padding-top']=valpct
  dir['padding-right']=valpct
  dir['padding-bottom']=valpct
  dir['padding-left']=valpct
  dir['padding']=marpad
  dir['border-top-width']=wids
  dir['border-right-width']=wids
  dir['border-bottom-width']=wids
  dir['border-left-width']=wids
  dir['border-width']=wids
  dir['border-color']=colors
  dir['border-style']='none;hidden;dotted;dashed;solid;double;groove;ridge;inset;outset'
  dir['border-top']=bords
  dir['border-right']=bords
  dir['border-bottom']=bords
  dir['border-left']=bords
  dir['border']=bords
  dir['width']=valpct
  dir['height']=valpct
  dir['float']='none;left;right'
  dir['clear']='none;left;right;both'
  dir['clip']='rect(Tpx Rpx Bpx Lpx);auto'
  dir['display']='inline;block;flex;grid;inline-block;inline-flex;inline-table;list-item;run-in;table;table-caption;table-column-group;table-header-group;table-footer-group;table-row-group;table-cell;table-column;table-row;none'
  dir['list-style-type']='disc;circle;square;none;decimal;decimal-leading-zero;lower-alpha;upper-alpha'
  dir['list-style-image']=imgs
  dir['list-style-position']='inside;outside'
  dir['list-style']='type position image'
  .environment[key]=dir
  return 1

unload: procedure
  parse arg key
  dir=.environment[key]
  if dir<>.NIL then do
    drop dir
    .environment[key]=.NIL
  end
  return

showEnv: procedure
  'EDIT initcss_temp.txt'
  'INPUT REXX Environment:'
  loop i over .environment
    'INPUT' i '=' .environment[i]
  end i
  return

error:
dashes=copies('=', 40)
say dashes
say 'Error' rc 'at line' sigl
-- say 'Instruction:' sourceline(sigl)
say dashes
return

