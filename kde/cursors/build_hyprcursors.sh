#!/bin/bash

generate_cursor() {
	local rawsvg="$1"
	local cursor="$2"
	local dir="$3"

	if [ "$dir/$cursor.svg" -ot $rawsvg ] ; then
		inkscape -i $cursor $rawsvg --export-filename="$dir/$cursor.svg" > /dev/null
	fi
}

generate_animated_cursor() {
	local rawsvg="$1"
	local cursor="$2"
	local dir="$3"

	rm "$dir/$cursor/$cursor.svg"
	for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
	do
		generate_cursor $rawsvg $cursor-$i $dir/$cursor
	done
}

cd "$( dirname "${BASH_SOURCE[0]}" )"
RAWSVG="src/cursors.svg"
INDEX="src/index.theme"
ALIASES="src/cursorList"


echo -ne "Checking Requirements...\\r"
if [ ! -f $RAWSVG ] ; then
	echo -e "\\nFAIL: '$RAWSVG' missing in /src"
	exit 1
fi

if [ ! -f $INDEX ] ; then
	echo -e "\\nFAIL: '$INDEX' missing in /src"
	exit 1
fi

if  ! type "inkscape" > /dev/null ; then
	echo -e "\\nFAIL: inkscape must be installed"
	exit 1
fi

echo -e "Checking Requirements... DONE"

DIR="build_hyprcursors/hyprcursors"

echo -e "\033[0KGenerating simple cursor pixmaps..."
for CUR in src/config/*.cursor; do
	BASENAME=$CUR
	BASENAME=${BASENAME##*/}
	BASENAME=${BASENAME%.*}

	generate_cursor $RAWSVG $BASENAME $DIR/$BASENAME
done
echo -e "\033[0KGenerating simple cursor pixmaps... DONE"

echo -ne "\033[0KGenerating animated cursor pixmaps..."
generate_animated_cursor $RAWSVG progress $DIR
generate_animated_cursor $RAWSVG wait $DIR
echo -e "\033[0KGenerating animated cursor pixmaps... DONE"

echo -ne "\033[0KGenerating hyprcursors..."
cd build_hyprcursors/
hyprcursor-util -c .
echo -ne "\033[0KGenerating hyprcursors... DONE"

echo "COMPLETE!"
