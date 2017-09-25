/* --------------------------------------------------------------
 | Copy down -- fill a block mark with the top line of the mark
 | Toby Thurston - 28 Aug 1997
  --------------------------------------------------------------- */
'EXTRACT /mark/'                       -- get the mark (if any)
select                                 -- check mark is ok
  when mark.0 = 0 then "msg Nothing marked!"
  when mark.6 = 0 then "msg Mark exists off screen in" mark.1
  when mark.4 = 0 then "msg Block mark needed, not a line mark."
  when mark.2 = mark.3 then "msg Extend the mark down..."
otherwise                              -- mark is ok now
  'EXTRACT /cursor/'                   -- remember where we were
  'EXTRACT /line' mark.2'/'            -- get the line
  s=substr(line.1,mark.4,mark.5-mark.4+1)  -- get the substring
  'CURSOR begmark'                     -- move to top left of mark
  'INSMODE off'                        -- overwrite not insert
  s=translate(s,'01'x," ")             -- preserve leading blanks
  do mark.3-mark.2                     -- for lines 2..n of mark
    'CURSOR +1' mark.4                 -- move down & stay left
    'EXTRACT /curline/'
    if curline.2                       -- not hidden
      then 'keyin' s                   -- insert the substring
  end
  'CURSOR begmark'                     -- cursor to top of mark
  'c/' || '01'x || '/ /m*'             -- put spaces back
  'CURSOR' cursor.1 cursor.2           -- put the cursor back
  'MSG'                                -- remove the changed msg
end
'REFRESH'                              -- dismiss the cmd line
'INSMODE on'                           -- overwrite not insert
exit
