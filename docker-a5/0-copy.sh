#!/bin/bash

WORK=/tmp/work
mkdir -p $WORK

# Copy the first PDF in /mount to working folder.
FILE=$(find /mount -iname "*.pdf" | head -n 1)
echo "Processing File: $FILE"
cp $FILE $WORK

# Target file for processing
export TARGET=$(find $WORK -iname "*.pdf" | head -n 1)