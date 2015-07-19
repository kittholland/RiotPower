Function Get-Champions
{
    [CmdletBinding()]
    Param
    (
        [string]$Region = 'na'
    )
    $champions = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.2/champion"
    $champions.champions
}