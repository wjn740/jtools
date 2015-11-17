#!/bin/bash
set -eu

awk '
BEGIN{
print "<html>"
print "<body>"
print "<head>"
print "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"/>"
print "<title>"$page_title"</title>"
print "</head>"
print "<pre class=\"western\">"
}
{
    for(i=1;i<=NF;i++){
        if ($i ~ /http/){
            $i="<a href=\042"$i"\042>"$i"</a>"
        }
        if ($i ~ /PASSED/){
            $i="<font color=\"#99ff66\">""PASSED""</font>"
        }
        if ($i ~ /FAILED/){
            $i="<font color=\"#ff3333\">""FAILED""</font>"
        }
    }
} 1
END{
print "</pre>"
print "</body>"
print "</html>"
}' $1

##
#        if ($i ~ /PASSED/){
#            $i="<font color="#99ff66">$i</font>"
#        }
#        if ($i ~ /FAILED/){
#            $i="<font color="#ff3333">$i</font>"
#        }
