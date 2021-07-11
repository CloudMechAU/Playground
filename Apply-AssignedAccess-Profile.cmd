cd /D "%~dp0"
PsExec.exe -accepteula -i -d -s PowerShell.exe -noexit -executionpolicy bypass -file "%~dp0\Configure-AssignedAccess-WMIBridge.ps1" 2> %WINDIR%\Temp\AssignedAccessLog-WMIBridge.txt
