#!/bin/bash

. /root/1-signatures.sh

# For 16 pages on four double sided sheets:
find $WORK -iname "*-x*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
  -dim 1x2 -paper A4 -layout "16r,1r,2r,15r,14r,3r,4r,13r,12r,5r,6r,11r,10r,7r,8r,9r"

cp $WORK/*-up.pdf /mount