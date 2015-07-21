# RiotPower
Powershell module for Riot Games API

This is a powershell wrapper for the Riot Games Rest API https://developer.riotgames.com/api/

To import this module you can choose the "Download ZIP" option on the right hand side. Once you've downloaded, unzip to a location you'll remember. Once it's downloaded, open powershell (I recommend the Powershell ISE, which should be included with Windows) and run the command: 
Import-Module <Path to Module>\RiotPower.psd1 (ex: Import-Module C:\Scripts\RiotPower\RiotPower.psd1)

If you are receiving an error about script execution you will need to run:
Set-ExecutionPolicy Unrestricted

Once it is imported you can view available commands with: 

  Get-Command -Module RiotPower

To begin using you must obtain an API key from Riot Games at https://developer.riotgames.com/ once you have obtained a key use the Add-ApiKey cmdlet to begin making requests. 

Commands included in this module:

Add-ApiKey

Get-ApiKey

Get-ChallengerLeague

Get-Champion

Get-Champions

Get-CurrentGame

Get-FeaturedGames

Get-LeagueBySummoner

Get-LeagueByTeam

Get-LeagueEntryBySummoner

Get-LeagueEntryByTeam

Get-MasterLeague

Get-Match

Get-MatchHistory

Get-RankedStats

Get-RecentGames

Get-StaticChampionData

Get-StaticItemData

Get-StaticLanguagesData

Get-StaticLanguageStringsData

Get-StaticMapData

Get-StaticMasteryData

Get-StaticRealmData

Get-StaticRuneData

Get-StaticSummonerSpellData

Get-StaticVersionData

Get-Stats

Get-Status

Get-Summoner

Get-SummonerMasteries

Get-SummonerRunes

Get-Team

Invoke-RiotRestMethod

Remove-ApiKey

Select-ApiKey

Split-Array
