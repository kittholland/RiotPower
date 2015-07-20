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
        $summoner = Get-Summoner -Name $Name -Region $Region
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        $summoner = Get-Summoner -ID $ID -Region $Region
    }
    $results = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $summoner.id -Method '/masteries'
    Foreach($result in $results)
    {
        $summonerName = $summoner | Where-Object {$_.id -eq $result.summonerId} | Select-Object -ExpandProperty Name
        $result | Add-Member -MemberType NoteProperty -Name Name -Value $summonerName
        $result
    }
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
        $summoner = Get-Summoner -Name $Name -Region $Region
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        $summoner = Get-Summoner -ID $ID -Region $Region
    }
    $results = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $summoner.id -Method '/runes'
    Foreach($result in $results)
    {
        $summonerName = $summoner | Where-Object {$_.id -eq $result.summonerId} | Select-Object -ExpandProperty Name
        $result | Add-Member -MemberType NoteProperty -Name Name -Value $summonerName
        $result
    }
}