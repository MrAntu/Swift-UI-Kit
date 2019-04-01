#!/bin/bash

x=1
while [ $x -le 12 ]
do
  echo "Welcome $x times"
  x=$(( $x + 1 ))
  sleep 300
done
