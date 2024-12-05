@echo off
setlocal enabledelayedexpansion

set vrs=2.0

:: [%1 = File, To Load MenuBar Items]
:: [%2 = Color of the MenuBar]
:: [%3 = Variable to Return Area of Each Menu Option on MenuBar, For Using with GetInput.exe]
:: [%4 = Variable to Return The Mouse Hover color of Each Element of MenuBar]

if /i "%~1" == "" (goto :INFO)
if /i "%~1" == "/?" (goto :INFO)
if /i "%~1" == "-h" (goto :INFO)
if /i "%~1" == "help" (goto :INFO)
if /i "%~1" == "-help" (goto :INFO)

if /i "%~1" == "vrs" (echo.%vrs%&&goto :EOF)

if /i "%~2" == "" (goto :INFO)
if /i "%~3" == "" (goto :INFO)
if /i "%~4" == "" (goto :INFO)

set "_File=%~1"
set "_Color=%~2"
set _Count=0
set X=0
set Y=0
set _Total_len=0
set _Script=MenuBarClick.bat

:: Generating MenuBarClick
echo.@echo off>"!_Script!"
echo.setlocal enabledelayedexpansion>>"!_Script!"
echo.:: Auto generated MenuBar Click file>>"!_Script!"
echo.set mainMenu=0 >>"!_Script!"
echo.set subMenu=0 >>"!_Script!"
echo.>>"!_Script!"

call GetDim _Lines _Columns

for /l %%A in (1,1,!_Columns!) do (set "_MenuBG=!_MenuBG! ")

:: Loading The Raw Data From Database to Current Environment
for /f "EOL=# Usebackq Tokens=*" %%A in ("%_File%") do (
	set _Temp=%%A

	if /i "!_Temp:~0,1!" == "$" (
			for %%X in (!_Count!) do (set "_Menu_%%X_Sub=!_Menu_%%X_Sub!"%%A" ")
		) else (
		set /a _Count+=1
		set "_Menu_!_Count!=%%A"

		call Getlen ".%%A.."
		set Len=!Errorlevel!
		set /a _Total_len+=!Len!

		set "_MenuBar=!_MenuBar!/g !X! !Y! /d " %%A ^|" "

		set _Menu_!_Count!_X=!X!
		set /a X+=!Len!
		set /a _Menu_!_Count!_X_End=!X! -2
		set _Menu_!_Count!_Y=!Y!

		)
)

set /a _Y_=!Y! + 1
set _Invert_Color=%_Color:~1,1%%_Color:~0,1%
set _Box=
set _Hover=

for /l %%A in (1,1,!_Count!) do (
	set "_Box=!_Box!!_Menu_%%A_X! !_Menu_%%A_Y! !_Menu_%%A_X_End! !_Menu_%%A_Y! "
	set "_Hover=!_Hover!!_Invert_Color! "

	if /i "!_Menu_%%A_Sub!" NEQ "" (
		echo.if %%~1 EQU %%A ^(>>"!_Script!"
		echo.	set mainMenu=%%A>>"!_Script!"
		echo.	call List.bat !_Menu_%%A_X! !_Y_! !_Color! !_Menu_%%A_Sub:$=!>>"!_Script!"
		echo.	set subMenu=^^!Errorlevel^^!>>"!_Script!"
		echo.^)>>"!_Script!"
	) else (
		echo.if %%~1 EQU %%A ^(set mainMenu=%%A^& set subMenu=0^)>>"!_Script!"
	)
)

:: Done generating Check_MenuBar_Click
echo.>>"!_Script!"
echo.:: Preparing to return user input>>"!_Script!"
echo.:: Using tunneling>>"!_Script!"
echo.endlocal ^&^& set "%%~2=%%mainMenu%%" ^&^& set "%%~3=%%subMenu%%">>"!_Script!"
echo.goto :EOF>>"!_Script!"
batbox /g 0 0 /c 0x%_Color% /d "!_MenuBG!" !_MenuBar! /c 0x07
endlocal && set "%~3=%_Box%" && set "%~4=%_Hover%"
goto :EOF

:INFO
echo.
echo. This function helps in Adding a little GUI effect into your batch program...
echo. It Prints simple MenuBar on cmd console at Top X=0 Y=0; Co-ordinates (Default)
echo. You Need to provide a Text File, Containing The MenuBar Options And Their Sub
echo. Options, (Which are starting By '$' Sign in the File.) [See Example @ Bottom]
echo.
echo. After printing, it Generates a 'Check_MenuBar_Click.Bat' Script For Verifying
echo. Whether, User has clicked On Any Menu Option or Not. 
echo. You can use this file to Simply interacting with the MenuBar Easily. [See E.g]
echo. 
echo. IF 'X' is clicked, or Pressed ESC From Keyboard... then it will return 0 in 
echo. the 'Errorlevel' Variable.
echo.
echo. Syntax: call MenuBar [File] [Color] [_MenuBar_Area] [_Hover_Color]
echo. Syntax: call MenuBar [help ^| /^? ^| -h ^| -help]
echo. Syntax: call MenuBar vrs
echo.
echo. Where:-
echo. File		= Database File of the MenuBar [Contains Menu_options+Sub_Menu]
echo. Color		= Color of the MenuBar [Hex Code: 0F,08,07 etc.]
echo. vrs		= Version of MenuBar function
echo. _MenuBar_Area	= It is Not a value, It is the name of variable - In which the
echo. 		MenuBar Function will Return Co-ordinates of the Menu options.
echo. _Hover_Color	= It is Not a value, It is the name of variable - In which the
echo. 		MenuBar Function will Return Hover color of the .
echo.
echo. Example:-
echo. Call MenuBar Menu_Options.txt F0 _Getlnput_Selection_Box _Selection_Hover_Color
echo.
echo. Where, Menu_Options - File should be as Follows:
echo. -------------------------------------------------------------------------------
echo. # All Lines, after '#' Are Comments... And, after '$' Are Sub_Menu options.
echo. Menu 1
echo. $Menu 1 - Sub Menu 1
echo. $Menu 1 - Sub Menu 2
echo. $Menu 1 - Sub Menu 3
echo. Menu 2
echo. $Menu 2 - Sub Menu 1
echo. $Menu 2 - Sub Menu 2
echo. Menu 3
echo. $Menu 3 - Sub Menu 1
echo. # Quite simple... Isn't it?
echo. -------------------------------------------------------------------------------
echo. 
echo. Demo:
echo. A Short And Simple Batch Program would be as:
echo. :MENU
echo. cls
echo. call MenuBar File f0 _Box _Hover
echo.
echo. :: Enabling Mouse Interaction
echo. GetInput /M %%_BOx%% /H %%_Hover%%
echo.
echo. call Check_MenuBar_Click.bat %%Errorlevel%% _Menu_Option _Sub_menu_option
echo.
echo. title %%_Menu_Option%%x%%_Sub_menu_option%%
echo. goto :MENU
goto :EOF
