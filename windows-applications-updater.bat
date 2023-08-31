@ECHO OFF

: Code source: https://stackoverflow.com/a/10052222
: Prompts the user to grant the script Administrator Access.
: The script must run with Administrator Access to prevent each indivdual application installer/updater from prompting the user for consent.
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

: Script start

ECHO Updating update tool "winget"...
ECHO;
: Documentation source: https://learn.microsoft.com/en-us/windows/package-manager/winget/upgrade
winget upgrade --silent --force --id Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
ECHO;
ECHO Updating applications...
ECHO;
: Documentation source: https://learn.microsoft.com/en-us/windows/package-manager/winget/upgrade
winget upgrade --silent --accept-package-agreements --accept-source-agreements --all --include-unknown --force --disable-interactivity
ECHO;
ECHO Finished installing all available updates.
TIMEOUT /t 10