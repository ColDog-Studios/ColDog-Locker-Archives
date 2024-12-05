@shift /0

:: SETUP
@echo off
prompt $T coldog@$P$G
md "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
md "%USERPROFILE%\AppData\Local\ColDog Studios" && cls
set "vrsn=v3.0.0"
title ColDog Locker %vrsn%
set "bar=----------------------------------------------"
set "cdl=-        ColDog Locker Console %vrsn%        -"
set "cpr=-  (c) ColDog Studios. All rights reserved.  -"
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg") do set failedAttempts=%%x && cls

:: ADVANCEMENT SYSTEM
::if NOT EXIST "%USERPROFILE%\AppData\Local\ColDog Studios\exp.cfg" > "%USERPROFILE%\AppData\Local\ColDog Studios\exp.cfg" echo 0
::attrib +H +S "%USERPROFILE%\AppData\Local\ColDog Studios\exp.cfg"
::for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Local\ColDog Studios\exp.cfg") do set /A lockerStars=%%x
set /A "lockerStars=0"
if "%lockerStars%"=="0"  set "str=-                                            -"
if "%lockerStars%"=="1"  set "str=-                     *                      -"
if "%lockerStars%"=="2"  set "str=-                   *   *                    -"
if "%lockerStars%"=="3"  set "str=-                 *   *   *                  -"
if "%lockerStars%"=="4"  set "str=-               *   *   *   *                -"
if "%lockerStars%"=="5"  set "str=-             *   *   *   *   *              -"
if "%lockerStars%"=="6"  set "str=-           *   *   *   *   *   *            -"
if "%lockerStars%"=="7"  set "str=-         *   *   *   *   *   *   *          -"
if "%lockerStars%"=="8"  set "str=-       *   *   *   *   *   *   *   *        -"
if "%lockerStars%"=="9"  set "str=-     *   *   *   *   *   *   *   *   *      -"
if "%lockerStars%"=="10" set "str=-   *   *   *   *   *   *   *   *   *   *    -"
if EXIST "%USERPROFILE%\AppData\Roaming\ColDog Studios\acceptTerms.dat" goto WELCOME

::DISCLAIMER
:DISCLAIMER
color 03
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo ColDog Studios is committed to keeping your files secure and will fix any security vulnerability as soon as possible.
echo ColDog Studios does not recieve any information from you such as passwords.
echo All of the configuration is stored on your local machine.
echo.
echo  - By using this software, you agree that ColDog Studios is not held liable for any data lost, stolen, or accessed.
echo  - Any unauthorized copying, distributing, or selling of this software is prohibited.
echo  - Do not type any blank or illegal characters into the prompts.
echo.
pause > nul | set /P ="By pressing any key, you agree to the terms above . . ."

fsutil file createnew acceptTerms.dat 420 && cls
move "acceptTerms.dat" "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
cls
goto WELCOME

:: WELCOME
:WELCOME
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\locker.cfg") do set lockerName=%%x
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\key.cfg") do set lockerKey=%%x
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\secCode.cfg") do set secCode=%%x
color 03
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
pause
if EXIST "%USERPROFILE%\AppData\Roaming\ColDog Studios\lock.cfg" goto LOCKOUT
if EXIST "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp" goto UNLOCK
if EXIST %lockerName% goto MENU

:: CONFIG
:CONFIG
color 03
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
set /P "inputLocker=Locker Name: "
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Minimum Password Length: at least 8 characters
echo Recommended Password Length: at least 12 characters
echo.
set "inputPassword1=Powershell -Command "$pword = read-host ' Locker Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /F "usebackq delims=" %%p in (`%inputPassword1%`) do set inputPass1=%%p

set "inputPassword2=Powershell -Command "$pword = read-host 'Confirm Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /F "usebackq delims=" %%q in (`%inputPassword2%`) do set inputPass2=%%q
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
if "%inputPass1:~7%" EQU "" goto BADLENGTH
if "%inputPass2:~7%" EQU "" goto BADLENGTH
if "%inputPass1%"=="%inputPass2%" goto CREATE
if NOT "%inputPass1%"=="%inputPass2%" goto INVALID

:: BADLENGTH
:BADLENGTH
color 04
echo Your Password needs to be at least 8 characters
echo.
pause > nul | set /P ="Press any key to retry . . . "
goto CONFIG

:: INVALID
:INVALID
color 04
echo Name for Folder or Password is Invalid
echo.
pause > nul | set /P ="Press any key to retry . . . "
goto CONFIG

:: CREATE
:CREATE
color 03
fsutil file createnew data.dat 69 && cls
move "data.dat" "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
echo %inputLocker%> "%USERPROFILE%\AppData\Roaming\ColDog Studios\locker.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\locker.cfg"
md "%inputLocker%"
cipher /E "%inputLocker%"
echo %inputPass1%> "%USERPROFILE%\AppData\Roaming\ColDog Studios\key.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\key.cfg"
echo %inputLocker% Created.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
for /F "delims=" %%c in (' powershell "( (1..6) | ForEach-Object { Get-Random -Minimum 0 -Maximum 9 } ) -join {}" ') do set "genCode=%%c"
echo %genCode%> "%USERPROFILE%\AppData\Roaming\ColDog Studios\secCode.cfg"
echo %genCode%> "CDL-Security-Code.txt"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\secCode.cfg"

:CODECHECK
color 03
echo Your Security Code is %genCode%. Save it somewhere safe and secure.
echo.
set inputCode=c
set /P "inputCode=Enter your security code to continue: "
if NOT %genCode%==%inputCode% goto CODEFAIL
goto WELCOME

:CODEFAIL
color 04
echo.
echo Incorrect security code.
echo.
pause > nul | set /P "=Press any key to retry . . . "

cls
goto CODECHECK

