Function Get-RecentGames
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Foreach($summoner in $id)
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.3/game/by-summoner/" -Parameter $summoner -Method '/recent'
    }
}