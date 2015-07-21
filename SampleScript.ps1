#Import the RiotPower Module. I already have an ApiKey setup, but if I did not I would have to use Add-ApiKey command to add one before I ran anything else.
Import-Module C:\git\RiotPower\RiotPower.psd1

#Region I am searching. Korea sounds like a good place to look for interesting builds.
$region = 'kr'

#Language Region for Static Data
$languageRegion = 'na'

#Get a list of player IDs, there are several sources you could use. In this example I getting a list of all 200 Challenger players and using those IDs.
$PlayerIDs = Get-ChallengerLeague -LeagueType Solo -Region $region | Select-Object -ExpandProperty playerOrTeamId

#Name of the item that I am searching for. I'd like to see if anyone is making interesting builds with the new Liandry's.
$Item = "Liandry's Torment"

#Type of game I am interested in. The game types can be found at https://developer.riotgames.com/docs/game-constants under Matchmaking Queues
$gameType = 'RANKED_SOLO_5x5'
 
#For the static data I use the NA region so I will return summoner spell, champion and item names in English. If I selected KR as my region for these I would get back Korean names. The items are located by ID so the language doesnt matter for looking them up.
#I will use this static data later in the script when I want to translate an Item ID into a recognizable name.
$summonerSpellData = Get-StaticSummonerSpellData -Region $languageRegion
$championData = Get-Champions -Region $languageRegion
$itemData = Get-StaticItemData -Region $languageRegion

#Get the ID of the item I selected above, almost everything must be located by ID so it is important to know how to go back and forth from readable name, to queryable ID.
$itemID = $itemData | Where-Object {$_.name -eq $Item} | Select-Object -ExpandProperty id

#Get-RecentGames will return the 10 most recent games for each of the players I specify. Since I set $PlayerIDs to be all of the IDs in challenger league, it will return the most recent 10 games for each of them.
$playerGames = Get-RecentGames -ID $PlayerIDs -Region $region

#I am creating an empty array $results to store the games that I find that match my criteria
$results = @()

#Begin looping through each players games
Foreach($player in $playerGames)
{
#Loop through each game played by that player
    Foreach($game in $player.games)
    {
#Check if the game matches the type I specified before
        If($game.subType -eq $gameType)
        {
#Inspect the items that were in each inventory slot at the end of the game to see if one matches the itemID of the item I specified before
            If(
                $game.stats.item0 -eq $itemID -or
                $game.stats.item1 -eq $itemID -or
                $game.stats.item2 -eq $itemID -or
                $game.stats.item3 -eq $itemID -or
                $game.stats.item4 -eq $itemID -or
                $game.stats.item5 -eq $itemID
            )
#If we've gotten this far it means we've found a game that matches our gametype criteria AND our specified item was purchased. Now we will begin collecting and cleaning up the data to add to ours $results array.
            {
#This switch statement is checking what the value of the $game.stats.playerrole property is and then translating that into the name of the role and placing that in the $role variable. It's much nicer at the end to see Role: Support than Role: 2
#These values are found here: https://developer.riotgames.com/discussion/community-discussion/show/tdEi0i6u 
                Switch($game.stats.playerRole)
                {
                    1
                    {
                        $role = 'Duo'
                    }
                    2
                    {
                        $role = 'Support'
                    }
                    3
                    {
                        $role = 'Carry'                
                    }
                    4
                    {
                        $role = 'Solo'
                    }
                }
#This is doing the same thing for the playerPosition property
                Switch($game.stats.playerPosition)
                {
                    1
                    {
                        $position = 'Top'
                    }
                    2
                    {
                        $position = 'Middle'
                    }
                    3
                    {
                        $position = 'Jungle'
                    }
                    4
                    {
                        $position = 'Bot'
                    }
                }
#Now we build our result object! Each line specified a property that I would like returned in the final output. It can have as much or as little information as we like.
#Since $results is an array we can use += to add objects to the array as we go through the loop. When we're done all the games we found will be stored in this format in $results. 
                $results += [pscustomobject]@{
#Name of the player 
                    Player = $player.Name
#Game Outcome
                    Win = $game.stats.win
#Now we get to use the static $championData we collected earlier. We look at $championData where the id matches the championID from this game. Then we extract the name of that champion. 
#For example this would translate championID 161 into championName Vel'Koz.
                    Champion = ($championData | Where-Object {$_.id -eq $game.championId} | Select-Object -ExpandProperty Name)
#Role, based on the lookup we did earlier.
                    Role = $role
#Position, based on the lookup we did earlier.
                    Position = $position
#Summoner Spell name, doing the same ID to name translation as we did for Champion
                    Summoner1 = ($summonerSpellData | Where-Object {$_.id -eq $game.spell1} | Select-Object -ExpandProperty Name)
                    Summoner2 = ($summonerSpellData | Where-Object {$_.id -eq $game.spell2} | Select-Object -ExpandProperty Name)
                    Kills = $game.stats.championsKilled
                    Deaths = $game.stats.numDeaths
                    Assists = $game.stats.assists
                    Level = $game.stats.level
#Item lookup for each slot, same as summonerspells and champions.
                    Item0 = ($itemData | Where-Object {$_.id -eq $game.stats.item0} | Select-Object -ExpandProperty Name)
                    Item1 = ($itemData | Where-Object {$_.id -eq $game.stats.item1} | Select-Object -ExpandProperty Name)
                    Item2 = ($itemData | Where-Object {$_.id -eq $game.stats.item2} | Select-Object -ExpandProperty Name)
                    Item3 = ($itemData | Where-Object {$_.id -eq $game.stats.item3} | Select-Object -ExpandProperty Name)
                    Item4 = ($itemData | Where-Object {$_.id -eq $game.stats.item4} | Select-Object -ExpandProperty Name)
                    Item5 = ($itemData | Where-Object {$_.id -eq $game.stats.item5} | Select-Object -ExpandProperty Name)
                    Item6 = ($itemData | Where-Object {$_.id -eq $game.stats.item6} | Select-Object -ExpandProperty Name)
                }
            }
        }
    }
}
#Output the results to the screen.
$results

#There are lots of other interesting things we could do with these results. I've commented out some below.

#Display the results in a table
#$results | Format-Table

#Export the results to a CSV file on my desktop. Handy for working on data in Excel.
#$results | Export-Csv -Path C:\Users\kittholland\desktop\Results.csv -NoTypeInformation

#Display the results in a graphical gridview
#$results | Out-GridView

#Display the results where the champion being played was NOT Rumble
#$results | Where-Object {$_.Champion -ne 'Rumble'}