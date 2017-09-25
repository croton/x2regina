/* -------------------------------------------------------------------
   Underline the current line of text
   Usage: underl [n]   where n is in {0..4} & defaults to 1
                      n corresponds to the idea of a heading level
   -------------------------------------------------------------------
*/
arg option .
if \datatype(option,"W") then option = 1
else if option > 4 then option = 4
else if option < 0 then option = 1  /* option is now 0 1 2 3 or 4 */
char = word("= - "" ' .",option + 1)   /* choose a underline char */
'extract /curline/'                    /* read the current line   */
? = VERIFY(curline.1," ")              /* find first non-blank    */
'input' copies(" ",?-1)""copies(char,length(curline.1)-?+1)
'down 2'                        /* move down past the underlining */
exit
