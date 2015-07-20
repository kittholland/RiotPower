Function Get-LeagueBySummoner
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
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/by-summoner/" -Parameter $ID
}

Function Get-LeagueEntryBySummoner
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
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/by-summoner/" -Parameter $ID -Method '/entry'
}

Function Get-ChallengerLeague
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [ValidateSet('Solo', 'Team3', 'Team5')]
        [Parameter(Mandatory=$true)]
        [string]$LeagueType
    )
    Switch($LeagueType)
    {
        'Solo'
        {
            $type = 'RANKED_SOLO_5x5'
        }
        'Team3'
        {
            $type = 'RANKED_TEAM_3x3'
        }
        'Team5'
        {
            $type = 'RANKED_TEAM_5x5'
        }
    }
    $league = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/challenger" -Query "type=$type&"
    $league.entries
}

Function Get-MasterLeague
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [ValidateSet('Solo', 'Team3', 'Team5')]
        [Parameter(Mandatory=$true)]
        [string]$LeagueType
    )
    Switch($LeagueType)
    {
        'Solo'
        {
            $type = 'RANKED_SOLO_5x5'
        }
        'Team3'
        {
            $type = 'RANKED_TEAM_3x3'
        }
        'Team5'
        {
            $type = 'RANKED_TEAM_5x5'
        }
    }
    $league = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.5/league/master" -Query "type=$type&"
    $league.entries
}