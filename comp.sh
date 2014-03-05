#!/bin/bash

vulcan < $1 > "$1.latex" &
latexmk -pdf "$1.latex"

latexmk -c "$1.latex"
