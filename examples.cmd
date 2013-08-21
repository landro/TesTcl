@echo off

Rem add local path to tcl library paths
set dir=%~dp0
set lib=%dir:\=/%
set lib=%lib:~0,-1%
if "%TCLLIBPATH%" == "" (
  set TCLLIBPATH=%lib% %TCLLIBPATH%
) else (
  set TCLLIBPATH=%lib%
)

Rem execute all test scripts
for %%f in (examples\example_*.tcl) do (
  jtcl examples\%%~nf.tcl
)
