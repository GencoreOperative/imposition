#!/bin/bash

. /root/0-copy.sh

COUNT=$(java -cp /root/multivalent.jar tool.pdf.Info $TARGET | grep "Page count:" | cut -d ' ' -f 3)
echo "Page Count: $COUNT"

# Calculate the number of signatures we need
# Maths in bash should not be this hard...
SIG_MOD=$(bc <<< "scale=1; $COUNT%16")
if [[ $SIG_MOD == "0" ]]; then
	SIGNATURES=$(bc <<< "$COUNT/16")
else
	A=$(echo "$COUNT + 1" | bc)
	SIGNATURES=$(echo "$A / 16" | bc)
fi
echo "Signatures: $SIGNATURES"

# Then run the split tool to split the PDF into signatures
java -cp /root/multivalent.jar tool.pdf.Split -page "1-last/16" $TARGET