@echo off
echo Starting Chrome with disabled web security for local mapping...
echo WARNING: Only use this for mapping! Close this window when done.
echo.
start chrome.exe --disable-web-security --user-data-dir="%TEMP%\chrome-dev-session" "%~dp0index.html"
