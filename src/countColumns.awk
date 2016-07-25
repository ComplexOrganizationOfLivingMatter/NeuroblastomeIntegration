{
  #http://www.unix.com/shell-programming-and-scripting/104692-awk-sum-columns.html
#Call it this way: awk -f countColumns.awk file.ndump2
  for(i=1; i<=NF; i++)
    sum[i] +=$i
}
END {
  for(i=1; i in sum; i++)
    printf("%s%s", sum[i], (i+1 in sum) ? OFS : ORS)
}