@echo off
cls

rem 将Example.ahk换成需要的测试文件

"C:\Program Files\AutoHotkey\AutoHotkey.exe" Example.ahk | python colorfulout.py

echo.
echo.
set wait=
set /p wait=Enter any key
