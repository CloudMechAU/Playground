Start-Transcript -Path "$env:WINDIR\Temp\AssignedAccess-viaWMIBridge-Enable.txt" -Append

#Target MDM_AssignedAccess and apply XML
function EnableKiosk {
  $nameSpaceName="root\cimv2\mdm\dmmap"
  $className="MDM_AssignedAccess"
  $obj = Get-CimInstance -Namespace $namespaceName -ClassName $className
  $obj.Configuration = Get-Content -Path "LockdownProfile.xml" -Raw

  $obj.Configuration = $obj.Configuration -replace "<", "&lt;"
  $obj.Configuration = $obj.Configuration -replace ">", "&gt;"

  Set-CimInstance -CimInstance $obj
}

#Set Registry Value 
function SetReg {
  $regpath = "HKLM:Software"
  $regname = "KioskProfile"
  $regvalue = "Enabled"
  New-ItemProperty –Path $regpath –Name $regname –PropertyType String –Value $regvalue
  $verifyValue = Get-ItemProperty –Path $regpath –Name $regname
  Write-Host "The $regName named value is set to: " $verifyValue.$regname
}

#Logic
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Set-Location $dir

EnableKiosk
SetReg

Stop-Transcript
