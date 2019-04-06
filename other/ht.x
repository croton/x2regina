/* Quick pick menu for HTML tags */
arg option
list='address article aside footer header hgroup main nav section figure figcaption blockquote'
if option='' then 'MACRO qp' list
else              'MACRO chooser' list '--t HTML'
