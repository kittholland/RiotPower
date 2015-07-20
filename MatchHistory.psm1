Function Get-MatchHistory
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
        $result = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.2/matchhistory/" -Parameter $summonerID.id
        $result | Add-Member -MemberType NoteProperty -Name name -Value $summonerID.name
        $result | Add-Member -MemberType NoteProperty -Name id -Value $summonerID.id
        $result
    }
}
