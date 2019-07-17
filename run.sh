# java -cp multivalent.jar tool.pdf.Info /mount/test.pdf

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

java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 1-16 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test1.pdf
java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 17-32 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test2.pdf
java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 33-48 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test3.pdf
java -cp /root/multivalent.jar tool.pdf.Impose -verbose -dim 2x2 -paper A4 -range 49-64 -layout "8,1,5u,4u,2,7,3u,6u" /mount/test.pdf --outfile /mount/test4.pdf