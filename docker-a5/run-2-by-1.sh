#!/bin/bash -xv

. /root/0-copy.sh

SIGNATURES=$1
if [ -z "$SIGNATURES" ]; then
	SIGNATURES=16
fi
echo "Signatures Size: $SIGNATURES"

# Generate Signatures String
SIG_STRING=$(java -jar /root/sequence-generator-0.1.jar $SIGNATURES)

# For 16 pages on four double sided sheets:
find $WORK -iname "*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
  -dim 1x2 -paper A4 -layout "$SIG_STRING"

cp $WORK/*-up.pdf /mount