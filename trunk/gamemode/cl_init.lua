-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

MySelf = NULL
hook.Add("Think", "GetLocal", function()
	if not ClientReady then ClientReady = true gamemode.Call( "OnClientReady" ) end
	
	MySelf = LocalPlayer()
	if MySelf:IsValid() then
		-- MYSELFVALID = true
		hook.Remove("Think", "GetLocal")
		if not GAMEMODE.HookGetLocal then
			GAMEMODE.HookGetLocal = function(g) end
		end
		gamemode.Call("HookGetLocal", MySelf)
		RunConsoleCommand( "PostPlayerInitialSpawn" )
		gamemode.Call( "OnSelfReady" )
	end
end)

-- gm13 workaround
surface.OldCreateFont = surface.CreateFont
function surface.CreateFont(arg1,arg2,arg3,arg4,arg5,arg6)	
	
	local name = arg6-- [6]-- or "None"
	local fontdata = {
		font = arg1,-- [1],-- or "Arial",
		size = arg2,-- [2],-- or 5,
		weight = arg3,-- [3],-- or 500,
		antialias = arg4,-- [4],-- or false, 
		additive = arg5,-- [5],-- or true,
		}
	surface.OldCreateFont(name,fontdata)
	
end

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local ents = ents
local draw = draw
local surface = surface
local render = render
local gui = gui


GM.RewardIcons = {}
w, h = ScrW(), ScrH()
Threshold = 0

include("shared.lua")
include("modules/debug/sh_debug.lua")
include("client/cl_utils.lua")
include("shared/sh_utils.lua")
include("client/cl_chat.lua")
include("client/cl_scoreboard.lua")
include("client/cl_targetid.lua")
include("client/cl_selectionmenu.lua")
include("client/cl_hudpickup.lua")
include("client/cl_spawnmenu.lua")
include("client/cl_endgame.lua")
include("client/cl_postprocess.lua")
include("client/cl_deathnotice.lua")
include("client/cl_beats.lua")
include("client/cl_splitmessage.lua")
include("client/cl_director.lua")
include("client/vgui/poptions.lua")
include("client/vgui/phelp.lua")
include("client/vgui/pclasses.lua")
include("client/vgui/pshop.lua")
include("client/vgui/pweapons.lua")
include("client/vgui/pclassinfo.lua")
include("client/vgui/pskillshop.lua")
include("client/vgui/pmapmanager.lua")
include("client/cl_dermaskin.lua")
include("client/vgui/phclasses.lua")
include("greencoins/cl_greencoins.lua")
include("client/cl_admin.lua")
include("client/cl_customdeathnotice.lua")
-- include("shared/sh_animations.lua")
-- include("shared/sh_zombo_anims.lua")
-- include("shared/sh_human_anims.lua")
include("client/cl_hud.lua")
include("client/cl_voice.lua")
include("client/cl_waves.lua")

--[=[-----------------------------------------------------------
		Include stand alone modules
------------------------------------------------------------]=]
include( "modules/afk/cl_afk.lua" ) -- AFK manager
include( "modules/damage_indicator/cl_dmg_indicator.lua" )
include ( "modules/weightspeed/sh_weightspeed.lua" )
-- include ( "modules/friends/cl_friends.lua" ) -- w.i.p. friends module
include( "modules/hud_beta/cl_hud_beta.lua" ) -- beta hud (?)
-- include( "modules/nav_graph/sh_nav_graph.lua" )
include( "modules/skillpoints/cl_skillpoints.lua" )
include( "modules/skillpoints/sh_skillpoints.lua" )

include( "modules/legs/cl_legs.lua" )
include( "modules/news/cl_news.lua" )

include("modules/boneanimlib_v2/cl_boneanimlib.lua")

-- SQL-stats related
include( "server/stats/sh_utils.lua" )

CreateClientConVar("_zs_redeemclass", 1, true, false)

color_white = Color(255, 255, 255, 220)
color_black = Color(50, 50, 50, 255)
color_black_alpha180 = Color(0, 0, 0, 180)
color_black_alpha90 = Color(0, 0, 0, 90)
color_white_alpha200 = Color(255, 255, 255, 200)
color_white_alpha180 = Color(255, 255, 255, 180)
color_white_alpha90 = Color(255, 255, 255, 90)
COLOR_INFLICTION = Color(235, 185, 0, 165)
COLOR_DARKBLUE = Color(5, 75, 150, 255)
COLOR_DARKGREEN = Color(0, 150, 0, 255)
COLOR_DARKRED = Color(185, 0, 0, 255)
COLOR_DARKRED_HUD = Color(185, 0, 0, 180)
COLOR_DARKCYAN = Color(0, 155, 155, 255)
COLOR_DARKCYAN_HUD = Color(0, 155, 155, 180)
COLOR_GRAY = Color(190, 190, 190, 255)
COLOR_GRAY_HUD = Color(190, 190, 190, 180)
COLOR_RED = Color(255, 0, 0)
COLOR_BLUE = Color(0, 0, 255)
COLOR_GREEN = Color(0, 255, 0)
COLOR_LIMEGREEN = Color(50, 255, 50)
COLOR_YELLOW = Color(255, 255, 0)
COLOR_PURPLE = Color(255, 0, 255)
COLOR_CYAN = Color(0, 255, 255)
COLOR_WHITE = Color(255, 255, 255, 255)
COLOR_BLACK = Color(0, 0, 0, 255)

COLOR_MRGREEN = Color(0,165,132,165)
COLOR_MRGREEN2 = Color(80,120,110,165)

COLOR_HUD_OK = Color(0, 150, 0, 255)
COLOR_HUD_SCRATCHED = Color(35, 130, 0, 255)
COLOR_HUD_HURT = Color(160, 160, 0, 255)
COLOR_HUD_CRITICAL = Color(220, 0, 0, 255)

COLOR_HUD_OK2 = Color(40, 100, 40, 255)
COLOR_HUD_SCRATCHED2 = Color(25, 100, 10, 255)
COLOR_HUD_HURT2 = Color(120, 120, 40, 255)
COLOR_HUD_CRITICAL2 = Color(170, 40, 40, 255)

COLOR_AMMO = Color(200,170,150)

ENDTIME = 0
difficulty = 0

TOTALGIBS = 0

NearZombies = 0
ActualNearZombies = 0

hook.Remove("PlayerTick","TickWidgets")

-- Loading...
local RandomText = table.Random( { 
	"Fetching your braaainns!", 
	"Messing with your data!", 
	"Braaaainnns...", 
	"Stealing your brains...", 
	"A brain a day keeps the doctor away!",
	"Messing with Lua...", 
	"Headcrabs ate your profile...", 
	"I'll load your profile right now!",
	"Don't worry, we know what we're doing!",
	"Breeding headcrab eggs...",
	"Searching for zombie antidote...",
	"Removing blood from the map...",
	"Piling up meat...",
	"Mixing fake blood...",
	"Putting supplies into supply crates...",
	"Starting zombie apocalypse...",
	"Sewing zombie parts together...", } 
 )
 
function GM:HookGetLocal()
	MYSELFVALID = true

	self.Think = self._Think
	self.HUDShouldDraw = self._HUDShouldDraw
	self.RenderScreenspaceEffects = self._RenderScreenspaceEffects -- Deluvas; WTF?
	self.CalcView = self._CalcView
	self.ShouldDrawLocalPlayer = self._ShouldDrawLocalPlayer
	self.PostDrawOpaqueRenderables = self._PostDrawOpaqueRenderables
	self.HUDPaint = self._HUDPaint
	self.HUDPaintBackground = self._HUDPaintBackground
	self.CreateMove = self._CreateMove
	self.PrePlayerDraw = self._PrePlayerDraw
	self.PostPlayerDraw = self._PostPlayerDraw
	self.HUDWeaponPickedUp = self._HUDWeaponPickedUp
	self.HUDDrawTargetID = self._HUDDrawTargetID
end

local matGlow = Material("Sprites/light_glow02_add_noz")
local colHealth = Color(255, 255, 0, 255)

function GM:_PostDrawOpaqueRenderables()
	
	if MySelf:Team() == TEAM_UNDEAD then
			local eyepos = EyePos()
			for _, pl in pairs(team.GetPlayers(TEAM_HUMAN)) do
				if pl:Alive() and pl:GetPos():Distance(eyepos) <= 1024 and not (pl:GetSuit() == "stalkersuit" and pl:GetVelocity():Length() < 10) then
					local healthfrac = math.max(pl:Health(), 0) / 100
					colHealth.r = math.Approach(255, 0, math.abs(255 - 0) * healthfrac)
					colHealth.g = math.Approach(0, 255, math.abs(0 - 255) * healthfrac)

					local attach = pl:GetAttachment(pl:LookupAttachment("chest"))
					local pos = attach and attach.Pos or pl:LocalToWorld(pl:OBBCenter())

					render.SetMaterial(matGlow)
					render.DrawSprite(pos, 13, 13, colHealth)
					local size = math.sin(RealTime()*3 + pl:EntIndex()) * 50 - 21
					if size > 0 then
						render.DrawSprite(pos, size * 1.5, size, colHealth)
						render.DrawSprite(pos, size, size * 1.5, colHealth)
					end
				end
			end
	end
	
end
 
