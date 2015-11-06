@echo off

echo Configuring Portable Jekyll...
pushd %~dp0
call "..\..\Open Source\PortableJekyll\setpath.cmd"
if not "%errorlevel%" == "0" goto Error

echo Changing to website directory...
pushd %~dp0jekyll-template
if not "%errorlevel%" == "0" goto Error

echo Starting Jekyll server...
jekyll serve --incremental
if not "%errorlevel%" == "0" goto Error
goto Finally

:Error

:Finally
echo.
echo.
pause