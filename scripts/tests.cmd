@echo off
for %%f in (test\test_*.tcl) do (
  jtcl test\%%~nf.tcl
)
