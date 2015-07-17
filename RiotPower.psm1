Function Add-ApiKey
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
        [string]$ApiKey,
        [Parameter(Mandatory=$true,
        ValueFromPipelineByPropertyName=$true)]
        [string]$RateLimit,
        [string]$KeyPath = "$env:USERPROFILE\riotApiKeys.json",
        [switch]$Default,
        [switch]$Current
    )
    If(Test-Path $KeyPath)
    {
        $keys = @(Get-Content -Path $KeyPath -Raw| ConvertFrom-Json)
        $keys += @{
            Name=$Name
            ApiKey=$ApiKey
            RateLimit=$RateLimit
            Default = $Default.IsPresent
            Current = $Current.IsPresent
        }
        $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
    }
    Else
    {
        $keys = @(
            @{
                Name = $Name
                ApiKey = $ApiKey
                RateLimit = $RateLimit
                Default = $true
                Current = $true
            }
        )
        $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
    }
}

Function Get-ApiKey
{
    [CmdletBinding()]
    Param
    (
        [string]$Name,
        [string]$ApiKey,
        [switch]$Current,
        [switch]$Default,
        [string]$KeyPath = "$env:USERPROFILE\riotApiKeys.json"
    )
    If(-Not(Test-Path -Path $KeyPath))
    {
        Write-Error -Message 'Could not locate apikey file specified, please use Add-ApiKey command.'
    }
    Else
    {
        $keys = Get-Content -Path $KeyPath -Raw | ConvertFrom-Json
        If($Current)
        {
            $keys | Where-Object {$_.Current -eq 'True'}
        }
        ElseIf($Default)
        {
            $keys | Where-Object {$_.Default -eq 'True'}
        }
        ElseIf($Name -and $ApiKey)
        {
            $keys | Where-Object {$_.Name -eq $Name -and $_.ApiKey -eq $ApiKey}
        }
        ElseIf($Name)
        {
            $keys | Where-Object {$_.Name -eq $Name}
        }
        ElseIf($ApiKey)
        {
            $keys | Where-Object {$_.ApiKey -eq $ApiKey}
        }
        Else
        {
            $keys
        }
    }
}

Function Get-SummonerByName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$SummonerName,
        [string]$Region = 'na'
    )
    $OFS = ','
    $ApiKey = Get-ApiKey -Current
    If($ApiKey)
    {
        $key = $ApiKey.ApiKey
        $response = Invoke-RestMethod -Method Get -Uri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/by-name/$SummonerName`?api_key=$key"
        If($response)
        {
            Return $response
        }
        Else
        {
            Write-Error -Message 'No response received'
        }
    }
    Else
    {
        Write-Error -Message 'Error loading ApiKey'
    }
}


Function Get-SummonerByID
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$SummonerID,
        [string]$Region = 'na'
    )
    $OFS = ','
    $ApiKey = Get-ApiKey -Current
    If($ApiKey)
    {
        $key = $ApiKey.ApiKey
        $response = Invoke-RestMethod -Method Get -Uri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/$SummonerID`?api_key=$key"
        If($response)
        {
            Return $response
        }
        Else
        {
            Write-Error -Message 'No response received'
        }
    }
    Else
    {
        Write-Error -Message 'Error loading ApiKey'
    }
}

Function Get-SummonerIDbyName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$SummonerName,
        [string]$Region = 'na'
    )
    $summonerID = @()
    $summoners = Get-SummonerByName -SummonerName $SummonerName
    Foreach($summoner in $SummonerName)
    {
        $summoners.$summoner.id
    }
}

Function Get-SummonerMasteries
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='summonerID')]
        [string[]]$SummonerID,
        [Parameter(Mandatory=$true,
        ParameterSetName='summonerName')]
        [string[]]$SummonerName,
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'summonerName')
    {
        $summonerID = Get-SummonerIDbyName -SummonerName $SummonerName
    }
    $OFS = ','
    $ApiKey = Get-ApiKey -Current
    If($ApiKey)
    {
        $key = $ApiKey.ApiKey
        $response = Invoke-RestMethod -Method Get -Uri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/$SummonerID/masteries`?api_key=$key"
        If($response)
        {
            Return $response
        }
        Else
        {
            Write-Error -Message 'No response received'
        }
    }
    Else
    {
        Write-Error -Message 'Error loading ApiKey'
    }
}
