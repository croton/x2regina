/* Navigate home for TS files */
'EXTRACT /EXT/'
if EXT.1='TS' then do
  'LOCATE /export /f'
  'FIND RESTORE'
  if rc<>0 then do
    'TOP'
    'CURSOR COL1'
  end
end
else 'MACRO nav'
