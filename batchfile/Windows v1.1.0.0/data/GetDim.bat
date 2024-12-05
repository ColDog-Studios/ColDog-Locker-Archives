@echo off
setlocal enabledelayedexpansion

if /i "%~1" == "" (goto :INFO)
if /i "%~1" == "/?" (goto :INFO)
if /i "%~1" == "-h" (goto :INFO)
if /i "%~1" == "help" (goto :INFO)
if /i "%~1" == "-help" (goto :INFO)

if /i "%~1" == "vrs" (echo.1.0&&goto :eof)

if /i "%~2" == "" (goto :INFO)

set _Parameter=1
for /f "Skip=3 tokens=2" %%A in ('mode con') do (set "_!_Parameter!=%%A" && set /A _Parameter+=1)
endlocal && set "%~1=%_1%" && set "%~2=%_2%"
goto :EOF

:INFO
echo.
echo. This function Simply Returns the current Dimensions of cmd console,
echo. in Two variables provided.
echo.
echo. Syntax: Call GetDim [Rows] [Columns]
echo. Syntax: call GetDim [help ^| /^? ^| -h ^| -help]
echo. Syntax: call GetDim ver
echo.
echo. Where:-
echo. Rows		= The Variable to save 'No. of Rows	[Y]'
echo. Columns	= The Variable to save 'No. of Columns	[X]'
echo. Help		= Shows this screen.
echo. vrs		= Version of the function.
goto :eof