#!/bin/bash
for d in `find . -type d -empty | grep -v '^\./\.git'`; do
    touch $d/.gitkeep;
done
