#!/bin/bash

if [ -z "$1" ]; then
  echo "No directory supplied"
  exit 1
fi

CUR_DIR=$(pwd)
cd $1

rm -r *
mkdir downloads
mkdir zipfiles

for d in 0 1 2 3 4 5 6 7 8 9 a b c d e f
do
  mkdir -p originals/$d
  mkdir -p thumbnails/$d
done

cd $CUR_DIR
echo "flushed"
