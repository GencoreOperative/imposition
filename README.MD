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

To create an A5 imposition from an A4 document, we can use the following command
from a folder which contains the PDF document to layout:

```
docker run --rm -ti -v "${PWD}":/mount imposition:a5
```

If we want to create an A6 imposition we can use the following command:

```
docker run --rm -ti -v "${PWD}":/mount imposition:a6
```