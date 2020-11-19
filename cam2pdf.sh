#!/bin/bash

mkdir -p tmp/
dir=$(pwd)

cd /run/user/1000/gvfs/*/Phone/DCIM/Camera
cp $(date +%Y%m%d)* $dir/tmp/

cd "$dir"

convert tmp/* -quality 20% -rotate 90 output.pdf

rm -rf tmp