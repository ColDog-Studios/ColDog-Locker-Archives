::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFDhbQCCNO1eKD7YI/fr+/NakrUE5W+V/S5vO3r2BM9wFuHntdpkj6ll+q4ZeQksWdxGkDg==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZk8aH0rSXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlDi
::ZQ05rAF9IAHYFVzEqQIWIQNRXmQ=
::eg0/rx1wNQPfEVWB+kM9LVsJDCKLJG6oZg==
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQICLRZbWgGRfEi1CpET76jX4OmMp19dd+0xa4DX3/StL+4V40LxZ5c533VU+A==
::dhA7uBVwLU+EWHqL+GY/L1tnWBGGNWSpZg==
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATE1008DBRTDDeWKW+zCaZ8
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDhbQCCNO1eeCbYJ5e31+/m7gUIRcO04OKPU2b+LMtwk40vgeoE+lllVltgDAB5kaEDlOkFklUhLrmGXecKEtm8=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
prompt $T~$$ 
set "vn=v1.4"
::Long Verson: v1.4.3
::Date Modified: 2/7/22
set   "bar=----------------------------------------------"
set "line1=-                 Fixer %vn%                 -"
set "line2=-  (c) ColDog Studios. All rights reserved.  -"
for /F "delims=" %%x in (%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg) do set theme=%%x
if "%theme%"=="light" set "t=F"
if "%theme%"=="dark" set "t=0"

:START
color %t%C
title Fixer
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo [1] Delete ColDog Locker Configuration
echo [2] Delete Light/Dark Theme Configuration
echo [3] Close Fixer
echo.
set /P "cho=> "
if  /I %cho%==1 goto FLRM
if  /I %cho%==2 goto THEME
if  /I %cho%==3 goto END

color %t%4
title Error
echo.
echo Invalid Choice.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

goto START
:FLRM
color %t%A
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo ColDog Locker configuration has been deleted.
echo.
pause

cls
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
del "%USERPROFILE%\AppData\Roaming\ColDogStudios\data.dat"
cls
goto START

:THEME
color %t%A
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo ColDog Locker Theme configuration has been deleted.
echo.
pause

cls
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg"
cls
goto START

:END
exit /B
