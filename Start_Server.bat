@echo off
cd /d "%~dp0"
set "TARGET_URL=http://127.0.0.1:8080/index.html"
start "" "%TARGET_URL%"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\serve.ps1"