/* -----------------------------------------------------------------------------
   Display the results of a DIR command in a file.  Each line contains a
   file which can be opened with the Ctrl-P key.
   Written by B. Thompson, February 21, 1994
   -----------------------------------------------------------------------------
*/
parse arg dirinfo
tempfile = 'temp.DIR'
/* Remove unwanted stats lines, which happen to begin with a space  */
ADDRESS CMD 'dir' dirinfo '|grep -ve "^[ ]">'tempfile

'EDIT .DIR'
'TOP'
'DELETE *'                  -- Make sure we start clean
'GET' tempfile
'ALT 0 0'                   -- Allow user to quit

ADDRESS CMD 'del' tempfile  -- Cleanup
exit
