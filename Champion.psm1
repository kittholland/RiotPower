Function Get-Champions
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('br', 'eune', 'euw', 'kr', 'lan', 'las', 'na', 'oce', 'ru', 'tr')]
        [string]$Region = 'na'
    )
    $champions = Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.2/champion"
    $championData = Get-StaticChampionData -Region $Region
    Foreach($champion in $champions.champions)
    {
        $championName = $championData | Where-Object {$_.id -eq $champion.id} | Select-Object -ExpandProperty name
        $champion | Add-Member -MemberType NoteProperty -Name 'Name' -Value $championName
        $champion
    }
}

Function Get-Champion
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
    $champions = Get-Champions
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Foreach($championName in $Name)
        {
            $champions | Where-Object {$_.name -eq $championName}
        }
    }
    ElseIf($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Foreach($championID in $ID)
        {
            $champions | Where-Object {$_.id -eq $championID}
        }
    }
}