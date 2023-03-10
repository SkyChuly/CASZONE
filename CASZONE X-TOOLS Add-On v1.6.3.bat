@echo off
mode con:cols=65 lines=20
title CASZONE X-TOOLS Add-On v1.6.3 (개발자:김인철)
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Run as Administrator...
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    rem del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin


echo ========================================================================


:MENU
echo.
echo.
echo ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
echo.
echo        X-TOOLS Add-On 인증서 관리 (개발자:김인철)
echo.
echo ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
echo.
echo.

if exist "%~dp0\GPKI" (
echo.
echo 인증서 복원
echo.
echo "%~dp0\GPKI"
echo.
echo 백업으로 진행 할려면..
echo 해당 폴더에 있는 파일을 모두 제거 후 프로그램을 다시 실행해주세요.
echo.
echo 현재 폴더의 인증서 파일로 ♥복원을 진행합니다.
call :MsgBox "현재 폴더의 인증서 파일로 ♥복원을 진행합니다."  "VBOKOnly" "CASZONE X-TOOLS Add-On v1.6.3 (개발자:김인철)"
echo.
timeout -t 3
echo.
  goto AFTER
  ) else (
echo.
echo 인증서 백업
echo.
echo 윈도우 사용자 계정 폴더에 백업을 진행합니다.
echo 백업경로 "%userprofile%\#인증서"
echo.
call :MsgBox "인증서 백업을 진행합니다."  "VBOKOnly" "CASZONE X-TOOLS Add-On v1.6.3 (개발자:김인철)"
echo.
timeout -t 3
echo.
  goto BEFORE
  )
if end


:MsgBox prompt type title
setlocal enableextensions
set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
>"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
endlocal & exit /b %exitCode%


echo ========================================================================


:BEFORE
c:
cd\
cls

echo.
echo.
echo ─────────────────────────
echo 기존 PC 사용자 공인인증서 백업
echo ─────────────────────────
echo.
echo.

call :MsgBox "GPKI 및 NPKI 인증서 백업을 진행합니다."  "VBYesNo+VBQuestion" "CASZONE X-TOOLS Add-On v1.6.3 (개발자:김인철)"
 if errorlevel 7 (
  echo NO - 프로그램 종료
   goto END
 ) else if errorlevel 6 (
  echo YES - 인증서 백업 진행
   goto BEFOREYES
 )
   exit /b


:MsgBox prompt type title
setlocal enableextensions
set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
>"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
endlocal & exit /b %exitCode%


echo ========================================================================


:BEFOREYES

rd /s /q "%userprofile%\#인증서"

md "%userprofile%\#인증서"

c:
cd\
cd "%userprofile%\#인증서"

set folder="%userprofile%\#인증서"
echo ─────────────────────────

md "%folder%\GPKI"
md "%folder%\NPKI_program\NPKI"
md "%folder%\NPKI_appdata\NPKI"

xcopy "%systemdrive%\GPKI" "%folder%\GPKI" /e /h /k /y
xcopy "%programfiles%\NPKI" "%folder%\NPKI_program\NPKI" /e /h /k /y
xcopy "%userprofile%\AppData\LocalLow\NPKI" "%folder%\NPKI_appdata\NPKI" /e /h /k /y

:: E 비어 있는 경우를 포함하여 디렉터리와 하위 디렉터리를 복사합니다.
:: H 숨겨진 파일과 시스템 파일도 복사합니다.
:: K 특성을 복사합니다. 일반적인 Xcopy는 읽기 전용 특성을 다시 설정합니다.
:: Y 기존 대상 파일을 덮어쓸지 여부를 묻지 않습니다.

md "%folder%\%DATE%\GPKI"
md "%folder%\%DATE%\NPKI_program\NPKI"
md "%folder%\%DATE%\NPKI_appdata\NPKI"

robocopy /MIR /ZB /XO /XA:H /R:1 /W:1 /V /NJH /NJS /TEE "%systemdrive%\GPKI" "%folder%\%DATE%\GPKI"
robocopy /MIR /ZB /XO /XA:H /R:1 /W:1 /V /NJH /NJS /TEE "%programfiles%\NPKI" "%folder%\%DATE%\NPKI_program\NPKI"
robocopy /MIR /ZB /XO /XA:H /R:1 /W:1 /V /NJH /NJS /TEE "%userprofile%\AppData\LocalLow\NPKI" "%folder%\%DATE%\NPKI_appdata\NPKI"

copy /y "%~dp0\인증서 관리*.cmd" "%folder%"

copy /y "%~dp0\7za.exe" "%folder%"

"%~dp0\7za.exe" a -tzip "%userprofile%\#인증서_%DATE%.zip" "%folder%"

md "%userprofile%\#인증서\#인증서백업완료"

move /y "%userprofile%\#인증서_%DATE%.zip" "%userprofile%\#인증서\#인증서백업완료"

echo "#인증서.zip 파일을 압축 해제 후 프로그램 실행하세요" >  "%folder%\꼭 읽어보세요.txt"

echo GPKI 및 NPKI 인증서 백업이 완료 되었습니다.
call :MsgBox "GPKI 및 NPKI 인증서 백업이 완료 되었습니다."

%SystemRoot%\explorer.exe /n, /e, "%userprofile%\#인증서\#인증서백업완료"

goto END


echo ========================================================================


:AFTER
cls

echo.
echo.
echo ─────────────────────────
echo 새 PC 에서 사용자 인증서 복원
echo ─────────────────────────
echo.
echo.
echo 윈도우 바탕화면 #인증서 폴더의 인증서 파일로 ♥복원을 진행합니다.
echo.
echo.
echo 백업을 진행 할려면
echo 바탕화면에 #인증서 폴더를 제거 후 프로그램을 다시 실행해주세요.
echo.
echo.
echo.
call :MsgBox "GPKI 및 NPKI 인증서 복원을 진행합니다."  "VBYesNo+VBQuestion" "CASZONE X-TOOLS Add-On v1.6.3 (개발자:김인철)"
 if errorlevel 7 (
  echo NO - 프로그램 종료
   goto END
 ) else if errorlevel 6 (
  echo YES - 인증서 복원 진행
   goto AFTERYES
 )
   exit /b


:MsgBox prompt type title
setlocal enableextensions
set "tempFile=%temp%\%~nx0.%random%%random%%random%vbs.tmp"
>"%tempFile%" echo(WScript.Quit msgBox("%~1",%~2,"%~3") & cscript //nologo //e:vbscript "%tempFile%"
set "exitCode=%errorlevel%" & del "%tempFile%" >nul 2>nul
endlocal & exit /b %exitCode%


echo ========================================================================


:AFTERYES
c:
cd\
cd %~dp0

md "%systemdrive%\GPKI"
md "%programfiles%\NPKI"
md "%userprofile%\AppData\LocalLow\NPKI"

xcopy "%~dp0\GPKI" "%systemdrive%\GPKI" /e /h /k /y
xcopy "%~dp0\NPKI_program\NPKI" "%programfiles%\NPKI" /e /h /k /y
xcopy "%~dp0\NPKI_appdata\NPKI" "%userprofile%\AppData\LocalLow\NPKI" /e /h /k /y

echo GPKI 및 NPKI 인증서 복원이 완료 되었습니다.
call :MsgBox "GPKI 및 NPKI 인증서 복원이 완료 되었습니다."

goto END
echo.

:END
exit
echo.
