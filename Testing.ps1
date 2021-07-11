$nameSpaceName="root\cimv2\mdm\dmmap"
$className="MDM_AssignedAccess"
$obj = Get-CimInstance -Namespace $namespaceName -ClassName $className
Add-Type -AssemblyName System.Web
$obj.Configuration = [System.Web.HttpUtility]::HtmlEncode(@"
<?xml version="1.0" encoding="utf-8" ?>
<AssignedAccessConfiguration
    xmlns="http://schemas.microsoft.com/AssignedAccess/2017/config"
    xmlns:v2="http://schemas.microsoft.com/AssignedAccess/201810/config"
    xmlns:v3="http://schemas.microsoft.com/AssignedAccess/2020/config"
>
    <Profiles>
        <Profile Id="{9A2A490F-10F6-4764-974A-43B19E722C23}">
            <AllAppsList>
                <AllowedApps>
                    <App AppUserModelId="MSEdge" />
                    <App AppUserModelId="Microsoft.Windows.Explorer" />
                    <App DesktopAppPath="%SystemRoot%\system32\notepad.exe" />
                    <App DesktopAppPath="{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" />
                </AllowedApps>
            </AllAppsList>
            <v2:FileExplorerNamespaceRestrictions>
                <!--<v2:AllowedNamespace Name="Downloads"/>-->
                <v3:AllowRemovableDrives/>
            </v2:FileExplorerNamespaceRestrictions>
            <StartLayout><!--
                <![CDATA[<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
                    <LayoutOptions StartTileGroupCellWidth="6" />
                        <DefaultLayoutOverride>
                            <StartLayoutCollection>
                                <defaultlayout:StartLayout GroupCellWidth="6">
                                    <start:Group Name="Examinations">
                                        <start:DesktopApplicationTile Size="2x2" Column="4" Row="0" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
                                        <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" />
                                        <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Acrobat Reader DC.lnk" />
                                        <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk" />
                                    </start:Group>
                                </defaultlayout:StartLayout>
                            </StartLayoutCollection>
                        </DefaultLayoutOverride>
                    </LayoutModificationTemplate>
                ]]>-->
            </StartLayout>
            <Taskbar ShowTaskbar="false"/>
        </Profile>
    </Profiles>
    <Configs>
        <v3:GlobalProfile Id="{9A2A490F-10F6-4764-974A-43B19E722C23}"/>
        <Config>
            <AutoLogonAccount v2:DisplayName="Examinations"/>
            <DefaultProfile Id="{9A2A490F-10F6-4764-974A-43B19E722C23}"/>
        </Config>
    </Configs>
</AssignedAccessConfiguration>
"@)

Set-CimInstance -CimInstance $obj
