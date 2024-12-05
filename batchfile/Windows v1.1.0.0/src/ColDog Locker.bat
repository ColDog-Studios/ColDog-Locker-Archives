@shift /0

:: ==============================================
:: SETUP
:: ==============================================
@echo off
setlocal enabledelayedexpansion

:: CDL constant variables
set "vrsn=v1.1.0"
set "dateMod=9/9/2022"
set "cdlDIR=%PROGRAMFILES(X86)%\ColDog Studios\ColDog Locker"
set "RoamingData=%AppData%\ColDog Studios\ColDog Locker"
set "LocalData=%LocalAppData%\ColDog Studios\ColDog Locker"
title ColDog Locker %vrsn%

:: Create CDS & CDL folder locations if not already existing
if not exist "%USERPROFILE%\AppData\Roaming\ColDog Studio\ColDog Locker" md "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker"
if not exist "%USERPROFILE%\AppData\Local\ColDog Studios\ColDog Locker" md "%USERPROFILE%\AppData\Local\ColDog Studios\ColDog Locker"
if not exist "%USERPROFILE%\Documents\ColDog Locker" md "%USERPROFILE%\Documents\ColDog Locker"

cd %cdlDIR% && cd data

:: Encryption/Decryption Arrays
set "charSet=abcdefghijklmnopqrstuvwxyz1234567890@#$*(.,- \/"
set i=0
for %%a in (
    Q268B 386OI 2H1O6 HI839 2Y886 35I00 80B3I O86I9
    899YY 73Y4L 7V6U7 V05M9 79YK4 F2A84 G6V72 7T23U
    9X975 U02Z2 09YN3 A43L3 N7746 N7746 03IK3 P570F
    4E016 33BH5 A6651 ML563 5M5E3 6042V 9J30S 8T2Y6
    B7923 16S8B H2293 5J548 M873U 564KT CG039 92KA7
    1T2Y3 GM988 99YS3 S181M 9784T 17ML2 F8830 T15Q1
    C6R74 60Z4X 389ZH 45HS8 ) do (
   for %%i in (!i!) do for /F "delims=" %%c in ("!charSet:~%%i,1!") do (
      set "ENC[%%c]=%%a"
      set "DEC[%%a]=%%c"
   )
   set /A i+=1
)

:: ==============================================
:: MAIN MENU
:: ==============================================
:MENU

:: Security Code Decryption
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\secCode.cfg") do set "secCode=%%x"

:: Get Failed Attempts, if in Lockout, goto correct block
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg") do set "failedAttempts=%%x"
if exist "%USERPROFILE%\AppData\Roaming\ColDog Studios\lock.cfg" goto LOCKOUT

:: Get Folder Name
for /F "usebackq delims=" %%x in ("%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\locker.cfg") do set "lockerName=%%x"

:: Password Decryption
if exist "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\key.cfg" do (
    set /p inputDecrypt=< "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\key.cfg"
    set passDecrypt=%inputDecrypt%
    set "lockerKey="
    :passDecrypt
        set "lockerKey=%lockerKey%!DEC[%passDecrypt:~0,5%]!"
        set "passDecrypt=%passDecrypt:~5%"
    if defined passDecrypt goto passDecrypt
)

set menuSelection=na
cls

:: Load CDL Menu Bar
call MenuBar menuOptions f0 _Box _Hover

::Enabling Mouse Interaction
GetInput /M %_BOx% /H 70

:: Get chosen Menu Option
call MenuBarClick.bat %Errorlevel% menuOption subMenuOption
set "menuSelection=%menuOption%x%subMenuOption%"

:: File
if /i "%menuSelection%" == "1x0" goto MENU
if /i "%menuSelection%" == "1x1" goto CONFIG
if /i "%menuSelection%" == "1x2" goto REMOVE
if /i "%menuSelection%" == "1x3" exit /b

:: Home
if /i "%menuSelection%" == "2x0" goto MENU
if /i "%menuSelection%" == "2x1" start https://ColDogStudios.github.io && goto MENU
if /i "%menuSelection%" == "2x2" start https://github.com/ColDogStudios && goto MENU

:: ColDog Locker
if /i "%menuSelection%" == "3x0" goto MENU
if /i "%menuSelection%" == "3x1" goto LOCK 
if /i "%menuSelection%" == "3x2" goto UNLOCK

:: Tools
if /i "%menuSelection%" == "4x0" goto MENU
if /i "%menuSelection%" == "4x1" goto SYSINFO
if /i "%menuSelection%" == "4x2" goto CUSTOM-INPUT

:: Help
if /i "%menuSelection%" == "5x0" goto MENU
if /i "%menuSelection%" == "5x1" goto ABOUT
if /i "%menuSelection%" == "5x2" goto FAQ
if /i "%menuSelection%" == "5x3" goto HOW-TO
if /i "%menuSelection%" == "5x4" goto UPDATES

