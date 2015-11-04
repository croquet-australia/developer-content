@echo off

echo Opening http://localhost:4000...
start http://localhost:4000
if not "%errorlevel%" == "0" goto Error
goto Finally

:Error
echo.
echo.
pause

:Finally
