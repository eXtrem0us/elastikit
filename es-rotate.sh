#!/bin/bash

baseaddr="$(realpath $0)"
basepath="$(dirname $baseaddr)"
confdir="$basepath/conf"

redcolor="$(tput setaf 1)"
greencolor="$(tput setaf 2)"
browncolor="$(tput setaf 3)"
bluecolor="$(tput setaf 4)"
cyancolor="$(tput setaf 14)"
resetcolor="$(tput sgr0)"

#Only if the index pattern is set in the purge list
cat "$confdir/es-rotate-purge.conf" | cut -d, -f1 | while read -r prefix
do
    datelessindices=( $(escurl /_cat/indices/$prefix*|awk '{print $3}'|cut -d'_' -f1|sort|uniq) )
    echo "======$prefix======"
    for datelessindex in ${datelessindices[@]}
    do
        #Checks the policy, if it is Keep
        echo -n "${cyancolor}$datelessindex${resetcolor}:::"
        if grep "$datelessindex" "$confdir/es-rotate-keep.conf" > /dev/null
        then
            retention=$(grep "$datelessindex" "$confdir/es-rotate-keep.conf"|cut -d, -f2)
            echo "Retention::${cyancolor}$retention ${resetcolor}Policy::${greencolor}KEEP"
        #Otherwise the policy is Purge
        else
            retention=$(grep "$prefix" "$confdir/es-rotate-purge.conf"|cut -d, -f2)
            echo "Retention::${cyancolor}$retention ${resetcolor}Policy::${redcolor}PURGE"
        fi
        selectedindices=( $(escurl /_cat/indices/$datelessindex*|awk '{print $3}'|sort|uniq) )
        if [ "${#selectedindices[@]}" -gt "${retention}" ]
        then
            selectedindicestodelete=${selectedindices[@]::$(( ${#selectedindices[@]}-${retention} ))}
            #echo "${resetcolor}${selectedindices[@]}"
            echo "${resetcolor}Candidates to DELETE: ${browncolor}${selectedindicestodelete[@]}"
            for candidateindex in ${selectedindicestodelete[@]}
            do
                esdelete $candidateindex
            done
        else
            echo "${bluecolor}No candidates to DELETE!"
        fi
        echo "${resetcolor}"
    done
done