goto :MENU

:: ==============================================
:: FILE MENU OPTIONS
:: ==============================================

:: New Folder Creation
:CONFIG
if not exist "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\locker.cfg" goto NEWFOLDER
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('A folder has already been created.', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Exclamation);}"
goto MENU

:NEWFOLDER
echo.
echo.
echo.
set /p "inputLocker=Locker Name: "
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Minimum Password Length: at least 8 characters
echo Recommended Password Length: at least 12 characters
echo.
set "inputPassword1=Powershell -Command "$pword = read-host ' Locker Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%inputPassword1%`) do set inputPass1=%%p

set "inputPassword2=Powershell -Command "$pword = read-host 'Confirm Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%q in (`%inputPassword2%`) do set inputPass2=%%q
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
if "%inputPass1:~7%" EQU "" goto BADLENGTH
if "%inputPass1%"=="%inputPass2%" goto CREATE
if not "%inputPass1%"=="%inputPass2%" goto NOMATCH

:NOMATCH
echo Passwords do not match
echo.
pause > nul | set /P ="Press any key to retry . . . "
goto CONFIG && cls

:BADLENGTH
echo Your Password needs to be at least 8 characters
echo.
pause > nul | set /P ="Press any key to retry . . . "
goto CONFIG && cls

:CREATE
echo %inputLocker% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\locker.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\locker.cfg"
md "%USERPROFILE%\Documents\ColDog Locker\%inputLocker%"
cipher /E "%USERPROFILE%\Documents\ColDog Locker\%inputLocker%"

:: Password Encryption
set passEncrypt=%inputPass1%
set "encryptOut="
:passEncrypt
    set "encryptOut=%encryptOut%!ENC[%passEncrypt:~0,1%]!"
    set "passEncrypt=%passEncrypt:~1%"
if defined passEncrypt goto passEncrypt
echo %encryptOut% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\key.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\key.cfg"

fsutil file createnew data.dat 69
move "data.dat" "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker" && cls

:: Security Code Generation
for /F "delims=" %%c in (' powershell "( (1..6) | ForEach-Object { Get-Random -Minimum 0 -Maximum 9 } ) -join {}" ') do set "genCode=%%c"

:: Security Code Encryption 



echo %genCode% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\secCode.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\secCode.cfg"
echo %genCode% > "%USERPROFILE%\Documents\ColDog Locker\CDL-Security-Code.txt"
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('The Security Code for %inputLocker% is %genCode%' + [System.Environment]::NewLine + 'Store the code somewhere safe', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Warning);}"
goto MENU

:: ==============================================

:: Remove Current Folder
:REMOVE
if exist "%USERPROFILE%\Appdata\Roaming\ColDog Studios\ColDog Locker\temp" goto RMWARN
if exist "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\locker.cfg" goto RMCONFIG
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('There is no configuration to remove', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Exclamation);}"
goto MENU

:RMWARN
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Confirm you want to delete ColDog Locker configuration' + [System.Environment]::NewLine + [System.Environment]::NewLine +'Warning, if you choose YES while %lockerName% is locked, you will remove all contents inside of %lockerName% and its contents will be unrecoverable.', 'ColDog Locker', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\rmOut.tmp
set /p rmOut=<%TEMP%\rmOut.tmp
if %rmOut% == Yes goto RM-YES
if %rmOut% == No goto MENU

:RMCONFIG
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Confirm you want to delete ColDog Locker configuration', 'ColDog Locker', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\rmOut.tmp
set /p rmOut=<%TEMP%\rmOut.tmp
if %rmOut% == Yes goto RM-YES
if %rmOut% == No goto MENU

:RM-YES
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker" && cls
rmdir /Q /S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp" && cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('ColDog Locker configuration deleted', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto MENU

:: ==============================================
:: CDL MENU OPTIONS
:: ==============================================

:: Lock Folder
:LOCK
if exist "%USERPROFILE%\Documents\ColDog Locker\%lockerName%" goto FDLOCK
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('There is no folder to lock', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Exclamation);}"
goto MENU

:FDLOCK
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Confirm you want to lock %lockerName%', 'ColDog Locker', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\lkOut.tmp
set /p lkOut=<%TEMP%\lkOut.tmp
if %lkOut% == Yes goto FDLOCK-YES
if %lkOut% == No goto MENU

:FDLOCK-YES
ren "%USERPROFILE%\Documents\ColDog Locker\%lockerName%" temp
move "%USERPROFILE%\Documents\ColDog Locker\temp" "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker" && cls
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp"
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('%lockerName% has been locked', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto MENU

:: ==============================================

:: Unlock Folder
:UNLOCK
if exist "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp" goto FDUNLOCK
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('There is no folder to unlock', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Exclamation);}"
goto MENU

