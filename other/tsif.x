/* Create an if statement around the current line of code. */
  'CURSOR DATA'
  'INSMODE ON'
  'CURSOR UP'
  'KEYIN if'
  'CURSOR COL1'
  'CURSOR DOWN'
  'COPYLINE'
  'CURSOR NEXTLINE'
  'KEYIN else'
  do 2
    'CURSOR COL1'
  end
  'KEYIN   '  -- indent clause 1
  'CURSOR COL1'
  do 2
    'CURSOR DOWN'
  end
  'KEYIN   '  -- indent clause 2
  do 4
    'CURSOR COL1'
  end
  'CURSOR EOL'  -- leave cursor at end of "if"
exit
