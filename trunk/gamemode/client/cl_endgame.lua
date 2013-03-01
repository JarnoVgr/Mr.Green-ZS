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

-- Colors :P
local COLOR_SUBTITLE = Color ( 146,146,146,255 )
local COLOR_TITLE = Color ( 255,245,245,255 )
local COLOR_GREY_ONE = Color ( 99,99,99,255 )
local COLOR_DARK_GREY = Color ( 35,35,35,255 )
local COLOR_BLUE = Color ( 139,183,220,255 )
local COLOR_LIGHT_GREY = Color ( 62,62,62,255 )
local COLOR_LIGHT_RED = Color ( 116,26,26,255 )
local COLOR_DARK_GREY_BUTTON = Color ( 12,72,122,255 )
local COLOR_DARK_RED = Color ( 123,24,24,255 )

--Do not change this. From one to 15 are the changable button colors
local Color_Labels = {}
for i = 1, 16 do
	if i < 9 then
		Color_Labels[i] = Color ( 35,35,35,255 )
	elseif i < 15 and i >= 9 then
		Color_Labels[i] = Color ( 0,0,0,0 )
	else
		Color_Labels[i] = COLOR_GREY_ONE
	end
end

--Sound DB
local Sounds = {}
Sounds.Accept = "mrgreen/ui/menu_focus.wav"
Sounds.Click = "mrgreen/ui/menu_click01.wav"
Sounds.Over = "mrgreen/ui/menu_accept.wav"

-- Screen (3:4) and Widescreen (the rest)
SCREEN = w/h > 1.24 and w/h < 1.35
WIDESCREEN = w/h > 1.45 and w/h < 1.8 or w/h == 1.6

/*---------------------------------------------------------
	     Expand panel metatable
---------------------------------------------------------*/
local metapanel = FindMetaTable ("Panel")
if metapanel then

	-- Simple panel align to center function
	function metapanel:AlignCenter ()
		local posx, posy = self:GetPos()
		local wide, tall = self:GetWide(),self:GetTall()
		
		self:SetPos ( posx - ( wide / 2 ), posy - ( tall / 2 ) )
	end
	
end

/*---------------------------------------------------------
	Hints used for end-round board
---------------------------------------------------------*/
local GameHints = {
	"Headcrabs are small. They can hardly be seen. Use them wisely.",
	"As a zombie, you can throw props at humans, in most cases, killing them.",
	"If you get stuck in props or walls, type !stuck.",
	"As a human, you have limited weapon slots. Press F3 to drop a weapon.",
	"If you are injured, call a Medic or search for health vials in the map!",
	"After redeeming, humans are protected for a short amount of time from all damage!",
	"You can nail objects using the nailing hammer (nail-gun).",
	"As a Medic, you can heal yourself by holding RIGHT-MOUSE button!",
	"You can press F1 for further game instructions.",
	"As a Berserker, you can heal yourself by hitting undead with melee weapons!",
	"As Support, be sure to find a nice sniping place and cover your mates!",
	"As an Undead, you can redeem by getting a score of 8 (and pressing F2).",
	"As a Medic, you can heal other by holding LEFT-MOUSE button!",
	"If you suicide in the first 5 minutes, you will be weak as undead.",
	"When humans are camping, use the Poison Headcrab!",
	"If '(bonus)' is written next to 'Most ..' achievements then you get 5 GC!",
	"You can buy hats and upgrades from our shop with Greencoins! (GC)",
	"You can open the 'Shop' by typing !shop in the chat!",
	"As a Zombie, press F3 to change your class!",
	"As a human, you can change your class by typing !hclass < classname >",
	"Poison Zombies can throw meat at other zombies, healing them!",
	"Gibs (meat) heal you as a zombie, if you eat them.",
	"You can type !rtd to Roll the Dice and if you are lucky, receive something!"
}

/*---------------------------------------------------------
		Initialize Fonts
---------------------------------------------------------*/
function InitializeFonts ()
	-- Bold Arials
	surface.CreateFont("Arial", ScreenScale(22.8), 700, true, false, "ArialBoldTwenty")
	surface.CreateFont("Arial", ScreenScale(20.8), 700, true, false, "ArialBoldEighteen")
	surface.CreateFont("Arial", ScreenScale(10.4), 700, true, false, "ArialBoldNine")
	surface.CreateFont("Arial", ScreenScale(8.4), 700, true, false, "ArialBoldSix")
	surface.CreateFont("Arial", ScreenScale(13.4), 700, true, false, "ArialBoldTwelv")
	
	-- Normal Arials
	surface.CreateFont("Arial", ScreenScale(22.8), 500, true, false, "ArialTwenty")
	surface.CreateFont("Arial", ScreenScale(25.4), 500, true, false, "ArialTwentyTwo")
	surface.CreateFont("Arial", ScreenScale(11), 400, true, false, "ArialNine")
	surface.CreateFont("Arial", ScreenScale(13.4), 500, true, false, "ArialTwelve")
end
hook.Add ("Initialize","InitializeFonts",InitializeFonts)

/*---------------------------------------------------------
	 Update screen width and height
---------------------------------------------------------*/
function UpdateScreenType()
	w,h = ScrW(),ScrH()

	-- Screen (3:4) and Widescreen (the rest)
	SCREEN = w/h > 1.24 and w/h < 1.35
	WIDESCREEN = w/h > 1.45 and w/h < 1.8 or w/h == 1.6
end

/*---------------------------------------------------------
	Some function i use to scale panels 
---------------------------------------------------------*/
function ScalePanel ( nr )
	local newnr = ScrW() * ( nr / 1280 )

	local ratio =  math.Clamp ( ScrH() / 800, 0.9, 1 )
	return newnr * ratio
end

/*---------------------------------------------------------
	Blur function taken from utils
---------------------------------------------------------*/
local matBlurScreen = Material( "pp/blurscreen" )

function DrawBlur ( starttime, amount )
	if starttime == 0 and amount == 0 then return end
 
	local Fraction = 1
	 
	if ( starttime ) then
		Fraction = math.Clamp( (SysTime() - starttime) / 1, 0, 1 )
	end
	
	if ( amount ) then	
		Fraction = amount
	end
	 
	x,y = 0,0
	 
	DisableClipping( true )
		   
	surface.SetMaterial( matBlurScreen )   
	surface.SetDrawColor( 255, 255, 255, 255 )
				   
	for i=0.33, 1, 0.33 do
		matBlurScreen:SetFloat( "$blur", Fraction * 5 * i )
		if ( render ) then render.UpdateScreenEffectTexture() end 
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
		   
	surface.SetDrawColor( 10, 10, 10, 200 * Fraction )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )
		   
	DisableClipping( false )
end

/*---------------------------------------------------------
	   Main Intermission Funciton
---------------------------------------------------------*/

local TimerImage = surface.GetTextureID ("zombiesurvival/endgame/timer")
local Spinner = surface.GetTextureID ("zombiesurvival/endgame/spinner")
local IsVotingOver = false
local WinnerMap = "Random Map"
local WinnerMapName = "Random Map"
local ROUNDWINNER = "Nobody"
local NextPageLabel = {}

timer.Simple (0.1, function()
	MySelf.VoteAlready = false 
	MySelf.VotedMapSlot = nil
end )

