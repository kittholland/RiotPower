# RiotPower
Powershell module for Riot Games API

This is a powershell wrapper for the Riot Games Rest API https://developer.riotgames.com/api/

To use, simply copy the folder to your system and import the module manifest:

  Import-Module C:\RiotPower\RiotPower.psd1

Once it is imported you can view available commands with: 

  Get-Command -Module RiotPower

To begin using you must obtain an API key from Riot Games at https://developer.riotgames.com/ once you have obtained a key use the Add-ApiKey cmdlet to begin making requests. 
