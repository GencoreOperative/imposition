#!/bin/bash

set -e

# Display help information
show_help() {
    cat << 'HELPEOF' >&2
Imposition Docker - PDF Processing Tool

DESCRIPTION:
  Processes a PDF from STDIN by splitting it into signatures and imposing them
  in a 1x2 layout on A4 pages. Output is written to STDOUT.
  This is useful for booklet and signature preparation for printing.

USAGE:
  entrypoint.sh [OPTIONS]

OPTIONS:
  -h, --help     Display this help message and exit

STDIN/STDOUT:
  Reads a PDF file from standard input and writes the processed PDF to
  standard output. All other output (progress, errors) goes to stderr.

EXAMPLES:
  Process a file and save output:
    cat mydocument.pdf | docker run --rm -i imposition:latest > output.pdf

  Using the wrapper script:
    ./imposition-a5 mydocument.pdf > output.pdf

REQUIREMENTS:
  - PDF data must be provided on STDIN
  - The input must be a valid PDF file

OUTPUT:
  The processed PDF with imposition (1x2 layout on A4) is written to STDOUT.
  All progress messages and errors are written to STDERR.

NOTES:
  - Processing includes page count analysis, signature generation, and
    imposition with 1x2 layout on A4 paper
  - All intermediate files are created in /tmp/work (temporary)
  - No volume mounts required - everything is piped via stdin/stdout

HELPEOF
}

# Check for help flag
if [ $# -gt 0 ] && ([ "$1" = "-h" ] || [ "$1" = "--help" ]); then
    show_help
    exit 0
fi

if [ $# -gt 0 ]; then
    echo "Error: Unexpected argument '$1'" >&2
    show_help
    exit 1
fi

# Set up working directory
WORK=/tmp/work
mkdir -p $WORK

# Read PDF from STDIN and save to work directory
INPUT_PDF="$WORK/input.pdf"
cat > "$INPUT_PDF"

# Get page count from PDF
COUNT=$(java -cp /root/multivalent.jar tool.pdf.Info "$INPUT_PDF" 2>&1 | grep "Page count:" | cut -d ' ' -f 3)
echo "Page Count: $COUNT" >&2

# Generate signature sequence string
SIG_STRING=$(java -jar /root/sequence-generator-0.1.jar $COUNT)
echo "Signature String: $SIG_STRING" >&2

# Perform imposition (1 page per signature unit, then impose as 1x2 on A4)
echo "Performing imposition (1x2 layout on A4)..." >&2
find "$WORK" -iname "*.pdf" | xargs java -cp /root/multivalent.jar tool.pdf.Impose \
    -dim 1x2 -paper A4 -layout "$SIG_STRING" 2>&1 | grep -v "^$" >&2

# Find and output the generated file to STDOUT
OUTPUT_PDF=$(find "$WORK" -iname "*-up.pdf" | head -n 1)
if [ -z "$OUTPUT_PDF" ]; then
    echo "Error: No output PDF generated" >&2
    exit 1
fi

cat "$OUTPUT_PDF"
echo "" >&2
echo "Processing complete!" >&2

# Cleanup
rm -rf "$WORK"
