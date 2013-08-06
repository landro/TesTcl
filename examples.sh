#!/bin/bash
for f in examples/example_*.tcl
do
	jtcl "$f"
done
