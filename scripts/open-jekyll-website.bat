@echo off

echo Opening http://127.0.0.1:4000/...
start http://127.0.0.1:4000/
if not "%errorlevel%" == "0" goto Error
goto Finally

:Error
echo.
echo.
pause

:Finally
