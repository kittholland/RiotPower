Function Get-Summoner
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/by-name/" -Parameter $Name
    }
    If($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID
    }
}

Function Get-SummonerIDbyName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $ID = @()
    $summoners = Get-Summoner -Name $Name -Region $Region
    $summoners.id
}

Function Get-SummonerMasteries
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name -Region $Region
    }
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID -Method '/masteries'
}

Function Get-SummonerRunes
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name -Region $Region
    }
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID -Method '/runes'
}

Function Get-SummonerNamebyId
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name -Region $Region
    }
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID -Method '/name'
}