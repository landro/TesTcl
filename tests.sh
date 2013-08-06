#!/bin/bash
for f in test/test_*.tcl
do
	jtcl "$f"
done
