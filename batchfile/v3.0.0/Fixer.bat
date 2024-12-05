@shift /0

:: SETUP
@echo off
prompt $T~$$ 
set vn=v1.5
:: Long Verson: v1.5.0
:: Date Modified: 4/28/22
set   "bar=----------------------------------------------"
set "line1=-                 Fixer %vn%                 -"
set "line2=-  (c) ColDog Studios. All rights reserved.  -"
title Fixer %vn%

:: MENU
:MENU
color 03
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Delete ColDog Locker Configuration? [ Y/n ]
echo.
set /P "cho=> "
if /I %cho%==y goto DELETE
if /I %cho%==n exit /B
color 04
echo.
echo Invalid Choice.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

goto MENU

:DELETE
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
cls
exit /B