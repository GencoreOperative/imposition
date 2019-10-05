#!/bin/bash

. /root/1-signatures.sh

# For 16 pages on two double sided sheets:
find $WORK -iname "*-x*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
  -dim 2x2 -paper A4 -layout "16,1,9u,8u,2,15,7u,10u,14,3,11u,6u,4,13,5u,12u"

cp $WORK/*-up.pdf /mount