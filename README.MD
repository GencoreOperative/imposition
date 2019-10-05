# Overview

This project performs PDF imposition using a source PDF document and produces
a collection of output PDF files which are scaled down.

Imposition is the process of rearranging the pages of a document so that 
they are laid out in print order on the paper.

# Build

```
docker build -f docker-2-by-1/Dockerfile docker-2-by-1 -t imposition:a5
docker build -f docker-2-by-2/Dockerfile docker-2-by-2 -t imposition:a6
```

# Run


To create an A5 Imposition from an A4 document, we can use the following command:

```
docker run --rm -ti -v ${PWD}:/mount imposition:a5
```

(cd docker && docker build . -t imposition:latest) && docker run --rm -ti -v ${PWD}:/mount imposition:latest