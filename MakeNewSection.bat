@echo off
setlocal enabledelayedexpansion

:main_loop
:: Get user input
set /p "target_chapter=Enter chapter name: "
set /p "project_name=Enter section name: "

:: Validate input
if "%target_chapter%"=="" (
    echo Error: Chapter cannot be empty
    goto :retry_prompt
)
if "%project_name%"=="" (
    echo Error: Section name cannot be empty
    goto :retry_prompt
)

:: Build full path
set "full_path=%~dp0chapters\%target_chapter%\%project_name%"

:: Create target folder
if exist "%full_path%" (
    echo Error: Folder already exists - "%full_path%"
    goto :retry_prompt
)
mkdir "%full_path%" || (
    echo Error: Failed to create folder - "%full_path%"
    goto :retry_prompt
)

:: Copy template files (assuming template_files in script directory)
echo Copying template files...
copy /Y "%~dp0template\main.tex" "%full_path%\%project_name%.tex" || (
    echo Error: File copy failed
    goto :retry_prompt
)
xcopy /E /I /Q "%~dp0template\text.tex" "%full_path%" || (
    echo Error: File copy failed
    goto :retry_prompt
)
@REM xcopy /E /I /Q "%~dp0template\placeholder.jpg" "%full_path%" || (
@REM     echo Error: File copy failed
@REM     goto :retry_prompt
@REM )

:: Create symbolic link (example: linking to common_resources in parent directory)
echo Creating symbolic link...
mklink "%full_path%\noteformyself.cls" "..\..\..\template\noteformyself.cls" || (
    echo Error: Failed to create symbolic link
    echo Note: May require administrator privileges
    goto :retry_prompt
)
mklink "%full_path%\notation.tex" "..\..\..\template\notation.tex" || (
    echo Error: Failed to create symbolic link
    echo Note: May require administrator privileges
    goto :retry_prompt
)
mklink "%full_path%\ref.bib" "..\..\..\template\ref.bib" || (
    echo Error: Failed to create symbolic link
    echo Note: May require administrator privileges
    goto :retry_prompt
)

echo Project structure created successfully:
echo Path: %full_path%
echo Contents:
dir /b "%full_path%"

:retry_prompt
echo.
echo Choose an option:
echo [R] Run again
echo [Q] Quit
choice /c RQ /n /m "Press R to run again or Q to quit: "
if errorlevel 2 goto :end
if errorlevel 1 goto :main_loop

:end
echo.
echo Goodbye!
endlocal