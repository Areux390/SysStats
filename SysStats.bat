@echo off
setlocal enabledelayedexpansion
title Advanced System Specifications Analyzer (Pure Batch)
color 0A

echo ================================================
echo    ADVANCED SYSTEM SPECIFICATIONS ANALYZER
echo         Pure Batch - No External Dependencies
echo         For PC Builders and Developers
echo ================================================
echo.

REM Create output file with timestamp
for /f "tokens=1-6 delims=/:. " %%a in ("%date% %time%") do (
    set "timestamp=%%c-%%a-%%b_%%d-%%e-%%f"
)
set "outputfile=SystemSpecs_%timestamp%.txt"

echo Generating comprehensive system report using native Windows commands...
echo Report will be saved as: %outputfile%
echo.

(
echo ================================================
echo    ADVANCED SYSTEM SPECIFICATIONS REPORT
echo      Generated: %date% %time%
echo      Method: Pure Batch Commands
echo ================================================
echo.

echo [BASIC SYSTEM INFORMATION]
echo =====================================
systeminfo | findstr /C:"Host Name" /C:"OS Name" /C:"OS Version" /C:"System Manufacturer" /C:"System Model" /C:"System Type" /C:"Processor" /C:"Total Physical Memory"
echo.

echo [DETAILED SYSTEM INFO]
echo =====================================
systeminfo
echo.

echo [ENVIRONMENT VARIABLES]
echo =====================================
set
echo.

echo [PROCESSOR INFORMATION]
echo =====================================
echo Processor Details:
reg query "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0" 2>nul
echo.
echo Number of Processors:
echo %NUMBER_OF_PROCESSORS%
echo.

echo [MEMORY INFORMATION]
echo =====================================
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Total Physical Memory"') do echo Total Physical Memory: %%a
for /f "tokens=2 delims=:" %%a in ('systeminfo ^| findstr /C:"Available Physical Memory"') do echo Available Physical Memory: %%a
echo.

echo [DISK DRIVES AND STORAGE]
echo =====================================
echo Drive Information:
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        echo Drive %%d: exists
        dir %%d:\ | findstr /C:"bytes free"
        fsutil fsinfo volumeinfo %%d:\ 2>nul
        echo.
    )
)
echo.

echo [GRAPHICS AND DISPLAY]
echo =====================================
echo Display Mode Information:
mode con
echo.
echo Graphics Driver Information:
driverquery | findstr /i "display\|video\|graphics\|nvidia\|amd\|intel"
echo.

echo [NETWORK CONFIGURATION]
echo =====================================
echo Network Interface Configuration:
ipconfig /all
echo.
echo Network Statistics:
netstat -e
echo.

echo [ACTIVE NETWORK CONNECTIONS]
echo =====================================
netstat -an | findstr ESTABLISHED
echo.

echo [SYSTEM PROCESSES]
echo =====================================
tasklist /fo table
echo.

echo [SYSTEM SERVICES]
echo =====================================
net start
echo.

echo [STARTUP PROGRAMS]
echo =====================================
echo Checking common startup locations...
dir "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup" /b 2>nul
dir "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Startup" /b 2>nul
echo.
echo Registry Startup Entries:
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" 2>nul
reg query "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" 2>nul
echo.

echo [USB DEVICES]
echo =====================================
echo USB Device Information from Registry:
reg query "HKLM\SYSTEM\CurrentControlSet\Enum\USB" /s /f "FriendlyName" /t REG_SZ 2>nul | findstr /i "FriendlyName"
echo.

echo [AUDIO DEVICES]
echo =====================================
echo Audio Device Information:
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio" /s 2>nul | findstr /i "FriendlyName"
echo.

echo [INSTALLED SOFTWARE - DEVELOPMENT TOOLS]
echo =====================================
echo Checking for common development tools...
where git >nul 2>&1 && (
    echo Git: Found
    git --version 2>nul
) || echo Git: Not found
echo.
where node >nul 2>&1 && (
    echo Node.js: Found
    node --version 2>nul
) || echo Node.js: Not found
echo.
where npm >nul 2>&1 && (
    echo NPM: Found
    npm --version 2>nul
) || echo NPM: Not found
echo.
where python >nul 2>&1 && (
    echo Python: Found
    python --version 2>nul
) || echo Python: Not found
echo.
where java >nul 2>&1 && (
    echo Java: Found
    java -version 2>&1 | findstr version
) || echo Java: Not found
echo.
where dotnet >nul 2>&1 && (
    echo .NET: Found
    dotnet --version 2>nul
) || echo .NET: Not found
echo.
where docker >nul 2>&1 && (
    echo Docker: Found
    docker --version 2>nul
) || echo Docker: Not found
echo.

