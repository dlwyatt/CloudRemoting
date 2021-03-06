CloudRemoting PowerShell module
===============================

[![Build status](https://ci.appveyor.com/api/projects/status/kdc6a75b8wludjq6?svg=true)](https://ci.appveyor.com/project/muratiakos/cloudremoting)
[![Join the chat at https://gitter.im/murati-hu/CloudRemoting](https://badges.gitter.im/murati-hu/CloudRemoting.svg)](https://gitter.im/murati-hu/CloudRemoting?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

CloudRemoting module provides an easy and scriptable way to connect to EC2, Azure
or to other machines via RDP, PSRemoting and SSM sessions on top of the standard
cmdlets by:
 - Seamless EC2 Administrator Credential decryption for RDP and PSRemoting
 - Credential pass-through for RDP Sessions
 - Pipeline integrated SSM Run Command execution

## Installation
CloudRemoting is available via [PowerShellGallery][PowerShellGallery] and via
[PsGet][psget], so you can simply install it with the following command:
```powershell
# Install it from PowerShell Gallery with PS5 / psget.net for older PS versions
Install-Module CloudRemoting

# Or install it directly from this repository with psget.net
psget\Install-Module -ModuleUrl -ModuleUrl https://github.com/murati-hu/CloudRemoting/archive/latest.zip
```
Of course you can download and install the module manually too from
[Downloads][download]

## Usage
```powershell
Import-Module CloudRemoting
```

## Few Examples
### Integrated SSM Command execution
AWS SSM Run-command allows us to execute scripts against EC2 Instances from anywhere
without direct network connectivity to the targets.
`Invoke-SSMCommand` is an extension on top of the standard `Send-SSMCommand` to make
this task even easier and fully integrate this feature to PowerShell pipelines.
```powershell
# Execute scripts with SSM Run Command similarly as Invoke-Command
Get-Ec2Instance i-2492acfc | Invoke-SSMCommand { iisreset }

# Execute SSM alias, with a CLI serialized command via S3 output
Set-DefaultSSMOutput -BucketName 'ssm-outputs' -KeyPrefix 'logs/'
Get-Ec2Instance i-2492acfc | ssm { Get-WebSite } -EnableCliXml | Select Name,InstanceId
```
![ssm_command](https://cloud.githubusercontent.com/assets/2268036/20460497/82df7c0e-af49-11e6-93f3-acdea3d9aa8c.gif)


### Enter an EC2 Admin RDP Session with Private-Key file
You can use the `Enter-EC2RdpSession` cmdlet or its `ec2rdp` alias to connect to any EC2 instance as an administrator via RDP.
```powershell
Get-Ec2Instance i-2492acfc | Enter-EC2RdpSession -PemFile '~/.ssh/myprivatekey.pem'
```
![ec2_rdp_session](https://cloud.githubusercontent.com/assets/2268036/14919383/ae1d3438-0e7c-11e6-9026-d995fb2deb50.gif)


### Open EC2 Admin PSSessions with Private-Key
Similarly to the native `PSSession` cmdlets, you can use the `New-EC2PSSession` and `Enter-EC2RdpSession` commands to create or enter to any EC2 PSSession as an administrator:
```powershell
# Enter to a single EC2 PSSession
Get-Ec2Instance i-2492acfc | Enter-EC2PSSession -PemFile '~/.ssh/myprivatekey.pem'

# Set Default EC2 PemFile and create multiple EC2 PSSessions
Set-DefaultEC2PemFile -PemFile '~/.ssh/myprivatekey.pem'
Get-Ec2Instance -Filter @{name='tag:env'; value='demo'} | New-EC2PSSession
```
![ec2_multiple_pssession](https://cloud.githubusercontent.com/assets/2268036/14919352/8a8cb82c-0e7c-11e6-9260-23a0fa4dd912.gif)

Please note that all EC2 cmdlets rely on the official [`AWSPowershell`][AWSPowershell] module.
It expects the module to be installed with valid AWS credentials setup.


### RemoteDesktop to any machine
In order to connect to any machine via RDP, you can simply call `Enter-RdpSession` cmdlet or its `rdp` alias.
```powershell
# Connect an RDP Session to any machine
$c = Get-EC2Credential # Or retrieve from a persisted creds
Enter-RdpSession -ComputerName '207.47.222.251' -Credential $c
```

## Documentation
Cmdlets and functions for CloudRemoting have their own help PowerShell help, which
you can read with `help <cmdlet-name>`.

## Versioning
CloudRemoting aims to adhere to [Semantic Versioning 2.0.0][semver].

## Issues
In case of any issues, raise an [issue ticket][issues] in this repository and/or
feel free to contribute to this project if you have a possible fix for it.

## Development
* Source hosted at [Github.com][repo]
* Report issues/questions/feature requests on [Github Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the [repo][repo]
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors
Created and maintained by [Akos Murati][muratiakos] (<akos@murati.hu>).

## License
Apache License, Version 2.0 (see [LICENSE][LICENSE])

[repo]: https://github.com/murati-hu/CloudRemoting
[issues]: https://github.com/murati-hu/CloudRemoting/issues
[muratiakos]: http://murati.hu
[license]: LICENSE
[semver]: http://semver.org/
[psget]: http://psget.net/
[download]: https://github.com/murati-hu/CloudRemoting/archive/latest.zip
[PowerShellGallery]: https://www.powershellgallery.com
[AWSPowershell]: https://aws.amazon.com/powershell
