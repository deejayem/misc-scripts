#for i in `grep -l 'Content-Type: text/html' *`; do echo "${i}"; sed -i '$!N;/^--*.*Part.*Content-Type: *text.html/,/^--*.*Part/d' "${i}" ; done
for i in `grep -il 'Content-Type: text/html' *`; do echo "${i}"; sed -i '$!N;$!N;/^--.*Content-Type: *text.html/I,/^--/d' "${i}" ; done
