@echo off
setlocal
cd /d "%~dp0"
if not exist ".venv\Scripts\python.exe" (
  echo Creating Python virtual environment...
  py -3 -m venv .venv
  if errorlevel 1 goto failed
)
echo Installing or updating dependencies...
.venv\Scripts\python.exe -m pip install --upgrade pip
if errorlevel 1 goto failed
.venv\Scripts\python.exe -m pip install -r requirements.txt
if errorlevel 1 goto failed
echo.
echo NEX OSINT Pro: http://127.0.0.1:8000
echo API docs: http://127.0.0.1:8000/api/docs
echo Keep this window open while using the app.
.venv\Scripts\python.exe -m uvicorn app:app --host 127.0.0.1 --port 8000
if errorlevel 1 goto failed
goto end
:failed
echo.
echo Setup failed. Check that Python 3.10+ is installed and that internet access is available.
pause
:end
endlocal
