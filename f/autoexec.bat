@echo off
set ScriptRoot=%~dp0

echo Starting ahk...
start %USERPROFILE%\scoop\apps\autohotkey\current\AutoHotkeyU64.exe %ScriptRoot%autohotkey.ahk

pause
