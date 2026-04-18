#!/bin/bash

set -e

# Display help information
show_help() {
    cat << 'HELPEOF' >&2
Signatures Docker - PDF Splitting Tool

DESCRIPTION:
  Splits a PDF into individual signatures from STDIN and outputs a ZIP file
  containing all signatures to STDOUT. A signature is a folded sheet containing
  multiple pages suitable for booklet binding.

USAGE:
  entrypoint.sh [OPTIONS] <signature_size>

ARGUMENTS:
  <signature_size> Number of pages per signature (must be multiple of 4)
                  Common values: 4, 8, 16, 32

OPTIONS:
  -h, --help       Display this help message and exit

STDIN/STDOUT:
  Reads a PDF file from standard input and writes a ZIP file containing
  individual signature PDFs to standard output. All messages go to stderr.

EXAMPLES:
  Split a PDF into 16-page signatures:
    cat mydocument.pdf | docker run --rm -i signatures:latest 16 > signatures.zip

  Using the wrapper script:
    ./signatures mydocument.pdf 16 > signatures.zip

REQUIREMENTS:
  - PDF data must be provided on STDIN
  - The input must be a valid PDF file
  - Signature size must be a positive integer multiple of 4

NOTES:
  - Each signature is output as a separate PDF file in the ZIP
  - Files are named based on their signature number (sig-001.pdf, sig-002.pdf, etc.)
  - All intermediate files are created in /tmp/work (temporary)
  - No volume mounts required - everything is piped via stdin/stdout

HELPEOF
}

# Check for help flag
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    if [ $# -eq 0 ]; then
        echo "Error: Signature size argument required" >&2
        show_help
        exit 1
    else
        show_help
        exit 0
    fi
fi

SIGNATURE_SIZE="$1"

# Validate signature size is a positive integer and multiple of 4
if ! [[ "$SIGNATURE_SIZE" =~ ^[0-9]+$ ]] || [ "$SIGNATURE_SIZE" -lt 1 ]; then
    echo "Error: Signature size must be a positive integer, got '$SIGNATURE_SIZE'" >&2
    exit 1
fi

if [ $((SIGNATURE_SIZE % 4)) -ne 0 ]; then
    echo "Error: Signature size must be a multiple of 4 (for A5 imposition), got '$SIGNATURE_SIZE'" >&2
    exit 1
fi

# Set up working directory
WORK=/tmp/work
rm -rf "$WORK"
mkdir -p "$WORK"

# Read PDF from STDIN and save to work directory
INPUT_PDF="$WORK/input.pdf"
cat > "$INPUT_PDF"

# Get page count from PDF
echo "Analyzing PDF..." >&2
COUNT=$(java -cp /root/multivalent.jar tool.pdf.Info "$INPUT_PDF" 2>&1 | grep "Page count:" | cut -d ' ' -f 3)
echo "Page Count: $COUNT" >&2

# Calculate number of signatures needed using pure bash arithmetic
# Ceiling division: (COUNT + SIGNATURE_SIZE - 1) / SIGNATURE_SIZE
NUM_SIGNATURES=$(( (COUNT + SIGNATURE_SIZE - 1) / SIGNATURE_SIZE ))
echo "Splitting into $NUM_SIGNATURES signatures of $SIGNATURE_SIZE pages each" >&2

# Display page ranges for each signature
for ((i=1; i<=NUM_SIGNATURES; i++)); do
    START_PAGE=$(( (i - 1) * SIGNATURE_SIZE + 1 ))
    END_PAGE=$(( i * SIGNATURE_SIZE ))
    if [ $END_PAGE -gt $COUNT ]; then
        END_PAGE=$COUNT
    fi
    PAGE_COUNT=$(( END_PAGE - START_PAGE + 1 ))
    echo "  Signature $i: pages $START_PAGE-$END_PAGE ($PAGE_COUNT pages)" >&2
done

# Split PDF into signatures
echo "Splitting PDF..." >&2
java -cp /root/multivalent.jar tool.pdf.Split -page "1-last/$SIGNATURE_SIZE" "$INPUT_PDF" >&2

# Find all split PDF files, sort them, and rename sequentially into ZIP
echo "Creating ZIP archive..." >&2
COUNTER=1
for PDF in $(find "$WORK" -maxdepth 1 -type f -name "*.pdf" ! -name "input.pdf" | sort); do
    PADDED=$(printf "%03d" $COUNTER)
    mv "$PDF" "$WORK/sig-$PADDED.pdf"
    COUNTER=$((COUNTER + 1))
done

# Create ZIP file with all signatures
cd "$WORK"
zip -q signatures.zip sig-*.pdf

# Output ZIP to STDOUT
cat signatures.zip
echo "" >&2
echo "Created ZIP with $((COUNTER - 1)) signature files" >&2
echo "Processing complete!" >&2

# Cleanup
rm -rf "$WORK"
