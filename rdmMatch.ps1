[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]$ComputerName
)
    
begin {
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] - Entering Begin Block."
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] - Exiting Begin Block."
}
    
process {
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] - Entering Process Block."
    try {
        $vmdisk = Get-HardDisk -VM $ComputerName | Where-Object {$_.ScsiCanonicalName -ne $null} | Select-Object ScsiCanonicalName, Name
        $windowsDisk = Get-PhysicalDisk -CimSession $ComputerName
        $vmDisk | ForEach-Object {
            $currentDiskSerial = $_.ScsiCanonicalName.Replace("naa.", "")
            $matchWindowsDrive = $windowsDisk | Where-Object {$_.UniqueID -eq $currentDiskSerial}

            $vmDiskObj = [PSCustomObject][Ordered] @{
                computerName    = $computerName
                winFriendlyName = $matchWindowsDrive.FriendlyName
                vmwareName      = $_.Name
            }
            Write-Output $vmDiskObj
        } #end foreach
    } #end try block
    catch {
        Write-Error -Message "There was an error attempting to associate the drives.  Error: $_"
    } #end catch block
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] - Exiting Process Block."
} #end process block
    
end {
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] - Entering End Block."
    Write-Verbose -Message "[$($MyInvocation.MyCommand.Name)] - Exiting End Block."
}
