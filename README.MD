# Overview

This project performs imposition of PDF files to produce a layout suitable
for book binding projects.

Imposition is the process of rearranging the pages of a document so that 
they are laid out in print order on the paper. In this case we are interested
in taking an A4 document and preparing it for print at A5 size on A4 paper.
In addition this project plans to support imposition from A4 size down to 
A6 size on A4 paper.

## Usage

The intended use case is a source A4 PDF document which is then scaled and 
laid out on A5 size paper ready for double sided printing. This is ideal for 
book binding projects. Most operating system print dialogs are not able to layout the pages in the correct position on the page to suit book binding tasks.

The printed signatures are to be folded in half with the binding performed 
on the short edge of a page.

[Diagram of process]

In addition, this project supports A4 to A6 imposition as well.
TODO - add details about paper grain and how to prepare paper for printing.

# Build

The project is arranged such that different versions of the project represent
the different modes of operation. Therefore we need to build each mode that
we are interested in:

```
docker build -f docker-a5/Dockerfile docker-a5 -t imposition:a5
docker build -f docker-a6/Dockerfile docker-a6 -t imposition:a6
```

# Run

## Using the Wrapper Script (Recommended)

The easiest way to use the tool is with the provided wrapper script:

```bash
# Process a PDF with default output naming (creates myfile-imposed.pdf)
./imposition-a5 myfile.pdf

# Process a PDF with custom output name
./imposition-a5 myfile.pdf -o output.pdf

# View help
./imposition-a5 --help
```

The wrapper script handles all the Docker complexity and pipes data via STDIN/STDOUT.

## Using Docker Directly

You can also call Docker directly if you prefer:

```bash
# Process a PDF and save to output.pdf
cat mydocument.pdf | docker run --rm -i imposition:a5 > output.pdf
```

## How It Works

- Input PDF is read from STDIN
- The tool analyzes the page count and generates an imposition sequence
- Pages are arranged in 1x2 layout on A4 paper for printing
- Output is written to STDOUT as a new PDF file
- All processing happens in a temporary container (no files on disk during processing)