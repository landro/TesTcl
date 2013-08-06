@echo off
for %%f in (examples\example_*.tcl) do (
	jtcl examples\%%~nf.tcl
)