:: MENU
:MENU
set mcho="c"
color 03
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo [ 1 ] Lock %lockerName%
echo [ 2 ] Delete %lockerName%
echo [ 3 ] About ColDog Locker
echo [ 4 ] System Information
echo.
set /P "mcho=> "
if /I %mcho%==1 goto LOCK
if /I %mcho%==2 goto REMOVE
if /I %mcho%==3 goto ABOUT
if /I %mcho%==4 goto SYSTEM

:: EEs
if /I %mcho%==dev        goto DEV
if /I %mcho%==ColDog5044 goto COLDOG
if /I %mcho%==Sl66p      goto SL66PY
if /I %mcho%==Boggs      goto BOGGS
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color 04
echo Invalid Choice.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

goto MENU

:: LOCK
:LOCK
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color 02
echo %lockerName% locked.
echo.
pause > nul | set /P "=Press any key to return . . . "

ren "%lockerName%" temp
move temp "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp"
goto WELCOME

:: UNLOCK
:UNLOCK
set unlockPass="pass"
color 03
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo Failed Attempts = %failedAttempts%
echo.
set "unlockPassword=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%unlockPassword%`) do set unlockPass=%%p

if NOT "%unlockPass%"=="%lockerKey%" goto FAIL
if "%unlockPass%"=="%lockerKey%" goto SUCCESS

:: FAIL
:FAIL
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color 04
echo Incorrect Password!
echo.
pause > nul | set /P "=Press any key to retry . . . "

set /A failedAttempts = %failedAttempts%+1
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" && cls
> "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" echo %failedAttempts%
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
if %failedAttempts% == 10 goto PRELOCK
goto UNLOCK

:: SUCCESS
:SUCCESS
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color 02
echo %lockerName% Unlocked.
echo.
pause > nul | set /P "=Press any key to return . . . "

set /A failedAttempts=0
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" && cls
> "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" echo %failedAttempts%
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp"
move "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp" && cls
ren temp "%lockerName%" && cls
cls
goto WELCOME

::LOCKOUT
:PRELOCK
set failedAttempts=0
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" && cls
> "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" echo %failedAttempts%
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
fsutil file createnew lock.cfg 666 && cls
move "lock.cfg" "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\lock.cfg"

:LOCKOUT
color 04
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo You have been locked out from %lockerName% due to multiple password failures.
echo Please input the four digit code you were recieved when creating %lockerName%. You have four attempts.
echo.
echo Failed Attempts = %failedAttempts%
echo.
set /P "inputSecCode=> "
if %inputSecCode%==%SecCode% goto DEMILIT
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color 04
echo Wrong code.
echo. 
pause > nul | set /P "=Press any key to retry . . . "

set /A failedAttempts = %failedAttempts%+1
if %failedAttempts%==4 goto LOCKFAIL
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" && cls
> "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg" echo %failedAttempts%
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
goto LOCKOUT

::DEMILIT
:DEMILIT
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
color 02
echo Correct Code.
echo.
echo You will need to make a new folder and password.
pause
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp"
move "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp" && cls
ren temp "%lockerName%" && cls
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
exit /B

::LOCKFAIL
:LOCKFAIL
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp" && cls
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
@rmdir /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp" && cls
exit /B

:: REMOVE
:REMOVE
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo ColDog Locker configuration has been deleted.
echo. 
pause > nul | set /P "=Press any key to exit . . . "

exit /B

:: ABOUT
:ABOUT
color 03
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo Created By: Collin Laney (ColDog5044). 11/17/21,
echo for a security project in Cybersecurity Class
echo.
echo Assisted by Bryce Slabaugh (Sl66p).
echo.
echo ColDog Locker GitHub:
echo https://github.com/ColDogStudios/ColDog-Locker-Console
echo.
echo ColDog Studios Official Website:
echo https://coldogstudios.github.io
echo.
pause > nul | set /P "=Press any key to return . . . "

goto MENU

:: DEV
:DEV
color 05
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo v3.0.0.1
echo "The New Locker Update"
echo Hotfix update
echo Date Modified: 5/9/22
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to return . . . "

goto MENU

:: SYSTEM
:SYSTEM
color 03
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

goto MENU

:: COLDOG
:COLDOG
color 09
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo Collin Laney (ColDog5044), is a Cybersecurity student that seeks to pursue security and penetration testing.
echo.
echo  - CEO of ColDog Studios
echo  - Founder of ColDog Locker
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo List of certifications:
echo.
echo TestOut - IT Fundamentals
echo TestOut - PC Pro
echo TestOut - Security Pro
echo TestOut - Linux Pro
echo Cisco - Introduction to Cybersecurity
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Certifications in progress:
echo.
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
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to return  . . . "

goto MENU

:: SL66PY
:SL66PY
color 0D
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo Mr. Bryce "Sleep" Slabaugh is a student of Mr. Wayne Boggs at the HACC.
echo Sleep is currently training to reach his "Security Pro" certification, and is wanting to
echo be a penetration tester or database administrator. He also is an assistant developer
echo for ColDog Studios.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo List of certifications:
echo.
echo TestOut - IT Fundamentals
echo TestOut - PC Pro
echo TestOut - Security Pro
echo Cisco - Introduction to Cybersecurity
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Certifications in Progress:
echo.
echo TestOut - Linux Pro
echo TestOut - Network Pro
echo TestOut - Ethical Hacker Pro
echo TestOut - CyberDefese Pro
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P "=Press any key to return  . . . "

goto MENU

:: BOGGS
:BOGGS
color 0C
cls
echo %bar%
echo %str%
echo %cdl%
echo %cpr%
echo %str%
echo %bar%
echo.
echo Mr. Wayne Boggs is the Cybersecurity Instructor at the Hillsdale Area Career Center (HACC). 
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

goto MENU