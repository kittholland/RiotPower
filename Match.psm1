Function Get-Match
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [Parameter(Mandatory=$true)]
        [string[]]$MatchID
    )
    Foreach($match in $MatchID)
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v2.2/match/$match/"
    }
}