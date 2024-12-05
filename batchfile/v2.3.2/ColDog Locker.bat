:: App Metadata
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
::cxY6rQJ7JhzQF1fEqQJiZk8aHErSXA==
::ZQ05rAF9IBncCkqN+0xwdVsGAlDMbAs=
::ZQ05rAF9IAHYFVzEqQITJxdwQwPCEGS5DbAOqMv04fmIrkh9
::eg0/rx1wNQPfEVWB+kM9LVsJDCeNME+1AfUw5+vw6vjHgUITR+0zfe8=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQITOh5VWAGRfGr6ALoQ7O3pr/6I4l4cUuczYc/IzrucJaAV40nhZvY=
::dhA7uBVwLU+EWHqL+GY/L1tnWBGGNWSpZg==
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATE1008DBRTDDeWKW+zCaZ8
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDhbQCCNO1eeCbYJ5e31+/m7gUIRcO04OKPU2b+LMtwk40vgeoE+lllVltgDAB5kaEDlOkFklU1NukCKMIqwvAzqT1rH41M1ew==
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983

:: SETUP
@echo off
prompt $T~$$ 
md "%USERPROFILE%\AppData\Roaming\ColDogStudios"
set "vrsn=v2.3.2"
set   "bar=--------------------------------------------------"
set "line1=-              ColDog Locker %vrsn%              -"
set "line2=-    (c) ColDog Studios. All rights reserved.    -"
for /F "delims=" %%x in (%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg) do set locker=%%x
for /F "delims=" %%x in (%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg) do set fdkey=%%x
for /F "delims=" %%x in (%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg) do set theme=%%x
if "%theme%"=="light" set "ut=F0"
if "%theme%"=="light" set "t=F"
if "%theme%"=="dark" set "ut=0F"
if "%theme%"=="dark" set "t=0"
set /A failedAttempts=0
color %ut%
title ColDog Locker
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
pause
if NOT EXIST "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg" goto THEME
if EXIST "%USERPROFILE%\AppData\Roaming\ColDogStudios\temp" goto UNLOCK
if EXIST "%locker%" goto CHOICE
if NOT EXIST "%locker%" goto CREATE
::***********************SETUP************************

::***********************THEME************************
:THEME
title Theme Select
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Select Light or Dark Theme [L,D]
echo.
set /P "themeSelect=> "
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
if /I "%themeSelect%"=="l" goto LIGHT
if /I "%themeSelect%"=="d" goto DARK
color 04
title Error
echo Invalid Choice.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

goto THEME
::***********************THEME************************

::***********************LIGHT************************
:LIGHT
color F0
echo light> "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg"

echo Light Theme Successfully Applied
echo.
pause > nul | set /P "=Press any key to exit . . . "

goto END
::***********************LIGHT************************

::************************DARK************************
:DARK
color 0F
echo dark> "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDogStudios\theme.cfg"

echo Dark Theme Successfully Applied
echo.
pause > nul | set /P "=Press any key to exit . . . "

goto END
::************************DARK************************

::***********************CREATE***********************
:CREATE
color %ut%
title Create Folder Name
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
set /P "folderName=Create Folder Name: "
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
title Create Password
echo Minimum Password Length: at least 8 characters
echo Recommended Password Length: at least 12 characters
echo.
set "psCommand=powershell -Command "$pword = read-host ' Create Folder Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set pass=%%p   

set "psCommand=powershell -Command "$pword = read-host 'Confirm Folder Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%q in (`%psCommand%`) do set pass2=%%q   
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
if "%folderName%"==""  goto INVALID
if "%folderName%"==" " goto INVALID
if "%pass%"==""  goto INVALID
if "%pass%"==" " goto INVALID
if "%pass:~10%" EQU "" goto BADLENGTH
if "%pass%"=="%pass2%" goto NEXT
if NOT "%pass%"=="%pass2%" goto INVALID

:NEXT
title Writing...
echo Creating %folderName% . . . 
echo %folderName%> "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
md "%folderName%"
cipher /E "%folderName%"
echo %folderName% Created Successfully.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Setting Password . . .
echo %pass%> "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
echo.
color %t%a
echo Password Set Successfully.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to exit . . . "

