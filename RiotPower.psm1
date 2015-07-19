Function Add-ApiKey
{
<#   
  .SYNOPSIS    
    Add an ApiKey to your local keystore for subsequent commands. Key is stored in your Windows profile.  
  .PARAMETER Name
   Name of your ApiKey for ease selecting later. (Dev, Prod, App1 etc.)
  .PARAMETER ApiKey
   The key you are adding.
  .PARAMETER RateLimit
   The rate limit for your API key measured in requests per 10 seconds. Default is 10.
  .PARAMETER Default
   Adding this parameter will set this key as your default for future sessions.
  .PARAMETER Current
   Adding this parameter will set this key as the current key to use for this session.
  .EXAMPLE   
   Add-ApiKey -Name 'Dev' -ApiKey df4750ee-8b33-4975-9d8a-a52c481fae3d -RateLimit 100 -Default
#>  

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
        [switch]$Default,
        [switch]$Current
    )
    $KeyPath = "$env:USERPROFILE\riotApiKeys.json"
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
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [Parameter(ParameterSetName='Name')]
        [string]$Name,
        [Parameter(ParameterSetName='ApiKey')]
        [string]$ApiKey,
        [Parameter(ParameterSetName='Current')]
        [switch]$Current,
        [Parameter(ParameterSetName='Default')]
        [switch]$Default
    )
    $KeyPath = "$env:USERPROFILE\riotApiKeys.json"
    If(-Not(Test-Path -Path $KeyPath))
    {
        Write-Error -Message 'Could not locate apikey file specified, please use Add-ApiKey command.'
    }
    Else
    {
        $keys = Get-Content -Path $KeyPath -Raw | ConvertFrom-Json
        Switch($PSCmdlet.ParameterSetName)
        {
            'Current'
            {
                $keys | Where-Object {$_.Current -eq 'True'}
            }
            'Default'
            {
                $keys | Where-Object {$_.Default -eq 'True'}
            }
            'Name'
            {
                $keys | Where-Object {$_.Name -eq $Name}
            }
            'ApiKey'
            {
                $keys | Where-Object {$_.ApiKey -eq $ApiKey}
            }
            'None'
            {
                $keys
            }
        }
    }
}

Function Invoke-RiotRestMethod
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [Uri]$BaseUri,
        [String[]]$Parameter,
        [String]$Method
    )
    $OFS = ','
    If(-Not($script:ApiRequests))
    {
        $script:ApiRequests = @()
    }
    $ApiKey = Get-ApiKey -Current
    $rateLimit = $apikey.RateLimit
    $key = $ApiKey.ApiKey
    If($Parameter.Count -gt 40)
    {
        $response = @()
        $arrays = Split-Array -inArray $Parameter -size 40
        Foreach($array in $arrays)
        {
            If($script:ApiRequests)
            {
                While($script:ApiRequests[-$rateLimit] -gt (Get-Date).AddSeconds(-10))
                {
                    Start-Sleep -Seconds 1
                }
            }
            $script:ApiRequests += Get-Date
            $chunk = Invoke-RestMethod -Method Get -Uri "$BaseUri$array$Method`?api_key=$key"
            If($chunk.$array[0])
            {
                Foreach($item in $array)
                {
                    $chunk.$item
                }
            }
            Else
            {
                $chunk
            }
        }
    }
    Else
    {
        If($script:ApiRequests.Count -gt 10)
        {
            While($script:ApiRequests[-$rateLimit] -gt (Get-Date).AddSeconds(-10))
            {
                Start-Sleep -Seconds 1
            }
        }
        $script:ApiRequests += Get-Date
        $response = Invoke-RestMethod -Method Get -Uri "$BaseUri$Parameter$Method`?api_key=$key"
        If($response)
        {
            If(-Not($Parameter))
            {
                $response
            }
            ElseIf($response.($Parameter[0]))
            {
                Foreach ($input in $Parameter)
                {
                    $response.$input
                }
            }
            Else
            {
                $response
            }
        }
        Else
        {
            Write-Error -Message 'No response received'
        }
    }
}

Function Get-Summoner
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,
        ParameterSetName='ID')]
        [string[]]$ID,
        [Parameter(Mandatory=$true,
        ParameterSetName='Name')]
        [string[]]$Name,        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/by-name/" -Parameter $Name
    }
    If($PSCmdlet.ParameterSetName -eq 'ID')
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID
    }
}

Function Get-SummonerIDbyName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$Name,
        [string]$Region = 'na'
    )
    $ID = @()
    $summoners = Get-Summoner -Name $Name
    $summoners.id
}

Function Get-SummonerMasteries
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID -Method '/masteries'
}

Function Get-SummonerRunes
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID -Method '/runes'
}

Function Get-SummonerNamebyId
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/" -Parameter $ID -Method '/name'
}

Function Get-RecentGames
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Foreach($summoner in $id)
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.3/game/by-summoner/" -Parameter $summoner -Method '/recent'
    }
}

Function Get-RankedStats
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Foreach($summoner in $id)
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.3/stats/by-summoner/" -Parameter $summoner -Method '/ranked'
    }
}

Function Get-Stats
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
        [string]$Region = 'na'
    )
    If($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $ID = Get-SummonerIDbyName -Name $Name
    }
    Foreach($summoner in $id)
    {
        Invoke-RiotRestMethod -BaseUri "https://$Region.api.pvp.net/api/lol/$Region/v1.3/stats/by-summoner/" -Parameter $summoner -Method '/summary'
    }
}

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

#Split-array is community script from https://gallery.technet.microsoft.com/scriptcenter/Split-an-array-into-parts-4357dcc1 by Barry Chum
Function Split-Array  
{ 
 
<#   
  .SYNOPSIS    
    Split an array  
  .PARAMETER inArray 
   A one dimensional array you want to split 
  .EXAMPLE   
   Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -parts 3 
  .EXAMPLE   
   Split-array -inArray @(1,2,3,4,5,6,7,8,9,10) -size 3 
#>  
 
  param($inArray,[int]$parts,[int]$size) 
   
  if ($parts) { 
    $PartSize = [Math]::Ceiling($inArray.count / $parts) 
  }  
  if ($size) { 
    $PartSize = $size 
    $parts = [Math]::Ceiling($inArray.count / $size) 
  } 
 
  $outArray = @() 
  for ($i=1; $i -le $parts; $i++) { 
    $start = (($i-1)*$PartSize) 
    $end = (($i)*$PartSize) - 1 
    if ($end -ge $inArray.count) {$end = $inArray.count} 
    $outArray+=,@($inArray[$start..$end]) 
  } 
  return ,$outArray 
 
}