hook.Add( "HUDPaint", "DrawWaiting", function()
	if not ENDROUND or SinglePlayer() then
		draw.SimpleText( "Please wait... "..RandomText, "ArialBoldFifteen", ScrW() * 0.5, ScrH() * 0.5, Color( 255,255,255,210 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		draw.SimpleText( "www.mrgreengaming.com", "ArialBoldTwelve", ScrW() * 0.5, ScrH() * 0.55, Color( 180,180,180,235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		if IsValid( MySelf ) then
			if CurTime() - MySelf.ReadyTime > 20 then
				MySelf.ReconnectTime = MySelf.ReconnectTime or CurTime() + 6
				draw.SimpleText( "Reconnecting in "..math.Clamp( math.Round( MySelf.ReconnectTime - CurTime() ), 0, 10 ), "ArialFifteen", ScrW() * 0.5, ScrH() * 0.6, Color( 230,50,38,235 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
				-- Run the 'ready' command (bugged from GMod update)
				if CurTime() - MySelf.ReadyTime > 25 then RunConsoleCommand( "PostPlayerInitialSpawn" ) end
				
				-- Reconnect after 20 seconds
				if math.Round( MySelf.ReconnectTime - CurTime() ) <= 0 then RunConsoleCommand( "retry" ) end
			end
		end
	end
end )

-- Called when client loaded
function GM:OnClientReady()
	gui.EnableScreenClicker( true )
end

-- Called when myself is ready
function GM:OnSelfReady()
	MySelf.Ready, MySelf.ReadyTime = true, CurTime()
end

-- Called when myself got SQL gata
function GM:OnPlayerReadySQL()
	MySelf.ReadySQLTime = CurTime()

	if MySelf:Team() == 0 then
		hook.Add( "Think", "CheckUpdateData", function()
			if IsValid( MySelf ) then
				if MySelf.ReadySQLTime + 2 < CurTime() then
					if MySelf.GotClassData and MySelf.GotShopData and MySelf.GotAchievementsData then
						MySelf.ReadySQL = true
						if not ENDROUND then 
							gui.EnableScreenClicker( false ) 
						end
						
						-- Remove wait message and this hook
						hook.Remove( "HUDPaint", "DrawWaiting" )
						hook.Remove( "Think", "CheckUpdateData" )
						
						-- Class menu
						DrawSelectClass()
					end
				end
			end			
		end )
	else
		MySelf.ReadySQL = true
		hook.Remove( "HUDPaint", "DrawWaiting" )
		
		if not ENDROUND then 
			gui.EnableScreenClicker( false ) 
		end
	end
end

net.Receive( "OnReadySQL", function( len )
	timer.Simple( 0.1, function()
		gamemode.Call( "OnPlayerReadySQL" )
	end )
end)

-- Usermessage hook to sql ready
local function OnReadySQL()
	timer.Simple( 0.1, function()
		gamemode.Call( "OnPlayerReadySQL" )
	end )
end
usermessage.Hook( "OnReadySQL", OnReadySQL )

--[=[----------------------------------------------------------------------
		Called when local player receives a SWEP
-----------------------------------------------------------------------]=]
function GM:OnWeaponEquip ( pl, mWeapon )
end

-- Prevent freeze when weapons drop
util.PrecacheSound("mrgreen/new/thunder1.mp3")
util.PrecacheSound("mrgreen/new/thunder2.mp3")
util.PrecacheSound("mrgreen/new/thunder3.mp3")
util.PrecacheSound("mrgreen/new/thunder4.mp3")
util.PrecacheSound("mrgreen/ui/gamestartup1.mp3")

if not killicon.GetFont then -- Need this for the rewards message.
	local kiaf = killicon.AddFont
	local storedfonts = {}
	local HL2Weapons = { "weapon_zs_melee_crowbar","weapon_zs_shotgun","weapon_zs_crossbow","weapon_zs_smg", "weapon_zs_pulserifle", "weapon_zs_magnum", "weapon_zs_barricadekit", "christmas_snowball",  "weapon_zs_grenade", "weapon_zs_pulsesmg", "weapon_zs_annabelle","admin_raverifle","weapon_zs_boomstick","weapon_zs_minishotty","weapon_zs_classic"}
	local ZSWeapons = { "weapon_zs_melee_axe","weapon_zs_melee_fryingpan","weapon_zs_melee_keyboard","weapon_zs_melee_pot", "weapon_zs_melee_plank", "weapon_zs_tools_hammer", "weapon_zs_melee_katana" }
	
	function killicon.AddFont(sClass, sFont, sLetter, cColor)
		-- Check to see if the weapon is hl2 or css
		local IsHl2Weapon = false
		for k,v in pairs (HL2Weapons) do
			if v == sClass then
				IsHl2Weapon = true
			end
		end
		if string.find(sClass,"pickup") then
			IsHl2Weapon = true
		end
		--Good way to sort out my new killicons :D
		local IsZSWeapon = false
		
		for k,v in pairs (ZSWeapons) do
			if v == sClass then
				IsZSWeapon = true
			end
		end
		
		if GetWeaponType ( sClass ) == "melee" and not IsZSWeapon then
			IsHl2Weapon = true
		end
		if sClass == "weapon_zs_melee_combatknife" then
			IsZSWeapon = false
			IsHl2Weapon = false
		end
		
		
		-- Add the font to the list
		storedfonts[sClass] = { font = sFont, letter = sLetter, IsHl2 = IsHl2Weapon, IsZS = IsZSWeapon }
		kiaf(sClass, sFont, sLetter, cColor)
	end

	function killicon.GetFont ( sClass )
		return storedfonts[sClass]
	end
end

if not killicon.GetImage then
	local kia = killicon.Add
	local storedicons = {}
	
	function killicon.Add(sClass, sMat, cColor)
		
		storedicons[sClass] = { mat = sMat, color = cColor }
		kia(sClass, sMat, cColor)
	
	end

	function killicon.GetImage ( sClass )
		return storedicons[sClass]
	end

end

local Top = {}
local TopZ = {}
local TopZD = {}
local TopHD = {}

local matHumanHeadID = ""
local matZomboHeadID = ""

bloodSplats = {}
for k = 1, 8 do
	bloodSplats[k] = surface.GetTextureID("vgui/images/blood_splat/blood_splat0"..k)
end

-- Custom ConCommand Function
function client_GetCommand (um)
	if not MySelf:IsValid() then return end
	
	local command = um:ReadString()
	local stringcommand = tostring (command) -- Just in case
	local argonepresent = um:ReadBool()
	local firstarg
	
	if argonepresent then
		firstarg = tostring(um:ReadString())
	end
	
	if argonepresent == true then
		RunConsoleCommand (stringcommand, firstarg) -- pl;ConCommand ("command 1") while RunConsoleCommand is like ("command","1") !!!!
	else
		RunConsoleCommand (stringcommand)
	end
end
usermessage.Hook ("client_GetCommand",client_GetCommand)

function GM:Initialize()
	self.ShowScoreboard = false

	--Initialize fonts
	surface.CreateFont("anthem", 42, 500, true, false, "ScoreboardHead")
	surface.CreateFont("anthem", 24, 500, true, false, "ScoreboardSub")
	surface.CreateFont("Tahoma", 16, 1000, true, false, "ScoreboardText")

	surface.CreateFont("csd", 42, 500, true, true, "Signs")

	surface.CreateFont("akbar", 20, 250, false, true, "HUDFontTiny")
	surface.CreateFont("akbar", 22, 400, false, true, "HUDFontSmaller")
	surface.CreateFont("anthem", 28, 400, false, true, "HUDFontSmall")
	surface.CreateFont("akbar", 42, 400, false, true, "HUDFont")
	surface.CreateFont("akbar", 72, 400, false, true, "HUDFontBig")
	surface.CreateFont("akbar", 20, 250, true, true, "HUDFontTinyAA")
	surface.CreateFont("akbar", 28, 400, true, true, "HUDFontSmallAA")
	surface.CreateFont("akbar", 42, 400, true, true, "HUDFontAA")
	surface.CreateFont("akbar", 72, 400, true, true, "HUDFontBigAA")

	surface.CreateFont("akbar", 20, 250, true, true, "HUDFontTiny2")
	surface.CreateFont("akbar", 22, 500, true, true, "HUDFontSmaller2")
	surface.CreateFont("akbar", 28, 500, true, true, "HUDFontSmall2")
	surface.CreateFont("akbar", 42, 500, true, true, "HUDFont2")
	surface.CreateFont("akbar", 72, 500, true, true, "HUDFontBig2")
	
	surface.CreateFont("akbar", 64, 500, true, true, "FUDAmmoBig")

	surface.CreateFont("akbar", ScreenScale(9), 500, true, true, "SSAKBAR")
	surface.CreateFont("Future Rot", ScreenScale(11), 500, true, false, "L4DTIMER")
	surface.CreateFont("Future Rot",ScreenScale(9), 500, true, false, "L4DDIFF")
	surface.CreateFont("Future Rot", ScreenScale(15), 500, true, false, "L4DNUM")
	surface.CreateFont("Future Rot", ScreenScale(8), 500, true, false, "BRAINS")
	surface.CreateFont("Cooper Std Black", ScreenScale(13), 500, true, false, "AMMO")
	surface.CreateFont("Future Rot", ScreenScale(6), 500, true, false, "GC")
	surface.CreateFont("Future Rot", ScreenScale(8), 500, true, false, "FRAGS")
	surface.CreateFont("Future Rot", ScreenScale(9), 500, true, false, "NINE")
	
	surface.CreateFont("Arial", ScreenScale(18), 500, true, false, "ArialThirteen")
	surface.CreateFont("Arial", ScreenScale(12), 700, true, false, "ArialBoldTwelve")
	surface.CreateFont("Arial", ScreenScale(10), 700, true, false, "ArialBoldTen")
	surface.CreateFont("Arial", ScreenScale(16), 500, true, false, "ArialFifteen")
	surface.CreateFont("Arial", ScreenScale(15), 700, true, false, "ArialBoldFifteen")
	surface.CreateFont("Arial", ScreenScale(20), 700, true, false, "ArialBoldTwenty")
	surface.CreateFont("Arial", ScreenScale(7), 700, true, false, "ArialBoldFive")	
	surface.CreateFont("Arial", ScreenScale(6), 700, true, false, "ArialBold4.5")	
	surface.CreateFont("Arial", ScreenScale(5), 700, true, false, "ArialBoldFour")	
	surface.CreateFont("Arial", ScreenScale(9), 700, true, false, "ArialBoldSeven")	
	surface.CreateFont("Arial", ScreenScale(25), 700, true, false, "ArialBold_25")	
	surface.CreateFont("Arial", ScreenScale(30), 700, true, false, "ArialBold_30")	
	surface.CreateFont("Arial", ScreenScale(40), 700, true, false, "ArialBold_40")	
	surface.CreateFont("Arial", ScreenScale(50), 700, true, false, "ArialBold_50")	
	
	surface.CreateFont("Future Rot", ScreenScale(7), 500, true, false, "SEVEN")
	surface.CreateFont("Cooper Std Black", ScreenScale(7), 500, true, false, "CPRSEVEN")
	surface.CreateFont("Cooper Std Black", ScreenScale(8), 500, true, false, "CPREIGHT")

	surface.CreateFont("Cooper Std Black", ScreenScale(12), 500, true, false, "L4D_HP")
	surface.CreateFont("anthem", 32, 500, true, false, "L4DUP")
	
	surface.CreateFont("akbar", ScreenScale(18), 250, true, true, "TARGETNAME")
	surface.CreateFont("akbar", ScreenScale(12), 500, true, true, "TARGETCLASS")
	surface.CreateFont("akbar", ScreenScale(12), 500, true, true, "TARGETHP")

	--SkillPoints fonts
	surface.CreateFont("CorpusCare", ScreenScale(6), 700, true, false, "CorpusCareFive")
	surface.CreateFont("CorpusCare", ScreenScale(7), 700, true, false, "CorpusCareSeven")
	surface.CreateFont("CorpusCare", ScreenScale(10), 700, true, false, "CorpusCareTen")
	surface.CreateFont("CorpusCare", ScreenScale(13), 700, true, false, "CorpusCareThirteen")
	surface.CreateFont("CorpusCare", ScreenScale(16), 500, true, false, "CorpusCareFifteen")

	--Notifications used by split message
	surface.CreateFont( "anthem", ScreenScale(19), 500, true, false, "Notifications" )

	--Force normal gamma
	if FORCE_NORMAL_GAMMA then
		RunConsoleCommand("mat_monitorgamma", "2.2")
		timer.Create("GammaChecker", 3, 0, function()
			RunConsoleCommand("mat_monitorgamma", "2.2")
		end)
	end
	
	--Sync server setting
	timer.Simple(4, function()
		RunConsoleCommand("zs_setautoredeem", tostring( GetConVarNumber("_zs_autoredeem")))
	end)
	
	--Force fast switch and some network vars
	RunConsoleCommand("hud_fastswitch", "1")
	RunConsoleCommand("mat_motion_blur_enabled", "1")
	
	--Call for the changelog
	--[==[http.Get(CHANGELOG_HTTP,"",HTTPChangelog)
	http.Get(ADMINS_HTTP,"",HTTPAdmins)]==]
	
	--self:SplitMessage( h * 0.6, "<color=ltred><font=HUDFontAA>Welcome to</font></color>", "<color=green><font=HUDFontAA>Mr. Green Zombie Survival</font></color>" )
end

function HTTPChangelog(contents, size)
	contents = string.Explode("@", contents)
	for _, text in pairs(contents) do
		text = string.gsub(text, "@", "")
	end
	table.Add(HELP_TEXT[2].text,contents)
end
function HTTPAdmins1(contents, size)
	contents = string.Explode("@", contents)
	for _, text in pairs(contents) do
		text = string.gsub(text, "@", "")
	end
	PrintTable(contents)
	table.Add(HELP_TXT[5].txt,contents)
end

function HTTPAdmins(contents, size)
	contents = string.Explode("@", contents)
	
	for _, text in pairs(contents) do
		text = string.gsub(text, "@", "")
	end
	
	contents[1] = nil
	
	for _, t in pairs(contents) do
		if string.find(t,"%^") then
			local new = string.sub(t,3)
			contents[_] = new
		end
	end
	

	local c = ""
	
	for _,line in pairs(contents) do
		c = c..[[		
				]]..line..[[]]
	end
	
	HELP_TXT[5].txt = c-- HELP_TXT[5].txt..[[]]..c..[[]]
	
	-- table.Add(HELP_TXT[3].text,contents)
end

function GM:RestoreViewmodel()
	timer.Simple( 0.1, function()
		local MySelf = LocalPlayer()
		if MySelf:IsValid() then
			local vm = MySelf:GetViewModel()
			if vm and vm:IsValid() then
				-- vm:SetColor(Color(255, 255, 255, 255))
			end
		end
	end)
end

function RestoreViewmodel(pl)
	
	timer.Simple ( 0.1, function()
		local MySelf = LocalPlayer()
		
		if MySelf:IsValid() then
			if MySelf ~= pl then return end
			local wep = MySelf:GetActiveWeapon()
			if wep then
				if not wep.Base or (wep.Base and not string.find(wep.Base,"zs_")) then
					local vm = MySelf:GetViewModel()
					if vm and vm:IsValid() then
						-- vm:SetColor(Color(255, 255, 255, 255))
					end
				end
			end
		end
		
	end )
	
end

local function LoopLastHuman()
	if not ENDROUND and util.tobool(GetConVar( "_zs_enablemusic" )) then
		surface.PlaySound(LASTHUMANSOUND)
		--timer.Simple(LASTHUMANSOUNDLENGTH, LoopLastHuman)
	end
end

local function DelayedLH()
	local MySelf = LocalPlayer()

	if not ENDROUND then
		if MySelf:Team() == TEAM_UNDEAD or not MySelf:Alive() then
			GAMEMODE:Add3DMessage(140, "Kill the Last Human", nil, "ArialBoldFifteen")
		else
			GAMEMODE:Add3DMessage(140, "You are the LAST HUMAN", nil, "ArialBoldFifteen")
			GAMEMODE:Add3DMessage(140, "Run for your life!", nil, "ArialBoldTen")
		end
	end
end

function GM:LastHuman()
	if LASTHUMAN or ENDROUND then
		return
	end

	LASTHUMAN = true
	
	RunConsoleCommand("stopsound")
	timer.Simple(0.5, function()
		LoopLastHuman()
	end)
	DrawingDanger = 1
	timer.Simple(0.5, function()
		DelayedLH()
	end)
	
	GAMEMODE:SetLastHumanText()
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.Alive then
		return pl:Team() ~= attacker:Team() or pl == attacker
	end
	return true
end

function GM:_HUDShouldDraw( name )
	return name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudSecondaryAmmo" and name ~= "CHudAmmo" and name ~= "CHudDamageIndicator" and name ~= "CHudWeapon" and name ~= "CHudHintDisplay"
end

local function ReceiveHeadcrabScale(um)
	local MySelf = LocalPlayer()

	local pl = um:ReadEntity()
	if pl:IsValid() then
		if pl == MySelf then
			HCView = true
			hook.Add("Think", "HCView", function()
				if MySelf:Health() <= 0 then
					HCView = false
					hook.Remove("Think", "HCView")
				end
			end)
		end
	end
end
usermessage.Hook("RcHCScale", ReceiveHeadcrabScale)

net.Receive("SendTitles", function(len)
	local tbl = net.ReadTable() or {}
	
	for _, stuff in pairs(tbl) do
		local pl = Entity(stuff[1])
		if pl and IsValid(pl) then
			pl.Title = stuff[2] or ""
		end
	end
end)

local function ReceiveTitles ( um )
	local pl, title
	local amount = um:ReadShort()
	for k = 1, amount do
		pl = um:ReadEntity()
		pl.Title = um:ReadString()
	end
end
usermessage.Hook( "SendTitles", ReceiveTitles )

--[=[----------------------------------------------------------------
      Receives updates data regarding the ammo regen timer
------------------------------------------------------------------]=]
local function ReceiveAmmoTimer( um )
	if not ValidEntity ( MySelf ) then return end

	-- Update the regeneration time
	local SetTimer = um:ReadShort()
	MySelf:SetAmmoTime(SetTimer or AMMO_REGENERATE_RATE)
	
	-- First regeneration
	MySelf.IsFirstRegeneration = true
end
usermessage.Hook("UpdateAmmoTime", ReceiveAmmoTimer)

PlayerIsAdmin = false
local function ReceiveAdmin(um)
	PlayerIsAdmin = um:ReadBool()
end
usermessage.Hook("SendAdminStats", ReceiveAdmin)

-- Receive map list
MapList = {}
local function ReceiveMapList(um)
	local index = um:ReadShort()
	local map = um:ReadString()
	map = string.gsub(map,".bsp","")
	MapList[index] = map
end
usermessage.Hook("RcMapList", ReceiveMapList)

net.Receive("SetAchievementsData", function(len)
	local pl = net.ReadEntity()
	if not IsValid(pl) then
		return
	end
	
	local tbl = net.ReadTable() or {}
	
	pl.DataTable = pl.DataTable or {}
	pl.DataTable["Achievements"] = {}
	
	for k, v in ipairs( achievementDesc ) do
		pl.DataTable["Achievements"][k] = tbl[k] or false
	end

	pl.GotAchievementsData = true
	pl.StatsReceived = true
	
	print("[DB] Successfully received achievements data")
end)

net.Receive("SetStatsData", function(len)
	local pl = net.ReadEntity()
	if not IsValid(pl) then
		return
	end
	
	-- Init datatable if it's not
	pl.DataTable = pl.DataTable or {}
	
	-- Receive goodies
	local Key = net.ReadString()
	local Value = net.ReadString()
	pl.DataTable[tostring(Key)] = string.Sanitize(Value)
end)

net.Receive("SendClassData", function(len)
	if not IsValid(MySelf) then
		return
	end
	
	local tbl = net.ReadTable() or {}
	
	MySelf.DataTable = MySelf.DataTable or {}
	MySelf.DataTable["ClassData"] = MySelf.DataTable["ClassData"] or { }
	
	MySelf.DataTable["ClassData"] = table.Copy(tbl)
	
	MySelf.GotClassData = true
	print("[DB] Successfully received class data")
end)

net.Receive("SetShopData", function(len)
	local pl = net.ReadEntity()
	if not IsValid( pl ) then
		return
	end
	
	local tbl = net.ReadTable() or {}
	
	pl.DataTable = pl.DataTable or {}
	pl.DataTable["ShopItems"] = pl.DataTable["ShopItems"] or {}
	
	for k, v in ipairs( shopData ) do
		pl.DataTable["ShopItems"][k] = tbl[k] or false
	end

	pl.GotShopData = true
	print("[DB] Successfully received shop data..")
end)

local function SetShopData(um)
	local pl = um:ReadEntity()
	if not IsValid( pl ) then return end
	
	--if not pl.DataTable then
	pl.DataTable = pl.DataTable or {}
	pl.DataTable["ShopItems"] = pl.DataTable["ShopItems"] or {}
	--end
	for k, v in ipairs( shopData ) do
		pl.DataTable["ShopItems"][k] = um:ReadBool()
	end
	
	pl.GotShopData = true
	print( "[DB] Successfully received shop data.." )
end
usermessage.Hook("SetShopData", SetShopData)

local function SetServerData(um)
	local index = um:ReadShort()
	
	for i, j in pairs(GAMEMODE.DataTable[index].players) do
		j.name = um:ReadString()
		j.value = um:ReadLong()
	end
	for i, j in pairs(GAMEMODE.DataTable[index+1].players) do
		j.name = um:ReadString()
		j.value = um:ReadLong()
	end
end
usermessage.Hook("SetServerData1", SetServerData)
usermessage.Hook("SetServerData2", SetServerData)
usermessage.Hook("SetServerData3", SetServerData)

net.Receive( "SendUpgradeNumbers", function( len )
	MySelf.TotalUpgrades = net.ReadDouble()
end)

local function SendUpgradeNumbers(um)
	MySelf.TotalUpgrades = um:ReadShort()
end
usermessage.Hook("SendUpgradeNumbers", SendUpgradeNumbers)

function UpdateHumanClass(um)
	local pl
	
	-- Read interval
	local tbStart = um:ReadShort()
	
	-- Set classes thoughout the interval
	for k = 1, tbStart do
		pl = um:ReadEntity()
		pl.ClassHuman = um:ReadShort()
	end
end
usermessage.Hook("UpdateHumanClass", UpdateHumanClass)

function SendZombieClass(um)
	local playersclass, pl

	-- Receive the interval
	local tbStart, tbEnd = um:ReadShort(), um:ReadShort()
	
	-- Set classes throughout the interval given
	for i = tbStart, tbEnd do
		pl = um:ReadEntity()
		playersclass = um:ReadShort()
		pl.Class = playersclass
	end
end
usermessage.Hook("SendZombieClass", SendZombieClass)

local function SendMaximumHealth(um)
	MySelf.MaximumHealth = um:ReadShort()
end
usermessage.Hook("SendMaximumHealth", SendMaximumHealth)

----------------------------- Spawn Protection Code for Humans  - Clientside  ------------------------------------ TODO: Fix

-- Fonts
local function InitializeFonts()
	surface.CreateFont("Arial", ScreenScale(10), 500, true, false, "ProtectionTitle" )
end
hook.Add("Initialize", "InitializeSpawnProtectionFonts", InitializeFonts)

local function ResetProtectionBox(pl)
	if pl ~= MySelf then
		return
	end
	
	hook.Remove( "HUDPaint", "DrawHumanSpawnProtection" )
end
hook.Add("PlayerSpawn", "ResetProtectionDrawBox", ResetProtectionBox)

local function drawSpawnProtection(pl)
	timer.Simple(0.25, function()
		if IsValid( pl ) then
			if pl == MySelf then
				hook.Add("HUDPaint", "DrawHumanSpawnProtection", function()
					if not IsValid( MySelf ) then
						return
					end
					
					-- Checks
					if not MySelf:Alive() or not MySelf:IsHuman() or not MySelf:HasSpawnProtection() or ENDROUND then return end
					
					-- Get damage reduction
					local CurrentReduction = MySelf:GetSpawnDamagePercent()
					
					local ww,wh = ScaleW(212),ScaleH(30)
					local wx,wy = w/2-ww/2, h-wh*4
					
					surface.SetDrawColor( 0, 0, 0, 150)
					surface.DrawRect(wx,wy,ww,wh)
					surface.DrawRect(wx+5 , wy+5,  ww-10, wh-10 )
					
					surface.SetDrawColor(98,17,17,255)
					surface.DrawRect(wx+5 , wy+5,(CurrentReduction*ww)-10, wh-10 )
					
					draw.SimpleTextOutlined("Spawn protection: "..math.Round(CurrentReduction * 100 ).."%", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
				end)
			end
		end
	end)
end
hook.Add("OnPlayerRedeem", "HumanSpawnProtection", drawSpawnProtection)

drawZombieBoost = drawZombieBoost or false
local BoostTime = 0

local function ResetBoostBox( pl )
	if pl ~= MySelf then
		return
	end
	
	drawZombieBoost = false
end
--hook.Add( "PlayerSpawn", "ResetBoostBox", ResetBoostBox )

local boostmat = surface.GetTextureID ( "zombiesurvival/hud/hud_friend_splash" )
local function DrawZombieBoost()
	if not IsValid( MySelf ) then return end
	if not drawZombieBoost then return end
					
	if not MySelf:Alive() or not MySelf:IsZombie() or ENDROUND then return end
	
	--local matSplash = surface.GetTextureID ( "zombiesurvival/hud/hud_friend_splash" )
	
	local swide,stall = ScaleW(166), ScaleH(17)
	local sx,sy = w/2 - swide/2, 3.5*h/4
	
	--local matW, matH = surface.GetTextureSize( matSplash )
	local matW, matH = ScaleW(315), ScaleH(315)
	local matX, matY = w/2 - matW/2, 3.5*h/4 + stall/2 - matH/2
	
	local coefW, coefH = swide/matW,stall/matH
	
	surface.SetDrawColor ( 119, 10, 10, 255 )
	surface.SetTexture ( boostmat )
	surface.DrawTexturedRect ( matX, matY, matW, matH ) 

	draw.SimpleTextOutlined("Speed boost", "ArialBoldFive", w/2 , sy-3, Color (255,255,255,255), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	
	sy = sy+5
	
	--draw.RoundedBox( 0, sx,sy,swide,stall, Color (1,1,1,200) )
	
	surface.SetDrawColor( 0, 0, 0, 150)
	surface.DrawRect(sx,sy,swide,stall )
	
	surface.DrawRect(sx+3 , sy+2.5, swide-6, stall-6 )	
	
	surface.SetDrawColor( 230,1,1,160)
	
	surface.DrawRect(sx+3 , sy+2.5, ((BoostTime - CurTime())/TranslateMapTable[ game.GetMap() ].ZombieSpawnProtection)*(swide-6),stall-6 )
	
	--draw.RoundedBox( 0, sx,sy,((BoostTime - CurTime())/TranslateMapTable[ game.GetMap() ].ZombieSpawnProtection)*swide,stall, Color (230,1,1,160) )
	
	--surface.SetDrawColor( 0, 0, 0, 255 )
	--surface.DrawOutlinedRect( sx,sy,swide,stall+1)
	
	--draw.SimpleText(math.Round(BoostTime - CurTime()), "ArialBoldTwelve", ScrW()/2 , ScrH()/2, Color (255,255,0,255), TEXT_ALIGN_CENTER)
	
	if BoostTime - CurTime() <= 0 then
		drawZombieBoost = false
	end
end
hook.Add("HUDPaint", "DrawZombieBoost", DrawZombieBoost)

local function EnableZombieBoost()
	BoostTime = CurTime() + TranslateMapTable[ game.GetMap() ].ZombieSpawnProtection
	drawZombieBoost = true
end
usermessage.Hook("EnableZombieBoost", EnableZombieBoost)

----------------------------------------------------------------------------------------------------------------------

function draw.DrawTextShadow( text, font, x, y, color, shadowcolor, xalign )
	local tw, th = 0, 0
	surface.SetFont(font)

	if xalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		x = x - tw * 0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		tw, th = surface.GetTextSize(text)
		x = x - tw
	end

	surface.SetTextColor(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a or 255)
	surface.SetTextPos(x+1, y+1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x+1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y+1)
	surface.DrawText(text)

	if color then
		surface.SetTextColor(color.r, color.g, color.b, color.a or 255)
	end

	surface.SetTextPos(x, y)
	surface.DrawText(text)

	return tw, th
end

function draw.SimpleTextShadow( text, font, x, y, color, shadowcolor, xalign, yalign )
	font 	= font 		or "Default"
	x 		= x 		or 0
	y 		= y 		or 0
	xalign 	= xalign 	or TEXT_ALIGN_LEFT
	yalign 	= yalign 	or TEXT_ALIGN_TOP
	local tw, th = 0, 0
	surface.SetFont(font)
	
	if xalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		x = x - tw*0.5
	elseif xalign == TEXT_ALIGN_RIGHT then
		tw, th = surface.GetTextSize(text)
		x = x - tw
	end
	
	if yalign == TEXT_ALIGN_CENTER then
		tw, th = surface.GetTextSize(text)
		y = y - th*0.5
	end

	surface.SetTextColor(shadowcolor.r, shadowcolor.g, shadowcolor.b, shadowcolor.a or 255)
	surface.SetTextPos(x+1, y+1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x+1, y-1)
	surface.DrawText(text)
	surface.SetTextPos(x-1, y+1)
	surface.DrawText(text)

	if color then
		surface.SetTextColor(color.r, color.g, color.b, color.a or 255)
	else
		surface.SetTextColor(255, 255, 255, 255)
	end

	surface.SetTextPos(x, y)
	surface.DrawText(text)

	return tw, th
end

function GM:_HUDPaintBackground()
end


-- HALLOWEEN!
local HalloweenNoticeTimer = 3
local halpha = {}
halpha.box = 0
halpha.text = 0
function DrawHalloweenNotice ()
	if not ValidEntity ( LocalPlayer() ) then return end
	if not MySelf:Alive() then return end
	
	surface.SetFont ("ArialBoldFive")
	local textsizeh, hheight = surface.GetTextSize ("Happy Halloween!")
	local boxsizeh, hheightpos = textsizeh + 30, hheight + 10
	draw.RoundedBox( 4, ( ScaleW(1282) - boxsizeh ), ( ScaleH(31) + 31/2 ) ,boxsizeh, ScaleH(31), Color (1,1,1,halpha.box) )
	draw.SimpleText("Happy Halloween!","ArialBoldFive", ScaleW(1282) - (boxsizeh - 15),ScaleH(51 + hheight) ,Color (255,0,0,halpha.text), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	
	if HalloweenNoticeTimer < CurTime() + 15 then
		halpha.box = math.Approach (halpha.box, 0, FrameTime() * 260)
		halpha.text = math.Approach (halpha.text, 0, FrameTime() * 260)
		
		if halpha.box == 0 and halpha.text == 0 then
			hook.Remove ("HUDPaint","DrawHalloweenNotice")
		end
	else
		halpha.box = math.Approach (halpha.box, 230, FrameTime() * 210)
		halpha.text = math.Approach (halpha.text, 255, FrameTime() * 210)
	end
end
local WATER_DROWNTIME_CONST = 20
local WATER_DROWNTIME = 20
-- Draw HUD
function GM:_HUDPaint()
	local MySelf = LocalPlayer()
	if not MySelf:IsValid() then return end
	local myteam = MySelf:Team()
	
	h = ScrH()
	w = ScrW()
	
	-- Not ready
	if not MySelf.ReadySQL then return end
	
	if myteam ~= TEAM_SPECTATOR then
		if MySelf:Alive() and not IsClassesMenuOpen() then
			self:DrawDeathNotice( 0.83, 0.07 )
			self:HUDDrawTargetID( MySelf, myteam )
		end
	end
	
	if MySelf:IsHuman() and MySelf:Alive() then
		--Drowning code for humans
		if 2 < MySelf:WaterLevel() then
			WATER_DROWNTIME = math.max(WATER_DROWNTIME - FrameTime(), 0)
			if WATER_DROWNTIME <= 0 then
				RunConsoleCommand("water_death")
				WATER_DROWNTIME = WATER_DROWNTIME_CONST
			elseif 10 < WATER_DROWNTIME then
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0.45, FrameTime() * 0.2)
				ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 0, FrameTime() * 0.25)
			end
			
			local ww,wh = ScaleW(212),ScaleH(30)
			local wx,wy = w/2-ww/2, h-wh*2
			
			surface.SetDrawColor( 0, 0, 0, 150)
			surface.DrawRect(wx,wy,ww,wh)
			surface.DrawRect(wx+5 , wy+5,  ww-10, wh-10 )
			
			surface.SetDrawColor(98,17,17,255)
			surface.DrawRect(wx+5 , wy+5,((WATER_DROWNTIME/WATER_DROWNTIME_CONST)*ww)-10, wh-10 )
			
			draw.SimpleTextOutlined("Oxygen: "..math.Round(WATER_DROWNTIME).." sec left", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
			
		elseif WATER_DROWNTIME > 0 and WATER_DROWNTIME ~= WATER_DROWNTIME_CONST then
		
			WATER_DROWNTIME = math.min(WATER_DROWNTIME + FrameTime() * 3, WATER_DROWNTIME_CONST)
			if WATER_DROWNTIME <= WATER_DROWNTIME_CONST then
				ColorModify["$pp_colour_addb"] = 0
				ColorModify["$pp_colour_colour"] = 1
			else
				ColorModify["$pp_colour_addb"] = math.Approach(ColorModify["$pp_colour_addb"], 0, FrameTime() * 0.3)
				ColorModify["$pp_colour_colour"] = math.Approach(ColorModify["$pp_colour_colour"], 1, FrameTime())
			end
			
			local ww,wh = ScaleW(212),ScaleH(30)
			local wx,wy = w/2-ww/2, h-wh*2
			
			surface.SetDrawColor( 0, 0, 0, 150)
			surface.DrawRect(wx,wy,ww,wh)
			surface.DrawRect(wx+5 , wy+5,  ww-10, wh-10 )
			
			surface.SetDrawColor(98,17,17,255)
			surface.DrawRect(wx+5 , wy+5,((WATER_DROWNTIME/WATER_DROWNTIME_CONST)*ww)-10, wh-10 )
			
			draw.SimpleTextOutlined("Recharging breath: "..math.Round(math.abs (WATER_DROWNTIME - WATER_DROWNTIME_CONST)).." sec left", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		end
	end
end

-- Dropped weapons glow/sparkles by Deluvas (thanks!)
function DrawBackgroundSelect()
	--if ENDROUND then return end -- Don't draw anything when the intermission is busy.

	local MySelf = LocalPlayer()
	if not MySelf:IsValid() then return end
	
	if MySelf:Team() == TEAM_UNDEAD or MySelf:Alive() == false then return end
	
	local wepcolor = { }
	wepcolor.r = 255
	wepcolor.g = 255
	wepcolor.b = 255
	
	for k, ent in pairs (ents.GetAll()) do
		if ent:IsValid() then
			if ent:IsWeapon() and not ent:GetOwner():IsPlayer() then --  I could have made a table :< 
				if ent:GetClass() == "weapon_zs_melee_axe" or ent:GetClass() == "weapon_zs_combatknife" or ent:GetClass() == "weapon_zs_melee_crowbar" or ent:GetClass() == "weapon_zs_melee_fryingpan" or ent:GetClass() == "weapon_zs_tools_hammer" or ent:GetClass() == "weapon_zs_melee_keyboard"	or ent:GetClass() == "weapon_zs_melee_plank" or ent:GetClass() == "weapon_zs_melee_pot" or ent:GetClass() == "weapon_zs_shovel" or ent:GetClass() == "weapon_zs_sledgehammer" then
				    wepcolor.r,wepcolor.g,wepcolor.b = 230,50,55
				elseif ent:GetClass() == "weapon_zs_usp" or ent:GetClass() == "weapon_zs_p228" then
					wepcolor.r,wepcolor.g,wepcolor.b = 233,202,23
				elseif ent:GetClass() == "weapon_zs_deagle" or ent:GetClass() == "weapon_zs_elites" or ent:GetClass() == "weapon_zs_glock" or ent:GetClass() == "weapon_zs_fiveseven" or ent:GetClass() == "weapon_zs_magnum" then
					wepcolor.r,wepcolor.g,wepcolor.b = 102,170,14
				elseif ent:GetClass() == "weapon_zs_p90" or ent:GetClass() == "weapon_zs_mac10" or ent:GetClass() == "weapon_zs_ump" or ent:GetClass() == "weapon_zs_tmp" or ent:GetClass() == "weapon_zs_mp5" then	
					wepcolor.r,wepcolor.g,wepcolor.b = 14,168,173
				elseif ent:GetClass() == "weapon_zs_m4a1" or ent:GetClass() == "weapon_zs_aug" or ent:GetClass() == "weapon_zs_galil" or ent:GetClass() == "weapon_zs_famas" or ent:GetClass() == "weapon_zs_sg552" or ent:GetClass() == "weapon_zs_pulserifle" or ent:GetClass() == "weapon_zs_m249" or ent:GetClass() == "weapon_zs_ak47" then	
					wepcolor.r,wepcolor.g,wepcolor.b = 35,38,163
				elseif ent:GetClass() == "weapon_zs_m1014" or ent:GetClass() == "weapon_zs_m3super90" then
					wepcolor.r,wepcolor.g,wepcolor.b = 165,93,22
				elseif ent:GetClass() == "weapon_zs_scout" or ent:GetClass() == "weapon_zs_crossbow" or ent:GetClass() == "weapon_zs_awm" then
					wepcolor.r,wepcolor.g,wepcolor.b = 170,177,40
				end
					
				local mypos = MySelf:GetShootPos()
				local ang = MySelf:GetAimVector()
				local tracedata = {}
				tracedata.start = mypos
				tracedata.endpos = ent:GetPos()
				--tracedata.filter = MASK_OPAQUE
				--tracedata.filter = {MySelf, ent}
				--tracedata.filter = CONTENTS_EMPTY --MASK_SOLID --MASK_SOLID
				local trace = util.TraceLine(tracedata)
				local distance = MySelf:GetPos():Distance(ent:GetPos())
					
				if distance < 500 and trace.HitWorld == false and math.random(1,12) == 1 then
					local propname = ent:GetClass()
					local cen = ent:LocalToWorld(ent:OBBCenter())
					cenp = cen:ToScreen()
					local pos = ent:GetPos()
					local emitter = ParticleEmitter(pos)
					local vNormal = VectorRand()
					local particle = emitter:Add("sprites/light_glow02_add", Vector (pos.x+math.random(-10, 10),pos.y+math.random(-10, 10),pos.z+9) )
					particle:SetVelocity(vNormal * math.random(50, 80) - Vector(0,0,math.random(-16, -4)))
					particle:SetDieTime(0.6)
					particle:SetStartAlpha(150)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.Rand(1,15))
					particle:SetEndSize(math.Rand(5,10))
					particle:SetColor(wepcolor.r, wepcolor.g, wepcolor.b) -- 155, 56, math.random(0, 50)
					particle:SetRoll(math.random(90, 360))
					particle:SetCollide(true)
					particle:SetGravity(Vector(0,0,-60))
					emitter:Finish()
				end
			end
		end
	end
end

--Coin painting effect
local amountAdded = 0
local yAddAdd = 40
local yAdd = 0
function PaintCoinEffect()
	yAdd = yAdd + FrameTime() * yAddAdd
	yAddAdd = math.max(0, yAddAdd - FrameTime()*35)
	local str
	if amountAdded < 0 then
		str = amountAdded
	else
		str = "+"..amountAdded
	end
	
	draw.DrawText(str, "SSAKBAR", w*0.097, h*0.250-yAdd, Color(30,94,27,255), TEXT_ALIGN_CENTER) 
end

function KillCoinPaint()
	amountAdded = 0
	hook.Remove("HUDPaint","PaintCoinEffect")
end

-- Disable this for a while
local cnt = 1
local function CoinEffect(um)
	--[=[yAdd = 0
	yAddAdd = 40
	local add = um:ReadShort()
	if add then
		amountAdded = amountAdded + add
		hook.Add("HUDPaint","PaintCoinEffect",PaintCoinEffect)
		timer.Remove("CoinKillTimer")
		timer.Create("CoinKillTimer",2,1,KillCoinPaint)
	end]=]
end
usermessage.Hook("CoinEffect", CoinEffect)

----------------------

BloodDraws = {}
function AddBloodSplat( severity )
	local toDraw = bloodSplats[math.random(1,8)]
	local dur = severity
	local alp = 55+severity*90
	
	if #BloodDraws < 5 then
		table.insert(BloodDraws, { fadestart = CurTime()+3+math.Rand(1,5), image = toDraw, duration = dur, alpha = alp })
	end
end

function BloodDraw()
	if not IsEntityValid( MySelf ) then return end
	
	for k, v in pairs(BloodDraws) do
		
		surface.SetTexture( v.image )
		surface.SetDrawColor( Color(120,0,0,v.alpha) )
		surface.DrawTexturedRect( 0,0,w,h )
		
		if (v.fadestart < CurTime()) then
			v.alpha = math.Approach(v.alpha, 0, FrameTime()*v.duration*100)
			if v.alpha == 0 then
				table.remove(BloodDraws,k)
			end
		end
	end
end
hook.Add("HUDPaint","DrawBloodSplats",BloodDraw)

-----------------

util.PrecacheSound("npc/stalker/breathing3.wav")
util.PrecacheSound("npc/zombie/zombie_pain6.wav")

GM.ZombieThirdPerson = false

function GM:PlayerBindPress(pl, bind, pressed)
	if string.find( bind, "speed" ) and pl:Team() ~= TEAM_UNDEAD and not pl:IsZombine() then
		return true
	elseif pl:Team() == TEAM_SPECTATOR and (string.find (bind, "messagemode") or string.find (bind,"messagemode2") or string.find (bind,"+voicerecord")) then 
		return true
	end
	
	--Third person view
	if bind == "+menu_context" then
		self.ZombieThirdPerson = not self.ZombieThirdPerson
	end
end

--[=[----------------------------------------------------------------
   Restrict  keys like jump / crouch for some classes
------------------------------------------------------------------]=]
function RestrictControls ( pl , bind, pressed ) 
	if not pl == MySelf then
		return
	end

	if pl:Team() == TEAM_UNDEAD then
		--Ducking
		if string.find(bind, "duck") then
			local Class = pl:GetZombieClass()
		
			if ZombieClasses[Class].CanCrouch == false then
				return true
			end
		end
	end
	
	--Walk for humans
	if pl:Team() == TEAM_HUMAN then
		if string.find(bind, "walk") then
			return true
		end		
	end
end
hook.Add("PlayerBindPress", "RestrictControl", RestrictControls)

function SpectatorSay ( say )
	return MySelf:Team() == TEAM_SPECTATOR
end
hook.Add("StartChat", "Spectator", SpectatorSay)

DEBUG_VIEW = false

local SkullCam = NULL
usermessage.Hook("SkullCam", function(um)
	local ent = um:ReadEntity()
	if ent and ent:IsValid() then
		SkullCam = ent
	end
end)
GM.FOVLerp = 1

hook.Add("Think", "CheckFOV", function()
	if not MySelf or not MySelf.Team then
		return
	end
	
	if MySelf:Team() == TEAM_HUMAN then
		local wep = MySelf:GetActiveWeapon()
		
		if wep:IsValid() and wep.GetIronsights and wep:GetIronsights() then
			GAMEMODE.FOVLerp = math.Approach(GAMEMODE.FOVLerp, wep.IronsightsMultiplier or 0.6, FrameTime() * 4)
		else
			GAMEMODE.FOVLerp = math.Approach(GAMEMODE.FOVLerp, 1, FrameTime() * 5)
		end
	else
		if not MySelf:Alive() then
			GAMEMODE:ToggleZombieVision(false)
		end
	end
end)

local function AddNightFog()
	render.FogMode( 1 ) 
	render.FogStart(0)
	render.FogEnd(10000)
	render.FogMaxDensity( 0.9 )
	
	render.FogColor( 0.1 * 255, 0.1 * 255, 0.1 * 255 )

	return true
end

local function AddNightFogSkybox(skyboxscale)
	render.FogMode( 1 ) 
	render.FogStart(0*skyboxscale)
	render.FogEnd(10000*skyboxscale)
	render.FogMaxDensity( 0.9 )

	render.FogColor( 0.1 * 255, 0.1 * 255, 0.1 * 255 )

	return true
end

local drawfog = false
hook.Add("Think","NightFog",function()
	if not GAMEMODE:IsNightMode() then
		return
	end
	
	if drawfog then
		return
	end
	
	drawfog = true
	
	hook.Add( "SetupWorldFog","AddNightFog", AddNightFog )
	hook.Add( "SetupSkyboxFog","AddNightFogSkybox", AddNightFogSkybox )	
end)

local undomodelblend = false
local undowraithblend = false
function GM:_PrePlayerDraw(pl)
	if pl.IsZombie and pl:IsZombie() and pl.IsWraith and pl:IsWraith() then
		if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsDisguised and pl:GetActiveWeapon():IsDisguised() then
			render.SetBlend(1)
		else
			local col = math.random( 1, 35 ) == 1 and 1 or 0.04
			render.SetBlend(col)
		end
		undowraithblend = true
	end

	if pl.status_overridemodel and pl.status_overridemodel:IsValid() and self:ShouldDrawLocalPlayer(MySelf) then
		undomodelblend = true
		render.SetBlend(0)
	end	
end

function GM:_PostPlayerDraw(pl)
	if undomodelblend then
		render.SetBlend(1)
		render.ModelMaterialOverride()
		render.SetColorModulation(1, 1, 1)
		undomodelblend = false
	end
	if undowraithblend then
		render.SetBlend(1)
		undowraithblend = false
	end
end


local revertvm = false
function GM:PreDrawViewModel(vm,pl,wep)
	if vm and wep then
		if wep.ShowViewModel == false then
			revertvm = true
			render.SetBlend(1/255)
		end
	end	
end

function GM:PostDrawViewModel(vm)
	if revertvm then
		render.SetBlend(1)
		revertvm = false
	end
end

local fovlerp = GetConVarNumber("fov_desired")
local maxfov = fovlerp
local minfov = fovlerp * 0.6
local staggerdir = VectorRand():GetNormal()

function GM:_ShouldDrawLocalPlayer(pl)
	local weapon = pl:GetActiveWeapon()
	return pl.Team and pl:Team() == TEAM_UNDEAD and ((self.ZombieThirdPerson or (IsValid(weapon) and weapon.GetClimbing and weapon:GetClimbing())) or (pl.Revive and pl.Revive:IsValid()))--  and pl.Revive:IsRising()
end

function GM:_CalcView ( pl, vPos, aAng, fFov )
	if not IsValid(MySelf) then
		return
	end

	-- Grab data
	local Velocity, EyeAngle = pl:GetVelocity(), pl:EyeAngles()

	-- Lower view position for crabs
	--[[if MySelf:IsZombie() then
		if MySelf:Health() > 0 then
			if ZombieClasses[MySelf:GetZombieClass()].ViewOffset then
				vPos = vPos + ZombieClasses[MySelf:GetZombieClass()].ViewOffset
			end
		end
	end]]
	
	--Revive camera
	if pl.Revive and pl.Revive.GetRagdollEyes then
		local rpos, rang = pl.Revive:GetRagdollEyes(pl)
		if rpos then
			return { origin = rpos, angles = rang }
		end
	end
	
	--Skull camera for dead humans
	if MySelf:GetRagdollEntity() and not (MySelf:GetObserverMode() == OBS_MODE_ROAMING or MySelf:GetObserverMode() == OBS_MODE_FREEZECAM or MySelf:GetObserverMode() == OBS_MODE_CHASE ) then
		local rpos, rang = self:GetRagdollEyes(MySelf)
		if rpos then
			return { origin = rpos, angles = rang }
		end
	end
	
	--
	if pl:ShouldDrawLocalPlayer() and pl:OldAlive() then
		local wep = pl:GetActiveWeapon()
		if IsValid(wep) and wep.GetClimbing and wep:GetClimbing() and not self.ZombieThirdPerson then
			local bone = pl:LookupBone("ValveBiped.HC_BodyCube")
			if bone then
				local pos,ang = pl:GetBonePosition(bone)
				if pos and ang then
					ang:RotateAroundAxis(ang:Up(),-90)
					return {origin = pos+pl:SyncAngles():Forward()*4+pl:SyncAngles():Up()*-3, angles = Angle(math.Clamp(aAng.p,-45,45),aAng.y,ang.r/6)}
				end
			end
		else
			return {origin = pl:GetThirdPersonCameraPos(vPos, aAng), angles = aAng}
		end
	end
	
	-- FOV controller ( used with MySelf:SetFOV () )

	fFov = fFov or GetConVar("fov_desired"):GetInt() or 75
	--[[MySelf.Fov = MySelf.Fov or GetConVar("fov_desired"):GetInt()
	 if MySelf.Fov then
	 	MySelf.CurrentFov = MySelf.CurrentFov or GetConVar("fov_desired"):GetInt()
	 	MySelf.CurrentFov = math.Approach ( MySelf.CurrentFov, MySelf.Fov, FrameTime() * 100 )
	 	fFov = MySelf.Fov -- .CurrentFov
	 end
	 	fFov = math.Approach ( fFov, MySelf.Fov, FrameTime() * 100 ) 
	
	 MySelf.ApproachFov = MySelf.ApproachFov or GetConVar("fov_desired"):GetInt()-- 75
	 
	 if MySelf.Fov then MySelf.ApproachFov = math.Approach ( MySelf.ApproachFov, MySelf.Fov, FrameTime() * 100 ) fFov = MySelf.ApproachFov end
	 MySelf.ApproachFov = math.Approach ( MySelf.ApproachFov, MySelf.Fov, FrameTime() * 100 ) 
	 fFov = MySelf.ApproachFov]]
	
	-- Weapon calc. view management ( human only )
	if MySelf:Team() == TEAM_HUMAN then
		local Weapon, WeaponAngle, WeaponPos = pl:GetActiveWeapon()
		if Weapon:IsValid() then
			local ViewModelFunc, CalcViewFunc = Weapon.GetViewModelPosition, Weapon.CalcView
			
			-- Use the weapon calc. view functions instead
			if ViewModelFunc then WeaponPos, WeaponAngle = ViewModelFunc ( Weapon, vPos, aAng ) end
			if CalcViewFunc then vPos, aAng, fFov = CalcViewFunc ( Weapon, pl, vPos, aAng, fFov ) end
		end
		
		--Bouncy view ( strafe )
		if ( MySelf:Alive() and MySelf:Health() > 30 ) and Velocity:Length() < 330 then
			aAng.roll = aAng.roll + EyeAngle:Right():DotProduct( Velocity ) * 0.007
		end	
		
		return { origin = vPos, angles = aAng, fov = fFov, vm_origin = WeaponPos, vm_angles = WeaponAngle }
	end

	return { origin = vPos, angles = aAng, fov = fFov }
end

function GM:IsRetroMode()
	return GetGlobalBool("retromode")
end

function GM:IsNightMode()
	return GetGlobalBool("nightmode")
end

function render.GetLightRGB(pos)
	local vec = render.GetLightColor(pos)
	return vec.r, vec.g, vec.b
end

local matPullBeam = Material("cable/rope")
local colPullBeam = Color(255, 255, 255, 255)
hook.Add("PostDrawOpaqueRenderables","DrawCarryRope",function()
	local holding = MySelf.status_human_holding
	if holding and holding:IsValid() and holding:GetIsHeavy() then
		local object = holding:GetObject()
		if object:IsValid() then
			local pullpos = holding:GetPullPos()
			local hingepos = holding:GetHingePos()
			local r, g, b = render.GetLightRGB(hingepos)
			colPullBeam.r = r * 255
			colPullBeam.g = g * 255
			colPullBeam.b = b * 255
			render.SetMaterial(matPullBeam)
			render.DrawBeam(hingepos, pullpos, 0.5, 0, pullpos:Distance(hingepos) / 128, colPullBeam)
		end
	end
end)

local vecfake = Vector(0, 0, 32000)
local nodraw = false
hook.Add("Think", "DrawZombieFlashLight", function()
	local light = Entity(0):GetDTEntity(0)
	
	if light and IsValid(light) then
		
		local todraw = MySelf and IsValid(MySelf) and MySelf.IsZombie and MySelf:IsZombie() and MySelf:OldAlive() and (GAMEMODE.m_ZombieVision or GAMEMODE:IsNightMode())
		
		if todraw then
			if light:IsEffectActive( EF_NODRAW ) then
				light:SetNoDraw(false)
			end
			light:SetOwner(MySelf)
			light:SetPos(EyePos())
			light:SetAngles(MySelf:EyeAngles())
		else
			if not light:IsEffectActive( EF_NODRAW ) then
				light:SetNoDraw(true)
			end
			light:SetPos(vecfake)
		end
	end

end)

local light = DynamicLight
local traceline = util.TraceLine

-- hook.Add("PostDrawOpaqueRenderables","DrawZombieVision",function()
	
	-- local todraw = MySelf and IsValid(MySelf) and MySelf.IsZombie and MySelf:IsZombie() and MySelf:Alive() and GAMEMODE.m_ZombieVision
	
	--[==[if todraw then
		local dlight = DynamicLight( MySelf:EntIndex() )
		if dlight then
			
			local trace = traceline({start = MySelf:GetShootPos(), endpos = MySelf:GetShootPos()+MySelf:GetAimVector()* 100, filter = MySelf})
		
			dlight.Pos = trace.HitPos + (trace.HitNormal or vector_origin)*5
			dlight.r = 235-- math.random(30,45)
			dlight.g = 60
			dlight.b = 60
			dlight.Brightness = 1
			dlight.Size = 390
			dlight.Decay = 390 * 5
			dlight.DieTime = CurTime() + 1
			dlight.Style = 0

		end				
	end]==]

-- end)

function GM:ToggleZombieVision(onoff)
	if onoff == nil then
		onoff = not self.m_ZombieVision
	end

	if onoff then
		if not self.m_ZombieVision then
			self.m_ZombieVision = true
			MySelf:EmitSound("npc/stalker/breathing3.wav", 0, 230)
			-- MySelf:SetDSP(5)
		end
	elseif self.m_ZombieVision then
		self.m_ZombieVision = nil
		MySelf:EmitSound("npc/zombie/zombie_pain6.wav", 0, 110)
		-- MySelf:SetDSP(0)
	end
end

local staggerdir = VectorRand():GetNormal()
function GM:_CreateMove(cmd)
	local vel
	if MYSELFVALID then 
		vel = MySelf:GetVelocity() 
	end

	if MYSELFVALID and MySelf:Team() == TEAM_HUMAN and MySelf:Alive() and vel:Length() < 330 and vel:Length() > 27 then 
	
		local angl = cmd:GetViewAngles()
		angl.pitch = (angl.pitch + math.sin(CurTime()*8)*0.06) 
		angl.yaw = (angl.yaw + math.cos(CurTime()*4)*0.03) 	
		
		cmd:SetViewAngles(angl)
		
	elseif MYSELFVALID and MySelf:Team() == TEAM_UNDEAD and MySelf:Alive() and vel:Length() < 330 and vel:Length() > 27 then 
	
		if not MySelf:IsHeadcrab() or not MySelf:IsPoisonCrab() then
			local zangl = cmd:GetViewAngles()
			zangl.pitch = (zangl.pitch + math.sin(CurTime()*8)*0.06) 
			zangl.yaw = (zangl.yaw + math.cos(CurTime()*4)*0.03) 	
			
			cmd:SetViewAngles(zangl)
		end
	end
end

function GM:ShutDown()
	--self:RestoreMaterials()
end

local last_mat = TEAM_UNASSIGNED
local orig_mat = TEAM_UNASSIGNED --  key of the original texture in the mat_replace table
local tex_to_check = { "$basetexture", "$bumpmap", "$phongexponenttexture", "$normalmap", "$no_draw"}
local mat_replace = { 
	{ [TEAM_UNASSIGNED] = { mat = Material("models/weapons/v_models/hands/v_hands") }, [TEAM_HUMAN] = { mat = Material("models/weapons/v_hand/v_hands_invisible") } },
	{ [TEAM_UNASSIGNED] = { mat = Material("models/weapons/v_hand/armtexture") }, [TEAM_HUMAN] = { mat = Material("models/weapons/v_hand/armtexture_cturban") } },
	{ [TEAM_UNASSIGNED] = { mat = Material("models/weapons/v_hand/v_hand_sheet") }, [TEAM_HUMAN] = { mat = Material("models/weapons/v_hand/v_hand_sheet_cturban") } }
}
local Replace = Material("models/weapons/v_models/hands/v_hands")
local This = Material("models/weapons/v_models/hands/Invisible")
function GM:SwitchMaterials( team_index )
	
	-- Replace:SetMaterialFloat( "$no_draw", 1 )
--[=[if (team_index ~= last_mat) then
		for k, texture in pairs( mat_replace ) do
			for i, tex_type in pairs( tex_to_check ) do
				if (not texture[orig_mat][tex_type]) then --  make sure the default textures are stored
					if (texture[orig_mat].mat:GetMaterialString( tex_type )) then
						texture[orig_mat][tex_type] = texture[orig_mat].mat:GetMaterialTexture( tex_type )
					end
				end
			end

			if (not texture[team_index]) then --  if team doesn't have a specific texture, revert to default
				for i, tex_type in pairs( tex_to_check ) do
					if (texture[orig_mat].mat:GetMaterialString( tex_type )) then
						texture[orig_mat].mat:SetMaterialTexture( tex_type, texture[orig_mat][tex_type] )
					end
				end
			else --  otherwise set team specific textures
				for i, tex_type in pairs( tex_to_check ) do
					if (texture[orig_mat].mat:GetMaterialString( tex_type )) then
						if (not texture[team_index][tex_type]) then
							texture[team_index][tex_type] = texture[team_index].mat:GetMaterialTexture( tex_type )
						end
						texture[orig_mat].mat:SetMaterialTexture( tex_type, texture[team_index][tex_type] )
					end
				end	
			end			
			
		end
		last_mat = team_index
	end
	]=]
end

function GM:RestoreMaterials()

	for k, texture in pairs( mat_replace ) do
		for i, tex_type in pairs( tex_to_check ) do
			if (texture[orig_mat].mat:GetMaterialString( tex_type ) and texture[orig_mat][tex_type]) then
				texture[orig_mat].mat:SetMaterialTexture( tex_type, texture[orig_mat][tex_type] )
			end
		end
	end
	
end

function GM:GetTeamColor(ent)
	if ent and ent:IsValid() and ent:IsPlayer() then
		local teamnum = ent:Team() or TEAM_UNASSIGNED
		return team.GetColor(teamnum) or color_white
	end
	return color_white
end

function GM:GetTeamNumColor(num)
	return team.GetColor(num) or color_white
end

function GM:OnChatTab(str)
	local LastWord
	for word in string.gmatch(str, "%a+") do
	     LastWord = word
	end
	if LastWord == nil then return str end
	playerlist = player.GetAll()
	for k, v in pairs(playerlist) do
		local nickname = v:Nick()
		if string.len(LastWord) < string.len(nickname) and string.find(string.lower(nickname), string.lower(LastWord)) == 1 then
			str = string.sub(str, 1, (string.len(LastWord) * -1)-1)
			str = str .. nickname
			return str
		end
	end
	return str
end

function GM:GetSWEPMenu()
	return {}
end

function GM:GetSENTMenu()
	return {}
end

function GM:PostProcessPermitted(str)
	return false
end

function GM:PostRenderVGUI()
end

function GM:RenderScene()
end

-- 2 second tick
local tbWarnings = { Sound ( "npc/zombie_poison/pz_alert1.wav" ), Sound ( "npc/zombie_poison/pz_call1.wav" ), Sound ( "npc/fast_zombie/fz_alert_far1.wav" ), Sound ( "ambient/creatures/town_zombie_call1.wav" ) }
local function UpdateDifficulty()
	if ENDROUND then return end
	
	-- Get difficulty
	difficulty = GetDifficulty()

	local bSound = false
	local iAmount = 0
	
	-- Infliction and threshold table
	local Infliction = GetInfliction()
	local ThresTable = { [1] = { Min = 0, Max = 0.3 }, [2] = { Min = 0.3, Max = 0.4 } ,[3] = { Min = 0.4, Max = 0.5 }, [4] = { Min = 0.5, Max = 0.75 }, [5] = { Min = 0.75, Max = 1 } }
	
	-- Check the current infliction
	for k,v in pairs (ThresTable) do
		if Infliction <= ThresTable[k].Max and Infliction > ThresTable[k].Min then
			Threshold = k - 1
		end	
	end
	
	-- Lock/unlock the class
	for i=1, #ZombieClasses do
		if ZombieClasses[i] then
			if ( ( ZombieClasses[i].Threshold <= Threshold ) or ( ZombieClasses[i].TimeLimit and ZombieClasses[i].TimeLimit < CurTime() ) ) and not ZombieClasses[i].Unlocked then
				ZombieClasses[i].Unlocked = true
				if iAmount == 0 then sWarning = ZombieClasses[i].Name else sWarning = sWarning.." and ".. ZombieClasses[i].Name end
				iAmount = iAmount + 1
				bSound = true
			end
		end
	end

	if not LASTHUMAN and bSound then
		if iAmount > 2 then
			sWarning = iAmount .." classes"
		end
		if ValidEntity( LocalPlayer() ) then
			surface.PlaySound( table.Random ( tbWarnings ) )
			MySelf:Message( sWarning.." unlocked!", 3 )
		end
	end
end
--timer.Create ( "PredictDifficulty", 2, 0, UpdateDifficulty )

local function SetDrop(um)
	local DropCount = um:ReadLong()
end
usermessage.Hook("SetDrop", SetDrop)

function Died()
	LASTDEATH = RealTime()
	surface.PlaySound( DEATHSOUND )
end

function GM:KeyPress(pl, key)
	if key == IN_USE and MySelf:Team() == TEAM_HUMAN then
		local ent = util.TraceLine({start = MySelf:EyePos(), endpos = MySelf:EyePos() + MySelf:GetAimVector() * 50, filter = MySelf}).Entity
		if ent and ent:IsValid() and ent:IsPlayer() then
			RunConsoleCommand("shove", ent:EntIndex())
		end
	end
end

function DrawLose()
	DrawLoseY = DrawLoseY or 0
	if DrawLoseY > h*0.8 then
		DrawLoseHoldTime = true
	else
		for i=1, 5 do
			draw.DrawText("Zombies win", "HUDFontBig", w*0.5, DrawLoseY - i*h*0.02, Color(255, 0, 0, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawLoseY = DrawLoseY + h * 0.495 * FrameTime()
	end
	if DrawLoseHoldTime then
		if not DrawLoseSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawLoseSound = true
		end

		draw.DrawText("Zombies win", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.DrawText("Zombies win", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.DrawText("Zombies win", "HUDFontBig", w*0.5, DrawLoseY, COLOR_WHITE, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("Zombies win", "HUDFontBig", w*0.5, DrawLoseY, COLOR_RED, TEXT_ALIGN_CENTER)
	end
end

function DrawWin()
	DrawWinY = DrawWinY or 0

	if DrawWinY > h*0.8 then
		DrawWinHoldTime = true
	else
		for i=1, 5 do
			draw.DrawText("Humans win", "HUDFontBig", w*0.5, DrawWinY - i*h*0.02, Color(0, 0, 255, 200 - i*25), TEXT_ALIGN_CENTER)
		end
		DrawWinY = DrawWinY + h * 0.495 * FrameTime() 
	end

	if DrawWinHoldTime then
		if not DrawWinSound then
			surface.PlaySound("weapons/physcannon/energy_disintegrate"..math.random(4,5)..".wav")
			surface.PlaySound("physics/metal/sawblade_stick"..math.random(1,3)..".wav")
			DrawWinSound = true
		end

		draw.DrawText("Humans win", "HUDFontBig", w*0.5 + XNameBlur2, YNameBlur + DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
		draw.DrawText("Humans win", "HUDFontBig", w*0.5 + XNameBlur, YNameBlur + DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
		draw.DrawText("Humans win", "HUDFontBig", w*0.5, DrawWinY, COLOR_WHITE, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("Humans win", "HUDFontBig", w*0.5, DrawWinY, COLOR_BLUE, TEXT_ALIGN_CENTER)
	end
end

function GM:Rewarded ( wep )
	local MySelf = LocalPlayer()
	if not MySelf:IsValid() then return end
	
	surface.PlaySound("mrgreen/new/weppickup"..math.random(1,3)..".wav")

	if wep and wep.PrintName then
		local font = "HL2MPTypeDeath"
		local letter = "0"
		local stuff = killicon.GetFont( wep:GetClass() )
		if stuff then
			font = stuff.font
			letter = stuff.letter
		end
		MySelf:Message( "Found a ".. wep.PrintName, nil, 1, 2.5 )
	else
		MySelf:Message( "Arsenal upgraded..", 2.5 )
	end
end
rW = Rewarded

--[=[---------------------------------------------------------
					Unlock achievement
---------------------------------------------------------]=]
local unlockSound = Sound("weapons/physcannon/energy_disintegrate5.wav")
local achvStack = 0
local achievTime = 0

function DrawAchievement()
	endX = w/2-200
	endY = h/2-150
	textEndX = w/2-90
	textEndY = h/2-150
	
	achievAlpha = achievAlpha or 255
	achievX = achievX or {}
	achievY = achievY or {}
	achievX[1] = achievX[1] or endX-w -- four text location
	achievY[1] = achievY[1] or endY
	achievX[2] = achievX[2] or endX+w
	achievY[2] = achievY[2] or endY
	achievX[3] = achievX[3] or endX
	achievY[3] = achievY[3] or endY-h
	achievX[4] = achievX[4] or endX
	achievY[4] = achievY[4] or endY+h
	achievX[5] = achievX[5] or endX-w -- image location
	achievY[5] = achievY[5] or endY	
	
	local rand = 0
	local rand2 = 0
	
	col = Color(255,255,255,achievAlpha)
	col2 = Color(0,0,0,achievAlpha)
	
	for k=1, 4 do
		rand = -2+math.Rand(0,4)
		rand2 = -2+math.Rand(0,4)
		col = Color(220,10,10,achievAlpha/1.5)
		if k == 4 then 
			col = Color(255,255,255,achievAlpha)
			rand = 0 
			rand2 = 0 
		end
		draw.SimpleTextOutlined("Achievement attained","HUDFontSmaller",achievX[k]+rand,achievY[k]+rand2,col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, col2)
		draw.SimpleTextOutlined(achievName,"HUDFontSmall",achievX[k]+rand,achievY[k]+20+rand2,col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, col2)
	end
	
	col = Color(255,255,255,achievAlpha)
	
	surface.SetTexture( achievImage )
	surface.SetDrawColor( col )
	surface.DrawTexturedRect( achievX[5], achievY[5],100,100 )
	
	for k=1,4 do
		achievX[k] = math.Approach(achievX[k], textEndX, w*3*FrameTime())
		achievY[k] = math.Approach(achievY[k], textEndY, h*3*FrameTime())
	end
	achievX[5] = math.Approach(achievX[5], endX, w*3*FrameTime())
	achievY[5] = math.Approach(achievY[5], endY, h*3*FrameTime())	
	
	if (achievTime < CurTime()+1) then
		achievAlpha = math.Approach(achievAlpha, 0, 255*FrameTime())
	end
	
	if (achievTime < CurTime()) then
		hook.Remove("HUDPaint","DrawAchievement")
		for k=1, 5 do
			achievX[k] = nil
			achievY[k] = nil
			achievAlpha = nil
		end
	end
end

function UnlockEffect( achv )
	achvStack = achvStack+1
	if achievTime < CurTime() then
		if MySelf.DataTable then
			MySelf.DataTable["Achievements"][achv] = true
		end
		
		local statID = util.GetAchievementID( achv )
		
		achvStack = achvStack-1
		achievName = achievementDesc[statID].Name
		achievImage = surface.GetTextureID(achievementDesc[statID].Image)
		achievTime = CurTime()+5
		
		surface.PlaySound(unlockSound)
		
		hook.Add("HUDPaint","DrawAchievement",DrawAchievement)
	else
		timer.Simple((achievTime-CurTime()+0.2)+5*(achvStack-1),function( str ) 
			UnlockEffect(achv) 
			achvStack = achvStack-1
		end) -- Achievement display delays
	end
end

-- Toxic effects

ToxicPool = 8
ToxicReset = 0
function ToxicThink()
	if ToxicReset <= CurTime() then
		-- gets decremented each time a set of particles spawn
		ToxicPool = ToxicPool+8
		ToxicReset = CurTime() + 5
	end
end
-- hook.Add('Think','ToxicThink',ToxicThink)

--Ravebreak, admin only
function RaveBreak(um)
	--Stop current sounds
	RunConsoleCommand("stopsound")

	--Delay sound to compensate lag
	timer.Simple(0.2, function()
		surface.PlaySound(RAVESOUND)
	end)
	
	--Start actual raving with a second delay
	timer.Simple(1,function()
		hook.Add("RenderScreenspaceEffects", "RaveDraw",RaveDraw)
	end)
end
usermessage.Hook("RaveBreak",RaveBreak)

local lightCnt = 1
local lastRaveUpdate = 0

--Rave render
function RaveDraw()
	local ang = MySelf:EyeAngles()
	ang.p = 30*math.sin((CurTime()%2*math.pi)*5)
	MySelf:SetEyeAngles( ang )
			
	if lastRaveUpdate < CurTime()-0.5 then
		lastRaveUpdate = CurTime()
		local last = lightCnt
		while (last == lightCnt) do
			lightCnt = math.random(1,#RaveColTab)
		end
	end

	DrawColorModify(RaveColTab[lightCnt])
end

--Rave end
function RaveEnd(um)
	hook.Remove("RenderScreenspaceEffects", "RaveDraw")
end
usermessage.Hook("RaveEnd",RaveEnd)

--Rave colours
RaveColTab = {
	{
		[ "$pp_colour_addr" ] 		= 0.05,
		[ "$pp_colour_addg" ] 		= 0,
		[ "$pp_colour_addb" ] 		= 0.05,
		[ "$pp_colour_brightness" ] = 0.1,
		[ "$pp_colour_contrast" ] 	= 1,
		[ "$pp_colour_colour" ] 	= 0,
		[ "$pp_colour_mulr" ] 		= 10,
		[ "$pp_colour_mulg" ] 		= 0,
		[ "$pp_colour_mulb" ] 		= 10
	},
	{
		[ "$pp_colour_addr" ] 		= 0,
		[ "$pp_colour_addg" ] 		= 0,
		[ "$pp_colour_addb" ] 		= 0.05,
		[ "$pp_colour_brightness" ] = 0.1,
		[ "$pp_colour_contrast" ] 	= 1,
		[ "$pp_colour_colour" ] 	= 0,
		[ "$pp_colour_mulr" ] 		= 0,
		[ "$pp_colour_mulg" ] 		= 0,
		[ "$pp_colour_mulb" ] 		= 20
	},
	{
		[ "$pp_colour_addr" ] 		= 0,
		[ "$pp_colour_addg" ] 		= 0.05,
		[ "$pp_colour_addb" ] 		= 0,
		[ "$pp_colour_brightness" ] = 0.1,
		[ "$pp_colour_contrast" ] 	= 1,
		[ "$pp_colour_colour" ] 	= 0,
		[ "$pp_colour_mulr" ] 		= 0,
		[ "$pp_colour_mulg" ] 		= 20,
		[ "$pp_colour_mulb" ] 		= 0
	},
	{
		[ "$pp_colour_addr" ] 		= 0.05,
		[ "$pp_colour_addg" ] 		= 0,
		[ "$pp_colour_addb" ] 		= 0,
		[ "$pp_colour_brightness" ] = 0.1,
		[ "$pp_colour_contrast" ] 	= 1,
		[ "$pp_colour_colour" ] 	= 0,
		[ "$pp_colour_mulr" ] 		= 20,
		[ "$pp_colour_mulg" ] 		= 0,
		[ "$pp_colour_mulb" ] 		= 0
	},
	{
		[ "$pp_colour_addr" ] 		= 0.05,
		[ "$pp_colour_addg" ] 		= 0.05,
		[ "$pp_colour_addb" ] 		= 0,
		[ "$pp_colour_brightness" ] = 0.1,
		[ "$pp_colour_contrast" ] 	= 1,
		[ "$pp_colour_colour" ] 	= 0,
		[ "$pp_colour_mulr" ] 		= 10,
		[ "$pp_colour_mulg" ] 		= 10,
		[ "$pp_colour_mulb" ] 		= 0
	}
}

-- Blood shit
net.Receive("BloodSplatter", function(len)
	local severity = net.ReadDouble()-- um:ReadShort()
	AddBloodSplat(severity)
	if ((net.ReadBit() or 0) == 1 and severity > 1) then
		AddBloodSplat(severity-1)
	end
end)

-- Receive spray locations
Sprays = {}
function ReceiveSprays(um)
	local amount = um:ReadShort()
	Sprays = {}
	for k = 1, amount do
		local index = um:ReadShort()
		local nm = um:ReadString()
		local vec = um:ReadVector()
		Sprays[index] = { name = nm, pos = vec }
	end
end
usermessage.Hook("SendSprays",ReceiveSprays)

function PlaySoundClient(sound)
	local sound = sound:ReadString()
	if LocalPlayer() and LocalPlayer():IsValid() then
		LocalPlayer():EmitSound(sound,130,100)
	end
end
usermessage.Hook("PlaySoundClient", PlaySoundClient) 

function PlayClientsideSound(um)
	local sound = um:ReadString()
	surface.PlaySound(sound)
end
usermessage.Hook("PlayClientsideSound", PlayClientsideSound) 


--[=[---------------------------------------------------
 			Deluvas - Global Painting Effect!  		
-----------------------------------------------------]=]

-- I'd rather eat my balls than rewrite this code down here
local Notes = {}
local NoteCount = 0
local NoteDecrementTime = 0

function cl_DrawNote(k,v,i)
	v.vely = v.vely + FrameTime()*150 --  Make it go up
	v.a = math.Approach(v.a,0, FrameTime()*100*1.2) --  Make the text fade!
	
	draw.DrawText( v.msg, "ArialBoldFifteen", v.x, v.y-v.vely, Color(v.col.r,v.col.g,v.col.b,v.a), TEXT_ALIGN_CENTER) 
end

function GM:AddNote (msg,len,col)
	NoteCount = NoteCount + 1 --  Increment when you add to the table.
	
	local note = {}
	note.msg 	= msg  --  Message
	note.rec 	= CurTime()  --  Time Added
	note.len 	= len  --  Lenght
	note.velx	= 0
	note.vely	= 0
	note.x		= ScrW() * 0.5  --  Pos x
	note.y 		= ScrH() * 0.35 + (NoteCount * 25)  --  Pos Y - Don't touch this unless you have a very good reason :<
	note.a		= 255 --  alpha
	note.col	= Color (col[4],col[3],col[2],col[1])
	table.insert( Notes, note ) --  Insert the table into the ...table
end

function DrawNotes ()
	if not Notes then return end
	if ENDROUND then return end
	if not LocalPlayer():Alive() then return end

	for k, v in pairs( Notes ) do
		if v ~= 0 then --  If the note table from the Notes table isn't = to 0 then draw the shit.
			cl_DrawNote(k,v,i)
		end
	end

	for k, v in pairs( Notes ) do
		if (v ~= 0 and v.rec + v.len < CurTime() and NoteCount > 0  )then --  If time's up, then substract it. If there are 0 items in the table, then reset it.
			NoteCount = NoteCount - 1
			-- Notes[k] = 0 -- MUST FIX THIS!
			if NoteCount == 0 then 
				Notes = { }
			end
			
		end
	end
end
hook.Add("HUDPaint", "DrawNotes", DrawNotes)

function PaintText(um)
	local col = { }

	msg = um:ReadString()
	len = um:ReadShort()
	for i = 1, 4 do
		col[i] = um:ReadShort()
	end
	
	GAMEMODE:AddNote(msg,len,col)
end
usermessage.Hook("PaintText", PaintText)

---------------------------------------------------------

function MeleeWeaponDrawHUD()
	local cW, cH = ScrW() * 0.5, ScrH() * 0.5
	local wLength, hLength =  ScaleW(16),ScaleW(6)
	
	surface.SetDrawColor( Color ( 188,183,153,30 ) )
	surface.DrawLine(cW - wLength, cH - 2, cW + wLength, cH - 2)
	
	surface.SetDrawColor( Color ( 188,183,153,160 ) )
	surface.DrawLine(cW - wLength, cH - 1, cW + wLength, cH - 1)
	
	surface.SetDrawColor( Color ( 188,183,153,160 ) )
	surface.DrawLine(cW - wLength, cH - 0, cW + wLength, cH - 0)
	
	surface.SetDrawColor( Color ( 188,183,153,30 ) )
	surface.DrawLine(cW - wLength, cH + 1, cW + wLength, cH + 1)

	
	surface.SetDrawColor( Color ( 188,183,153,50 ) )
	surface.DrawLine(cW - 1, cH - hLength, cW - 1, cH + hLength)
	
	surface.SetDrawColor( Color ( 188,183,153,130 ) )
	surface.DrawLine(cW - 0, cH - hLength, cW - 0, cH + hLength)
	
	surface.SetDrawColor( Color ( 188,183,153,50 ) )
	surface.DrawLine(cW + 1, cH - hLength, cW + 1, cH + hLength)
end

--[=[------------------------------------------------------
          Manages the ammo regeneration time
-------------------------------------------------------]=]
local AmmoRegenTimer, RegenSound = 0, Sound ( "buttons/weapon_confirm.wav" )
local function AmmoRegenThink()
	if not ValidEntity ( MySelf ) then return end
	if MySelf:Team() ~= TEAM_HUMAN then return end
	
	-- Prevent it on endround
	if ENDROUND then return end
	
	-- Grab data
	local Time = MySelf:GetAmmoTime()
	if Time == nil then return end
	
	-- Time to give ammo and when it reaches 0, reset the timer
	if Time <= -1 then 
		RunConsoleCommand ( "zs_regenammo" ) 
		
		-- This isn't fire time we regen anymore
		MySelf.IsFirstRegeneration = false 
		
		-- Reset timer
		MySelf:SetAmmoTime ( AMMO_REGENERATE_RATE )
		
		-- Play regeneration sound
		surface.PlaySound ( RegenSound ) 
		
		-- Notify
		MySelf:Message( "Ammunition Regenerated !" )

		return
	end
		
	-- Substract one time unit each second
	if AmmoRegenTimer <= CurTime() then MySelf:SetAmmoTime ( Time - 1 )	AmmoRegenTimer = CurTime() + 1 end
end
-- hook.Add ( "Think", "ManageAmmoRegen", AmmoRegenThink )

--[=[------------------------------------------------
     Refresh Toxic Fumes Effect ( 7 sec )
------------------------------------------------]=]
function RefreshToxicFumes()
	if ToxicPoints == nil then return end
	if ENDROUND then return end

	-- Spawn the effects clientside
	for k, v in pairs( ToxicPoints ) do
		local eData = EffectData()
			eData:SetOrigin( v + Vector ( 0,0,15 ) )
		util.Effect( "chemzombieambient", eData, true, true )
	end
	
	-- Refresh them
	timer.Simple( 7, RefreshToxicFumes )
end

-- Textures we need to draw the crosshair 
local matCore, matOuter = surface.GetTextureID ( "zombiesurvival/crosshair/undead_crosshair_core" ), surface.GetTextureID ( "zombiesurvival/crosshair/undead_crosshair_outer" )

function GM:DrawZombieCrosshair ( m_Owner, iDistance )
	if not IsEntityValid ( MySelf ) then return end
	if ENDROUND or IsClassesMenuOpen() then return end
	
	-- SQL ready
	if not MySelf.ReadySQL then return end
	if util.tobool(GetConVarNumber("_zs_hidecrosshair")) then return end
		
	-- Vars
	local bDrawOutline, colOuter = false, Color ( 255,255,255,240 )
		
	-- Headcrab have different view position
	local vStart = m_Owner:GetShootPos()
	if m_Owner:IsHeadcrab() or m_Owner:IsPoisonCrab() then vStart = m_Owner:GetPos() + Vector ( 0,0,32 ) end
	
	-- Trace the line	
	local trLine = util.TraceLine ( { start = vStart, endpos = vStart + ( m_Owner:GetAimVector() * 10000 ), filter = m_Owner } )
		
	-- Draw outer crosshair if hits entity
	local m_Ent = trLine.Entity
	if IsEntityValid ( m_Ent ) then 
		if m_Ent:IsPlayer() and m_Ent:IsHuman() then
			local fDistance = m_Owner:GetPos():Distance ( m_Ent:GetPos() )
			bDrawOutline = true
			if fDistance <= iDistance then colOuter = Color ( 10, 240, 10, 160 ) else colOuter = Color ( 240, 10, 10, 160 ) end
		end
	end
		
	-- Draw the inner crosshair
	surface.SetDrawColor ( 190,190,190,170 )
	surface.SetTexture ( matCore )
	surface.DrawTexturedRectRotated ( w * 0.5, h * 0.5, ScaleW(64), ScaleW(64), 0 )
		
	-- Draw outer crosshair
	if bDrawOutline then
		surface.SetDrawColor ( colOuter )
		surface.SetTexture ( matOuter )
		surface.DrawTexturedRectRotated ( w * 0.5, h * 0.5, ScaleW(64), ScaleW(64), 0 )
	end
end

GM.MapExploits = {}
-- receive map exploit locations
function RecMapExploits(um)
	local tab = {}
	
	tab = {}
	tab.origin = um:ReadVector()
		
	tab.bsize = um:ReadShort()
	tab.type = um:ReadString()
	table.insert(MapExploits, tab)
end
usermessage.Hook("mapexploits",RecMapExploits)