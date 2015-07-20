Function Get-FeaturedGames
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $games = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/observer-mode/rest/featured"
    $games.gameList
}