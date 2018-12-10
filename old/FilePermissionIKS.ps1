
function get-folderInfo {
    param 
    (
        $folderpath,
        $folderdepth
    )
    $primaerFolder = @()
    foreach ($f in (Get-ChildItem -Path $folderpath -Directory -Depth $folderdepth  ))
    {
        $acl = Get-Acl -Path $f.fullname
        foreach ($right in ($acl.access))
        {
            if ($right.IdentityReference -like "INTRA\*")
            {
                $myFolderobject = [PSCustomObject]@{
                    PrimaerFoldername = $f.fullname
                    PrimaerFolderAcl = $right.FileSystemRights
                    PrimaerFolderACLGroup = $right.IdentityReference
                }
                $primaerFolder += $myFolderobject
            }
        }
    }
  $primaerFolder  
    
}

function Get-PermissionFolder {
    param
    (
        $path,
        $Group,
        $FolderPermission,
        $Read,
        $Change
    )
    
$PermissionUser = $null
$PermissionUser = @()

    foreach($member in (Get-ADGroupMember $Group))
    {
        if($member.objectClass -eq "group")
        {
        foreach ($i in (Get-ADGroupMember $member))
        {
            if($i.objectClass -eq "group")
            {
                    foreach($ii in (Get-ADGroupMember $i))
                    {
                        $currentAdUser = $null
                        $currentAdUser = get-aduser $ii.samAccountName -Properties enabled,givenname,surname
                        if( $currentAdUser.enabled) # only activ users
                        {
                        $user = [PSCustomObject]@{
                            # LoginName = $ii.samAccountName
                            DisplayName = $currentAdUser.surname + "," + $currentAdUser.givenname + "(" + $ii.samAccountName + ")"
                            FolderName = $path
                            GroupRight = $Group
                            Rights = $FolderPermission
                            RX = $Read
                            Change = $Change
                            EffectiveGroup = $i.name
                            }
                        $PermissionUser += $user  
                        }
                    }
            }
            else 
            {   
                $currentAdUser = $null
                $currentAdUser = get-aduser $i.samAccountName -Properties enabled,givenname,surname
                        if( $currentAdUser.enabled) # only activ users
                        {
                        $user = [PSCustomObject]@{
                            # LoginName = $i.samAccountName
                            DisplayName = $currentAdUser.surname + "," + $currentAdUser.givenname + "(" + $i.samAccountName + ")"
                            FolderName = $path
                            GroupRight = $Group
                            Rights = $FolderPermission
                            RX = $Read
                            Change = $Change
                            EffectiveGroup = $member.name
                            }
                        $PermissionUser += $user
                        }
                   

                }
            }              
        }
        else {
            $currentAdUser = $null
            $currentAdUser = get-aduser $member.samAccountName -Properties enabled,givenname,surname
               if( $currentAdUser.enabled) # only activ users
                 {
                    $user = [PSCustomObject]@{
                    #LoginName = $member.SamAccountName
                    DisplayName = $currentAdUser.surname + "," + $currentAdUser.givenname + "(" + $member.samAccountName + ")"
                    FolderName = $path
                    GroupRight = $Group
                    Rights = $FolderPermission
                    RX = $Read
                    Change = $Change
                    EffectiveGroup = $member
                    }
                $PermissionUser += $user
                } 
        }

    }
    $PermissionUser
}


#region 
# GUI - START
#----------------------------------------------------------------------------------------------------|
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @" 
   <Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"

        Title="IKS Bericht" Height="314.073" Width="477.689">
        <Grid Margin="0,0,5,31">
        <GroupBox Name="Institut" Header="Institut" Margin="10,28,25,55">
           
            </GroupBox>
            <RadioButton Name="rd_Schulleitung" Content="Schulleitung" HorizontalAlignment="Left" Margin="200,45,0,0" VerticalAlignment="Top" Height="15"/>
            <RadioButton Name="rd_Rektorat" Content="Rektorat" HorizontalAlignment="Left" Margin="200,70,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_ZV" Content="Zentrale Verwaltung" HorizontalAlignment="Left" Margin="200,95,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_Kommision" Content="KommissionF&amp;E" HorizontalAlignment="Left" Margin="200,120,0,0" VerticalAlignment="Top"/>
            
            <RadioButton Name="rd_IS1" Content="IS1" HorizontalAlignment="Left" Margin="60,45,0,0" VerticalAlignment="Top" Height="15"/>
            <RadioButton Name="rd_IHP" Content="IHP" HorizontalAlignment="Left" Margin="60,70,0,0" VerticalAlignment="Top" Height="15"/>
            <RadioButton Name="rd_IFE" Content="IFE" HorizontalAlignment="Left" Margin="60,95,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_IS2" Content="IS2" HorizontalAlignment="Left" Margin="60,120,0,0" VerticalAlignment="Top" Height="15"/>
            <RadioButton Name="rd_VBK" Content="VBK" HorizontalAlignment="Left" Margin="60,145,0,0" VerticalAlignment="Top"/>
            
            <RadioButton Name="rd_IVP" Content="IVP" HorizontalAlignment="Left" Margin="130,45,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_IWM" Content="IWM" HorizontalAlignment="Left" Margin="130,70,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_VGA" Content="VGA" HorizontalAlignment="Left" Margin="130,95,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_IMB" Content="IMB" HorizontalAlignment="Left" Margin="130,120,0,0" VerticalAlignment="Top"/>
            <RadioButton Name="rd_IWB" Content="IWB" HorizontalAlignment="Left" Margin="130,145,0,0" VerticalAlignment="Top"/>
            
            <Button Name="btn_OK" Content="Create" HorizontalAlignment="Left" Margin="351,219,0,0" VerticalAlignment="Top" Width="75"/>
    </Grid>
