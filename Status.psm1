Function Get-Status
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region
    )
    If($Region)
    {
        Invoke-RestMethod -Uri "http://status.leagueoflegends.com/shards/$Region"
    }
    Else
    {
        Invoke-RestMethod -Uri "http://status.leagueoflegends.com/shards"
    }
}