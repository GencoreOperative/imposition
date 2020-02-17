#!/bin/bash

. /root/1-signatures.sh

# For 16 pages on four double sided sheets:
find $WORK -iname "*-x*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
  -dim 1x2 -paper A4 -layout "16r,1r,2r,15r,14r,3r,4r,13r,5r,12r,11r,6r,7r,10r,9r,8r"

cp $WORK/*-up.pdf /mount