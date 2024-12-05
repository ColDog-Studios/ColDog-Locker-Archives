@echo off

set vrs=2.0

:: [%1 = X-ordinate]
:: [%2 = Y-co_ordinate]
:: [%3 = the colour Code for the List,e.g. fc,08,70,07 etc...don't define it if you want default colour...or type '-' (minus) for no color change...]

if /i "%~1" == "" (goto :INFO)
if /i "%~1" == "/?" (goto :INFO)
if /i "%~1" == "-h" (goto :INFO)
if /i "%~1" == "help" (goto :INFO)
if /i "%~1" == "-help" (goto :INFO)

if /i "%~1" == "vrs" (echo.%vrs%&&goto :EOF)


if /i "%~2" == "" (goto :INFO)
if /i "%~3" == "" (goto :INFO)
if /i "%~4" == "" (goto :INFO)

:LIST
setlocal enabledelayedexpansion
set _List_Count=1
set _List_Width=1
set _Final=
set _Return_code=0

set x_val=%~1
set y_val=%~2
set color=%~3
if /i "!color!" == "-" (set color=07) else (set "color=%~3")

set /a y_val_old=!y_val! + 1

:LIST-LOOP
set "Item_!_List_Count!=%~4"

call Getlen "%~4"
set _Temp_width=!ErrorLevel!
if !_Temp_width! GTR !_List_Width! (set _List_Width=!_Temp_width!)

set Item_!_List_Count!_Width=%_Temp_width%

shift /4
if /I "%~4" == "" (goto :NEXT)
set /A _List_Count+=1
goto :LIST-LOOP

:NEXT
set /A _List_Width=!_List_Width!+4
set /A _List_Height=!_List_Count!+2
set /A _Max_Width=!x_val! + !_List_Width! - 2
set /A _Max_Height=!y_val_old! + !_List_Count! - 1
set _Box=
set _List_Space=

call GetDim _Rows _Columns
set /A _Rows-=2
set /A _Columns-=1

if %_Max_Width% GTR %_Columns% (
	set /A _List_Width-=4
	set /A x_val-=%_List_Width%
	goto :NEXT
	)
if %_Max_Height% GTR %_Rows% (
	set /A y_val-=%_List_Height%
	set /a y_val_old=!y_val! + 1
	goto :NEXT
	)

set _Special_X=%_Max_Width%
set _Special_Y=%y_val%
set "_Special_Area= %_Special_X% %_Special_Y% %_Special_X% %_Special_Y%"
set _Final=/c 0x%Color:~0,1%C /g %_Special_X% %_Special_Y% /d "X" /c 0x%color%

call Box %x_val% %y_val% %_List_Height% %_List_Width% - - %Color% 1

set /A x_val+=2
set y_val=!y_val_old!

for /l %%A in (1,1,!_List_Count!) do (
	set "_final=!_final! /g !x_val! !y_val! /d "!Item_%%A!" "
	set /a y_val+=1
)

batbox.exe %_final% /c 0x07

set y_val=!y_val_old!
set /a x_val-=1
set _Invert_color=%color:~1,1%%Color:~0,1%
set _Hover=

for /l %%A in (1,1,!_List_Count!) do (
	set "_Box=!_Box!!x_val! !y_val! !_Max_Width! !y_val! "
	set /A y_val+=1
	set "_Hover=!_Invert_color!!_Hover! "
	)

set _Box=%_Box:~0,-1% %_Special_Area%
set _Hover=%_Hover% C%Color:~1,1%

set /A _List_Count+=1

:USER-INPUT
set _Result=
GetInput /m %_Box% /h %_Hover%
set _Result=%Errorlevel%

iF %_Result% == 27 (set _Return_code=0 && goto :END)
iF %_Result% == %_List_Count% (set _Return_code=0 && goto :END)

if %_Result% GTR %_List_Count% (Goto :USER-INPUT)

set _Return_code=%_Result%

:END
exit /b !_Return_code!


:INFO
Echo.
Echo. This function helps in Adding a little GUI effect into your batch program...
echo. It Prints simple List on the cmd console at specified X Y co-ordinate...
Echo. After printing, it stops For User 'mouse' input... ANd returns the Item No.
Echo. Which is clicked by User... 
Echo. 
Echo. IF 'X' is clicked, or Pressed ESC From Keyboard... then it will return 0 in 
Echo. the 'Errorlevel' Variable.
echo.
echo. Syntax: call List [X] [Y] [color ^| - ] [Items 1] [Items 2] ...
echo. Syntax: call List [help ^| /^? ^| -h ^| -help]
echo. Syntax: call List vrs
echo.
echo. Where:-
echo. X			= X-ordinate of top-left corner of List
echo. Y			= Y-co_ordinate of top-left corner of List
echo. vrs		= Version of List function
Echo. Items #	= The Items to display in the List... They maybe Enclosed within "".
echo.
echo. This version %vrs% of List function contains much more GUI Capabilities.
echo. As it uses batbox.exe and calls it only once at the end of calculation...
Echo. For the most efficient output. This vrs. uses GetInput By Aacini too. For the
Echo. Advanced Output on the console.
goto :EOF
