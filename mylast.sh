#!/bin/bash

# variabile pentru setari de baza
limita=0
mod="last"
# fisierele unde sistemul tine logurile de autentificare
fisiere_log="/var/log/auth.log /var/log/auth.log.1"

# procesam argumentele primite din linia de comanda
# cat timp mai avem parametri, ii verificam pe rand
while [ "$#" -gt 0 ]; do
    case "$1" in
        -n)
            # daca gasim -n, luam numarul de linii din urmatorul argument
            limita=$2
            shift 2
            ;;
        lastb)
            # daca utilizatorul vrea logari esuate
            mod="lastb"
            shift
            ;;
        last)
            # daca vrea logari reusite (default)
            mod="last"
            shift
            ;;
        *)
            # restul parametrilor care nu ne intereseaza
            shift
            ;;
    esac
done

# definim ce cautam in fisiere in functie de modul ales
if [ "$mod" == "last" ]; then
    # cautam randurile cu Accepted sau session opened pentru last
    tipar="session opened|Accepted password"
else
    # cautam Failed sau auth failure pentru lastb
    tipar="Failed password|authentication failure"
fi

# afisam un cap de tabel simplu pentru aspect
echo "utilizator | terminal | data si ora"
echo "--------------------------------------"

# folosim zgrep pentru a citi si fisierele arhivate .gz
# sortam cu -r ca sa avem cele mai noi logari la inceput
date_brute=$(zgrep -E "$tipar" $fisiere_log 2>/dev/null | sort -r)

# daca am pus o limita cu -n, taiem output-ul cu head
if [ "$limita" -gt 0 ]; then
    final=$(echo "$date_brute" | head -n "$limita")
else
    final="$date_brute"
fi

# folosim awk pentru a extrage coloanele exacte: user si data/ora
echo "$final" | awk '{print $9, "\t", $2, $1, $3}'
