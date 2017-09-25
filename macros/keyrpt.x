/* -----------------------------------------------------------------------------
   KEYRPT.X
   Get keys from the user and output the key name and current setting.
   Written by Blair Thompson, November 8, 2000
   Make use of messagebox stem variable in 2.01.1, January 9, 2001
   -----------------------------------------------------------------------------
*/
  'EXTRACT /ESCAPE/'
  nl = escape.1'N'                               -- Newline escape sequence
  'EDIT testkey.rpt'
  'BOTTOM'
  do 30
    msg = 'X2 Editor Key Tester Utility' || nl || nl
    msg = msg' Use this program to determine the key name for any ' || nl
    msg = msg' key on your keyboard.  You can then configure it in ' || nl
    msg = msg' the profile to whatever function you desire. ' || nl || nl
    msg = msg' Press any key *except* Ctrl-C, or Escape to end'
    'messagebox' msg ||nl 'rc' rc 'result' result
    if rc <> 0 then leave
    if messagebox.1<>'/' then 'EXTRACT /key' messagebox.1'/'
    else                      'EXTRACT +key' messagebox.1'+'
    if key.1 = 0 then key.1 = 'undefined'
    'INPUT key name='Left(messagebox.1,12) 'function='key.1
    if result='1b'x | result='ESCAPE' then leave    -- Escape key
  end                                               -- End
exit
