Function Get-RankedStats
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
    $results = @()
    Foreach($summonerID in $summoner)
    {
        $result = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.3/stats/by-summoner/" -Parameter $summonerID.id -Method '/ranked'
        $result | Add-Member -MemberType NoteProperty -Name Name -Value $summonerID.Name
        $result
    }
}

Function Get-Stats
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
    $results = @()
    Foreach($summonerID in $summoner)
    {
        $result = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.3/stats/by-summoner/" -Parameter $summonerID.id -Method '/summary'
        $result | Add-Member -MemberType NoteProperty -Name Name -Value $summonerID.Name
        $result
    }
}