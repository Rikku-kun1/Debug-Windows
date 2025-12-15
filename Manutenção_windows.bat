@echo off
title Ferramenta Profissional de Manutencao do Windows
color 0A
setlocal EnableExtensions EnableDelayedExpansion

:: ADMIN
net session >nul 2>&1 || (
    echo Execute como ADMINISTRADOR!
    pause
    exit /b
)

:: LOG
if not exist "C:\ManutencaoLogs" mkdir C:\ManutencaoLogs
for /f %%i in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set DATA=%%i
set LOG=C:\ManutencaoLogs\Manutencao_%DATA%.log

echo ==== MANUTENCAO INICIADA ==== > "%LOG%"

:MENU
cls
echo ==========================================
echo   FERRAMENTA DE MANUTENCAO - WINDOWS
echo ==========================================
echo.
echo [1] Limpeza Completa
echo [2] Correcao do Sistema (SFC + DISM)
echo [3] Correcao de Disco (CHKDSK)
echo [4] Otimizacao Geral
echo [5] MANUTENCAO TOTAL
echo [6] Visualizar Log
echo [7] Criar ponto de Restauracao do Sistema
echo [8] Informacoes do Sistema
echo [0] Sair
echo.
set /p op=Escolha uma opcao:

if "%op%"=="1" call :LIMPEZA
if "%op%"=="2" call :CORRECAO
if "%op%"=="3" call :DISCO
if "%op%"=="4" call :OTIMIZA
if "%op%"=="5" call :TUDO
if "%op%"=="6" call :VIEWLOG
if "%op%"=="7" call :CREATEPOINT
if "%op%"=="8" call :INFOSYS
if "%op%"=="0" exit
goto MENU

:LIMPEZA
echo === LIMPEZA === >> "%LOG%"
del /f /s /q "%TEMP%\*" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
cleanmgr /sagerun:1 >nul 2>&1
ipconfig /flushdns >nul
echo Limpeza concluida >> "%LOG%"
pause
exit /b

:CORRECAO
echo === CORRECAO DO SISTEMA === >> "%LOG%"
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
echo Correcao concluida >> "%LOG%"
pause
exit /b

:DISCO
echo === CHKDSK === >> "%LOG%"
echo Y | chkdsk C: /f /r
echo CHKDSK agendado >> "%LOG%"
pause
exit /b

:OTIMIZA
echo === OTIMIZACAO === >> "%LOG%"
for /f %%i in ('powershell -command "(Get-PhysicalDisk | Where DeviceId -eq 0).MediaType"') do set DISCO=%%i

if /I "!DISCO!"=="SSD" (
    echo SSD detectado - TRIM >> "%LOG%"
    defrag C: /L
) else (
    echo HD detectado - Desfragmentando >> "%LOG%"
    defrag C: /O /U /V
)

powercfg -setactive SCHEME_MIN
netsh winsock reset >nul
netsh int ip reset >nul
echo Otimizacao concluida >> "%LOG%"
pause
exit /b

:VIEWLOG
echo ===== LOGS RECENTES =====
dir "C:\ManutencaoLogs" /OD /B
pause
exit /b

:CREATEPOINT
echo ==========================================
echo   CRIANDO PONTO DE RESTAURACAO
echo ==========================================
echo.

for /f %%i in ('powershell -command "Get-Date -Format yyyyMMdd_HHmmss"') do set DATA=%%i
set LOG_POINT=C:\ManutencaoLogs\PontoRestauracao_%DATA%.log

echo Criando ponto de restauracao...
echo Inicio: %date% %time% > "%LOG_POINT%"

powershell -command "Checkpoint-Computer -Description 'Ponto_Manutencao_Windows' -RestorePointType MODIFY_SETTINGS" >> "%LOG_POINT%" 2>&1

if %errorlevel%==0 (
    echo Ponto de restauracao criado com sucesso!
    echo Sucesso >> "%LOG_POINT%"
) else (
    echo Falha ao criar ponto de restauracao.
    echo Erro >> "%LOG_POINT%"
)

echo.
echo ==========================================
echo   PROCESSO FINALIZADO
echo   LOG: %LOG_POINT%
echo ==========================================
pause
exit /b

:INFOSYS
echo ==== INFORMACOES DO SISTEMA ====
echo.
:: Exibe informações principais na tela
systeminfo | findstr /B /C:"Nome do host" /C:"Nome do sistema operacional" /C:"Versao do SO" /C:"Fabricante" /C:"Tipo de sistema"

:: Registra no log
echo ==== INFORMACOES DO SISTEMA ==== >> "%LOG%"
systeminfo | findstr /B /C:"Nome do host" /C:"Nome do sistema operacional" /C:"Versao do SO" /C:"Fabricante" /C:"Tipo de sistema" /C:"Domínio" /C:"Memória física total" >> "%LOG%"

echo.
pause
exit /b

:TUDO
powershell -command "Checkpoint-Computer -Description 'Manutencao_Completa' -RestorePointType MODIFY_SETTINGS" >> "%LOG%" 2>&1
call :LIMPEZA
call :CORRECAO
call :DISCO
call :OTIMIZA
echo MANUTENCAO TOTAL FINALIZADA >> "%LOG%"
pause
exit /b
