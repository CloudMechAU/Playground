Start-Transcript -Path "$env:WINDIR\Temp\AssignedAccess-viaWMIBridge-Disable.txt" -Append

#Target MDM_AssignedAccess class and overwrite existing configuration to $null
function DisableKiosk {
  $nameSpaceName="root\cimv2\mdm\dmmap"
  $className="MDM_AssignedAccess"
  $obj = Get-CimInstance -Namespace $namespaceName -ClassName $className
  $objConfiguration = $obj.Configuration
  Write-Host "Current configuration set to: $objConfiguration"
  $obj.Configuration = $NULL
  Write-Host "Configuration set to $null"
}

function Remove-RegistryKeyValue {
[CmdletBinding(SupportsShouldProcess=$True,
    ConfirmImpact='Medium',
    DefaultParameterSetName='DelValue')]
    Param (
        [Parameter(ParameterSetName = 'DelValue', Position=0, Mandatory=$True, ValueFromPipelineByPropertyName=$True)]
        [parameter(ParameterSetName = 'DelKey', Position=0, ValueFromPipelineByPropertyName=$True)]
        [alias('Hive')]
        [ValidateSet('ClassesRoot', 'CurrentUser', 'LocalMachine', 'Users', 'CurrentConfig')]
        [String]$RegistryHive = 'LocalMachine',

        [Parameter(ParameterSetName = 'DelValue', Position=1, Mandatory=$True, ValueFromPipelineByPropertyName=$True)]
        [parameter(ParameterSetName = 'DelKey', Position=1, ValueFromPipelineByPropertyName=$True)]
        [alias('ParentKeypath')]
        [String]$RegistryKeyPath,

        [parameter(ParameterSetName = 'DelKey',Position=2, Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [String[]]$ChildKey,
    
        [parameter(ParameterSetName = 'DelValue',Position=3, Mandatory=$True, ValueFromPipelineByPropertyName=$true)]
        [String[]]$ValueName
    )
    Begin {
        $RegistryRoot= "[{0}]::{1}" -f 'Microsoft.Win32.RegistryHive', $RegistryHive
        try {
            $RegistryHive = Invoke-Expression $RegistryRoot -ErrorAction Stop
        }
        catch {
            Write-Host "Incorrect Registry Hive mentioned, $RegistryHive does not exist" 
        }
    }
    Process {
        try {
            $reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($RegistryHive, $Computer)
            $key = $reg.OpenSubKey($RegistryKeyPath, $true)
        }
        catch {
            Write-Host "Check permissions on computer name $Computer, cannot connect registry" -BackgroundColor DarkRed
            Continue
        }
        switch ($PsCmdlet.ParameterSetName) {
            'DelValue' {
                foreach ($regvalue in $ValueName) {
                    if ($key.GetValueNames() -contains $regvalue) {
                        [void]$key.DeleteValue($regvalue)
                    }
                    else {
                        Write-Host "Registry value name $regvalue doesn't exist under path $RegistryKeyPath" -BackgroundColor DarkRed
                    }
                }
                break
            }
            'DelKey' {
                foreach ($regkey in $ChildKey) {
                    if ($key.GetSubKeyNames() -contains $regkey) {
                        [void]$Key.DeleteSubKey("$regkey")
                    }
                    else {
                        Write-Host "Registry key $regKey doesn't exist under path $RegistryKeyPath" -BackgroundColor DarkRed
                    }
                }
                break
            }
        }
    }
    End {
        #[Microsoft.Win32.RegistryHive]::ClassesRoot
        #[Microsoft.Win32.RegistryHive]::CurrentUser
        #[Microsoft.Win32.RegistryHive]::LocalMachine
        #[Microsoft.Win32.RegistryHive]::Users
        #[Microsoft.Win32.RegistryHive]::CurrentConfig
    }
}
#Example usage of Remove-RegistryKeyValue function
#Remove-RegistryKeyValue -RegistryHive LocalMachine -RegistryKeyPath SYSTEM\DemoKey -ChildKey test1, test2
#Remove-RegistryKeyValue -RegistryHive LocalMachine -RegistryKeyPath SYSTEM\DemoKey -ValueName start, exp

#Logic
DisableKiosk
Remove-RegistryKeyValue -RegistryHive LocalMachine -RegistryKeyPath SOFTWARE -ValueName KioskProfile

Stop-Transcript
