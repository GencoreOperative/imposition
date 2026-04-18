# Overview

This project provides Docker-based tools for PDF imposition and signature splitting, suitable for book binding projects.

**Imposition** is the process of rearranging pages so they are laid out in print order on the paper.
**Signature splitting** divides a PDF into folded sheets ready for manual binding.

## Tools Included

### imposition-a5
Imposes an A4-sized PDF for printing at A5 size on A4 paper (1x2 layout). Pages are automatically rearranged with correct signature sequencing for book binding.

### signatures
Splits a PDF into individual signatures (folded sheets). Output is a ZIP file with each signature as a separate PDF. Signature size must be a multiple of 4 pages.

The intended use case is a source A4 PDF document which is then processed and laid out for double sided printing. This is ideal for book binding projects, as most operating system print dialogs cannot layout pages correctly for book binding tasks.

## Usage

The printed signatures are to be folded in half with the binding performed on the short edge of a page.

[Diagram of process]

# Build

The project is arranged such that different versions of the project represent
the different modes of operation. Therefore we need to build each mode that
we are interested in:

```
docker build -f docker-a5/Dockerfile docker-a5 -t imposition:a5
docker build -f docker-a6/Dockerfile docker-a6 -t imposition:a6
docker build -f docker-signatures/Dockerfile docker-signatures -t signatures:latest
```

# Run

## A5 Imposition (Recommended Usage)

The easiest way to use the A5 imposition tool is with the provided wrapper script:

```bash
# Process a PDF with default settings (A4 output)
./imposition-a5 myfile.pdf

# Process with custom paper size
./imposition-a5 myfile.pdf --paper A3

# View help
./imposition-a5 --help
```

**Options:**
- `--paper <size>` - Output paper size (default: A4). Common sizes: A3, A4, A5, Letter, Legal

Or call Docker directly:

```bash
cat mydocument.pdf | docker run --rm -i imposition:a5 > output.pdf
cat mydocument.pdf | docker run --rm -i imposition:a5 --paper A3 > output.pdf
```

## Splitting into Signatures

To split a PDF into individual signatures for manual binding, use the wrapper script:

```bash
# Split into 16-page signatures (creates myfile-signatures.zip)
./signatures myfile.pdf 16

# Split into 8-page signatures
./signatures myfile.pdf 8

# Split into 4-page signatures (default if no size specified: ./signatures myfile.pdf)
./signatures myfile.pdf 4

# View help
./signatures --help
```

Valid signature sizes: multiples of 4 (4, 8, 12, 16, 20, etc.)

Or call Docker directly:

```bash
cat mydocument.pdf | docker run --rm -i signatures:latest 16 > signatures.zip
```

Output is a ZIP file containing individual PDF files for each signature:
- `sig-001.pdf` - First signature
- `sig-002.pdf` - Second signature
- etc.

Each PDF can be printed and then folded in half for manual binding.

## How It Works

### A5 Imposition
- Input PDF is read from STDIN
- The tool analyzes the page count and generates an imposition sequence
- Pages are arranged in 1x2 layout on specified paper size for printing
- Output is written to STDOUT as a new PDF file
- **Note**: The underlying Multivalent tool does not support margin/spacing adjustments with custom layouts. Only paper size can be specified.

### Signatures Splitting
- Input PDF is read from STDIN
- The tool validates signature size (must be multiple of 4)
- Analyzes page count and calculates number of signatures needed
- PDF is split into individual signatures (folded sheets) using Multivalent tools
- Each signature is output as a separate PDF with sequential naming (sig-001.pdf, sig-002.pdf, etc.)
- All signatures are packaged into a ZIP archive
- ZIP file is written to STDOUT

### General Notes
- All processing happens in a temporary container (no files on disk during processing)
- No volume mounts required - everything is piped via STDIN/STDOUT
- All progress messages are written to STDERR (keeps output stream clean for piping)
- Wrapper scripts (`imposition-a5`, `signatures`) handle file I/O and naming
- Built on Multivalent tools (https://github.com/GencoreOperative/multivalent-tools)