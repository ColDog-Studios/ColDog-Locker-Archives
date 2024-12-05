@echo off
set "_text=%~1"
setlocal enabledelayedexpansion

set vrs=3.0
set len=0

IF /i "!_text!" == "" (goto :END)
IF /i "!_text!" == "/h" (goto :INFO)
IF /i "!_text!" == "/?" (goto :INFO)
IF /i "!_text!" == "-h" (goto :INFO)
IF /i "!_text!" == "Help" (goto :INFO)
IF /i "!_text!" == "vrs" (echo.%vrs% && goto :EOF)

:MAIN
set "s=!_text!#"
for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if "!s:~%%P,1!" NEQ "" ( 
        set /a "len+=%%P"
        set "s=!s:~%%P!"
    )
)

:END
endlocal && exit /b %len%

:INFO
echo.
echo. Calculates the Length of The Given String. Including special characters.
echo.
echo. Syntax: Call Getlen [String]
echo. Where
echo.
echo. String:	It is the String, Whose length to be calculated.
echo.
echo. The length of the string is Returned in to the Main fucntion through the
echo. Environmental Errorlevel variable.
echo.
echo. Try these lines in a Batch file: [E.g.]
goto :END