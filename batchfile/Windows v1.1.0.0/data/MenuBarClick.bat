@echo off
setlocal enabledelayedexpansion
:: Auto generated MenuBar Click file
set mainMenu=0 
set subMenu=0 

if %~1 EQU 1 (
	set mainMenu=1
	call List.bat 0 1 f0 "New" "Delete" "Exit" 
	set subMenu=!Errorlevel!
)
if %~1 EQU 2 (
	set mainMenu=2
	call List.bat 7 1 f0 "CDS Website" "CDS GitHub" 
	set subMenu=!Errorlevel!
)
if %~1 EQU 3 (
	set mainMenu=3
	call List.bat 14 1 f0 "Lock Folder" "Unlock Folder" 
	set subMenu=!Errorlevel!
)
if %~1 EQU 4 (
	set mainMenu=4
	call List.bat 30 1 f0 "System Info" "Custom Input" 
	set subMenu=!Errorlevel!
)
if %~1 EQU 5 (
	set mainMenu=5
	call List.bat 38 1 f0 "About" "How to Use" "Check for Updates" 
	set subMenu=!Errorlevel!
)

:: Preparing to return user input
:: Using tunneling
endlocal && set "%~2=%mainMenu%" && set "%~3=%subMenu%"
goto :EOF
