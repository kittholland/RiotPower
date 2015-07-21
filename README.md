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
  ex: Add-ApiKey -Name 'Dev' -ApiKey df4750ee-8b33-4975-9d8a-a52c481fae3d -RateLimit 10

Get-ApiKey
ex: Get-ApiKey -Name 'Dev'

Get-ChallengerLeague
ex: Get-ChallengerLeague -LeagueType Team5 -Region euw

Get-Champion
ex: Get-Champion -Name 'Fiora'

Get-Champions
ex: Get-Champions

Get-CurrentGame
ex: Get-CurrentGame -Name 'wingsofdeathx' -Region na
(Note: if there is no current game for that summoner you will receive a 404 warning.)

Get-FeaturedGames
ex: Get-FeaturedGames -Region kr

Get-LeagueBySummoner
ex: Get-LeagueBySummoner -Name 'TSM BULGOGI' -Region na
(Note: if the summoner you choose is not currently ranked in a league you will receive a 404 warning.)

Get-LeagueByTeam
ex: Get-LeagueByTeam -TeamID 'TEAM-788d7e50-0c1a-11e5-8678-c81f66dd45c9' -Region na
(You can get TeamIDs using Get-Team command)
(Note: if the team you choose is not currently ranked in a league you will receive a 404 warning.)

Get-LeagueEntryBySummoner
ex: Get-LeagueEntryBySummoner -Name 'TSM BULGOGI' -Region na
(Note: if the summoner you choose is not currently ranked in a league you will receive a 404 warning.)

Get-LeagueEntryByTeam
(You can get TeamIDs using Get-Team command)
ex: Get-LeagueByTeam -TeamID 'TEAM-788d7e50-0c1a-11e5-8678-c81f66dd45c9' -Region na
(Note: if the team you choose is not currently ranked in a league you will receive a 404 warning.)

Get-MasterLeague
Ex: Get-MasterLeague -LeagueType Solo -Region tr

Get-Match
(You can get MatchIDs using Get-MatchHistory)
Ex: Get-Match -MatchID 1882825956 -Region na
(Note: if the match ID is not found you will receive a 404 warning.)

Get-MatchHistory
Ex: Get-MatchHistory -Name 'kittH' -Region na

Get-RankedStats
Ex: Get-RankedStats -Name 'C9 Hai' -region na
(Note: If the summoner does not have ranked stats this season you will receive a 404 warning.)

Get-RecentGames
Ex: Get-RecentGames -Name 'Keane' 

Get-StaticChampionData
Ex: Get-StaticChampionData -Region na

Get-StaticItemData
Ex: Get-StaticItemData -Region na

Get-StaticLanguagesData
Ex: Get-StaticLanguagesData -Region na

Get-StaticLanguageStringsData
Ex: Get-StaticLanguageStringsData -Region na

Get-StaticMapData
Ex: Get-StaticMapData -Region na

Get-StaticMasteryData
Ex: Get-StaticMasteryData -Region na

Get-StaticRealmData
Ex: Get-StaticRealmData -Region na

Get-StaticRuneData
Ex: Get-StaticRuneData -Region na

Get-StaticSummonerSpellData
Ex: Get-StaticSummonerSpellData -Region na

Get-StaticVersionData
Ex: Get-StaticVersionData -Region na

Get-Stats
Ex: get-Static -Name 'Aphromoo' -Region na

Get-Status
Ex: Get-Status

Get-Summoner
Ex: Get-Summoner -ID 5 -Region na

Get-SummonerMasteries
Ex: Get-SummonerMasteries -Name 'Phreak' -Region na

Get-SummonerRunes
Ex: Get-SummonerRunes -Name 'Riot Lyte' -Region na

Get-Team
Ex: Get-Team -SummonerName 'Tryndamere' -Region na

Invoke-RiotRestMethod
Used interally for API calls

Remove-ApiKey
Ex: Remove-ApiKey -Name 'Dev'

Select-ApiKey
Ex: Select-ApiKey -Name 'Dev'

Split-Array
Used Internally for API calls
