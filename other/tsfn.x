/* Call TS/Angular dialogs */
arg option
select
  when option='D' then 'MACRO fnpick ngdir ng-@=""'
  when option='F' then 'MACRO fnpick ngfn angular.@();'
  when option='M' then 'MACRO chooser flex layout layout-align --t ngMaterial --p @=""'
  when option='S' then 'MACRO chooser up down left right enter --t Actions --p private m_@StateId: string;'
  when option='T' then 'MACRO chooser button md-dialog md-dialog-content md-dialog-actions --t ngTags --p ~@'
  otherwise
    'MSG ng [D | F | M | T]'
end
exit
