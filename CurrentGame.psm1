Function Get-CurrentGame
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
    Switch($region)
    {
        'BR'
        {
            $platformID = 'BR1'
        }
        'EUNE'
        {
            $platformID = 'EUN1'
        }
        'EUW'
        {
            $platformID = 'EUW1'
        }
        'KR'
        {
            $platformID = 'KR1'
        }
        'LAN'
        {
            $platformID = 'LA1'
        }
        'LAS'
        {
            $platformID = 'LA2'
        }
        'NA'
        {
            $platformID = 'NA1'
        }
        'OCE'
        {
            $platformID = 'OC1'
        }
        'RU'
        {
            $platformID = 'RU'
        }
        'TR'
        {
            $platformID = 'TR1'
        }
    }
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
        $result = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/observer-mode/rest/consumer/getSpectatorGameInfo/$platformID/" -Parameter $summonerID.id
        $result | Add-Member -MemberType NoteProperty -Name Name -Value $summonerID.Name
        $result
    }
}