#!/bin/bash

CONVERT_FLAGS="-quality 20% -rotate 90"

mkdir -p tmp/
dir=$(pwd)

cd /run/user/1000/gvfs/*/Phone/DCIM/Camera
cp $(date +%Y%m%d)* $dir/tmp/

cd "$dir"

MAX_BYTES=33554432 # 2^25
current_bytes=0

files=""

pdf_index=0
pdfs=""

make_pdf() {
	echo "CONVERT $files"
	convert $files $CONVERT_FLAGS "tmp/$pdf_index.pdf"

	pdfs="$pdfs tmp/$pdf_index.pdf"
	files=""
	current_bytes=0
	pdf_index=$(( pdf_index + 1 ))
}

for file in $(ls tmp/*.jpg | sort -V); do
	if [ ! -f "$file" ]; then
		continue;
	fi

	files="$files $file"
	bytes=$(stat --printf="%s" $file)
	current_bytes=$(( $current_bytes + $bytes ))

	(( $current_bytes >= $MAX_BYTES )) && make_pdf
done

[ -z "$files" ] || make_pdf

[ "$pdf_index" != "1" ] && {
	echo "COMBINE $pdfs"
	pdfunite $pdfs output.pdf
} || {
	echo "COPY $pdfs"
	mv tmp/0.pdf output.pdf
}

rm -rf tmp