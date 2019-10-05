# Overview

This project performs PDF imposition using a source PDF document and produces
a collection of output PDF files which are scaled laid out into a new PDF
document.

Imposition is the process of rearranging the pages of a document so that 
they are laid out in print order on the paper. In this case we are interested
in taking an A4 document and preparing it for print at A5 size on A4 paper.
In addition this project supports imposition from A4 size down to A6 size on
A4 paper.

# Build

```
docker build -f docker-a5/Dockerfile docker-a5 -t imposition:a5
docker build -f docker-a6/Dockerfile docker-a6 -t imposition:a6
```

# Run

To create an A5 imposition from an A4 document, we can use the following command
from a folder which contains the PDF document to layout:

```
docker run --rm -ti -v ${PWD}:/mount imposition:a5
```

If we want to create an A6 imposition we can use the following command:

```
docker run --rm -ti -v ${PWD}:/mount imposition:a6
```