
#Get the vCenter
cls
$vCenter = Read-Host "Enter the vCenter host"
Connect-VIServer $vCenter


function Show-Menu
{
     cls
     Write-Host "====================================================" 
     Write-Host "==== Welcome to $vCenter DVS-2-VSS Menu " 
     Write-Host "1: Press '1' for Converting DVS to VSS"
     Write-Host "2: Press '2' for Converting VSS to DVS"
     Write-Host "3: Press '3' to quit"
     Write-Host "====================================================" 

}


function DVS-2-VSS {

    $ESXiHost = Read-Host "Enter the ESXi host"
    $DVSwitch = Get-VMHost -Name $ESXiHost | Get-VDSwitch
    Write-Host "List of DVS  on host $ESXiHOST" 
    Write-Host "$DVSwitch"
    $source = Read-Host "Enter Distributed Switch name"
    $VSSwitch = Get-VMHost -Name $ESXiHost | Get-VirtualSwitch -standard
    Write-Host "List of VSS on host $ESXiHOST" 
    Write-Host "$VSSwitch"
    $destination = Read-Host "Enter stadanrd switch name"

  #Get the destination vSwitch
    $destSwitch = Get-VirtualSwitch -host $ESXiHost -name $destination
  #Get a list of all port groups on the source distributed vSwitch
    $allPGs = get-vmhost $ESXiHost | get-vdswitch -name $source | get-vdportgroup
    foreach ($thisPG in $allPGs) 
    {
      new-virtualportgroup -virtualswitch $destSwitch -name $thisPG.Name
      #Ensure that we don't try to tag an untagged VLAN
      if ($thisPG.vlanconfiguration.vlanid)
      {
       get-virtualportgroup -virtualswitch $destSwitch -name $thisPG.Name | Set-VirtualPortGroup -vlanid $thisPG.vlanconfiguration.vlanid
      }
    } 
    Read-Host "Convert is done. Please press enter to go to main menu"
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                DVS-2-VSS
           } '2' {
                cls
                'You chose option #2'
           } '3' {
                 Disconnect-VIServer * -confirm:$false
                 Write-Host " "
                 Write-Host "==== Thank you for using DVS-2-VSS ========" 
                 return
           } 
     }
}
until ($input -eq '3')








