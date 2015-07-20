Function Get-Team
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='SummonerID')]
        [string[]]$SummonerID,
        [Parameter(Mandatory=$true,
        ParameterSetName='SummonerName')]
        [string[]]$SummonerName,
        [Parameter(Mandatory=$true,
        ParameterSetName='TeamID')]
        [string[]]$TeamID,
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'SummonerName')
    {
        $summonerID = Get-Summoner -Name $SummonerName -Region $Region | Select-Object -ExpandProperty id
    }
    If($PSCmdlet.ParameterSetName -eq 'TeamID')
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.4/team/" -Parameter $TeamID
    }
    Else
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.4/team/by-summoner/" -Parameter $SummonerID
    }
}
