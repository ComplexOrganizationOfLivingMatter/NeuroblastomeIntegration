find Data/ -name '*RET*.ndump2' | while read f; do cp -f "$f" "Results/RET/${f:9}"; done
find Data/ -name '*CD45*.ndump2' | while read f; do cp -f "$f" "Results/CD45/${f:9}"; done

find Data/ -name '*CD4*.ndump2' | while read f; do cp -f "$f" "Results/CD4/${f:9}"; done
find Data/ -name '*CD7*.ndump2' | while read f; do cp -f "$f" "Results/CD7/${f:9}"; done
find Data/ -name '*CD8*.ndump2' | while read f; do cp -f "$f" "Results/CD8/${f:9}"; done
find Data/ -name '*CD11b*.ndump2' | while read f; do cp -f "$f" "Results/CD11b/${f:9}"; done


find Data/ -name '*CD11c*.ndump2' | while read f; do cp -f "$f" "Results/CD11c/${f:9}"; done


find Data/ -name '*CD20*.ndump2' | while read f; do cp -f "$f" "Results/CD20/${f:9}"; done

find Data/ -name '*CD31*.ndump2' | while read f; do cp -f "$f" "Results/CD31/${f:9}"; done

find Data/ -name '*CD68*.ndump2' | while read f; do cp -f "$f" "Results/CD68/${f:9}"; done

find Data/ -name '*CD163*.ndump2' | while read f; do cp -f "$f" "Results/CD163/${f:9}"; done


find Data/ -name '*COL*.ndump2' | while read f; do cp -f "$f" "Results/COL/${f:9}"; done
find Data/ -name '*GAG*.ndump2' | while read f; do cp -f "$f" "Results/GAG/${f:9}"; done
find Data/ -name '*OCT4*.ndump2' | while read f; do cp -f "$f" "Results/OCT4/${f:9}"; done

find Data/ -name '*S100A6*.ndump2' | while read f; do cp -f "$f" "Results/S100A6/${f:9}"; done