</Window>
"@ 
# Ende GUI muss separat gesetzt werden https://www.benecke.cloud/powershell-how-to-build-a-gui-with-visual-studio/

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader"; exit}
 
# Store Form Objects In PowerShell
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#Assign event 
$btn_OK.Add_Click({$form.Close()})

#Show Form
$Form.ShowDialog() | out-null

#endregion


# Main

# fill Path to label
$currentdate = Get-Date -Format yyyyMMddhhmm
switch ($true) {
    $rd_IHP.IsChecked { $filename = "C:\temp\IKS\IHP-$currentdate.csv"; $sInstitut = "IHP" }
    $rd_IS1.IsChecked { $filename = "C:\temp\IKS\IS1-$currentdate.csv"; $sInstitut = "IS1" }
    $rd_IS2.IsChecked { $filename = "C:\temp\IKS\IS2-$currentdate.csv"; $sInstitut = "IS2" }
    $rd_IVP.IsChecked { $filename = "C:\temp\IKS\IVP-$currentdate.csv"; $sInstitut = "IVP" }
    $rd_IWM.IsChecked { $filename = "C:\temp\IKS\IWM-$currentdate.csv"; $sInstitut = "IWM" }
    $rd_ZV.IsChecked { $filename = "C:\temp\IKS\ZV-$currentdate.csv"; $sInstitut = "ZV" }
    $rd_Rektorat.IsChecked { $filename = "C:\temp\IKS\Rektorat-$currentdate.csv"; $sInstitut = "Rektorat" }
    $rd_VGA.IsChecked { $filename = "C:\temp\IKS\VGA-$currentdate.csv"; $sInstitut = "VGA" }

    $rd_IMB.IsChecked { $filename = "C:\temp\IKS\IMB-$currentdate.csv"; $sInstitut = "IMB" }
    $rd_IFE.IsChecked { $filename = "C:\temp\IKS\IFE-$currentdate.csv"; $sInstitut = "IFE" }
    $rd_IWB.IsChecked { $filename = "C:\temp\IKS\IWB-$currentdate.csv"; $sInstitut = "IWB" }
    $rd_Kommision.IsChecked { $filename = "C:\temp\IKS\KommissionF&E-$currentdate.csv"; $sInstitut = "Kommission F&E" }
    $rd_Schulleitung.IsChecked { $filename = "C:\temp\IKS\Schulleitung-$currentdate.csv"; $sInstitut = "Schulleitung" }
    $rd_VBK.IsChecked { $filename = "C:\temp\IKS\VBK-$currentdate.csv"; $sInstitut = "VBK" }
    Default {$sInstitut = $null}
}
#region GUI - START
#----------------------------------------------------------------------------------------------------|

# Start Programm
if ($sInstitut -ne $null) {
    
    $pf = get-folderInfo -folderpath "\\srv-file-001\Users\$sInstitut" -folderdepth 1
    foreach ($p in $pf)
{
    if ( $p.PrimaerFolderAcl -eq "ReadAndExecute, Synchronize")
    {
    Get-PermissionFolder -path $p.PrimaerFoldername -Group $p.PrimaerFolderACLGroup.Value.Remove(0,6) -FolderPermission $p.PrimaerFolderAcl -Read "r" -Change "" | export-csv -Path $filename -Append -NoTypeInformation -Encoding UTF8
    }
    else
    {
    Get-PermissionFolder -path $p.PrimaerFoldername -Group $p.PrimaerFolderACLGroup.Value.Remove(0,6) -FolderPermission $p.PrimaerFolderAcl -Read "" -Change "c" | export-csv -Path $filename -Append -NoTypeInformation -Encoding UTF8
    }

}
[System.Windows.MessageBox]::Show("File saved: " + $filename)

}
else {
    [System.Windows.MessageBox]::Show("Choose an Institut, please! Restart program....")
}

