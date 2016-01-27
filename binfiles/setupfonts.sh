#!/bin/bash

cd ~

# Add additional fonts to the fontpath
while read f; do
  xset fp+ $f
done < ~/.additional-fonts
