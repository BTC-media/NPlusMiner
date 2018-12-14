if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1; RegisterLoaded(".\Include.ps1")}
 
$Path = ".\Bin\NVIDIA-Bminer\bminer.exe"
$Uri = "https://www.bminercontent.com/releases/bminer-lite-v10.7.0-31ee7bc-CUDA-9.2-amd64.zip"
$Commands = [PSCustomObject]@{
    #"equihashBTG" = " -uri zhash://" #EquihashBTG(testing)
    #"equihash" = " -uri stratum://" #Equihash(fastest)
    #"equihash144" = " -pers auto -uri equihash1445://" #Equihash144(testing)
    #"zhash" = " -pers auto -uri equihash1445://" #Zhash(testing)
    #"ethash" = " -uri ethstratum://" #Ethash(testing 2080)
}
$Port = $Variables.NVIDIAMinerAPITCPPort
$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = " -api 127.0.0.1:$Port -nofee -uri stratum://$($Pools.(Get-Algorithm($_)).User):$($Pools.(Get-Algorithm($_)).Pass.ToString().replace(',','%2C'))@$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Week} 
        API = "Bminer"
        Port = $Port
        Wrap = $false
        URI = $Uri    
        User = $Pools.(Get-Algorithm($_)).User
        Host = $Pools.(Get-Algorithm $_).Host
        Coin = $Pools.(Get-Algorithm $_).Coin
    }
}
