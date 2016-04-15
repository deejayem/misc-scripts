#!/bin/sh
#pdftotext -layout $1 - 2>/dev/null|less
pdftotext -q -layout $1 -|less