fsutil file createnew data.dat 69
move "data.dat" "%USERPROFILE%\AppData\Roaming\ColDogStudios"
cls
goto END
::***********************CREATE***********************

::**********************INVALID**********************
:INVALID
color %t%4
title /!\ INVALID /!\
echo Name for Folder or Password is Invalid
echo.
pause > nul | set /P "=Press any key to retry . . . "

goto CREATE
::**********************INVALID**********************

::*********************BADLENGTH*********************
:BADLENGTH
color %t%4
title /!\ INVALID /!\
echo Your Password needs to be at least 8 characters
echo.
pause > nul | set /P "=Press any key to retry . . . "

goto CREATE
::*********************BADLENGTH*********************

::***********************CHOICE***********************
:CHOICE
color %ut%
title Action Needed
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Confirm you want to lock the locker? [Y,N] Delete the locker? [rm]
echo.
set /P "lcho=> "
if  /I %lcho%==Y          goto LOCK
if  /I %lcho%==N          goto END
if  /I %lcho%==rm         goto REMOVE
if  /I %lcho%==about      goto ABOUT
if  /I %lcho%==dev        goto DEV
if  /I %lcho%==system     goto SYSTEM
if  /I %lcho%==ColDog5044 goto COLDOG
if  /I %lcho%==Boggs      goto BOGGS
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color %t%4
title Error
echo Invalid Choice.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

goto CHOICE
::***********************CHOICE***********************

::************************LOCK************************
:LOCK
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Locking...
color %t%A
title Locked
echo Locker locked.
echo.
pause > nul | set /P "=Press any key to exit . . . "

ren "%locker%" temp
move temp "%USERPROFILE%\AppData\Roaming\ColDogStudios"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDogStudios\temp"
cls
goto END
::************************LOCK************************

::***********************UNLOCK***********************
:UNLOCK
color %ut%
title Enter Password
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
set "psCommand=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set unpass=%%p   
if "%unpass%"=="%fdkey%" goto SUCCESS
if NOT "%unpass%" =="%fdkey%" goto FAIL

    ::******************SUCCESS*******************
:SUCCESS
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color %t%A
title Unlocked
echo Locker Unlocked Successfully.
echo.
pause > nul | set /P "=Press any key to exit . . . "

attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\temp"
move "%USERPROFILE%\AppData\Roaming\ColDogStudios\temp"
ren temp "%locker%"
cls
goto END
    ::******************SUCCESS*******************

    ::********************FAIL********************
:FAIL
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
set /A failedAttempts = %failedAttempts%+1
if %failedAttempts% == 10 goto DELETE
color %t%4
title Error
echo Incorrect Password!
echo.
pause > nul | set /P "=Press any key to retry . . . "

goto UNLOCK
    ::********************FAIL********************

::***********************UNLOCK***********************

::***********************DELETE***********************
:DELETE

color %t%4
title Deleted
echo The folder has been deleted due to 10 unsucessful unlock attempts.
echo.
pause > nul | set /P "=Press any key to exit . . . "

cls
@rmdir /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\temp"
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
del "%USERPROFILE%\AppData\Roaming\ColDogStudios\data.dat"
cls
goto END
::***********************DELETE***********************

::***********************REMOVE***********************
:REMOVE
color %t%C
title /!\ WARNING /!\
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Are you sure you want to delete the folder and all of its contents? [Y,N]
echo.
set /P "dcho=> "
if  /I %dcho%==Y goto FLRM
if  /I %dcho%==N goto CHOICE
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color %t%4
title Error
echo Invalid Choice.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

goto REMOVE

:FLRM
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
@rmdir /S /Q "%locker%"
color %t%A
title Deleting
echo "%locker%" and all of its contents have been deleted.
echo.
pause > nul | set /P "=Press any key to exit . . . "

cls
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\locker.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDogStudios\key.cfg"
del "%USERPROFILE%\AppData\Roaming\ColDogStudios\data.dat"
cls
goto END
::***********************REMOVE***********************

