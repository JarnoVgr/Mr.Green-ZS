-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local table = table
local surface = surface
local draw = draw
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer

--[==[---------------------------------------------------------
		Initialize Fonts
---------------------------------------------------------]==]
function InitializeFonts ()
	surface.CreateFont("Arial", ScreenScale(22.8), 700, true, false, "ArialBoldTwenty")
	surface.CreateFont("Arial", ScreenScale(10.4), 700, true, false, "ArialBoldNine")
	surface.CreateFont("Arial", ScreenScale(11), 400, true, false, "ArialNine")
end
hook.Add ("Initialize","InitializeFonts",InitializeFonts)

local IsVotingOver = false
local WinnerMap = "Random Map"
local WinnerMapName = "Random Map"
local ROUNDWINNER = "Nobody"

--[==[---------------------------------------------------------
              Receive Top healing done ( medic)
---------------------------------------------------------]==]
local TopHealing = {}
local function ReceiveTopHealing ( um )
	local index = um:ReadShort()
	TopHealing[index] = {}
	TopHealing[index].Name = um:ReadString()
	TopHealing[index].Score = um:ReadString()
end
usermessage.Hook("RcTopHealing", ReceiveTopHealing)

--[==[---------------------------------------------------------
              Receive Top Infected killed
---------------------------------------------------------]==]
local TopZombiesKilled = {}
local function ReceiveTopZombiesKilled ( um )
	local index = um:ReadShort()
	TopZombiesKilled[index] = {}
	TopZombiesKilled[index].Name = um:ReadString()
	TopZombiesKilled[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombiesKilled", ReceiveTopZombiesKilled)

--[==[---------------------------------------------------------
                Receive Top Brains Eaten
---------------------------------------------------------]==]
local TopBrainsEaten = {}
local function ReceiveTopZombies ( um )
	local index = um:ReadShort()
	TopBrainsEaten[index] = {}
	TopBrainsEaten[index].Name = um:ReadString()
	TopBrainsEaten[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombies", ReceiveTopZombies)

--[==[---------------------------------------------------------
       Receive Top Damage done by Humans
---------------------------------------------------------]==]
local TopHumanDamage = {}
local function ReceiveTopHumanDamages ( um )
	local index = um:ReadShort()
	TopHumanDamage[index] = {}
	TopHumanDamage[index].Name = um:ReadString()
	TopHumanDamage[index].Score = um:ReadString()
end
usermessage.Hook("RcTopHumanDamages", ReceiveTopHumanDamages)

--[==[---------------------------------------------------------
       Receive Top Damage done by Zombies
---------------------------------------------------------]==]
local TopZombieDamage = {}
local function ReceiveTopZombieDamages ( um )
	local index = um:ReadShort()
	TopZombieDamage[index] = {}
	TopZombieDamage[index].Name = um:ReadString()
	TopZombieDamage[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombieDamages", ReceiveTopZombieDamages)

--[==[---------------------------------------------------------
           Receive Top Survival Times
---------------------------------------------------------]==]
local TopSurvivalTimes = {}
local function ReceiveTopTimes ( um )
	local i = um:ReadShort()
	TopSurvivalTimes[i] = {}
	TopSurvivalTimes[i].Name = um:ReadString()
	TopSurvivalTimes[i].Score = um:ReadString()
end
usermessage.Hook("RcTopTimes", ReceiveTopTimes)

--[==[---------------------------------------------------------
	   Receive voting maps (3 maps)
---------------------------------------------------------]==]
local VotePoints = {}

local function ReceiveVotemaps ( um )
	for i = 1, 3 do
	    local key = um:ReadString()
	    local friendlyname = um:ReadString()
	    VotePoints[key] = { Votes = 0, Map = { FileName = key, FriendlyName = friendlyname } }
	end
end
usermessage.Hook("RecVotemaps", ReceiveVotemaps)

--[==[---------------------------------------------------------
	   Receive vote points update
---------------------------------------------------------]==]
local function ReceiveVotePoints ( um ) 
	for i = 1, 3 do
	    local key = um:ReadString()
		VotePoints[key] = VotePoints[key] or { Votes = 0, Map = { FileName = key, FriendlyName = "Unknown" } }
    	VotePoints[key].Votes = um:ReadShort()
	end
end
usermessage.Hook("RecVoteChange",ReceiveVotePoints)

--[==[---------------------------------------------------------
     Receive the voted map slot server-side
---------------------------------------------------------]==]
local function ReceiveAutomaticVoteResult ( um )
	MySelf.VotedMapFile = um:ReadString()
end
usermessage.Hook("RecAutomaticVoteResult",ReceiveAutomaticVoteResult)

--[==[---------------------------------------------------------
	   Receive Nextmap ( Vote Result )
---------------------------------------------------------]==]
function SetWinnerMap ( mapname, mapname2 )
	WinnerMap = mapname
	WinnerMapName = mapname2
	IsVotingOver = true
end

util.PrecacheSound("music/HL1_song25_REMIX3.mp3")
util.PrecacheSound("music/HL1_song21.mp3")

function Intermission ( nextmap, winner, timeleft )
	if ENDROUND then return end

	ENDROUND = true
	hook.Remove("RenderScreenspaceEffects", "PostProcess")
	--hook.Add("RenderScreenspaceEffects", "DrawEnding", DrawEnding)
	ENDTIME = CurTime()
	DrawingDanger = 0
	NearZombies = 0
	NextThump = 200
	ROUNDWINNER = winner
	RunConsoleCommand("stopsound")
	
	-- Play the team specific.sounds (  thanks to Mayco :D )
	timer.Simple (0.2, function() 
		if winner == TEAM_HUMAN and MySelf:Team() == TEAM_HUMAN then
			surface.PlaySound ( "music/HL1_song25_REMIX3.mp3" )
		else
			surface.PlaySound ( "music/HL1_song21.mp3" )
		end
	end)
	
	if ValidEntity(MySelf) and MySelf.Team and MySelf:Team() ~= TEAM_SPECTATOR then
	
		local wep = MySelf:GetActiveWeapon()
		
		if wep and wep:IsValid() then
			wep.DrawHUD = function() end
		end
	
	end
	
	--Enable mouse
	gui.EnableScreenClicker ( true )
	
	-- Convert unfriendly map names to friendly ones
	for k,v in pairs (TranslateMapTable) do
		if nextmap == k then
			nextmap = v.Name
			break
		end
	end
	
	if nextmap == nil then
		nextmap = "an Unknown Place"
	end
	
	-- Winner managment and team score
	local wintext, wincol = "The round was a withdraw.", Color(255,255,255,255)

	if winner == TEAM_HUMAN then
		wintext = "Survivors win the round!"
		wincol = Color(255,255,255,255)
	elseif winner == TEAM_UNDEAD then
		wintext = "The Undead rule the world!"
		wincol = Color(200,40,40,255)
	end

	MySelf.HasVotedMap = false
	
	local delay = 1.1 -- delay between messages
	local drawtime = delay-0.05 -- how long it takes to draw a message
	
	-- Shuffle votemaps
	local shuffleMaps = {}
	local index = 1
	
	for k, v in pairs( VotePoints ) do
	   shuffleMaps[index] = v
	   index = index + 1
	end

	shuffleMaps = table.Shuffle( shuffleMaps )
	
	for i = 1, #shuffleMaps do
	   AddMapLabel( h/2+85+30 * i, shuffleMaps[i].Map.FileName, shuffleMaps[i].Map.FriendlyName )
	end
	
	-- kinda messy but whatever
	local top = {}
	
	local txt = "Nobody survived..."
	if TopSurvivalTimes[1] then txt = TopSurvivalTimes[1].Name.." was strong enough to survive for "..TopSurvivalTimes[1].Score end
	top[1] = {txt,0,0}
	
	txt = "Nobody killed the zombies, because all humans are pussies D:"
	if TopZombiesKilled[1] and tonumber(TopZombiesKilled[1].Score) > 0 then txt = TopZombiesKilled[1].Name.." caused a bloodbath by killing "..TopZombiesKilled[1].Score.." undead" end
	top[2] = {txt,0,0}
	
	txt = "Zombies were too lazy to kill humans this round"
	if TopBrainsEaten[1] and tonumber(TopBrainsEaten[1].Score) > 0 then txt = TopBrainsEaten[1].Name.." was the hungriest zombie for eating "..TopBrainsEaten[1].Score.." brain"..(tonumber(TopBrainsEaten[1].Score) > 1 and "s" or "") end
	top[3] = {txt,0,0}
	
	txt = "Somehow humans failed at damaging zombies"
	if TopHumanDamage[1] and tonumber(TopHumanDamage[1].Score) > 0 then txt = TopHumanDamage[1].Name.."  dealt the most pain to zombies by inflicting  "..TopHumanDamage[1].Score.." damage" end
	top[4] = {txt,0,0}
	
	txt = "Humans were lucky to avoid taking any damage from undead"
	if TopZombieDamage[1] and tonumber(TopZombieDamage[1].Score) > 0 then txt = TopZombieDamage[1].Name.." tore the most humans to pieces by inflicting "..TopZombieDamage[1].Score.." damage to them" end
	top[5] = {txt,0,0}
	
	txt = "No helpful players because you all are selfish :<"
	if TopHealing[1] and tonumber(TopHealing[1].Score) > 0 then txt = TopHealing[1].Name.." was the most helpful player by healing "..TopHealing[1].Score.." hp in total" end
	top[6] = {txt,0,0}
	
	-- set the draw time 
	for i,_ in pairs(top) do
		top[i][2] = CurTime() + delay*i
		top[i][3] = CurTime() + delay*i + drawtime
	end
	
	-- Overwrite main paint/background
	function GAMEMODE:HUDPaint()-- end
		local TimeToChange = math.Clamp ( math.floor ( ENDTIME + timeleft - CurTime() ), 0, 9999 )
		local headertext = "Next round in "..( TimeToChange + 1 )
		
		-- Draw the actual text
		
		for k,v in pairs(top) do
			local tx, time, dtime = v[1], v[2], v[3]
			local al = 0
			if CurTime() >= time then
				local delta = dtime - CurTime()
				al = (1-math.max(0, math.Clamp(delta,0,1))) * 255
				draw.SimpleTextOutlined(tx, "ArialBoldFive", w/2, 80+35*k, Color(255,255,255,al), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,al))
			end
		end
		
		draw.SimpleTextOutlined(wintext, "ArialBold_25", w/2, h/2, wincol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		
		local votetxt = "Vote for the next map:"
		if MySelf.HasVotedMap == true then
			votetxt = "Wait for other players to vote"
		end
		
		draw.SimpleTextOutlined(votetxt, "ArialBoldTen", w/2, h/2+60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		
		if IsVotingOver == true then
			strMap = WinnerMapName
			headertext = "Next map will be "..tostring( strMap ).." in "..( TimeToChange + 1 )
		end
		
		draw.SimpleTextOutlined(headertext, "ArialBoldFifteen", w/2, h-80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
				
	end
end

local MapLabel = {}
	
function AddMapLabel(y,mapfilename,mapname)
	
	surface.SetFont("ArialBoldSeven")
	
	local tw,th = surface.GetTextSize ( mapname.." | Votes: 99 | WINNER" )-- take a bit bigger size
	
	local sw, sh = tw+30, th+6
	
	MapLabel[mapfilename] = vgui.Create( "DButton")
	MapLabel[mapfilename]:SetText("")
	MapLabel[mapfilename]:SetSize(sw, sh)
	MapLabel[mapfilename]:SetPos(w/2-sw/2,y)
	MapLabel[mapfilename].Color = color_white
	MapLabel[mapfilename].OnCursorEntered = function()
		MapLabel[mapfilename].Overed = true 
	end
	MapLabel[mapfilename].OnCursorExited = function()
		MapLabel[mapfilename].Overed = false 
	end
	MapLabel[mapfilename].DoClick = function()
		if not MySelf.HasVotedMap then
			MySelf.HasVotedMap = true
			MySelf.VotedMapFile = mapfilename

			-- Send voted mapfilename to server
			RunConsoleCommand ( "VoteAddMap", mapfilename )
		end
	end
	MapLabel[mapfilename].Paint = function()
		if VotePoints[mapfilename].Votes > 0 then
			if IsVotingOver == true and mapfilename == WinnerMap then
				draw.SimpleTextOutlined(mapname.." | Votes: "..VotePoints[mapfilename].Votes.." | WINNER", "ArialBoldSeven", sw/2, sh/2, Color(255,10,10,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			else
				draw.SimpleTextOutlined(mapname.." | Votes: "..VotePoints[mapfilename].Votes, "ArialBoldSeven", sw/2, sh/2, MapLabel[mapfilename].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
		else
			draw.SimpleTextOutlined(mapname, "ArialBoldSeven", sw/2, sh/2, MapLabel[mapfilename].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
		if MapLabel[mapfilename].Overed and not MySelf.HasVotedMap then
			surface.SetDrawColor( 255, 255, 255, 255)
			surface.DrawOutlinedRect( 0, 0, sw, sh)
			surface.DrawOutlinedRect( 1, 1, sw-2, sh-2 )
		end
	end
	MapLabel[mapfilename].Think = function()
		if MySelf.VotedMapFile and MySelf.VotedMapFile == mapfilename then
			MapLabel[mapfilename].Color = Color(120,120,120,255)
		end
		gui.EnableScreenClicker ( true )
	end

end




