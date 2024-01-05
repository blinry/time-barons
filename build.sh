#!/usr/bin/env bash

set -eu -o pipefail

# Dimensions of the source images in the published PDFs.
CONTENT_WIDTH=749 # px
CONTENT_HEIGHT=1049 # px

# Dimensions of the printed cards, with 3 mm bleed on each side.
CARD_WIDTH_MM=69 # mm
CARD_HEIGHT_MM=94 # mm

# Desired margin around the content on the printed cards.
# A margin of 2.25 mm means that the content will overhang by 0.75 mm on each side.
SIDE_MARGIN_MM=2.25 # mm

# Calculate margins in pixels.
SIDE_MARGIN=$(printf "%.0f" "$(bc -l <<< "$CONTENT_WIDTH*$SIDE_MARGIN_MM/$CARD_WIDTH_MM")") # px
CARD_WIDTH=$(bc -l <<< "$CONTENT_WIDTH+2*$SIDE_MARGIN") # px
CARD_HEIGHT=$(bc -l <<< "$CARD_WIDTH*$CARD_HEIGHT_MM/$CARD_WIDTH_MM") # px
TOP_MARGIN=$(printf "%.0f" "$(bc -l <<< "($CARD_HEIGHT-$CONTENT_HEIGHT)/2")") # px

# Crop cards from the source PDFs, add margins, and combine into a single PDF.
# When processing the back side, we need to flip the image horizontally, crop, and flip back.
convert -density 300 "core_set.pdf[0,2,4,6,8,10]" "expansion_set.pdf[0,2,4,6,8,10]" "multiplayer.pdf[0]" -crop +150+75 -crop -149-74 -crop 3x3-1-1@ +repage -bordercolor black -border "$SIDE_MARGIN"x"$TOP_MARGIN" front.pdf
convert -density 300 "core_set.pdf[1,3,5,7,9,11]" "expansion_set.pdf[1,3,5,7,9,11]" "multiplayer.pdf[1]" -crop +150+75 -crop -149-74 -flop -crop 3x3-1-1@ +repage -flop -bordercolor black -border "$SIDE_MARGIN"x"$TOP_MARGIN" back.pdf
