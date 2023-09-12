/* debug -- Helper to display debug info */
parse arg name params
if name='' then do; 'MSG debug macroname [params]'; exit; end
ADDRESS X 'MACRO' name params '>.\debugx.log'
exit