:FDUNLOCK
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Confirm you want to unlock %lockerName%', 'ColDog Locker', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %TEMP%\unlkOut.tmp
set /p unlkOut=<%TEMP%\unlkOut.tmp
if %unlkOut% == Yes goto FDUNLOCK-YES
if %unlkOut% == No goto MENU

:FDUNLOCK-YES
cls
set unlockPass="pass"
echo %lockerKey%
echo %passDecrypt%
echo Failed Attempts = %failedAttempts%
echo.
set "unlockPassword=powershell -Command "$pword = read-host 'Enter Password' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%unlockPassword%`) do set unlockPass=%%p

if not "%unlockPass%"=="%lockerKey%" goto FAIL
if "%unlockPass%"=="%lockerKey%" goto SUCCESS

:: FAIL
:FAIL
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Incorrect Password', 'ColDog Locker', 'Retry', [System.Windows.Forms.MessageBoxIcon]::Error);}" > %TEMP%\psOut.tmp
set /p psOut=<%TEMP%\psOut.tmp
if %psOut% == Cancel goto MENU
set /A failedAttempts = %failedAttempts%+1
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
echo %failedAttempts% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
if %failedAttempts% == 10 goto PRELOCK
goto FDUNLOCK-YES

:: SUCCESS
:SUCCESS
set /A failedAttempts=0
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
echo %failedAttempts% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp"
move "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp" "%USERPROFILE%\Documents\ColDog Locker"
ren "%USERPROFILE%\Documents\ColDog Locker\temp" "%lockerName%"
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('%lockerName% has been unlocked', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto MENU

::LOCKOUT
:PRELOCK
set failedAttempts=0
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
echo %failedAttempts% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\fat.cfg"
fsutil file createnew lock.cfg 666
move "lock.cfg" "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\lock.cfg"
cls

:LOCKOUT
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have been locked out from %lockerName% due to multiple password failures.' + [System.Environment]::NewLine + [System.Environment]::NewLine + 'Please input the six digit code you were recieved when creating %lockerName%.' + [System.Environment]::NewLine + [System.Environment]::NewLine + 'You have four attempts.', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Error);}"
cls
powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Failed Attempts = %failedAttempts%', 'ColDog Locker')}" > %TEMP%\inputOut.tmp
set /p inputSecCode=<%TEMP%\inputOut.tmp

if %inputSecCode%==%secCode% goto DEMILIT

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Incorrect Code', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Warning);}"

set /A failedAttempts = %failedAttempts%+1
if %failedAttempts%==4 goto LOCKFAIL
attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
del /S /Q "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
echo %failedAttempts% > "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
attrib +H +S "%USERPROFILE%\AppData\Roaming\ColDog Studios\fat.cfg"
goto LOCKOUT

::DEMILIT
:DEMILIT
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Correct Code' + [System.Environment]::NewLine + 'You will need to create a new folder', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"

attrib -H -S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker temp"
move "%USERPROFILE%\AppData\Roaming\ColDog Studios\temp" && cls
ren temp "%lockerName%" && cls
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios" && cls
goto MENU

::LOCKFAIL
:LOCKFAIL
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp"
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker"
rmdir /Q /S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp"
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('%lockerName% and its contents have been deleted', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Error);}"
goto MENU

:: ==============================================
:: TOOLS MENU OPTIONS
:: ==============================================

:: View System Info
:SYSINFO
echo.
echo.
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo                    SYSTEM INFO
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
systeminfo | findstr /c:"Host Name"
systeminfo | findstr /c:"OS Name"
systeminfo | findstr /c:"OS Version"
systeminfo | findstr /c:"Registered Owner"
systeminfo | findstr /c:"Registered Organization"
systeminfo | findstr /c:"Product ID"
systeminfo | findstr /c:"Original Install Date"
echo.
systeminfo | findstr /c:"System Boot Time"
systeminfo | findstr /c:"System Manufacturer"
systeminfo | findstr /c:"System Model"
systeminfo | findstr /c:"System Type"
echo.
systeminfo | findstr /c:"BIOS Version"
systeminfo | findstr /c:"Time Zone"
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo                    HARDWARE INFO
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo Memory
echo ---------------
systeminfo | findstr /c:"Total Physical Memory"
systeminfo | findstr /c:"Available Physical Memory"
echo.
echo CPU
echo ---------------
wmic cpu get name
echo.
echo Drives
echo ---------------
wmic diskdrive get name,model,size
echo.
echo GPU
echo ---------------
wmic path win32_VideoController get name,CurrentRefreshRate
wmic path win32_VideoController get CurrentHorizontalResolution,CurrentVerticalResolution
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
echo                    NETWORK INFO
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
ipconfig | findstr /c:"IPv4 Address"
echo.
ipconfig /all | findstr /c:"Physical Address"
echo.
pause > nul | set /P ="Press any key to return  . . . "
goto MENU

:: ==============================================

:: Custom Input
:CUSTOM-INPUT
powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Enter your command', 'ColDog Locker Input')}" > %TEMP%\inputOut.tmp
set /p inputOut=<%TEMP%\inputOut.tmp

if /i %inputOut% == DEV goto DEV
if /i %inputOut% == DeleteAllCFG goto DeleteAllCFG
if /i %inputOut% == ColDog goto COLDOG
if /i %inputOut% == ColDog5044 goto COLDOG
if /i %inputOut% == BOGGS goto BOGGS
if /i %inputOut% == SnareMaster goto RR

powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Input was unable to find any results for %inputOut%', 'ColDog Locker Input', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Error);}"
goto MENU

:DEV
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'ColDog Locker', 'You found an Easter Egg - DEV Menu.', [System.Windows.Forms.ToolTipIcon]::None)}"
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Current Version: %vrsn%' + [System.Environment]::NewLine + 'Date Modified: %dateMod%' + [System.Environment]::NewLine + [System.Environment]::NewLine + 'Version Name: The GUI Release', 'ColDog Locker DEV', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto MENU

:DeleteAllCFG
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Confirm you want to FULLY remove ALL configuration', 'ColDog Locker', 'YesNo', [System.Windows.Forms.MessageBoxIcon]::Warning);}" > %temp%\frm.tmp
set /p frm=<%temp%\frm.tmp
if %frm% == No goto MENU

del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp"
del /Q /A "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker"
rmdir /Q /S "%USERPROFILE%\AppData\Roaming\ColDog Studios\ColDog Locker\temp"
del /Q /A "%USERPROFILE%\AppData\Local\ColDog Studios\ColDog Locker"
rmdir /Q /S "%USERPROFILE%\AppData\Local\ColDog Studios\ColDog Locker\temp"
cls
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('ColDog Locker configuration is fully removed', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Warning);}"
goto MENU

:COLDOG
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'ColDog Locker', 'You found an Easter Egg - ColDog Menu.', [System.Windows.Forms.ToolTipIcon]::None)}"
echo.
echo.
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
echo OSHA 10-Hour General Industry
echo The Recreational UAS Safety Test (TRUST) Completion
echo.
echo. https://www.linkedin.com/in/collin-laney/
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
echo DJ ColDog:
echo  - https://coldogstudios.github.io/projects/dj-coldog/
echo  - https://www.soundcloud.com/dj-coldog
echo.
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo.
pause > nul | set /P ="Press any key to return  . . . "
goto MENU

:BOGGS
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'ColDog Locker', 'You found an Easter Egg - Boggs Menu.', [System.Windows.Forms.ToolTipIcon]::None)}"
echo.
echo.
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
pause > nul | set /P ="Press any key to return . . . "
goto MENU

:RR
start https://www.youtube.com/watch?v=dQw4w9WgXcQ
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Rick Astley', 'You have been Rick Rolled', [System.Windows.Forms.ToolTipIcon]::None)}"
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You got Rick Rolled', 'Rick Astley', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto RR

:: ==============================================
:: HELP MENU OPTIONS
:: ==============================================

:: About Pop-Up
:ABOUT
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Copyright 2022 ColDog Studios. All Rights Reserved' + [System.Environment]::NewLine + 'Created by Collin Laney (ColDog5044) 11/17/21' + [System.Environment]::NewLine + 'Taught by W. Boggs', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto MENU

:: ==============================================

:: Frequently Asked Questions
:FAQ
start https://github.com/ColDogStudios/ColDog-Locker-Windows/blob/CDS/docs/FAQ.md
goto MENU

:: How to Use
:HOW-TO
start https://github.com/ColDogStudios/ColDog-Locker-Windows/blob/CDS/docs/how-to.md
goto MENU

:: ==============================================

:: Check for updates
:UPDATES
bitsadmin.exe /transfer "MyTask" "https://coldogstudios.github.io/projects/coldog-locker/windows/gui-latest.txt" "%cd%\LatestVersion.txt" && cls
for /F "usebackq delims=" %%v in ("LatestVersion.txt") do set "lvrsn=%%v"
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Current Version: %vrsn%' + [System.Environment]::NewLine + 'Latest Version: %lvrsn%', 'ColDog Locker', 'Ok', [System.Windows.Forms.MessageBoxIcon]::Information);}"
goto MENU
