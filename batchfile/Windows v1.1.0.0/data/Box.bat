@echo off

set vrs=4.0

:: [%1 = X-ordinate]
:: [%2 = Y-co_ordinate]
:: [%3 = height of box]
:: [%4 = width of box] 
:: [%5 = width From where to separate box,if don't specified or specified '-' (minus),then box will not be separated.]
:: [%6 = Background element of Box,if not specified or specified '-' (minus),then no background will be shown...It should be a single Character...]
:: [%7 = the colour Code for the Box,e.g. fc,08,70,07 etc...don't define it if you want default colour...or type '-' (minus) for no color change...]
:: [%8 = The Style / type of box you want to print.]
:: [%9 = _Variable to save output to.]

if /i "%~1" == "" (goto :INFO)
if /i "%~1" == "/?" (goto :INFO)
if /i "%~1" == "-h" (goto :INFO)
if /i "%~1" == "help" (goto :INFO)
if /i "%~1" == "-help" (goto :INFO)

if /i "%~1" == "vrs" (echo.4.0&&goto :EOF)


if /i "%~2" == "" (goto :INFO)
if /i "%~3" == "" (goto :INFO)
if /i "%~4" == "" (goto :INFO)

:BOX
setlocal enabledelayedexpansion
set _string=
set "_SpaceWidth=/d ""
set _final=

set x_val=%~1
set y_val=%~2
set sepr=%~5
if /i "!sepr!" == "-" (set sepr=)
set char=%~6
if /i "!char!" == "-" (set char=)
if defined char (set char=!char:~0,1!) else (set "char= ")
set color=%~7
if defined color (if /i "!color!" == "-" (set color=) else (set "color=/c 0x%~7"))

set Type=%~8
if not defined Type (Set Type=1)
if %Type% GTR 4 (Set Type=1)

if /i "%Type%" == "0" (
	if /i "%~6" == "-" (
		set _Hor_line=/a 32
		set _Ver_line=/a 32
		set _Top_sepr=/a 32
		set _Base_sepr=/a 32
		set _Top_left=/a 32
		set _Top_right=/a 32
		set _Base_right=/a 32
		set _Base_left=/a 32
		) else (
		set _Hor_line=/d "%char%"
		set _Ver_line=/d "%char%"
		set _Top_sepr=/d "%char%"
		set _Base_sepr=/d "%char%"
		set _Top_left=/d "%char%"
		set _Top_right=/d "%char%"
		set _Base_right=/d "%char%"
		set _Base_left=/d "%char%"
		)
)

if /i "%Type%" == "1" (
set _Hor_line=/a 196
set _Ver_line=/a 179
set _Top_sepr=/a 194
set _Base_sepr=/a 193
set _Top_left=/a 218
set _Top_right=/a 191
set _Base_right=/a 217
set _Base_left=/a 192
)

if /i "%Type%" == "2" (
set _Hor_line=/a 205
set _Ver_line=/a 186
set _Top_sepr=/a 203
set _Base_sepr=/a 202
set _Top_left=/a 201
set _Top_right=/a 187
set _Base_right=/a 188
set _Base_left=/a 200
)

if /i "%Type%" == "3" (
set _Hor_line=/a 205
set _Ver_line=/a 179
set _Top_sepr=/a 209
set _Base_sepr=/a 207
set _Top_left=/a 213
set _Top_right=/a 184
set _Base_right=/a 190
set _Base_left=/a 212
)

if /i "%Type%" == "4" (
set _Hor_line=/a 196
set _Ver_line=/a 186
set _Top_sepr=/a 210
set _Base_sepr=/a 208
set _Top_left=/a 214
set _Top_right=/a 183
set _Base_right=/a 189
set _Base_left=/a 211
)

set /a _char_width=%~4-2
set /a _box_height=%~3-2

for /l %%A in (1,1,!_char_width!) do (
	if /i "%%A" == "%~5" (
	set "_string=!_string! !_Top_sepr!"
	set "_SpaceWidth=!_SpaceWidth!" !_Ver_line! /d ""
	) else (
	set "_string=!_string! !_Hor_line!"
	set "_SpaceWidth=!_SpaceWidth!!char!"
	)
)

set "_SpaceWidth=!_SpaceWidth!""
set "_final=/g !x_val! !y_val! !_Top_left! !_string! !_Top_right! !_final! "
set /a y_val+=1

for /l %%A in (1,1,!_box_height!) do (
set "_final=/g !x_val! !y_val! !_Ver_line! !_SpaceWidth! !_Ver_line! !_final! "
set /a y_val+=1
)

set _To_Replace=!_Top_sepr:~-3!
set _Replace_With=!_Base_sepr:~-3!

for %%A in ("!_To_Replace!") do For %%B in ("!_Replace_With!") do set "_final=/g !x_val! !y_val! !_Base_left! !_string:%%~A=%%~B! !_Base_right! !_final! "

iF /i "%~9" == "" (batbox %color% %_final% /c 0x07) else (endlocal && set "%~9=%color% %_final% /c 0x07")
goto :EOF


:INFO
Echo.
Echo. This function helps in Adding a little GUI effect into your batch program...
echo. It Prints simple box on the cmd console at specified X Y co-ordinate...
echo.
echo. Syntax: call Box [X] [Y] [Height] [Width] [Sepration] [BG_Char] [color] [Type]
Echo.              [_Var]
echo. Syntax: call Box [help ^| /^? ^| -h ^| -help]
echo. Syntax: call Box vrs
echo.
echo. Where:-
echo. X		= X-ordinate of top-left corner of box
echo. Y		= Y-co_ordinate of top-left corner of box
echo. Height		= height of box
echo. Width		= width of box
echo. Sepration	= width From where to separate box,if don't specified or
echo.		  specified '-' (minus),then box will not be separated.
echo. BG_char	= Background element of Box,if not specified or specified
echo.		  '-' (minus),then no background will be shown...It should be
echo.		  a single Character...
echo. color		= the color Code for the Box,e.g. fc,08,70,07 etc...
echo.		  Don't define it if you want default colour...or type '-'
echo.		  (minus) for no color change...
echo. Type 		= The style / type of the Box you want, double Border, single
echo.		  Border etc. New, No Border Option added [Valid values: 0 to 4]
Echo. _Var 		= Variable to Save Output, instead of Printing Directly.
Echo.			(Optional)
echo. vrs		= Version of Box function
goto :EOF