::***********************ABOUT***********************
:ABOUT
color %t%6
title About
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Created By: Collin Laney (ColDog5044). 11/17/21,
echo for a security project in Cybersecurity Class
echo.
echo ColDog Locker Console GitHub:
echo https://github.com/ColDogStudios/ColDog-Locker-Windows
echo.
echo ColDog Studios Official Website:
echo https://coldogstudios.github.io
echo.
pause > nul | set /P "=Press any key to return . . . "

goto CHOICE
::***********************ABOUT***********************

::************************DEV************************
:DEV
color %t%5
title DEV
cls
echo %bar%
echo %line1%
echo %bar%
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo v2.4.0.0
echo "Advancement Update"
echo Date Modified: 2/7/22
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to return . . . "

goto CHOICE
::************************DEV************************

::***********************SYSTEM***********************
:SYSTEM
color %t%9
title System Info
cls
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo                    WINDOWS INFO
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
systeminfo | findstr /c:"OS Name"
systeminfo | findstr /c:"OS Version"
systeminfo | findstr /c:"System Type"
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo                    HARDWARE INFO
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
systeminfo | findstr /c:"Total Physical Memory"
echo.
wmic cpu get name
wmic diskdrive get name,model,size
wmic path win32_videocontroller get name
wmic path win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo                    NETWORK INFO
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
ipconfig | findstr IPv4
ipconfig | findstr IPv6
echo.
pause > nul | set /P "=Press any key to return  . . . "

goto CHOICE
::***********************SYSTEM***********************

::***********************COLDOG***********************
:COLDOG
color %t%1
title ColDog Studios
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Collin Laney (ColDog5044), is a Cybersecurity student that seeks to pursue security and penetrating.
echo  - Developer of ColDog Locker
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo List of certifications:
echo.
echo TestOut - PC Pro
echo TestOut - IT Fundamentals
echo TestOut - Security Pro
echo Cisco - Introduction to Cybersecurity
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Certifications in progress:
echo.
echo TestOut - Linux Pro
echo TestOut - Network Pro
echo TestOut - Ethical Hacker Pro
echo TestOut - CyberDefese Pro
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Other Projects:
echo.
echo ColDog Studios Website:
echo  - https://coldogstudios.github.io
echo.
echo Laney Environmental Website (In progress):
echo  - https://coldog5044.github.io
echo.
echo DJ ColDog:
echo  - https://www.soundcloud.com/dj-coldog
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to return  . . . "

goto CHOICE
::***********************COLDOG***********************

::***********************BOGGS***********************
:BOGGS
color %t%3
title Wayne Boggs
cls
echo %bar%
echo %line1%
echo %line2%
echo %bar%
echo.
echo Mr. Wayne Boggs is the Cybersecurity Instructor. 
echo He has a Bachelor's degree in Business Teacher Education from Ferris State University. 
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo List of certifications:
echo.
echo  - CompTIA IT Fundamentals+
echo  - CompTIA A+
echo  - CompTIA Security+ cd
echo  - Microsoft Technology Associate: Database Administration Fundamentals (MTA)
echo  - Microsoft Technology Associate: Security Fundamentals (MTA)
echo  - Microsoft Technology Associate: Networking Fundamentals (MTA)
echo  - Microsoft Technology Assiciate: Windows Operating System Fundamentals (MTA)
echo  - Microsoft Excel 2016 Certification
echo  - Microsoft PowerPoint 2016 Certification
echo  - Microsoft PowerPoint 2013 Certification
echo  - Microsoft Word 2016 Certification
echo  - Microsoft Word 2013 Certification
echo  - TestOut - PC Pro
echo  - TestOut - Security Pro
echo  - TestOut - Desktop Pro
echo  - TestOut - Linux Pro
echo  - TestOut - Network Pro
echo  - TestOut - Server Pro Install
echo  - Cisco - Instructor 5 Years of Service
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo List of Skills:
echo.
echo  - Database Administration
echo  - Customer Service
echo  - Public Speaking
echo  - Strategic Planning
echo  - Social Media
echo  - Microsoft Office
echo  - Microsoft Excel
echo  - Team Building
echo  - Leadership
echo  - Management
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to return . . . "

goto CHOICE
::***********************BOGGS***********************

::************************END************************
:END
exit /B
