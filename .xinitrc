#!/bin/bash

# apply custom key bindings
if [ -f "$HOME/.xmodmaprc" ]; then
  xmodmap "$HOME/.xmodmaprc"
fi
