-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

//Global table
stats = {}

//Check stats interval
stats.CheckTime = 300

//Hook to endround event
local function OnGameEnd( iWinnerTeam )
	
	//Get map
	local sMap = game.GetMap()
	
	//Stats page link
	local sLink = "http://www.mr-green.nl/portal/statistics/rec_stats.php?game=zs"
	
	//Add team score values
	local sParameter = "&add_global_human_wins="..( ( 1 and iWinnerTeam == TEAM_HUMAN ) or 0 ).."&add_global_zombie_wins="..( ( 1 and iWinnerTeam == TEAM_UNDEAD ) or 0 )
	sLink = sLink..sParameter
	
	//Add wins per map
	sLink = sLink.."&add_human_wins_"..sMap.."="..( ( 1 and iWinnerTeam == TEAM_HUMAN ) or 0 ).."&add_zombie_wins_"..sMap.."="..( ( 1 and iWinnerTeam == TEAM_UNDEAD ) or 0 )
	
	// Add/set/get content
	http.Get( sLink, "", stats.Callback )
end
//hook.Add( "OnEndRound", "WebStatsEndGame", OnGameEnd )

//Stats callback
function stats.Callback( Args, Content, Size )
end