@echo off
REM Flutter Firefox Launch Script for Windows
REM Usage: scripts\launch_firefox.bat

echo Starting Flutter web server...
echo.

REM Start Flutter web server in background
start /B flutter run -d web-server --web-port=8080 --web-hostname=localhost

REM Wait for server to be ready
echo Waiting for server to start...
timeout /t 5 /nobreak >nul

REM Open Firefox
echo Opening Firefox...
start firefox http://localhost:8080

echo.
echo Firefox launched! The app should open at http://localhost:8080
echo Press Ctrl+C to stop the Flutter web server.
echo.