echo [WINDOWS FEATURES]
echo =====================================
dism /online /get-features /format:table 2>nul | findstr /i "Enabled"
echo.

echo [SYSTEM FILE INTEGRITY]
echo =====================================
echo Running system file check verification...
sfc /verifyonly >nul 2>&1
if !errorlevel! equ 0 (
    echo System File Integrity: OK
) else (
    echo System File Integrity: Issues detected - run 'sfc /scannow' as administrator
)
echo.

echo [POWER CONFIGURATION]
echo =====================================
echo Current Power Scheme:
powercfg /getactivescheme 2>nul
echo.
echo Power Capabilities:
powercfg /availablesleepstates 2>nul
echo.

echo [HARDWARE INFORMATION]
echo =====================================
echo Hardware Registry Information:
reg query "HKLM\HARDWARE\DESCRIPTION\System" 2>nul
echo.

echo [SYSTEM UPTIME AND PERFORMANCE]
echo =====================================
echo Boot Time and Uptime:
systeminfo | findstr /C:"System Boot Time" /C:"System Up Time"
echo.

echo [EVENT LOGS - SYSTEM ERRORS]
echo =====================================
echo Recent System Events:
for /f "tokens=*" %%a in ('wevtutil qe System /c:5 /rd:true /f:text /q:"*[System[(Level=1 or Level=2)]]" 2^>nul') do echo %%a
echo.

echo [DRIVER INFORMATION]
echo =====================================
echo Installed Drivers:
driverquery /fo table
echo.

echo [SCHEDULED TASKS]
echo =====================================
echo Active Scheduled Tasks:
schtasks /query /fo table | findstr /V "INFO:"
echo.

echo [FIREWALL STATUS]
echo =====================================
echo Windows Firewall Status:
netsh advfirewall show allprofiles state
echo.

echo [SYSTEM TEMPERATURES - WMIC Alternative]
echo =====================================
echo Temperature monitoring requires third-party tools
echo Common locations to check:
echo - BIOS/UEFI settings
echo - Hardware monitoring software
echo - Manufacturer utilities
echo.

echo [VIRTUALIZATION SUPPORT]
echo =====================================
echo Checking virtualization support:
systeminfo | findstr /C:"Hyper-V"
echo.

echo [FRAME TIME ANALYSIS]
echo =====================================
echo Running DirectX Diagnostics for frame time analysis...
dxdiag /t dxdiag_report.txt
timeout /t 15 /nobreak >nul
if exist dxdiag_report.txt (
    echo DirectX Diagnostic Report:
    type dxdiag_report.txt
    del dxdiag_report.txt
) else (
    echo DirectX diagnostic timeout - may need manual execution
)
echo.

echo [SYSTEM PERFORMANCE SNAPSHOT]
echo =====================================
echo Current System Performance:
typeperf "\Processor(_Total)\%% Processor Time" -sc 1 2>nul
typeperf "\Memory\Available MBytes" -sc 1 2>nul
echo.

echo ================================================
echo Report generation completed: %date% %time%
echo ================================================
) > "%outputfile%"

echo.
echo ================================================
echo REPORT GENERATED SUCCESSFULLY!
echo ================================================
echo File saved as: %outputfile%
echo.

REM Display real-time system information
echo [REAL-TIME SYSTEM STATUS]
echo ================================================
echo Current Date/Time: %date% %time%
echo Computer Name: %COMPUTERNAME%
echo User Name: %USERNAME%
echo Windows Directory: %WINDIR%
echo System Drive: %SYSTEMDRIVE%
echo Architecture: %PROCESSOR_ARCHITECTURE%
echo Number of Processors: %NUMBER_OF_PROCESSORS%
echo.

echo Additional Commands for Real-time Monitoring:
echo ================================================
echo 1. Task Manager: taskmgr
echo 2. Resource Monitor: resmon
echo 3. Performance Monitor: perfmon
echo 4. System Information: msinfo32
echo 5. DirectX Diagnostics: dxdiag
echo 6. Device Manager: devmgmt.msc
echo 7. Disk Management: diskmgmt.msc
echo 8. Event Viewer: eventvwr
echo.

echo Press any key to view the generated report...
pause >nul

REM Open the report file
if exist "%outputfile%" (
    start notepad "%outputfile%"
) else (
    echo Error: Report file was not created successfully.
)

echo.
echo ================================================
echo SYSTEM ANALYSIS COMPLETE
echo ================================================
echo For PC Builders: Review hardware specs, drivers,
echo temperatures, and performance metrics.
echo.
echo For Developers: Check installed tools, system
echo capabilities, services, and environment variables.
echo ================================================
echo.
pause