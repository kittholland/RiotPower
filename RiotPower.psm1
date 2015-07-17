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
    [CmdletBinding()]
    Param
    (
        [string]$Name,
        [string]$ApiKey,
        [switch]$Current,
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

Function Invoke-RiotRestMethod
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [Uri]$Uri,
        [String[]]$Parameter
    )
    If(-Not($script:ApiRequests))
    {
        $script:ApiRequests = @()
    }
    $ApiKey = Get-ApiKey -Current
    $rateLimit = $apikey.RateLimit
    $key = $ApiKey.ApiKey
    If($Parameter.Count -gt 40)
    {
        $arrays = Split-Array -inArray $Parameter -size 40
        Foreach($array in $arrays)
        {
            While($script:ApiRequests[-$rateLimit] -gt (Get-Date).AddSeconds(-10))
            {
                Start-Sleep -Seconds 1
            }
            $script:ApiRequests += Get-Date
            $response += Invoke-RestMethod -Method Get -Uri "$uri/$Parameter`?api_key=$key"
        }
    }
    $response = Invoke-RestMethod -Method Get -Uri "$uri/$Parameter`?api_key=$key"
    If($response)
    {
        Foreach ($input in $Parameter)
        {
            $response.$input
        }
    }
    Else
    {
        Write-Error -Message 'No response received'
    }
}

Function Get-SummonerByName
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true)]
        [string[]]$Name,
        [string]$Region = 'na'
    )
    $OFS = ','
    $ApiKey = Get-ApiKey -Current
    If($ApiKey)
    {
        $key = $ApiKey.ApiKey
        $response = Invoke-RestMethod -Method Get -Uri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/by-name/$Name`?api_key=$key"
        If($response)
        {
            Foreach ($summoner in $Name)
            {
                $response.$summoner
            }
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
        [string[]]$ID,
        [string]$Region = 'na'
    )
    $OFS = ','
    $ApiKey = Get-ApiKey -Current
    If($ApiKey)
    {
        $key = $ApiKey.ApiKey
        $response = Invoke-RestMethod -Method Get -Uri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/$ID`?api_key=$key"
        If($response)
        {
            Foreach($summoner in $ID)
            {
                $response.$summoner
            }
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
        [string[]]$Name,
        [string]$Region = 'na'
    )
    $ID = @()
    $summoners = Get-SummonerByName -Name $Name
    Foreach($summoner in $Name)
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
    $OFS = ','
    $ApiKey = Get-ApiKey -Current
    If($ApiKey)
    {
        $key = $ApiKey.ApiKey
        $response = Invoke-RestMethod -Method Get -Uri "https://$Region.api.pvp.net/api/lol/$Region/v1.4/summoner/$ID/masteries`?api_key=$key"
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