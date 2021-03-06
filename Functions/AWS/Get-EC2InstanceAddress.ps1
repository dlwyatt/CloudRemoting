<#
.SYNOPSIS
    Returns all or a prefered address from an EC2 Instance
.DESCRIPTION
    The cmdlet accepts pipeline input of EC2 instances.

    If -AddressProperty is defined, it returns only that, otherwise it returns
    all. The valid addresses are:
     - PrivateIpAddress
     - PublicIpAddress
     - PrivateDnsName
     - PublicDnsName

.PARAMETER InstanceObject
    Mandatory - Ec2 Instance Object to get the addresses from
.PARAMETER AddressProperty
    Optional - Name of the Address property to be filtered

.EXAMPLE
    Get-Ec2Instance i-2492acfc  | Select -ExpandProperty Instances | Get-EC2InstanceAddress
.EXAMPLE
    Get-Ec2Instance i-2492acfc  | Select -ExpandProperty Instances | Get-EC2InstanceAddress -AddressProperty PublicDnsName
#>
function Get-EC2InstanceAddress {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [Amazon.EC2.Model.Instance]$InstanceObject,

        [Parameter()]
        [ValidateSet($null,'PrivateIpAddress','PublicIpAddress','PrivateDnsName','PublicDnsName')]
        [string]$AddressProperty
    )
    if ($InstanceObject) {
        if ($AddressProperty) {
            Write-Verbose "Address filtering for '$AddressProperty'"
            $InstanceObject.$AddressProperty
        } else {
            Write-Verbose "Returning unfiltered addresses"
            $InstanceObject.PrivateIpAddress
            $InstanceObject.PublicIpAddress
            $InstanceObject.PrivateDnsName
            $InstanceObject.PublicDnsName
            $InstanceObject.Tags | Where-Object Key -eq ComputerName | Select-Object -ExpandProperty Value
        }
    }
}
