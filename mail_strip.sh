for i in `grep -il 'Content-Type: text/html' *`; do echo "${i}"; perl ~/mail_strip.pl < "${i}" > "${i}.stripped" && mv "${i}.stripped" "${i}" ; done

