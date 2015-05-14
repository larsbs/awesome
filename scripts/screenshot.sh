#!/bin/bash

timestamp="$(date +%Y%m%d%H%M%S)"
targetbase="$HOME/Imágenes/Screenshots"
mkdir -p $targetbase
[ -d $targetbase ] || exit 1
scrot $targetbase/$timestamp.png
