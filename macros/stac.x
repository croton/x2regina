/* stac - A stack for X2 */
parse arg input
if input='' then do
  'MSG Items on queue' queued()
end
else if input='get' then do
  parse pull item
  'MSG Pulled item' item queued() 'items left in queue'
  if datatype(item,'W') then 'CURSOR' item
end
else do
  push input
  'MSG Item' input 'pushed on queue'
end
exit
