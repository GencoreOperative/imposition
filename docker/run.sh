# Test for page count, fail if missing

WORK=/tmp/work

# Copy the first PDF in /mount to working folder.
FILE=$(find /mount -iname "*.pdf" | head -n 1)
echo "Processing File: $FILE"
mkdir -p $WORK
cp $FILE $WORK

# Target file for processing
TARGET=$(find $WORK -iname "*.pdf" | head -n 1)

# Filename: /mount/test.pdf
# Title: Common Sense for the 21st Century_Download version
# Author:
# Subject:
# Keywords:
# Creator: Word
# Producer: macOS Version 10.14.5 (Build 18F132) Quartz PDFContext
# Created: Tue Jul 16 18:54:16 UTC 2019
# Page count: 79
# PDF version: 1.3
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
ls -las $WORK

# For 8 pages on one double sided sheet:
# "8,1,5u,4u,2,7,3u,6u"
# For 16 pages on two double sided sheets:
# "16,1,9u,8u,2,15,7u,10u,14,3,11u,6u,4,13,5u,12u"
find $WORK -iname "*-x*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
  -dim 2x2 -paper A4 -layout "16,1,9u,8u,2,15,7u,10u,14,3,11u,6u,4,13,5u,12u"
ls -las $WORK

cp $WORK/*-up.pdf /mount

# Then run impose tool to generate the imposition of those signatures

#java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 1-16 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test1.pdf
#java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 17-32 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test2.pdf
#java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 33-48 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test3.pdf
#java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 49-64 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test4.pdf