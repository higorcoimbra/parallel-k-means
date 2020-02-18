printf '%b %b\n' `cat $1 | cut -d$' '  -f1,2` > $2
