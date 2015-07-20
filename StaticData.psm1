Function Get-StaticChampionData
{
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [Parameter(ParameterSetName='Name')]
        [string[]]$Name,
        [Parameter(ParameterSetName='ID')]
        [string[]]$ID
    )
    $results = @()
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/champion"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $results += $entries.data.$entry
    }
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Foreach($item in $name)
        {
            $results | Where-Object {$_.name -eq $item}
        }
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Foreach($item in $id)
        {
            $results | Where-Object {$_.id -eq $item}
        }
    }
    Else
    {
        $results
    }
}

Function Get-StaticItemData
{
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [Parameter(ParameterSetName='Name')]
        [string[]]$Name,
        [Parameter(ParameterSetName='ID')]
        [string[]]$ID
    )
    $results = @()
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/item"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $results += $entries.data.$entry
    }
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Foreach($item in $name)
        {
            $results | Where-Object {$_.name -eq $item}
        }
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Foreach($item in $id)
        {
            $results | Where-Object {$_.id -eq $item}
        }
    }
    Else
    {
        $results
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
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [Parameter(ParameterSetName='Name')]
        [string[]]$Name,
        [Parameter(ParameterSetName='ID')]
        [string[]]$ID
    )
    $results = @()
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/mastery"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $results += $entries.data.$entry
    }
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Foreach($item in $name)
        {
            $results | Where-Object {$_.name -eq $item}
        }
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Foreach($item in $id)
        {
            $results | Where-Object {$_.id -eq $item}
        }
    }
    Else
    {
        $results
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
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [Parameter(ParameterSetName='Name')]
        [string[]]$Name,
        [Parameter(ParameterSetName='ID')]
        [string[]]$ID
    )
    $results = @()
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/rune"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $results += $entries.data.$entry
    }
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Foreach($item in $name)
        {
            $results | Where-Object {$_.name -eq $item}
        }
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Foreach($item in $id)
        {
            $results | Where-Object {$_.id -eq $item}
        }
    }
    Else
    {
        $results
    }
}

Function Get-StaticSummonerSpellData
{
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na',
        [Parameter(ParameterSetName='Name')]
        [string[]]$Name,
        [Parameter(ParameterSetName='ID')]
        [string[]]$ID
    )
    $results = @()
    $entries = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/static-data/$Region/v1.2/summoner-spell"
    Foreach ($entry in ($entries.data | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name))
    {
        $results += $entries.data.$entry
    }
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Foreach($item in $name)
        {
            $results | Where-Object {$_.name -eq $item}
        }
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Foreach($item in $id)
        {
            $results | Where-Object {$_.id -eq $item}
        }
    }
    Else
    {
        $results
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