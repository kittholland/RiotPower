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
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [string]$ApiKey,
        [string]$RateLimit = 10,
        [switch]$Current
    )
    $KeyPath = "$env:USERPROFILE\riotApiKeys.json"
    If(Test-Path $KeyPath)
    {
        $keys = Get-Content -Path $KeyPath -Raw| ConvertFrom-Json
        If($keys.apikey -contains $ApiKey -or $keys.name -contains $Name)
        {
            If($keys.name -contains $Name)
            {
                Write-Error -Message 'Duplicate name detected, please enter a different name.'
            }
            If($keys.apikey -contains $ApiKey)
            {
                Write-Error -Message 'Duplicate key detected, please enter a different APIKey.'
            }
        }
        Else
        {
            $keys += @{
                Name=$Name
                ApiKey=$ApiKey
                RateLimit=$RateLimit
                Current = $Current.IsPresent
            }
            $keys | ConvertTo-Json | Out-File -FilePath $KeyPath
        }
    }
    Else
    {
        $keys = @(
            @{
                Name = $Name
                ApiKey = $ApiKey
                RateLimit = $RateLimit
                Current = $true
            }
        )
        $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
    }
}

Function Select-ApiKey
{
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [Parameter(ParameterSetName='Name')]
        [string]$Name,
        [Parameter(ParameterSetName='ApiKey')]
        [string]$ApiKey
    )
    $KeyPath = "$env:USERPROFILE\riotApiKeys.json"
    If(Test-Path $KeyPath)
    {
        $keys = Get-Content -Path $KeyPath -Raw| ConvertFrom-Json
        Switch($PSCmdlet.ParameterSetName)
        {
            'Name'
            {
                $key = $keys | Where-Object {$_.name -eq $Name}
                If(-Not($key))
                {
                    Write-Error "Could not locate a key named $name."
                }
                Else
                {
                    $oldCurrent = $keys | Where-Object {$_.current -eq 'True'}
                    $oldCurrent.current = 'False'
                    $key.current = 'True'
                    $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
                }
            }
            'ApiKey'
            {
                $key = $keys | Where-Object {$_.apikey -eq $ApiKey}
                If(-Not($key))
                {
                    Write-Error "Could not locate a key matching $ApiKey."
                }
                Else
                {
                    $oldCurrent = $keys | Where-Object {$_.current -eq 'True'}
                    $oldCurrent.current = 'False'
                    $key.current = 'True'
                    $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
                }
            }
        }
    }
    Else
    {
        Write-Error -Message 'Could not locate ApiKey file. Please use add-apikey command before proceeding.'
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
        [switch]$Current
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
                $currentKey = $keys | Where-Object {$_.Current -eq 'True'}
                If($currentKey.count -gt 1)
                {
                    Write-Warning -Message 'Duplicate current keys found. Using first key'
                    $currentKey = $currentKey[0]
                }
                $currentKey
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

Function Remove-ApiKey
{
    [CmdletBinding(DefaultParameterSetName='None')]
    Param
    (
        [Parameter(ParameterSetName='Name')]
        [string]$Name,
        [Parameter(ParameterSetName='ApiKey')]
        [string]$ApiKey
    )
    $KeyPath = "$env:USERPROFILE\riotApiKeys.json"
    If(Test-Path $KeyPath)
    {
        $keys = Get-Content -Path $KeyPath -Raw| ConvertFrom-Json
        Switch($PSCmdlet.ParameterSetName)
        {
            'Name'
            {
                $key = $keys | Where-Object {$_.name -eq $Name}
                If(-Not($key))
                {
                    Write-Error "Could not locate a key named $name."
                }
                Else
                {
                    $keys = $keys | Where-Object {$_.name -ne $Name}
                    If($key.current -eq 'True')
                    {
                        $keys[0].current = 'True'
                    }
                    $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
                }
            }
            'ApiKey'
            {
                $key = $keys | Where-Object {$_.apikey -eq $ApiKey}
                If(-Not($key))
                {
                    Write-Error "Could not locate a key matching $ApiKey."
                }
                Else
                {
                    $keys = $keys | Where-Object {$_.apikey -ne $ApiKey}
                    If($key.current -eq 'True')
                    {
                        $keys[0].current = 'True'
                    }
                    $keys | ConvertTo-Json | Out-File -FilePath $KeyPath 
                }
            }
        }
    }
    Else
    {
        Write-Error -Message 'Could not locate ApiKey file. Please use add-apikey command before proceeding.'
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
        [String]$Method,
        [String]$Query
    )
    $OFS = ','
    If(-Not($global:ApiRequests))
    {
        $global:ApiRequests = @()
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
            If($global:ApiRequests)
            {
                While($global:ApiRequests[-$rateLimit] -gt (Get-Date).AddSeconds(-10))
                {
                    Start-Sleep -Seconds 1
                }
            }
            $global:ApiRequests += Get-Date
            $chunk = Invoke-RestMethod -Method Get -Uri ("$BaseUri$Parameter$Method`?$Query" + "api_key=$key")
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
        If($global:ApiRequests.Count -gt 10)
        {
            While($global:ApiRequests[-$rateLimit] -gt (Get-Date).AddSeconds(-10))
            {
                Start-Sleep -Milliseconds 1025
            }
        }
        $global:ApiRequests += Get-Date
        $response = Invoke-RestMethod -Method Get -Uri ("$BaseUri$Parameter$Method`?$Query" + "api_key=$key")
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