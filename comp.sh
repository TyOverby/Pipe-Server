#!/bin/bash

scala com.prealpha.pipe.generators.latex.LatexDocument $1 > "$1.latex"

lualatex "$1.latex"
