for i in `grep -l 'Content-Type: text/html' *`; do echo "${i}"; sed -i '$!N;/^--Apple-Mail-.*Content-Type: *text.html/,/^--Apple-Mail-/d' "${i}" ; done

