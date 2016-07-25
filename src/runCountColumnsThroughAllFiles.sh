#usr/bin/sh

ls '../../Results/graphletsCount/Casos/1/' | grep .ndump2 | while read f; do echo "$f"; awk -f countColumns.awk "../../Results/graphletsCount/Casos/1/$f" > "../../Results/graphletsCount/Casos/1/$f.sumGraphlets" ; done