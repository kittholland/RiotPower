Function Get-StaticChampionData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $results = @()
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/champion"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $results += $entries.data.$entry
    }
    $results
}

Function Get-StaticItemData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/item"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $entries.data.$entry
    }
}

Function Get-StaticLanguageStringsData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/language-strings"
}

Function Get-StaticLanguagesData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/languages"
}

Function Get-StaticMapData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/map"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $entries.data.$entry
    }
}

Function Get-StaticMasteryData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/mastery"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $entries.data.$entry
    }
}

Function Get-StaticRealmData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/realm"
}

Function Get-StaticRuneData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/rune"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $entries.data.$entry
    }
}

Function Get-StaticSummonerSpellData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/summoner-spell"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $entries.data.$entry
    }
}

Function Get-StaticVersionData
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/versions"
}