function IntermissionOld ( nextmap, winner, timeleft )
	if ENDROUND then return end

	ENDROUND = true
	hook.Remove("RenderScreenspaceEffects", "PostProcess")
	ENDTIME = CurTime()
	DrawingDanger = 0
	NearZombies = 0
	NextThump = 200
	ROUNDWINNER = winner
	RunConsoleCommand("stopsounds")
	
	-- Play the team specific.sounds (  thanks to Mayco :D )
	timer.Simple (0.2, function() 
		if MySelf:Team() == TEAM_HUMAN then
			surface.PlaySound ( "endgame/humanwin.mp3" )
		else
			surface.PlaySound ( "endgame/zombiewins.mp3" )
		end
	end)
	
	--Enable mouse
	gui.EnableScreenClicker ( true )
	
	--Choose a randomhint
	local randomhint = GameHints [ math.random (1,#GameHints) ] 
	
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
	
	---Winner managment and team score
	local congratulations,wintext = "You've failed surviving ...","The round was a withdraw."

	if winner == TEAM_HUMAN then
		wintext = "Survivors win the round!"
		if MySelf:Team() == TEAM_HUMAN then
			congratulations = "We're safe ... for now!"
		end
	elseif winner == TEAM_UNDEAD then
		congratulations = "We've failed surviving ..."
		wintext = "The Undead rule the world!"
	end
	
	--Choose some randomblood spats
	local bloodrand1 = bloodSplats[math.random(1,2)]
	local bloodrand2 = bloodSplats[math.random(3,8)]
	
	-- Create the votemap panel
	local votemap = vgui.Create ("Votemap")
	votemap:SetVisible ( true )
	
	--Manange Votemap Stuff
	ManageVotemap ( votemap )
	
	--- Init the Hint Next and Prev buttons
	DoLabel ( 15, nil, "ArialBoldTwelv", ">", 0, 0, COLOR_LIGHT_RED, "hint", COLOR_GREY_ONE, 0, 0 )
	DoLabel ( 16, nil, "ArialBoldTwelv", "<", 0, 0, COLOR_LIGHT_RED, "hint", COLOR_GREY_ONE, 0, 0 )
	
	--Make the 15'th label go forward into the table and the 16th go backwards
	NextPageLabel[15].OnMousePressed = function()
		local pos = 0
		for k,v in ipairs (GameHints) do
			if randomhint == v then
				pos = k
			end
		end
		
		if GameHints[pos + 1] then
			randomhint = GameHints [pos + 1]
		else
			pos = 1
			randomhint = GameHints [pos + 1]
		end
		surface.PlaySound ( Sounds.Click )
	end
	NextPageLabel[16].OnMousePressed = function()
		local pos = 0
		for k,v in ipairs (GameHints) do
			if randomhint == v then
				pos = k
			end
		end
		
		if GameHints[pos - 1] then
			randomhint = GameHints [pos - 1]
		else
			pos = #GameHints
			randomhint = GameHints [pos - 1]
		end
		
		surface.PlaySound ( Sounds.Click )
	end
	
	-- Overwrite main paint/background
	function GAMEMODE:HUDPaint() end
	function GAMEMODE:HUDPaintBackground ()
		local TimeToChange = math.Clamp ( math.floor ( ENDTIME + timeleft - CurTime() ), 0, 9999 )
		local headertext = "You must vote a map!"
		
		if IsVotingOver == false then
			if MySelf.VoteAlready == false then
				headertext = "Vote your favourite map from the Votemap Panel"
			elseif MySelf.VoteAlready == true then
				headertext = "Please wait for other players to vote!"
			end
		elseif IsVotingOver == true then
			local tbMap, strMap = TranslateMapTable[WinnerMap]
			if tbMap then strMap = tbMap.Name else strMap = "a Mystical Place" end
			headertext = "You are on your way to "..tostring( strMap ).." !" 
		end
		
		---Draw the red flash for votemap panel if the player hasn't voted yet
		if MySelf.VoteAlready == false then
			local panelx,panely = votemap:GetPos()
			local bounds = ScaleW(18)
			draw.RoundedBox(8, panelx - (bounds / 2), panely - (bounds / 2), votemap:GetWide() + bounds, votemap:GetTall() + bounds, Color ( 123,24,24,255 * math.abs ( math.sin ( CurTime() * 2.3 ) ) ) )		
		end
		
		--Draw some blood on the screen
		surface.SetTexture( bloodrand1 )
		surface.SetDrawColor( Color(140,0,0,255) )
		surface.DrawTexturedRect( 0,0,w,h )
		surface.SetTexture( bloodrand2 )
		surface.DrawTexturedRect( 0,0,w,h )
		
		if SCREEN then
			surface.SetDrawColor ( 35,35,35,255 )
			surface.DrawRect ( 0,0,ScaleW(1280),ScaleH(148) ) -- Bara grii de sus, aia mare
			surface.DrawRect ( 0,ScaleH(878), ScaleW(1280), ScaleH(148) ) -- bara grii de jos, aia mare
			
			surface.SetDrawColor ( 62,62,62,255 )
			surface.DrawRect ( 0, ScaleH(141), ScaleW(1280), ScaleH(7) )
			surface.DrawRect ( 0, ScaleH(878), ScaleW(1280), ScaleH(7) )
			
			-- The timer picture in the upper left corner
			surface.SetDrawColor ( 255,255,255,255 )
			surface.SetTexture ( TimerImage )
			surface.DrawTexturedRectRotated ( ScaleW(70), ScaleH(66), ScalePanel(68), ScalePanel(68), 0 )

			-- Spinner from l4d
			surface.SetDrawColor ( 255,255,255,255 )
			surface.SetTexture ( Spinner )
			surface.DrawTexturedRectRotated ( ScaleW(1193), ScaleH(68), ScaleW(95), ScaleH(95), 0 )	

			--Next, prev buttons for hints
			local gamehinttext, dist = "Game hints: "..randomhint, 28
			surface.SetFont ( "ArialBoldTwelv" )
			local hintwide, hinttall = surface.GetTextSize ( gamehinttext )
			local signwide, signtall = surface.GetTextSize (">")
			
			--Update the labels position
			NextPageLabel[15]:SetPos ( ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) - (signwide / 2),ScaleH(982) - (signtall / 2) )
			NextPageLabel[16]:SetPos ( ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) - (signwide / 2) ,ScaleH(982) - (signtall / 2) )
			
			--Draw the hint nextpage and prevpage
			draw.SimpleText (">","ArialBoldTwelv",ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) ,ScaleH(982), Color_Labels[15],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText ("<","ArialBoldTwelv",ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) ,ScaleH(982), Color_Labels[16],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
			draw.SimpleText ("Waiting","ArialBoldTwenty", ScaleW(1022),ScaleH(68), COLOR_SUBTITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText (congratulations,"ArialTwentyTwo", ScaleW(136),ScaleH(49), COLOR_TITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (headertext.." ("..TimeToChange..")","ArialTwelve", ScaleW(136),ScaleH(98), COLOR_SUBTITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (wintext,"ArialTwenty", ScrW() * 0.5,ScaleH(931), COLOR_TITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText ("Game hints: "..randomhint,"ArialTwelve", ScrW() * 0.5,ScaleH(982), COLOR_GREY_ONE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		elseif WIDESCREEN then
			surface.SetDrawColor ( 35,35,35,255 )
			surface.DrawRect ( 0,0,ScaleW(1280),ScaleW(124) ) -- Bara grii de sus, aia mare
			surface.DrawRect ( 0,ScaleH(866), ScaleW(1280), ScaleW(124) ) -- bara grii de jos, aia mare
			
			-- The timer picture in the upper left corner
			surface.SetDrawColor ( 255,255,255,255 )
			surface.SetTexture ( TimerImage )
			surface.DrawTexturedRectRotated ( ScaleW(72), ScaleH(75), ScalePanel(64), ScalePanel(64), 0 )
			
			-- Spinner from l4d
			surface.SetDrawColor ( 255,255,255,255 )
			surface.SetTexture ( Spinner )
			surface.DrawTexturedRectRotated ( ScaleW(1194), ScaleH(80), ScalePanel(88), ScalePanel(88), 0 )
			
			--Next, prev buttons for hints
			local gamehinttext, dist = "Game hints: "..randomhint, 28
			surface.SetFont ( "ArialBoldTwelv" )
			local hintwide, hinttall = surface.GetTextSize ( gamehinttext )
			local signwide, signtall = surface.GetTextSize (">")
			
			--Update the labels position
			NextPageLabel[15]:SetPos ( ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) - (signwide / 2),ScaleH(978) - (signtall / 2) )
			NextPageLabel[16]:SetPos ( ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) - (signwide / 2) ,ScaleH(978) - (signtall / 2) )
			
			--Draw the hint nextpage and prevpage
			draw.SimpleText (">","ArialBoldTwelv",ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) ,ScaleH(978), Color_Labels[15],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText ("<","ArialBoldTwelv",ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) ,ScaleH(978), Color_Labels[16],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
			surface.SetDrawColor ( 62,62,62,255 )
			surface.DrawRect ( 0, ScaleW(124 - 5), ScaleW(1280), ScaleH(7) ) --- Bara aia subtire de sus
			surface.DrawRect ( 0, ScaleH(866), ScaleW(1280), ScaleH(7) ) --- Bara subtire de jos
		
			draw.SimpleText ("Waiting","ArialBoldTwenty", ScaleW(1022),ScaleH(75), COLOR_SUBTITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText (congratulations,"ArialTwentyTwo", ScaleW(136),ScaleH(54), COLOR_TITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (headertext.." ("..TimeToChange..")","ArialTwelve", ScaleW(136),ScaleH(113), COLOR_SUBTITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (wintext,"ArialTwenty", ScrW() * 0.5,ScaleH(918), COLOR_TITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText ("Game hints: "..randomhint,"ArialTwelve", ScrW() * 0.5,ScaleH(978), COLOR_GREY_ONE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	
	--- Create the champions panel
	local NITWITZ = vgui.Create("Nitwits")
	NITWITZ:SetVisible ( true )
	
	--Manange Nitwits
	ManageNitwits( NITWITZ )
	
	--- Create the team score panel
	local TEAM_PANEL = vgui.Create("Teamscore")
	TEAM_PANEL:SetVisible ( true )
	
	--Manange Team score
	ManageTeamScore( TEAM_PANEL )
	
	--- Create the general score panel
	local GENERAL_SCORE = vgui.Create("Generalscore")
	GENERAL_SCORE:SetVisible ( true )
	
	--Manage General score stuff
	ManageGeneralScore ( GENERAL_SCORE )
	
	//Reposition the chatbox if the nitwits panel isn't visible
	if not NITWITZ:IsVisible() then
		CustomChat.PosX = ScaleW(40)
		CustomChat.PosY = ScaleH(680)
	end
	
	// Open the custom chatbox
	CustomChat.ResetChat()
		
	print ("/************************* PANELS HAVE BEEN INIT /*************************")
end

/*---------------------------------------------------------
	   Intermission drawing function
---------------------------------------------------------*/
function DrawIntermission ( votemap, nextmap, winner )
end

/*---------------------------------------------------------
	   Manange team score stuff
---------------------------------------------------------*/
local GeneralTeamScores = {}
function ManageTeamScore ( panel )
	-- Initialize the subtitles
	panel.PageSubtitles = { 
		"General scores",
		"Greencoins gained",
		"Most chosen class" ,
	} 
	
	--Manage page stuff
	panel.Page = 1
	panel.MaxPages = 3
	
	-- Update "General scores" (can be done clientside)
	UpdateTeamScore()
end

/*---------------------------------------------------------
   Get teams score for general team score table
---------------------------------------------------------*/
function UpdateTeamScore ()
	local humanscore = 0
	local undeadscore = 0
	
	//Calculate the score
	for k,pl in pairs ( player.GetAll() ) do
		if pl:Team() == TEAM_HUMAN then
			humanscore = humanscore + pl:Frags()
		elseif pl:Team() == TEAM_UNDEAD then
			undeadscore = undeadscore + pl:Frags()
		end
	end

	-- Insert the scores into the main table
	GeneralTeamScores["General scores"] = { 
		[1] = humanscore,
		[2] = undeadscore,
	}
end

/*---------------------------------------------------------
	   Manange general score stuff
---------------------------------------------------------*/
function ManageGeneralScore ( panel )
	-- Main Title
	panel.PageTitle = {
		"GENERAL",
		"OFFENSIVE",
		"DEFENSIVE"
	}
	
	--Subtitles
	panel.PageSubtitle = {
		"Survival of the fittest",
		"Most greencoins gained",
		"Most assists (both teams)",
		"Most healing done (medic)",
		"Most undead killed",
		"Damage done to humans",
		"Most brains eaten",
		"Damage done to undead"
	}
	
	--Manage page stuff
	panel.Page = 1
	panel.MaxPages = 8	
end

local function ReceiveMostChosenClass ( um )
	GeneralTeamScores["Most chosen class"] = {}
	
	--The string received is composed of both stats. You have to sepparate them.
	local String = um:ReadString()
	local strexplode = string.Explode ( "|", String )
	
	-- Update teh teamscore table with Most Chosen Class
	for i = 1, 2 do
		GeneralTeamScores["Most chosen class"][i] = strexplode[i]
	end
end
usermessage.Hook ("RecMostChosenClass",ReceiveMostChosenClass)

/*---------------------------------------------------------
	  Receive Total Greencoins per team 
---------------------------------------------------------*/
local function ReceiveGreencoinsTeam ( um )
	--Initialize the subtable
	GeneralTeamScores["Greencoins gained"] = {}

	--Update that shit
	for i = 1,2 do
		GeneralTeamScores["Greencoins gained"][i] = um:ReadShort()
	end
end
usermessage.Hook ("RecTeamGreencoinsGained", ReceiveGreencoinsTeam)

/*---------------------------------------------------------
              Receive Top healing done ( medic)
---------------------------------------------------------*/
local TopHealing = {}
local function ReceiveTopHealing ( um )
	local index = um:ReadShort()
	TopHealing[index] = {}
	TopHealing[index].Name = um:ReadString()
	TopHealing[index].Score = um:ReadString()
end
usermessage.Hook("RcTopHealing", ReceiveTopHealing)

/*---------------------------------------------------------
              Receive Top Infected killed
---------------------------------------------------------*/
local TopZombiesKilled = {}
local function ReceiveTopZombiesKilled ( um )
	local index = um:ReadShort()
	TopZombiesKilled[index] = {}
	TopZombiesKilled[index].Name = um:ReadString()
	TopZombiesKilled[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombiesKilled", ReceiveTopZombiesKilled)

/*---------------------------------------------------------
                Receive Top Assists
---------------------------------------------------------*/
local TopAssists = {}
local function ReceiveTopAssists ( um )
	local index = um:ReadShort()
	TopAssists[index] = {}
	TopAssists[index].Name = um:ReadString()
	TopAssists[index].Score = um:ReadString()
end
usermessage.Hook("RcTopAssists", ReceiveTopAssists)

/*---------------------------------------------------------
                Receive Top Brains Eaten
---------------------------------------------------------*/
local TopBrainsEaten = {}
local function ReceiveTopZombies ( um )
	local index = um:ReadShort()
	TopBrainsEaten[index] = {}
	TopBrainsEaten[index].Name = um:ReadString()
	TopBrainsEaten[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombies", ReceiveTopZombies)

/*---------------------------------------------------------
       Receive Top Damage done by Humans
---------------------------------------------------------*/
local TopHumanDamage = {}
local function ReceiveTopHumanDamages ( um )
	local index = um:ReadShort()
	TopHumanDamage[index] = {}
	TopHumanDamage[index].Name = um:ReadString()
	TopHumanDamage[index].Score = um:ReadString()
end
usermessage.Hook("RcTopHumanDamages", ReceiveTopHumanDamages)

/*---------------------------------------------------------
       Receive Top Damage done by Zombies
---------------------------------------------------------*/
local TopZombieDamage = {}
local function ReceiveTopZombieDamages ( um )
	local index = um:ReadShort()
	TopZombieDamage[index] = {}
	TopZombieDamage[index].Name = um:ReadString()
	TopZombieDamage[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombieDamages", ReceiveTopZombieDamages)

/*---------------------------------------------------------
           Receive Top Greencoins Gained
---------------------------------------------------------*/
local TopGreencoinsGained = {}
local function ReceiveTopGreencoins ( um )
	local i = um:ReadShort()
	TopGreencoinsGained[i] = {}
	TopGreencoinsGained[i].Name = um:ReadString()
	TopGreencoinsGained[i].Score = um:ReadString()
end
usermessage.Hook("RcTopGreencoins", ReceiveTopGreencoins)

/*---------------------------------------------------------
           Receive Top Survival Times
---------------------------------------------------------*/
local TopSurvivalTimes = {}
local function ReceiveTopTimes ( um )
	local i = um:ReadShort()
	TopSurvivalTimes[i] = {}
	TopSurvivalTimes[i].Name = um:ReadString()
	TopSurvivalTimes[i].Score = um:ReadString()
end
usermessage.Hook("RcTopTimes", ReceiveTopTimes)

/*---------------------------------------------------------
	   Receive VoteMap List (6 maps)
---------------------------------------------------------*/

-- Init the votemap list and points
--[[
local Votemaplist = {}
local VotePoints = {}

local function ReceiveVotemaps ( um )
	---A total of 6 maps
	for i = 1,3 do
		Votemaplist[i] = um:ReadString()
	end
	
	PrintTable ( Votemaplist )
end
usermessage.Hook("RecVotemaps", ReceiveVotemaps)

/*---------------------------------------------------------
	   Receive Votepoints (6 maps)
---------------------------------------------------------*/
local function ReceiveVotePoints ( um ) 
	--Update our current list
	for i = 1,3 do
		VotePoints[i] = um:ReadShort()
	end
end
usermessage.Hook("RecVoteChange",ReceiveVotePoints)

/*---------------------------------------------------------
     Receive the voted map slot server-side
---------------------------------------------------------*/
local function ReceiveAutomaticVoteResult ( um )
	-- Receive vote result for those who didn't vote manually from server
	MySelf.VotedMapSlot = um:ReadShort()
end
usermessage.Hook("RecAutomaticVoteResult",ReceiveAutomaticVoteResult)

/*---------------------------------------------------------
	   Receive Nextmap ( Vote Result )
---------------------------------------------------------*/
function SetWinnerMap ( mapname )
	WinnerMap = mapname
	IsVotingOver = true
	
	--Switch vote panel page to the winner map if widescreen
	local panel,slot = VOTEMAP,1
	if WIDESCREEN then
		for i = 1, #panel.Maps do
			if tostring(WinnerMap) == panel.Maps[i] then
				slot = i
				break
			end
		end
		
		if slot < 4 then	
			panel.Page = 1
		elseif slot >= 4 and slot < 7 then
			panel.Page = 2
		end
	end
end]]

/*---------------------------------------------------------
	        Manage Votemap Panel
---------------------------------------------------------*/
function ManageVotemap ( panel )
	panel.Maps = {}
	
	--Wide,tall
	if SCREEN then
		panel:SetSize ( ScaleW(440),ScaleH(214) )
	else
		panel:SetSize ( ScalePanel(440),ScalePanel(214) )
	end
	
	panel:SetPos ( ScaleW(269), h * 0.5 )
	
	local Wide,Tall = panel:GetWide(),panel:GetTall()
	
	-- Initlaize the votemap bool ( see if the map is already set)
	MySelf.VoteAlready = false

	for k,v in ipairs (Votemaplist) do
		panel.Maps[k] = v
		VotePoints[k] = 0
	end
	
	-- Create the labels 
	local h,posy,tall = 0,0,0
	if SCREEN then h = ScaleH(122) posy = ScaleH(16) tall = ScaleH(30) else h = ScalePanel(122) posy = ScalePanel(16) tall = ScalePanel(30) end

	--Pagestuff
	panel.Page = 1
	panel.MaxPages = 1
	if WIDESCREEN then panel.MaxPages = 1 end
	
	local fitonpage = 3
	if WIDESCREEN then fitonpage = 3 end
	
	for i = 1, fitonpage do
		DoLabel ( i+8, panel, font, text, 7, h - posy, COLOR_LIGHT_GREY, "label", Color(0,0,0,0), Wide - 14, tall )
		
		local increment = ScaleH(34)
		if WIDESCREEN then increment = ScalePanel(34) end
		h = h + increment
	end
end

/*---------------------------------------------------------
      Receive Nitwits (as Clavus or Ywa named them)
---------------------------------------------------------*/

-- Init the Nitwits table
local Nitwits = {}

local function ReceiveNitwits(um)
	-- Reset any existing table
	table.Empty ( Nitwits )
	
	--- A total of 12 Nitwits (  HOLY SHIT  )
	for i = 1,12 do
		Nitwits[i] = um:ReadString()
	end
end
usermessage.Hook("RcTopNitwits", ReceiveNitwits)

/*---------------------------------------------------------
		Manage Nitwits
---------------------------------------------------------*/
function ManageNitwits ( panel )

	-- Create the actual nitwit list desc.
	local NitwitsInOrder = { 
		"Most scary player",
		"Most horny player",
		"Most unhappy player",
		"Most brutal player",
		"Most propkills",
		"Last human",
		"Most headshots",
		"Most helpful player",
		"Most undead meleed",
		"First player redeemed",
		"Most greencoins gained",
		"Hungriest zombie" 
	}	

	panel.PageScoreName = {} -- Nitwit name / description
	panel.PageScore = {} -- Player names

	local id = 0
	for k,v in ipairs (Nitwits) do
		id = id + 1
		if v != "" then
			panel.PageScoreName[id] = NitwitsInOrder[k] 
			panel.PageScore[id] = Nitwits[k] 
		end
	end
	
	-- Convert the tables to consecutive keys from 1 to .. how many items are in there
	table.Resequence ( panel.PageScoreName )
	table.Resequence ( panel.PageScore )
	
	--Manage page stuff
	panel.Page = 1 -- Current Page
	
	--- Maximum pages stuff
	local entryperpage = 0
	if SCREEN then
		entryperpage = 6
	else	
		entryperpage = 3
	end
	
	-- Calc total pages
	panel.MaxPages = math.ceil ( #panel.PageScoreName / entryperpage )
	
	--Close the panel if there are 0-1 players in it
	if #panel.PageScoreName <= 1 then
		panel:SetVisible ( false )
		panel = nil
	end
end

/*---------------------------------------------------------
		Votemap Panel
---------------------------------------------------------*/
local VOTEMAP_PANEL = {}

function VOTEMAP_PANEL:Init()
	VOTEMAP = self
end

function VOTEMAP_PANEL:Paint()
	local Wide = self:GetWide()
	local Tall = self:GetTall()
	
	draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
	surface.SetDrawColor ( COLOR_BLUE )
	
	//Voted map names
	if not self.MapNames then
		self.MapNames = {}
		for i = 1, 3 do
			local tbMap, strName = TranslateMapTable [ self.Maps[i] ], table.Random ( { "Unknown Place", "Creepy Horrors", "Mysterious Place" } )
			if tbMap then strName = tostring ( tbMap.Name ) end
			self.MapNames[i] = strName
		end
	end
	
	-- Voted map name (the one voted by you)
	local votedmap = "None"
	if MySelf.VoteAlready == true and MySelf.VotedMapSlot != nil then
		if not MySelf.strMapVote then MySelf.strMapVote = string.gsub ( self.MapNames[ MySelf.VotedMapSlot ], "(voted)", "" ) or "a map" end
		votedmap = MySelf.strMapVote
	end
	
	local nextsign,prevsign = ">","<"
	local voteheader = ""
	
	if SCREEN then
		voteheader = "Select the next map for the gamemode!"
		if MySelf.VoteAlready == true then
			voteheader = "You have voted '"..tostring(votedmap).."' !"
		end
		if IsVotingOver == true then
			voteheader = "Voting has successfully ended."
		end
		
		surface.DrawRect ( 7,7, Wide - 14, ScaleH(93) )
		draw.SimpleText ("VOTEMAP:","ArialBoldEighteen", ScaleW(25),ScaleH(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText (tostring(voteheader),"ArialBoldNine", ScaleW(28),ScaleH(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	elseif WIDESCREEN then
		voteheader = "Select a map to vote!"
		if MySelf.VoteAlready == true then
			voteheader = "You've voted '"..tostring(votedmap).."' !"
		end
		if IsVotingOver == true then
			voteheader = "Voting has successfully ended."
		end
		
		surface.DrawRect ( 7,7, Wide - 14 , ScalePanel(93) )
		draw.SimpleText ("VOTEMAP:","ArialBoldEighteen", ScalePanel(25),ScalePanel(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText (tostring(voteheader),"ArialBoldNine", ScalePanel(28),ScalePanel(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	
	if SCREEN then
		self.Height = ScaleH(122)
		for i = 1,3 do
			-- Draw the selection area on every slot, but keep the color invisible
			surface.SetDrawColor ( Color_Labels[i+8] )
			surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
			
			if i == MySelf.VotedMapSlot then
				if not string.find ( self.MapNames[i], "(voted)" ) then self.MapNames[i] = self.MapNames[i].." (voted)" end
				Color_Labels[i+8] = COLOR_LIGHT_GREY
			end
			
			-- Write (winner) if the map is the voted one
			if IsVotingOver == true and self.Maps[i] == tostring (WinnerMap) then
				if not string.find ( self.MapNames[i], "(winner)" ) then self.MapNames[i] = self.MapNames[i].." (winner)" end
			end
			
			-- Select the win map and make it red
			if self.Maps[i] == WinnerMap then	
				Color_Labels[i+8] = COLOR_LIGHT_RED
			end
			
			local howmanyvotes = "votes"
			if VotePoints[i] == 1 then
				howmanyvotes = "vote"
			end
						
			draw.SimpleText (tostring( self.MapNames[i] ),"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (tostring(VotePoints[i]).." "..howmanyvotes,"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			self.Height = self.Height + ScaleH(34)
		end	
	elseif WIDESCREEN then
		self.Height = ScalePanel(122)
		for i = 1,3 do
			local slot = i
			if i > 3 and self.Page == 2 then
				slot = i - 3
			end
			
			--Reset the first position if you change to page 2
			if slot == 1 then
				self.Height = ScalePanel(122)
			end
		
			-- Draw the selection area on every slot, but keep the color invisible
			if ( self.Page == 1 and i < 4 ) or ( self.Page == 2 and i >= 4 ) then
				surface.SetDrawColor ( Color_Labels[i+8] )
				surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
			end
			
			-- Write (voted) on the map you voted.
			if i == MySelf.VotedMapSlot then
				if not string.find ( self.MapNames[i], "(voted)" ) then self.MapNames[i] = self.MapNames[i].." (voted)" end
				Color_Labels[i+8] = COLOR_LIGHT_GREY
			end
			
			-- Write (winner) if the map is the voted one
			if IsVotingOver == true and self.Maps[i] == tostring (WinnerMap) then
				if not string.find ( self.MapNames[i], "(winner)" ) then self.MapNames[i] = self.MapNames[i].." (winner)" end
			end
			
			-- Select the win map and make it red
			if self.Maps[i] == WinnerMap then	
				Color_Labels[i+8] = COLOR_LIGHT_RED
			end
			
			local howmanyvotes = "votes"
			if VotePoints[i] == 1 then
				howmanyvotes = "vote"
			end
			
			if ( self.Page == 1 and i < 4 ) or ( self.Page == 2 and i >= 4 ) then
				draw.SimpleText (tostring( self.MapNames[i] ),"ArialNine", ScalePanel(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText (tostring(VotePoints[i]).." "..howmanyvotes,"ArialNine", Wide - 17 ,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
				self.Height = self.Height + ScalePanel(34)
			end
		end	
	end
	
	return true
end

function VOTEMAP_PANEL:Think()
	self:PerformLayout()
end

function VOTEMAP_PANEL:PerformLayout()
	local wNitwit, hNitwit = NITWITS:GetPos()
	local h = hNitwit - ( NITWITS:GetTall() * 0.1 ) - ( self:GetTall() * 0.5 )

	if SCREEN then
		if not NITWITS:IsVisible() then
			h = ScaleH(485)
		end
		self:SetSize ( ScaleW(440),ScaleH(214) )
		self:SetPos ( ScaleW(269), h)
	elseif WIDESCREEN then
		if not NITWITS:IsVisible() then
			h = ScaleH(476)
		end
		self:SetSize ( ScalePanel(440),ScalePanel(214) )
		self:SetPos ( ScaleW(260),h )
	end
	
	-- Align the panel to the center.
	self:AlignCenter()
end
vgui.Register("Votemap", VOTEMAP_PANEL, "Panel")


/*---------------------------------------------------------
		Nitwits panel
---------------------------------------------------------*/
local NITWITS_PANEL = {}

function NITWITS_PANEL:Init()
	NITWITS = self
	if SCREEN then
		self:SetSize ( ScaleW(440),ScaleH(317) )
	elseif WIDESCREEN then
		self:SetSize ( ScalePanel(440),ScalePanel(216) )
	end
	
	DoLabel ( 3, self, "ArialBoldEighteen", ">", ScaleW(400), ScaleH(54), COLOR_DARK_GREY_BUTTON, "next", COLOR_DARK_GREY ) -- Next button
	DoLabel ( 4, self, "ArialBoldEighteen", "<", ScaleW(370), ScaleH(54), COLOR_DARK_GREY_BUTTON, "prev", COLOR_DARK_GREY ) -- Prev button
end

function NITWITS_PANEL:Paint()
	local Wide = self:GetWide()
	local Tall = self:GetTall()
	
	draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
	surface.SetDrawColor ( COLOR_BLUE )
	
	local nextsign, prevsign = ">", "<"
	
	if SCREEN then
		surface.DrawRect ( 7,7, Wide - 14, ScaleH(93) )
		draw.SimpleText ("TOP RANKS:","ArialBoldEighteen", ScaleW(25),ScaleH(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText ("Veteran scores (page "..self.Page..")","ArialBoldNine", ScaleW(28),ScaleH(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		--Draw the buttons > and <
		draw.SimpleText (nextsign,"ArialBoldEighteen",ScaleW(400),ScaleH(54), Color_Labels[3],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText (prevsign,"ArialBoldEighteen",ScaleW(370),ScaleH(54), Color_Labels[4],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		self.Height = ScaleH(122)
		for i = 1,#self.PageScoreName do
			if self.Page == 2 then
				if i == 7 then
					self.Height = ScaleH(122)
				end
			end
			
			local scoredesc = self.PageScoreName[i]
			local playername = self.PageScore[i]
			
			if (self.Page == 1 and i < 7) or (self.Page == 2 and i >= 7 ) then
				-- Draw the selection box on your name
				local howmany,slot = 0,0
				if MySelf:Name() == playername then
					for i = 1, #self.PageScoreName do
						if self.PageScore[i] == MySelf:Name() then
							slot = i
							if i == 2 then
								break
							end
						end
					end
					for i = 1, #self.PageScoreName do
						if self.PageScore[i] == MySelf:Name() then
							howmany = howmany + 1
						end
					end
					
					if i == slot and howmany > 1 then
						surface.SetDrawColor ( Color ( 116,26,26,252 * math.abs ( math.sin ( CurTime() * 2.1 ) ) ) )
						scoredesc = scoredesc.." (bonus)"
					else
						surface.SetDrawColor ( COLOR_LIGHT_GREY )
					end
					
					surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
				end
				
				//Format player name so it doesn't exceed a character limit
				local text = string.Explode ("", playername )
				playername = ""
				for k,v in pairs (text) do
					if k <= 14 then
						playername = playername..v
					elseif k > 14 and k <= 17 then
						playername = playername.."."
					end
				end

				--- Draw the description of the nitwit and name of the veteran
				draw.SimpleText (scoredesc,"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText (playername,"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
				self.Height = self.Height + ScaleH(34)
			end
		end	
	elseif WIDESCREEN then
		surface.DrawRect ( 7,7, Wide - 14 , ScalePanel(93) )
		draw.SimpleText ("TOP RANKS:","ArialBoldEighteen", ScalePanel(25),ScalePanel(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText ("Veteran scores (page "..self.Page..")","ArialBoldNine", ScalePanel(28),ScalePanel(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		--Draw the button > and <
		draw.SimpleText (nextsign,"ArialBoldEighteen",ScalePanel(400),ScalePanel(54), Color_Labels[3],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText (prevsign,"ArialBoldEighteen",ScalePanel(370),ScalePanel(54), Color_Labels[4],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		self.Height = ScalePanel(122)
		for i = 1,#self.PageScoreName do
			if self.Page == 2 then
				if i == 4 then
					self.Height = ScalePanel(122)
				end
			end
			
			local scoredesc = self.PageScoreName[i]
			local playername = self.PageScore[i]
			
			if (self.Page == 1 and i < 4) or (self.Page == 2 and (i < 7 and i >= 4) ) or (self.Page == 3 and (i < 10 and i >= 7) ) or (self.Page == 4 and (i < 13 and i >= 10) ) then
				-- Draw the selection box on your name
				local howmany,slot = 0,0
				if MySelf:Name() == playername then
					for i = 1, #self.PageScoreName do
						if self.PageScore[i] == MySelf:Name() then
							slot = i
							break
						end
					end
					for i = 1, #self.PageScoreName do
						if self.PageScore[i] == MySelf:Name() then
							howmany = howmany + 1
						end
					end
					
					if i == slot and howmany > 1 then
						surface.SetDrawColor ( Color ( 116,26,26,252 * math.abs ( math.sin ( CurTime() * 2.1 ) ) ) )
						scoredesc = scoredesc.." (bonus)"
					else
						surface.SetDrawColor ( COLOR_LIGHT_GREY )
					end
					surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
				end
				
				//Format player name so it doesn't exceed a character limit
				local text = string.Explode ("", playername )
				playername = ""
				for k,v in pairs (text) do
					if k <= 14 then
						playername = playername..v
					elseif k > 14 and k <= 17 then
						playername = playername.."."
					end
				end
				
				--- Draw the description of the nitwit and name of the veteran
				draw.SimpleText (scoredesc,"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
				draw.SimpleText (playername,"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
				self.Height = self.Height + ScalePanel(34)
			end
		end	
	end
	
	---Resize the panel (we only need height)
	local height = self.Height - ScaleH(10)
	if WIDESCREEN then height = self.Height - ScalePanel(12) end
	
	self:Resize ( nil, height )
	
	self:PerformLayout()
		
	return true
end

function NITWITS_PANEL:PerformLayout()
	if SCREEN then
		self:SetPos ( ScaleW(269),ScaleH(676) )
	elseif WIDESCREEN then
		self:SetPos ( ScaleW(261),ScaleH(672) )
	end

	-- Align the panel to the center.
	self:AlignCenter()
end

function NITWITS_PANEL:Resize ( w, h )
	if SCREEN then
		self:SetSize ( ScaleW(440), h )
	else
		self:SetSize ( ScalePanel(440), h )
	end
end
vgui.Register("Nitwits", NITWITS_PANEL, "Panel")

/*---------------------------------------------------------
		Team score panel
---------------------------------------------------------*/
local TEAMSCORE_PANEL = {}

function TEAMSCORE_PANEL:Init()
	TEAMSCORE = self
	DoLabel ( 5, self, "ArialBoldEighteen", ">", ScaleW(412), ScaleH(54), COLOR_DARK_GREY_BUTTON, "next", COLOR_DARK_GREY ) -- Next Button
	DoLabel ( 6, self, "ArialBoldEighteen", "<", ScaleW(383), ScaleH(54), COLOR_DARK_GREY_BUTTON, "prev", COLOR_DARK_GREY ) -- Return Button
	
	-- Limit for scores
	self.ScoreBest = {
		["General scores"] = 100,
		["Greencoins gained"] = 1000
	}
end

local Teams = {"Team Humans", "Team Undead" }

function TEAMSCORE_PANEL:Paint()
	local Wide = self:GetWide()
	local Tall = self:GetTall()
	
	draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
	surface.SetDrawColor ( COLOR_BLUE )
	
	-- Dynamic stuff
	local nextsign,prevsign = ">","<"
	local subtitle = self.PageSubtitles[self.Page]
	
	if SCREEN then
		surface.DrawRect ( 7,7, Wide - 14, ScaleH(93) )
		draw.SimpleText ("TEAM SCORES:","ArialBoldEighteen", ScaleW(25),ScaleH(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText (subtitle.." (page "..self.Page..")","ArialBoldNine", ScaleW(28),ScaleH(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		--Draw the button > and <
		draw.SimpleText (nextsign,"ArialBoldEighteen",ScaleW(412),ScaleH(54), Color_Labels[5],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText (prevsign,"ArialBoldEighteen",ScaleW(383),ScaleH(54), Color_Labels[6],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			
		self.Height = ScaleH(122)
		for i = 1,2 do
			--Draw selection rectangle over your team.
			if ( MySelf:Team() == TEAM_HUMAN and i == 1 ) or ( MySelf:Team() == TEAM_UNDEAD and i == 2 ) then
				surface.SetDrawColor ( COLOR_LIGHT_GREY )
				surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
			end
			
			-- Subtitle and score
			local score = "No Score"
			if subtitle then
				if GeneralTeamScores[ subtitle ] then
					score = GeneralTeamScores[ subtitle ][i]
				end
			end
			
			-- Set up some nice titles :D
			local scorenumber = tonumber(score)
			local title = ""
			
			if scorenumber != nil then
				if scorenumber >= self.ScoreBest[subtitle] then
					title = "(Co-op)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
					title = "(Organized)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
					title = "(Lazy)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
					title = "(Newbie-ish)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 5 ) then
					title = "(Mingebag Cluster)"
				end
				
				if title != "" then
					surface.SetDrawColor ( COLOR_DARK_RED )
					surface.DrawRect ( 7, self.Height - ScaleH(15), Wide - 14, ScaleH(30) )
				end
			end
			
			--Write winner in front of the winner :P
			if ( i == 1 and ROUNDWINNER == TEAM_HUMAN ) or ( i == 2 and ROUNDWINNER == TEAM_UNDEAD ) then
				title = title.." (Winner)"
			end
			
			draw.SimpleText (Teams[i].." "..title,"ArialNine", ScaleW(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (tostring(score),"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			self.Height = self.Height + ScaleH(34)
		end	
	elseif WIDESCREEN then
		surface.DrawRect ( 7,7, Wide - 14, ScalePanel(93) )
		draw.SimpleText ("TEAM SCORES:","ArialBoldEighteen", ScalePanel(25),ScalePanel(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText (subtitle.." (page "..self.Page..")","ArialBoldNine", ScalePanel(28),ScalePanel(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		--Draw the button > and <
		draw.SimpleText (nextsign,"ArialBoldEighteen",ScalePanel(412),ScalePanel(54), Color_Labels[5],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText (prevsign,"ArialBoldEighteen",ScalePanel(383),ScalePanel(54), Color_Labels[6],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		
		self.Height = ScalePanel(122)
		for i = 1,2 do
			--Draw selection rectangle over your team.
			if ( MySelf:Team() == TEAM_HUMAN and i == 1 ) or ( MySelf:Team() == TEAM_UNDEAD and i == 2 ) then
				surface.SetDrawColor ( COLOR_LIGHT_GREY )
				surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
			end
			
			-- Subtitle and score
			local score = "No Score"
			if subtitle then
				if GeneralTeamScores[ subtitle ] then
					score = GeneralTeamScores[ subtitle ][i]
				end
			end
			
			-- Set up some nice titles :D
			local scorenumber = tonumber(score)
			local title = ""
			
			if scorenumber != nil then
				if scorenumber >= self.ScoreBest[subtitle] then
					title = "(Co-op)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
					title = "(Organized)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
					title = "(Lazy)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
					title = "(Newbie-ish)"
				elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 5 ) then
					title = "(Mingebag Cluster)"
				end
				
				if title != "" then
					surface.SetDrawColor ( COLOR_DARK_RED )
					surface.DrawRect ( 7, self.Height - ScalePanel(15), Wide - 14, ScalePanel(30) )
				end
			end
			
			--Write winner in front of the winner :P
			if ( i == 1 and ROUNDWINNER == TEAM_HUMAN ) or ( i == 2 and ROUNDWINNER == TEAM_UNDEAD ) then
				title = title.." (Winner)"
			end
			
			draw.SimpleText (Teams[i].." "..title,"ArialNine", ScalePanel(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (tostring(score),"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			self.Height = self.Height + ScalePanel(34)
		end	
	end
		
	return true
end

function TEAMSCORE_PANEL:PerformLayout()
	if SCREEN then
		self:SetSize ( ScaleW(449),ScaleH(179) )
		self:SetPos ( ScaleW(865),ScaleH(348) )
	elseif WIDESCREEN then
		self:SetSize ( ScalePanel(479),ScalePanel(178) )
		self:SetPos ( ScaleW(867),ScaleH(310) )
	end
	
	-- Align the panel to the center.
	self:AlignCenter()
end
vgui.Register("Teamscore", TEAMSCORE_PANEL, "Panel")

/*---------------------------------------------------------
	   Damage/Healing etc Panel
---------------------------------------------------------*/
local GENERALSCORE_PANEL = {}

function GENERALSCORE_PANEL:Init()
	local Wide,Tall
	
	if SCREEN then
		Wide,Tall = ScaleW(704),ScaleH(288)
	else
		Wide,Tall = ScalePanel(704),ScalePanel(288)
	end
	
	-- Limit for scores
	self.ScoreBest = {
		["Survival of the fittest"] = 0,
		["Most greencoins gained"] = 100 ,
		["Most assists (both teams)"] = 50,
		["Most healing done (medic)"] = 300,
		["Most undead killed"] = 70,
		["Damage done to humans"] = 1000,
		["Most brains eaten"] = 12,
		["Damage done to undead"] = 10000
	}
	
	GENERALSCORE = self
	DoLabel ( 7, self, "ArialBoldEighteen", ">", Wide - ScaleW(36), ScaleH(57), COLOR_DARK_GREY_BUTTON, "next", COLOR_DARK_GREY ) -- Next button
	DoLabel ( 8, self, "ArialBoldEighteen", "<", Wide - ScaleW(64), ScaleH(57), COLOR_DARK_GREY_BUTTON, "prev", COLOR_DARK_GREY ) -- Prev button
end

//Materials for the picture for each rank - Don't change the ORDER! (With chainsawman's help)
local ScoreImage = {
	[8] = surface.GetTextureID ("zombiesurvival/endgame/mostdamagedone"),
	[4] = surface.GetTextureID ("zombiesurvival/endgame/healing"),
	[3] = surface.GetTextureID ("zombiesurvival/endgame/assists"),
	[2] = surface.GetTextureID ("zombiesurvival/endgame/greencoins"),
	[1] = surface.GetTextureID ("zombiesurvival/endgame/survival"),
	[6] = surface.GetTextureID ("zombiesurvival/endgame/damagezombies"),
	[5] = surface.GetTextureID ("zombiesurvival/endgame/undeadkilled"),
	[7] = surface.GetTextureID ("zombiesurvival/endgame/brains"),
}

function GENERALSCORE_PANEL:Paint()
	local Wide = self:GetWide()
	local Tall = self:GetTall()
	
	draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY )
	surface.SetDrawColor ( COLOR_BLUE )
	
	local nextsign,prevsign = ">","<"
	local subtitle = self.PageSubtitle[self.Page]
	local title = ""
	
	if subtitle == "Most assists (both teams)" or subtitle == "Most healing done (medic)" then
		title = self.PageTitle[3]
	elseif subtitle == "Most undead killed" or subtitle == "Damage done to humans" or subtitle == "Most brains eaten" or subtitle == "Damage done to undead" then
		title = self.PageTitle[2]
	else
		title = self.PageTitle[1]
	end
	
	if SCREEN then
		surface.DrawRect ( ScaleW(280),7, Wide - ScaleW(280) - 7, ScaleH(100) )
		draw.SimpleText (title..":","ArialBoldEighteen", ScaleW(295),ScaleH(40), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText (subtitle,"ArialBoldNine", ScaleW(298),ScaleH(80), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

		-- Draw the button > and < 
		draw.SimpleText (nextsign,"ArialBoldEighteen",Wide - ScaleW(36),ScaleH(57), Color_Labels[7],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText (prevsign,"ArialBoldEighteen",Wide - ScaleW(64),ScaleH(57), Color_Labels[8],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		--Draw the specific image
		surface.SetTexture ( ScoreImage[self.Page] )
		surface.SetDrawColor ( 255,255,255,255 )
		surface.DrawTexturedRectRotated ( ScaleW(140), Tall / 2, ScaleW(267), ScaleH(270), 0 )
		
		local h = ScaleH(129)
		for i = 1,5 do
			-- Page setup!
			local playername,playerscore = "No Name","No Score"
			if subtitle == "Most greencoins gained" then
				if TopGreencoinsGained[i] then
					playername = TopGreencoinsGained[i].Name
					playerscore = TopGreencoinsGained[i].Score
				end
			elseif subtitle == "Survival of the fittest" then
				if TopSurvivalTimes[i] then
					playername = TopSurvivalTimes[i].Name
					playerscore = TopSurvivalTimes[i].Score
				end			
			elseif subtitle == "Most assists (both teams)" then
				if TopAssists[i] then
					playername = TopAssists[i].Name
					playerscore = TopAssists[i].Score
				end
			elseif subtitle == "Most healing done (medic)" then
				if TopHealing[i] then
					playername = TopHealing[i].Name
					playerscore = TopHealing[i].Score
				end	
			elseif subtitle == "Most undead killed" then
				if TopZombiesKilled[i] then
					playername = TopZombiesKilled[i].Name
					playerscore = TopZombiesKilled[i].Score
				end		
			elseif subtitle == "Damage done to humans" then
				if TopZombieDamage[i] then
					playername = TopZombieDamage[i].Name
					playerscore = TopZombieDamage[i].Score
				end	
			elseif subtitle == "Most brains eaten" then
				if TopBrainsEaten[i] then
					playername = TopBrainsEaten[i].Name
					playerscore = TopBrainsEaten[i].Score
				end	
			elseif subtitle == "Damage done to undead" then
				if TopHumanDamage[i] then
					playername = TopHumanDamage[i].Name
					playerscore = TopHumanDamage[i].Score
				end	
			end
			
			--Draw selection box over your name
			if MySelf:Name() == playername then 
				surface.SetDrawColor ( COLOR_LIGHT_GREY )
				surface.DrawRect ( ScaleW(280), h - ScaleH(15), Wide - ScaleW(287), ScaleH(30) )
			end
			
			if i == 1 then
				local scorenumber = tonumber(playerscore)
				local title = ""
				if scorenumber != nil then
					if scorenumber >= self.ScoreBest[subtitle] then
						title = "(Insane)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
						title = "(Skilled)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
						title = "(Mediocre)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
						title = "(Newbie)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 10 ) then
						title = "(Mingebag)"
					end
										
					if title != "" then
						playername = playername.." "..title
						surface.SetDrawColor ( COLOR_DARK_RED )
						surface.DrawRect ( ScaleW(280), h - ScaleH(15), Wide - ScaleW(287), ScaleH(30) )
					end
				end
			end
		
			//Format player name so it doesn't exceed a character limit
			local text = string.Explode ("", playername )
			playername = ""
			for k,v in pairs (text) do
				if k <= 25 then
					playername = playername..v
				elseif k > 25 and k <= 28 then
					playername = playername.."."
				end
			end
				
			draw.SimpleText (playername,"ArialNine", ScaleW(280 + 7),h, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (playerscore,"ArialNine", Wide - 17,h, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			h = h + ScaleH(34)
		end	
	elseif WIDESCREEN then
		surface.DrawRect ( ScalePanel(280),7, Wide - ScalePanel(280) - 7, ScalePanel(100) )
		draw.SimpleText (title..":","ArialBoldEighteen", ScalePanel(295),ScalePanel(40), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText (subtitle,"ArialBoldNine", ScalePanel(297),ScalePanel(80), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		
		-- Draw the button > and <
		draw.SimpleText (nextsign,"ArialBoldEighteen",Wide - ScalePanel(36),ScalePanel(57), Color_Labels[7],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.SimpleText (prevsign,"ArialBoldEighteen",Wide - ScalePanel(64),ScalePanel(57), Color_Labels[8],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

		--Draw the specific image
		surface.SetTexture ( ScoreImage[self.Page] )
		surface.SetDrawColor ( 255,255,255,255 )
		surface.DrawTexturedRectRotated ( ScalePanel(140), Tall / 2, ScalePanel(267), ScalePanel(270), 0 )
		
		local h = ScalePanel(129)
		for i = 1,5 do
			-- Page setup!
			local playername,playerscore = "No Name","No Score"
			local playername,playerscore = "No Name","No Score"
			if subtitle == "Most greencoins gained" then
				if TopGreencoinsGained[i] then
					playername = TopGreencoinsGained[i].Name
					playerscore = TopGreencoinsGained[i].Score
				end
			elseif subtitle == "Survival of the fittest" then
				if TopSurvivalTimes[i] then
					playername = TopSurvivalTimes[i].Name
					playerscore = TopSurvivalTimes[i].Score
				end			
			elseif subtitle == "Most assists (both teams)" then
				if TopAssists[i] then
					playername = TopAssists[i].Name
					playerscore = TopAssists[i].Score
				end
			elseif subtitle == "Most healing done (medic)" then
				if TopHealing[i] then
					playername = TopHealing[i].Name
					playerscore = TopHealing[i].Score
				end	
			elseif subtitle == "Most undead killed" then
				if TopZombiesKilled[i] then
					playername = TopZombiesKilled[i].Name
					playerscore = TopZombiesKilled[i].Score
				end		
			elseif subtitle == "Damage done to humans" then
				if TopZombieDamage[i] then
					playername = TopZombieDamage[i].Name
					playerscore = TopZombieDamage[i].Score
				end	
			elseif subtitle == "Most brains eaten" then
				if TopBrainsEaten[i] then
					playername = TopBrainsEaten[i].Name
					playerscore = TopBrainsEaten[i].Score
				end	
			elseif subtitle == "Damage done to undead" then
				if TopHumanDamage[i] then
					playername = TopHumanDamage[i].Name
					playerscore = TopHumanDamage[i].Score
				end	
			end
			
			--Draw selection box over your name
			if MySelf:Name() == playername then 
				surface.SetDrawColor ( COLOR_LIGHT_GREY )
				surface.DrawRect ( ScalePanel(280), h - ScalePanel(15), Wide - ScalePanel(287), ScalePanel(30) )
			end
			
			if i == 1 then
				local scorenumber = tonumber(playerscore)
				local title = ""
				if scorenumber != nil then
					if scorenumber >= self.ScoreBest[subtitle] then
						title = "(Insane)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 2 ) then
						title = "(Skilled)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 3 ) then
						title = "(Mediocre)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 4 ) then
						title = "(Newbie)"
					elseif scorenumber >= math.ceil ( self.ScoreBest[subtitle] / 10 ) then
						title = "(Mingebag)"
					end
										
					if title != "" then
						playername = playername.." "..title
						surface.SetDrawColor ( COLOR_DARK_RED )
						surface.DrawRect ( ScalePanel(280), h - ScalePanel(15), Wide - ScalePanel(287), ScalePanel(30) )
					end
				end
			end
			
			//Format player name so it doesn't exceed a character limit
			local text = string.Explode ("", playername )
			playername = ""
			for k,v in pairs (text) do
				if k <= 25 then
					playername = playername..v
				elseif k > 25 and k <= 28 then
					playername = playername.."."
				end
			end
				
			draw.SimpleText (playername,"ArialNine", ScalePanel(280 + 7),h, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText (playerscore,"ArialNine", Wide - ScalePanel(17),h, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
			h = h + ScalePanel(34)
		end	
	end
	
	return true
end

function GENERALSCORE_PANEL:PerformLayout()
	if SCREEN then
		self:SetSize ( ScaleW(704),ScaleH(288) )
		self:SetPos ( ScaleW(893),ScaleH(625) )
	elseif WIDESCREEN then
		self:SetSize ( ScalePanel(704),ScalePanel(288) )
		self:SetPos ( ScaleW(889),ScaleH(641) )
	end
	
	-- Align the panel to the center.
	self:AlignCenter()
end
vgui.Register("Generalscore", GENERALSCORE_PANEL, "Panel")

/*---------------------------------------------------------
	   Label creation base function
---------------------------------------------------------*/
function DoLabel ( id, parent, font, text, posx, posy, colorenter, buttontype, colorexit,wide,tall )
	NextPageLabel[id] = vgui.Create("DLabel")
	NextPageLabel[id]:SetParent ( parent )
	NextPageLabel[id]:SetText ("")
	
	local IsMouseOver = false
	
	if buttontype != "label" then
		surface.SetFont ( tostring (font) )
		local textw,texth = surface.GetTextSize ( tostring(text) )
		posx,posy = posx - (textw / 2), posy - (texth / 2)
		
		NextPageLabel[id]:SetSize ( textw, texth )
		NextPageLabel[id]:SetPos ( posx, posy )
	elseif buttontype == "label" then
		local Wide,Tall = parent:GetWide(),parent:GetTall()
		NextPageLabel[id]:SetSize ( wide, tall ) --Wide - 14, ScaleH(30) )
		NextPageLabel[id]:SetPos ( posx, posy )
	end
	
	NextPageLabel[id].OnCursorEntered = function()
		IsMouseOver = true
	
		if buttontype and buttontype == "label" and MySelf.VoteAlready == true then
			--Color_Labels[id] = colorenter
		else
			if parent == VOTEMAP and WIDESCREEN and buttontype and buttontype == "label" then
				if parent.Page == 1 then
					Color_Labels[id] = colorenter
				elseif parent.Page == 2 then
					Color_Labels[id + 3] = colorenter
				end
			else
				Color_Labels[id] = colorenter
				if buttontype and buttontype == "hint" then
					surface.PlaySound ( Sounds.Over )
				end
			end
		end		
		if parent and parent.Page then
			if buttontype != nil then
				if buttontype == "next" then
					if parent.Page < parent.MaxPages then
						surface.PlaySound ( Sounds.Over )
					end	
				elseif buttontype == "prev" then
					if parent.Page > 1 then
						surface.PlaySound ( Sounds.Over )
					end	
				end
			end
		end
	end
	
	NextPageLabel[id].OnCursorExited = function() 
		IsMouseOver = false
	
		if buttontype and buttontype == "label" and MySelf.VoteAlready == true then
			--Color_Labels[id] = colorexit
		else
			if parent == VOTEMAP and WIDESCREEN and buttontype and buttontype == "label" then
				if parent.Page == 1 then
					Color_Labels[id] = colorexit
				elseif parent.Page == 2 then
					Color_Labels[id + 3] = colorexit
				end
			else
				Color_Labels[id] = colorexit
			end
		end
	end
	
	NextPageLabel[id].Think = function()
		if IsVotingOver and IsVotingOver == true and buttontype and buttontype == "label" then
			if Color_Labels[id] == COLOR_LIGHT_GREY then
				if MySelf.VotedMapSlot and MySelf.VotedMapSlot != id - 8 then
					Color_Labels[id] = Color (0,0,0,0)
				end
			end
		end
		
		-- Color the buttons GREY if you can't push them.
		if buttontype != nil then
			if buttontype == "next" then
				if parent.Page == parent.MaxPages then
					Color_Labels[id] = COLOR_LIGHT_GREY
				else
					if IsMouseOver == false then
						Color_Labels[id] = colorexit
					end
				end
			elseif buttontype == "prev" then
				if parent.Page == 1 then
					Color_Labels[id] = COLOR_LIGHT_GREY
				else
					if IsMouseOver == false then
						Color_Labels[id] = colorexit
					end
				end
			end
		end
	end
	
	NextPageLabel[id].OnMousePressed = function()
		--Manage pages
		if parent and parent.Page then
			if buttontype != nil then
				if buttontype == "next" then
					if parent.Page < parent.MaxPages then
						parent.Page = parent.Page + 1
						surface.PlaySound ( Sounds.Click )
					end	
				elseif buttontype == "prev" then
					if parent.Page > 1 then
						parent.Page = parent.Page - 1
						surface.PlaySound ( Sounds.Click )
					end	
				end
			end
		end
		
		if buttontype and buttontype == "hint" then
			surface.PlaySound ( Sounds.Click )
		end
		
		if buttontype and buttontype == "label" and MySelf.VoteAlready == false then
			surface.PlaySound ( Sounds.Click )
			MySelf.VoteAlready = true
			MySelf.VotedMapSlot = id - 8
				
			--Special case for two pages with same label
			if WIDESCREEN then 
				if parent.Page == 1 then
					MySelf.VotedMapSlot = id - 8
				elseif parent.Page == 2 then
					MySelf.VotedMapSlot = id - 5 
				end
			end
			
			if parent == VOTEMAP and WIDESCREEN then
				if parent.Page == 1 then
					Color_Labels[id] = COLOR_LIGHT_GREY
				elseif parent.Page == 2 then
					Color_Labels[id + 3] = COLOR_LIGHT_GREY
				end
			else
				Color_Labels[id] = COLOR_LIGHT_GREY
			end
			
			--- Send the chosen map to the server
			RunConsoleCommand ( "VoteAddMap", tostring(MySelf.VotedMapSlot) )
		end
	end
end

//New Era! ---------------------------------------------------------------------------------------------------------------------

/*---------------------------------------------------------
	   Receive VoteMap List (3 maps)
---------------------------------------------------------*/

-- Init the votemap list and points
local Votemaplist = {}
local VotePoints = {}

local function ReceiveVotemaps ( um )
	---A total of 6 maps
	for i = 1,3 do
		Votemaplist[i] = {}
		Votemaplist[i].Map = um:ReadString()
		Votemaplist[i].MapName = um:ReadString()
	end
	
	PrintTable ( Votemaplist )
end
usermessage.Hook("RecVotemaps", ReceiveVotemaps)

/*---------------------------------------------------------
	   Receive Votepoints (6 maps)
---------------------------------------------------------*/
local function ReceiveVotePoints ( um ) 
	--Update our current list
	for i = 1,3 do
		VotePoints[i] = um:ReadShort()
	end
end
usermessage.Hook("RecVoteChange",ReceiveVotePoints)

/*---------------------------------------------------------
     Receive the voted map slot server-side
---------------------------------------------------------*/
local function ReceiveAutomaticVoteResult ( um )
	-- Receive vote result for those who didn't vote manually from server
	MySelf.VotedMapSlot = um:ReadShort()
end
usermessage.Hook("RecAutomaticVoteResult",ReceiveAutomaticVoteResult)

/*---------------------------------------------------------
	   Receive Nextmap ( Vote Result )
---------------------------------------------------------*/
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
		//if MySelf:Team() == TEAM_HUMAN then
		if winner == TEAM_HUMAN and MySelf:Team() == TEAM_HUMAN then
			surface.PlaySound ( "music/HL1_song25_REMIX3.mp3" )
			//surface.PlaySound ( "endgame/humanwin.mp3" )
		else
			surface.PlaySound ( "music/HL1_song21.mp3" )
			//surface.PlaySound ( "endgame/zombiewins.mp3" )
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
	
	---Winner managment and team score
	local wintext, wincol = "The round was a withdraw.", Color(255,255,255,255)

	if winner == TEAM_HUMAN then
		wintext = "Survivors win the round!"
		wincol = Color(255,255,255,255)
	elseif winner == TEAM_UNDEAD then
		wintext = "The Undead rule the world!"
		wincol = Color(200,40,40,255)
	end
	
	--Manange Votemap Stuff
	//ManageVotemap ( votemap )
	
	MySelf.VoteAlready = false
	
	local delay = 1.1 //delay between messages
	local drawtime = delay-0.05 //how long it takes to draw a message
	
	for k,v in ipairs (Votemaplist) do
		VotePoints[k] = 0
	end
	
	for i = 1,3 do
		AddMapLabel(h/2+85+30*i,i,Votemaplist[i].Map,Votemaplist[i].MapName)
	end
	//kinda messy but whatever
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
	
	txt = "Amazing but all players were polite this round"
	if Nitwits[2] and Nitwits[2] ~= "" then txt = Nitwits[2].." was the most horny player and he knows why :O" end
	top[7] = {txt,0,0}
	
	
	//set the draw time 
	for i,_ in pairs(top) do
		top[i][2] = CurTime() + delay*i
		top[i][3] = CurTime() + delay*i + drawtime
	end
	
	//PrintTable(top)
	
	-- Overwrite main paint/background
	function GAMEMODE:HUDPaint()-- end
	--function GAMEMODE:HUDPaintBackground ()
		local TimeToChange = math.Clamp ( math.floor ( ENDTIME + timeleft - CurTime() ), 0, 9999 )
		local headertext = "Next round in "..TimeToChange
		
		--[[if IsVotingOver == false then
			if MySelf.VoteAlready == false then
				headertext = "Vote your favourite map from the Votemap Panel"
			elseif MySelf.VoteAlready == true then
				headertext = "Please wait for other players to vote!"
			end
		elseif IsVotingOver == true then
			local tbMap, strMap = TranslateMapTable[WinnerMap]
			if tbMap then strMap = tbMap.Name else strMap = "a Mystical Place" end
			headertext = "You are on your way to "..tostring( strMap ).." !" 
		end]]
		
		//Draw the actual text
		
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
		if MySelf.VoteAlready == true then
			votetxt = "Wait for other players to vote"
		end
		
		draw.SimpleTextOutlined(votetxt, "ArialBoldTen", w/2, h/2+60, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
		
		if IsVotingOver == true then
			strMap = WinnerMapName
			//local tbMap, strMap = TranslateMapTable[WinnerMap]
			//if tbMap then strMap = tbMap.Name else strMap = "a Mystical Place" end
			headertext = "Next map will be "..tostring( strMap ).." in "..TimeToChange
		end
		
		draw.SimpleTextOutlined(headertext, "ArialBoldFifteen", w/2, h-80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0,255))
				
	end
	
		
	print ("/************************* PANELS HAVE BEEN INIT /*************************")
end

local MapLabel = {}
	
function AddMapLabel(y,index,map,mapname)
	
	//if Votemaplist[index].GotLabel then return end
	
	//local tmap, mapname = TranslateMapTable[map]
	
	//if tmap then mapname = tmap.Name else mapname = "a Mystical Place" end

	
	surface.SetFont("ArialBoldSeven")
	
	local tw,th = surface.GetTextSize ( mapname.." | Votes: 99 | WINNER" )//take a bit bigger size
	
	local sw, sh = tw+30, th+6
	
	MapLabel[map] = vgui.Create( "DButton")
	MapLabel[map]:SetText("")
	MapLabel[map]:SetSize(sw, sh)
	MapLabel[map]:SetPos(w/2-sw/2,y)
	MapLabel[map].Color = color_white
	MapLabel[map].OnCursorEntered = function()
		MapLabel[map].Overed = true 
	end
	MapLabel[map].OnCursorExited = function()
		MapLabel[map].Overed = false 
	end
	MapLabel[map].DoClick = function()
		if not MySelf.VoteAlready then
			MySelf.VoteAlready = true
			MySelf.VotedMapSlot = index
			RunConsoleCommand ( "VoteAddMap", tostring(MySelf.VotedMapSlot) )
		end
	end
	MapLabel[map].Paint = function()
		if VotePoints[index] > 0 then
			if IsVotingOver == true and map == WinnerMap then
				draw.SimpleTextOutlined(mapname.." | Votes: "..VotePoints[index].." | WINNER", "ArialBoldSeven", sw/2, sh/2, Color(255,10,10,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			else
				draw.SimpleTextOutlined(mapname.." | Votes: "..VotePoints[index], "ArialBoldSeven", sw/2, sh/2, MapLabel[map].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
			end
		else
			draw.SimpleTextOutlined(mapname, "ArialBoldSeven", sw/2, sh/2, MapLabel[map].Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,255))
		end
		if MapLabel[map].Overed and not MySelf.VoteAlready then
			
			surface.SetDrawColor( 255, 255, 255, 255)
			surface.DrawOutlinedRect( 0, 0, sw, sh)
			surface.DrawOutlinedRect( 1, 1, sw-2, sh-2 )
		end
	end
	MapLabel[map].Think = function()
		if MySelf.VotedMapSlot and MySelf.VotedMapSlot == index then
			MapLabel[map].Color = Color(120,120,120,255)
		end
		gui.EnableScreenClicker ( true )
	end
	
	//MapLabel[map]:InvalidateLayout()
	
	//MapLabel[map]:ParentToHUD()
	
	//MapLabel[map]:SetVisible(true)

	//Votemaplist[index].GotLabel = true

end




