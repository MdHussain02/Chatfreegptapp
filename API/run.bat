@echo off
REM Get the directory of the current script
set "SCRIPT_DIR=%~dp0"

REM Change directory to the script's location
cd /d "%SCRIPT_DIR%"

REM Check if the virtual environment exists
if not exist "env\Scripts\activate.bat" (
    REM Create the virtual environment
    python -m venv env

    REM Activate the virtual environment
    call "%SCRIPT_DIR%env\Scripts\activate.bat"

    REM Check if requirements.txt exists and install the required packages
    if exist "requirements.txt" (
        pip install -r requirements.txt
    )
) else (
    REM Activate the virtual environment
    call "%SCRIPT_DIR%env\Scripts\activate.bat"
)

REM Run the Python script
python "%SCRIPT_DIR%gui.py"
