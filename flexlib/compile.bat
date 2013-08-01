REM @echo off
cls

rem compc "%cd%\src\ego\themes\default.css" -o "%cd%\bin\default.swc"
ant -buildfile "build.xml"

pause