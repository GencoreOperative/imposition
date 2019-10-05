#!/bin/bash

. /root/1-signatures.sh

# For 16 pages on four double sided sheets:
find $WORK -iname "*-x*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
  -dim 1x2 -paper A4 -layout "16r,1r,15l,2l,14r,3r,13l,4l,12r,5r,11l,6l,10r,7r,9l,8l"

cp $WORK/*-up.pdf /mount