@echo off
setlocal enabledelayedexpansion

:: Get user input
set /p "target_path=Enter target path (e.g., C:\Users\user\Desktop\Note_on_Algebra_Geometry\chapters\preliminary): "
set /p "project_name=Enter section name: "

:: Validate input
if "%target_path%"=="" (
    echo Error: Target path cannot be empty
    goto :end
)
if "%project_name%"=="" (
    echo Error: Project name cannot be empty
    goto :end
)

:: Build full path
set "full_path=%target_path%\%project_name%"

:: Create target folder
if exist "%full_path%" (
    echo Error: Folder already exists - "%full_path%"
    goto :end
)
mkdir "%full_path%" || (
    echo Error: Failed to create folder - "%full_path%"
    goto :end
)

:: Copy template files (assuming template_files in script directory)
echo Copying template files...
xcopy /E /I /Q "%~dp0template\main.tex" "%full_path%" || (
    echo Error: File copy failed
    goto :end
)
xcopy /E /I /Q "%~dp0template\text.tex" "%full_path%" || (
    echo Error: File copy failed
    goto :end
)
xcopy /E /I /Q "%~dp0template\placeholder.jpg" "%full_path%" || (
    echo Error: File copy failed
    goto :end
)


:: Create symbolic link (example: linking to common_resources in parent directory)
echo Creating symbolic link...
mklink "%full_path%\noteformyself.cls" "..\..\..\template\noteformyself.cls" || (
    echo Error: Failed to create symbolic link
    echo Note: May require administrator privileges
    goto :end
)
mklink "%full_path%\notation.tex" "..\..\..\template\notation.tex" || (
    echo Error: Failed to create symbolic link
    echo Note: May require administrator privileges
    goto :end
)
mklink "%full_path%\ref.bib" "..\..\..\template\ref.bib" || (
    echo Error: Failed to create symbolic link
    echo Note: May require administrator privileges
    goto :end
)

:success
echo Project structure created successfully:
echo Path: %full_path%
echo Contents:
dir /b "%full_path%"
echo Symbolic link: common_link -> ..\common_resources
 
:end
echo.
echo Script execution completed.
echo Press any key to close this window...
pause >nul
endlocal