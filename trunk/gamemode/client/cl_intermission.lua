--Endgame scoreboard (Don't steal this from Cache, make your own >:P)

--Colors
local COLOR_SUBTITLE = Color(146,146,146,255 )
local COLOR_TITLE = Color(255,245,245,255 )
local COLOR_GREY_ONE = Color(99,99,99,255 )
local COLOR_DARK_GREY = Color(35,35,35,255 )
local COLOR_BLUE = Color(139,183,220,255 )
local COLOR_LIGHT_GREY = Color(62,62,62,255 )
local COLOR_LIGHT_RED = Color(116,26,26,255 )
local COLOR_DARK_GREY_BUTTON = Color(12,72,122,255 )
local COLOR_DARK_RED = Color(123,24,24,255 )

--Do not change this. From one to 15 are the changable button colors
IntermissionColorLabels = {}
for i = 1, 16 do
	if i < 9 then
		IntermissionColorLabels[i] = Color(35, 35, 35, 255)
	elseif i < 15 and i >= 9 then
		IntermissionColorLabels[i] = Color(0, 0, 0, 0)
	else
		IntermissionColorLabels[i] = COLOR_GREY_ONE
	end
end
 
IsVotingOver = false
WinnerMap = ""
VoteMaps = {}

 
--Sound DB
local Sounds = {}
Sounds.Accept = Sound("mrgreen/ui/menu_focus.wav")
Sounds.Click = Sound("mrgreen/ui/menu_click01.wav")
Sounds.Over = Sound("mrgreen/ui/menu_accept.wav")
 
--Screen (3:4) and Widescreen (the rest)
SCREEN = w/h > 1.24 and w/h < 1.35
WIDESCREEN = w/h > 1.45 and w/h < 1.8 or w/h == 1.6
if not WIDECREEN then
	SCREEN = true
end


--Include panels
include("vgui/p_intermission_generalscore.lua")
include("vgui/p_intermission_teamscore.lua")
include("vgui/p_intermission_nitwits.lua")
include("vgui/p_intermission_votemap.lua")
 
--[[---------------------------------------------------------
			 Expand panel metatable
---------------------------------------------------------]]
local metapanel = FindMetaTable("Panel")
if metapanel then
	--Simple panel align to center function
	function metapanel:AlignCenter ()
		local posx, posy = self:GetPos()
		local wide, tall = self:GetWide(),self:GetTall()
			   
		self:SetPos ( posx - ( wide / 2 ), posy - ( tall / 2 ) )
	end   
end
 
--[[---------------------------------------------------------
	--   Hints used for end-round board
---------------------------------------------------------]]
local GameHints = {
	"Headcrabs are small. They can hardly be seen. Use them wisely.",
	"As an Infected, you can throw props at humans, in most cases, killing them.",
	"As a Survivor, you have limited weapon slots. Press F3 to drop a weapon.",
	"If you are injured, call a Medic or search for health vials in the map.",
	"After redeeming, humans are protected for a short amount of time from all damage.",
	"You can nail objects using the nailing hammer.",
	"As a Medic, you can heal yourself by holding RIGHT-MOUSE button.",
	"Press F1 for further game instructions.",
	"When Survivors are camping, use the Poison Headcrab to take them out.",
	"You can buy hats and upgrades from our shop with GreenCoins.",
	"You can open the GreenCoins Shop by typing !shop in the chat.",
	"As an Undead, press F3 to change your class.",
	"Poison Zombies can throw meat at other zombies, healing them.", --Can they still do this?
	"Eating meat as Undead heals you.",
	"Like living on the edge? Type !rtd in chat to Roll the Dice."
}
 
--[[---------------------------------------------------------
				Initialize Fonts
---------------------------------------------------------]]
function InitializeFonts()
	--Bold Arials
	surface.CreateFontLegacy("Arial", ScreenScale(22.8), 700, true, false, "ArialBoldTwenty")
	surface.CreateFontLegacy("Arial", ScreenScale(20.8), 700, true, false, "ArialBoldEighteen")
	surface.CreateFontLegacy("Arial", ScreenScale(10.4), 700, true, false, "ArialBoldNine")
	surface.CreateFontLegacy("Arial", ScreenScale(8.4), 700, true, false, "ArialBoldSix")
	surface.CreateFontLegacy("Arial", ScreenScale(13.4), 700, true, false, "ArialBoldTwelv")
	   
	--Normal Arials
	surface.CreateFontLegacy("Arial", ScreenScale(22.8), 500, true, false, "ArialTwenty")
	surface.CreateFontLegacy("Arial", ScreenScale(25.4), 500, true, false, "ArialTwentyTwo")
	surface.CreateFontLegacy("Arial", ScreenScale(11), 400, true, false, "ArialNine")
	surface.CreateFontLegacy("Arial", ScreenScale(13.4), 500, true, false, "ArialTwelve")
end
hook.Add("Initialize", "InitializeFonts", InitializeFonts)
 
--[[---------------------------------------------------------
	   -- Update screen width and height
---------------------------------------------------------]]
function UpdateScreenType()
	w,h = ScrW(),ScrH()
 
	--Screen (3:4) and Widescreen (the rest)
	SCREEN = w/h > 1.24 and w/h < 1.35
	WIDESCREEN = w/h > 1.45 and w/h < 1.8 or w/h == 1.6
end
 
--[[---------------------------------------------------------
	--   Some function used to scale panels
---------------------------------------------------------]]
function ScalePanel(nr)
	local newnr = ScrW() * ( nr / 1280 )
 
	local ratio =  math.Clamp ( ScrH() / 800, 0.9, 1 )
	return newnr * ratio
end
 
--[[---------------------------------------------------------
		   Main Intermission Funciton
---------------------------------------------------------]]
 
local TimerImage = surface.GetTextureID("mrgreen/intermission/timer")
local WinnerTeam = "Nobody"
local NextPageLabel = {}
 
timer.Simple(0.1, function()
	MySelf.HasVotedMap = false
	MySelf.VotedMapSlot = nil
end)
 
local BlurStartTime = 0
function Intermission(nextmap, winner, timeleft)
	if ENDROUND then
		return
	end
 
	ENDROUND = true
	ENDTIME = CurTime()

	BlurStartTime = SysTime()
		
	hook.Remove("RenderScreenspaceEffects", "PostProcess")
		
	WinnerTeam = winner

	--Stop all sounds
	RunConsoleCommand("stopsound")
	   
	--Play the team specific.sounds
	timer.Simple(0.2, function()
		if IsValid(MySelf) and MySelf:Team() == TEAM_HUMAN then
			surface.PlaySound(Sound("mrgreen/music/intermission.mp3"))
		else
			surface.PlaySound(Sound("mrgreen/music/intermission_undead.mp3"))
		end
	end)
	   
	--Enable mouse
	gui.EnableScreenClicker(true)
	   
	---Winner managment and team score
	local congratulations, WinText = "You've failed surviving","The round was a withdraw"
 	if winner == TEAM_HUMAN then
		WinText = "The Humans survived!"
		if IsValid(MySelf) and MySelf:Team() == TEAM_HUMAN then
			congratulations = "We're safe ... for now!"
		end
	elseif winner == TEAM_UNDEAD then
		WinText = "The Undead rule the world"
	end
	   
	--Create the votemap panel
	local VoteMapPanel = vgui.Create("Votemap")
	VoteMapPanel:SetVisible(true)
   
	--Manage Votemap Stuff
	ManageVoteMap(VoteMapPanel)
	   
	--Init the Hint Next and Prev buttons
	DoLabel( 15, nil, "ArialBoldTwelv", ">", 0, 0, COLOR_LIGHT_RED, "hint", COLOR_GREY_ONE, 0, 0)
	DoLabel( 16, nil, "ArialBoldTwelv", "<", 0, 0, COLOR_LIGHT_RED, "hint", COLOR_GREY_ONE, 0, 0)

	--Pick a random hint
	local RandomHint = GameHints[ math.random (1,#GameHints) ]
	   
	--Make the 15'th label go forward into the table and the 16th go backwards
	NextPageLabel[15].OnMousePressed = function()
		local pos = 0
		for k,v in ipairs (GameHints) do
			if RandomHint == v then
				pos = k
			end
		end
			   
		if GameHints[pos + 1] then
			RandomHint = GameHints [pos + 1]
		else
			pos = 1
			RandomHint = GameHints [pos + 1]
		end
		surface.PlaySound(Sounds.Click)
	end
	
	NextPageLabel[16].OnMousePressed = function()
		local pos = 0
		for k,v in ipairs (GameHints) do
			if RandomHint == v then
				pos = k
			end
		end
		   
		if GameHints[pos - 1] then
			RandomHint = GameHints [pos - 1]
		else
			pos = #GameHints
			RandomHint = GameHints [pos - 1]
		end
			   
		surface.PlaySound(Sounds.Click)
	end
	   
	--Overwrite main paint/background
	function GAMEMODE:HUDPaint()
	end

	--Cache
	local RandomBlood1 = bloodSplats[math.random(1,2)]
	local RandomBlood2 = bloodSplats[math.random(3,5)]

	function GAMEMODE:HUDPaintBackground()
		DrawBlur(BlurStartTime)

		local TimeToChange = math.Clamp(math.Round(ENDTIME + timeleft - CurTime()), 0, 9999)
		local HeaderText = "Travelling in ".. TimeToChange .." seconds"
			   
		if not IsVotingOver then
			if not MySelf.HasVotedMap then
				HeaderText = "Cast your vote for the next destination"
			elseif MySelf.HasVotedMap then
				HeaderText = "Waiting for others to cast their vote"
			end
		elseif WinnerMap then
			local strMap = "a Mystical Place"

			for i,v in ipairs(VoteMaps) do
				if v.MapName == WinnerMap then
					strMap = v.OriginalTitle
					break
				end
			end

			HeaderText = "Travelling to ".. tostring(strMap)
			if TimeToChange >= 1 then
				HeaderText = HeaderText .." in ".. TimeToChange .." seconds"
			end
		end
			   
		---Draw the red flash for votemap panel when needed
		if not MySelf.HasVotedMap and not MySelf.HideVoteMapFlash then
			local panelx, panely = VoteMapPanel:GetPos()
			local bounds = ScaleW(18)
			draw.RoundedBox(8, panelx - (bounds / 2), panely - (bounds / 2), VoteMapPanel:GetWide() + bounds, VoteMapPanel:GetTall() + bounds, Color(123,24,24,255 * math.abs ( math.sin ( CurTime() * 2.3 ) ) ) )         
		end
			   
		--Draw some blood on the screen when being an Undead
		if MySelf:Team() == TEAM_UNDEAD then
			surface.SetDrawColor(Color(150,30,30,255))
			surface.SetTexture(RandomBlood1)
			surface.DrawTexturedRect(0, 0, w, h)
			--[[surface.SetTexture(RandomBlood2)
			surface.DrawTexturedRect(0, 0, w, h)]]
		end


		--Next, prev buttons for hints
		local GameHintText, dist = "Hint: ".. RandomHint, 28
		surface.SetFont("ArialBoldTwelv")
		local hintwide, hinttall = surface.GetTextSize(GameHintText)
		local SignWide, SignTall = surface.GetTextSize(">")
			   
		if SCREEN then
			--??
			--[[surface.SetDrawColor(35, 35, 35, 255)
			surface.DrawRect(0, 0, ScaleW(1280), ScaleH(148)) --Bara grii de sus, aia mare
			surface.DrawRect(0,ScaleH(878), ScaleW(1280), ScaleH(148)) --bara grii de jos, aia mare]]
				  
			--??
			--[[surface.SetDrawColor(62, 62, 62, 255)
			surface.DrawRect(0, ScaleH(141), ScaleW(1280), ScaleH(7))
			surface.DrawRect(0, ScaleH(878), ScaleW(1280), ScaleH(7))]]
				   
			--The timer picture in the upper left corner
			surface.SetDrawColor(Color(255,255,255,255))
			surface.SetTexture(TimerImage)
		   	surface.DrawTexturedRectRotated(ScaleW(70), ScaleH(66), ScalePanel(68), ScalePanel(68), 0)
				   
			--Update the labels position
			NextPageLabel[15]:SetPos ( ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) - (SignWide / 2),ScaleH(982) - (SignTall / 2) )
			NextPageLabel[16]:SetPos ( ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) - (SignWide / 2) ,ScaleH(982) - (SignTall / 2) )
					   
			--Draw the hint nextpage and prevpage
			draw.SimpleText(">","ArialBoldTwelv",ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) ,ScaleH(982), IntermissionColorLabels[15],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText("<","ArialBoldTwelv",ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) ,ScaleH(982), IntermissionColorLabels[16],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			   
			--draw.SimpleText ("Waiting","ArialBoldTwenty", ScaleW(1022),ScaleH(68), COLOR_SUBTITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(congratulations,"ArialTwentyTwo", ScaleW(136),ScaleH(49), COLOR_TITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(HeaderText,"ArialTwelve", ScaleW(136),ScaleH(98), COLOR_SUBTITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(WinText,"ArialTwenty", ScrW() * 0.5,ScaleH(931), COLOR_TITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(GameHintText,"ArialTwelve", ScrW() * 0.5,ScaleH(982), COLOR_GREY_ONE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		elseif WIDESCREEN then
			--??
			--[[surface.SetDrawColor(Color(35,35,35,255))
			surface.DrawRect ( 0,0,ScaleW(1280),ScaleW(124) ) --Bara grii de sus, aia mare
			surface.DrawRect ( 0,ScaleH(866), ScaleW(1280), ScaleW(124) ) --bara grii de jos, aia mare]]
					   
			--The timer picture in the upper left corner
			surface.SetDrawColor(Color(255,255,255,255))
			surface.SetTexture(TimerImage)
			surface.DrawTexturedRectRotated ( ScaleW(72), ScaleH(75), ScalePanel(64), ScalePanel(64), 0)
					   
			--Update the labels position
			NextPageLabel[15]:SetPos( ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) - (SignWide / 2),ScaleH(978) - (SignTall / 2) )
			NextPageLabel[16]:SetPos( ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) - (SignWide / 2) ,ScaleH(978) - (SignTall / 2) )
					   
			--Draw the hint nextpage and prevpage
			draw.SimpleText(">","ArialBoldTwelv",ScrW() * 0.5 + ( hintwide / 2 ) + ScaleW(dist) ,ScaleH(978), IntermissionColorLabels[15],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText("<","ArialBoldTwelv",ScrW() * 0.5 - ( hintwide / 2 ) - ScaleW(dist) ,ScaleH(978), IntermissionColorLabels[16],TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					   
			--[[surface.SetDrawColor( 62,62,62,255 )
			surface.DrawRect( 0, ScaleW(124 - 5), ScaleW(1280), ScaleH(7) ) --Bara aia subtire de sus
			surface.DrawRect( 0, ScaleH(866), ScaleW(1280), ScaleH(7) ) --Bara subtire de jos]]
			   
			--draw.SimpleText("Waiting","ArialBoldTwenty", ScaleW(1022),ScaleH(75), COLOR_SUBTITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(congratulations,"ArialTwentyTwo", ScaleW(136),ScaleH(54), COLOR_TITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(HeaderText,"ArialTwelve", ScaleW(136),ScaleH(113), COLOR_SUBTITLE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			draw.SimpleText(WinText,"ArialTwenty", ScrW() * 0.5,ScaleH(918), COLOR_TITLE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(GameHintText,"ArialTwelve", ScrW() * 0.5,ScaleH(978), COLOR_GREY_ONE, TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		end
	end
	   
	--Create the champions panel
	local NITWITZ = vgui.Create("Nitwits")
	NITWITZ:SetVisible(true)
	   
	--Manange Nitwits
	ManageNitwits(NITWITZ)
	   
	--Create the team score panel
	local TEAM_PANEL = vgui.Create("Teamscore")
	TEAM_PANEL:SetVisible(true)
	   
	--Manange Team score
	ManageTeamScore( TEAM_PANEL )
	   
	--Create the general score panel
	local GENERAL_SCORE = vgui.Create("Generalscore")
	GENERAL_SCORE:SetVisible ( true )
	   
	--Manage General score stuff
	ManageGeneralScore(GENERAL_SCORE)
	   
	--Reposition the chatbox if the nitwits panel isn't visible
	--[[if not NITWITZ:IsVisible() then
			CustomChat.PosX = ScaleW(40)
			CustomChat.PosY = ScaleH(680)
	end
	   
	--Open the custom chatbox
	CustomChat.ResetChat()]]
end
 
--[[---------------------------------------------------------
		--  Intermission drawing function
---------------------------------------------------------]]
function DrawIntermission(votemap, nextmap, winner)
end
 
--[[---------------------------------------------------------
		   Manange team score stuff
---------------------------------------------------------]]
GeneralTeamScores = {}
function ManageTeamScore ( panel )
	--Initialize the subtitles
	panel.PageSubtitles = {
		"General scores",
		"GreenCoins gained",
		"Most chosen class" ,
	}
	   
	--Manage page stuff
	panel.Page = 1
	panel.MaxPages = 3
	   
	--Update "General scores" (can be done clientside)
	UpdateTeamScore()
end
 
--[[---------------------------------------------------------
 --Get teams score for general team score table
---------------------------------------------------------]]
function UpdateTeamScore ()
		local humanscore = 0
		local undeadscore = 0
	   
		--Calculate the score
		for k,pl in pairs ( player.GetAll() ) do
				if pl:Team() == TEAM_HUMAN then
						humanscore = humanscore + pl:Frags()
				elseif pl:Team() == TEAM_UNDEAD then
						undeadscore = undeadscore + pl:Frags()
				end
		end
 
		--Insert the scores into the main table
		GeneralTeamScores["General scores"] = {
				[1] = humanscore,
				[2] = undeadscore,
		}
end
 
--[[---------------------------------------------------------
		   Manange general score stuff
---------------------------------------------------------]]
function ManageGeneralScore ( panel )
	--Main Title
	panel.PageTitle = {
		"GENERAL",
		"OFFENSIVE",
		"DEFENSIVE"
	}
	   
	--Subtitles
	panel.PageSubtitle = {
		"Survival of the fittest",
		"Most GreenCoins gained",
		"Most assists (both sides)",
		"Most healed",
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
	   
	--Update teh teamscore table with Most Chosen Class
	for i = 1, 2 do
		GeneralTeamScores["Most chosen class"][i] = strexplode[i]
	end
end
usermessage.Hook ("RecMostChosenClass",ReceiveMostChosenClass)
 
--[[---------------------------------------------------------
		  Receive Total Greencoins per team
---------------------------------------------------------]]
local function ReceiveGreencoinsTeam ( um )
	--Initialize the subtable
	GeneralTeamScores["GreenCoins gained"] = {}
 
	--Update that shit
	for i = 1,2 do
		GeneralTeamScores["GreenCoins gained"][i] = um:ReadShort()
	end
end
usermessage.Hook ("RecTeamGreencoinsGained", ReceiveGreencoinsTeam)
 
--[[---------------------------------------------------------
			 Receive Top healing done ( medic)
---------------------------------------------------------]]
TopHealing = {}
local function ReceiveTopHealing ( um )
	local index = um:ReadShort()
	TopHealing[index] = {}
	TopHealing[index].Name = um:ReadString()
	TopHealing[index].Score = um:ReadString()
end
usermessage.Hook("RcTopHealing", ReceiveTopHealing)
 
--[[---------------------------------------------------------
			 Receive Top Infected killed
---------------------------------------------------------]]
TopZombiesKilled = {}
local function ReceiveTopZombiesKilled ( um )
	local index = um:ReadShort()
	TopZombiesKilled[index] = {}
	TopZombiesKilled[index].Name = um:ReadString()
	TopZombiesKilled[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombiesKilled", ReceiveTopZombiesKilled)
 
--[[---------------------------------------------------------
			   Receive Top Assists
---------------------------------------------------------]]
TopAssists = {}
local function ReceiveTopAssists(um)
	local index = um:ReadShort()
	TopAssists[index] = {}
	TopAssists[index].Name = um:ReadString()
	TopAssists[index].Score = um:ReadString()
end
usermessage.Hook("RcTopAssists", ReceiveTopAssists)
 
--[[---------------------------------------------------------
			   Receive Top Brains Eaten
---------------------------------------------------------]]
TopBrainsEaten = {}
local function ReceiveTopZombies ( um )
	local index = um:ReadShort()
	TopBrainsEaten[index] = {}
	TopBrainsEaten[index].Name = um:ReadString()
	TopBrainsEaten[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombies", ReceiveTopZombies)
 
--[[---------------------------------------------------------
	  Receive Top Damage done by Humans
---------------------------------------------------------]]
TopHumanDamage = {}
local function ReceiveTopHumanDamages ( um )
	local index = um:ReadShort()
	TopHumanDamage[index] = {}
	TopHumanDamage[index].Name = um:ReadString()
	TopHumanDamage[index].Score = um:ReadString()
end
usermessage.Hook("RcTopHumanDamages", ReceiveTopHumanDamages)
 
--[[---------------------------------------------------------
	  Receive Top Damage done by Zombies
---------------------------------------------------------]]
TopZombieDamage = {}
local function ReceiveTopZombieDamages ( um )
	local index = um:ReadShort()
	TopZombieDamage[index] = {}
	TopZombieDamage[index].Name = um:ReadString()
	TopZombieDamage[index].Score = um:ReadString()
end
usermessage.Hook("RcTopZombieDamages", ReceiveTopZombieDamages)
 
--[[---------------------------------------------------------
		  Receive Top Greencoins Gained
---------------------------------------------------------]]
TopGreencoinsGained = {}
local function ReceiveTopGreencoins ( um )
	local i = um:ReadShort()
	TopGreencoinsGained[i] = {}
	TopGreencoinsGained[i].Name = um:ReadString()
	TopGreencoinsGained[i].Score = um:ReadString()
end
usermessage.Hook("RcTopGreencoins", ReceiveTopGreencoins)
 
--[[---------------------------------------------------------
		  Receive Top Survival Times
---------------------------------------------------------]]
TopSurvivalTimes = {}
local function ReceiveTopTimes ( um )
	local i = um:ReadShort()
	TopSurvivalTimes[i] = {}
	TopSurvivalTimes[i].Name = um:ReadString()
	TopSurvivalTimes[i].Score = um:ReadString()
end
usermessage.Hook("RcTopTimes", ReceiveTopTimes)


--[[---------------------------------------------------------
	   --   Label creation base function
---------------------------------------------------------]]
function DoLabel(id, parent, font, text, posx, posy, colorenter, buttontype, colorexit, wide, tall)
		NextPageLabel[id] = vgui.Create("DLabel")
		NextPageLabel[id]:SetParent ( parent )
		NextPageLabel[id]:SetText ("")
	   
		local IsMouseOver = false
	   
		if buttontype ~= "label" then
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
	   
				if buttontype and buttontype == "label" and MySelf.HasVotedMap then
						--IntermissionColorLabels[id] = colorenter
				else
					IntermissionColorLabels[id] = colorenter
					if buttontype and buttontype == "hint" then
						surface.PlaySound(Sounds.Over)
					end
				end            
				if parent and parent.Page then
						if buttontype ~= nil then
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
	   
				if buttontype and buttontype == "label" and MySelf.HasVotedMap then
						--IntermissionColorLabels[id] = colorexit
				else
					IntermissionColorLabels[id] = colorexit
				end
		end
	   
		NextPageLabel[id].Think = function()
				if IsVotingOver and buttontype and buttontype == "label" then
					if IntermissionColorLabels[id] == COLOR_LIGHT_GREY then
						if MySelf.VotedMapSlot and MySelf.VotedMapSlot ~= (id - 8) then
							IntermissionColorLabels[id] = Color (0,0,0,0)
						end
					end
				end
			   
				--Color the buttons GREY if you can't push them.
				if buttontype ~= nil then
						if buttontype == "next" then
								if parent.Page == parent.MaxPages then
										IntermissionColorLabels[id] = COLOR_LIGHT_GREY
								else
										if IsMouseOver == false then
												IntermissionColorLabels[id] = colorexit
										end
								end
						elseif buttontype == "prev" then
								if parent.Page == 1 then
										IntermissionColorLabels[id] = COLOR_LIGHT_GREY
								else
										if IsMouseOver == false then
												IntermissionColorLabels[id] = colorexit
										end
								end
						end
				end
		end
	   
		NextPageLabel[id].OnMousePressed = function()
				--Manage pages
				if parent and parent.Page then
						if buttontype ~= nil then
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
						surface.PlaySound(Sounds.Click)
				end
			   
				if buttontype and buttontype == "label" and not MySelf.HasVotedMap then				
					surface.PlaySound(Sounds.Click)
					MySelf.HasVotedMap = true
					MySelf.VotedMapSlot = id - 8
					
					IntermissionColorLabels[id] = COLOR_LIGHT_GREY

					local MapName

					for k,v in ipairs(VoteMaps) do
						if k == MySelf.VotedMapSlot then
							MapName = v.MapName
							break
						end
					end

					if not MapName or MapName == "" then
						return
					end

					--Send the chosen map to the server
					RunConsoleCommand("VoteAddMap", tostring(MapName))
				end
		end
end

Debug("[MODULE] Loaded Intermission")