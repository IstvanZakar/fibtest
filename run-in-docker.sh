#!/bin/bash    
CONTAINER_NAME=pedantic_goldberg
CPU_LIMITS=('1' '0.5' '0.25' '0.125' '0.0625')
for CPU in "${CPU_LIMITS[@]}"
do
  docker update $CONTAINER_NAME --cpus=$CPU >/dev/null
  for (( total=28; total>=1; total/=2 ))
  do  
    for (( c=1; c<=5; c++ ))
    do  
      iter=$(docker exec pedantic_goldberg /test/a.out -s 10 -f $total -t $total  | awk '{print $3}')
      echo "$total $total $CPU $iter"
      if [ $total -gt 1 ]; then
        iter=$(docker exec pedantic_goldberg /test/a.out -s 10 -f 1 -t $total  | awk '{print $3}')
        echo "1 $total $CPU $iter"
      fi
    done
  done
done
