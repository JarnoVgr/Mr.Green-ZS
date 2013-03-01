-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")

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


-- Replace beats with cuts of hl2_song2.mp3 here:
local Beats = {}
Beats[0] = {}
Beats[1] = {"zombiesurvival/hbeat1.wav"}
Beats[2] = {"zombiesurvival/hbeat1.wav"}
Beats[3] = {"zombiesurvival/hbeat2.wav"}
Beats[4] = {"zombiesurvival/hbeat3.wav"}
Beats[5] = {"zombiesurvival/hbeat4.wav"}
Beats[6] = {"zombiesurvival/hbeat5.wav"}
Beats[7] = {"zombiesurvival/hbeat6.wav"}
Beats[8] = {"zombiesurvival/hbeat7.wav"}
Beats[9] = {"zombiesurvival/hbeat8.wav"}
Beats[10] = {"zombiesurvival/hbeat9.wav"}

for i=1,10 do
	util.PrecacheSound(Beats[i][1])
end

local OldBeats = {}
OldBeats[0] = {}
OldBeats[1] = {"beat1.wav"}
OldBeats[2] = {"beat1.wav", "beat2.wav"}
OldBeats[3] = {"beat2.wav", "beat3.wav"}
OldBeats[4] = {"beat2.wav", "beat3.wav", "beat5.wav"}
OldBeats[5] = {"beat1.wav", "beat2.wav", "beat8.wav"}
OldBeats[6] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat7.wav", "beat8.wav"}
OldBeats[7] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav"}
OldBeats[8] = {"beat2.wav", "beat3.wav", "beat5.wav", "beat6.wav", "beat7.wav"}
OldBeats[9] = {"beat3.wav", "beat5.wav", "beat8.wav", "beat9.wav", "beat7.wav"}
OldBeats[10] = {"ecky.wav"}

local NewZBeats = {}




local ZBeats = {}
ZBeats[0] = {}
ZBeats[1] = {"zombiesurvival/_zbeat1.wav"}
ZBeats[2] = {"zombiesurvival/_zbeat2.wav"}
ZBeats[3] = {"zombiesurvival/_zbeat3.wav"}
ZBeats[4] = {"zombiesurvival/_zbeat4.wav"}
ZBeats[5] = {"zombiesurvival/_zbeat5.wav"}
ZBeats[6] = {"zombiesurvival/_zbeat6.wav"}
ZBeats[7] = {"zombiesurvival/_zbeat6_5.wav"}
ZBeats[8] = {"zombiesurvival/_zbeat7.wav"}
ZBeats[9] = {"zombiesurvival/_zbeat7_5.wav"}
ZBeats[10] = {"zombiesurvival/_zbeat8.wav"}

for i=1,10 do
	util.PrecacheSound(ZBeats[i][1])
end

local ZBeatLength = {}
ZBeatLength[0] = 1
ZBeatLength[1] = 2.4
ZBeatLength[2] = 3.3
ZBeatLength[3] = 4.5
ZBeatLength[4] = 9.9
ZBeatLength[5] = 9.95
ZBeatLength[6] = 7.4
ZBeatLength[7] = 5.1
ZBeatLength[8] = 10.3
ZBeatLength[9] = 10.3
ZBeatLength[10] = 10.2

util.PrecacheSound("beat1.wav")
util.PrecacheSound("beat2.wav")
util.PrecacheSound("beat3.wav")
util.PrecacheSound("beat4.wav")
util.PrecacheSound("beat5.wav")
util.PrecacheSound("beat6.wav")
util.PrecacheSound("beat7.wav")
util.PrecacheSound("beat8.wav")
util.PrecacheSound("beat9.wav")
util.PrecacheSound("zbeat1.wav")
util.PrecacheSound("zbeat2.wav")
util.PrecacheSound("zbeat3.wav")
util.PrecacheSound("zbeat4.wav")
util.PrecacheSound("zbeat5.wav")
util.PrecacheSound("zbeat6.wav")
util.PrecacheSound("zbeat7.wav")
util.PrecacheSound("zbeat8.wav")
util.PrecacheSound("ecky.wav")

local BeatLength = {}
BeatLength[0] = 1.0
BeatLength[1] = 1.7
BeatLength[2] = 1.7
BeatLength[3] = 1.7
BeatLength[4] = 1.7
BeatLength[5] = 1.7
BeatLength[6] = 1.7
BeatLength[7] = 1.65
BeatLength[8] = 1.7
BeatLength[9] = 1.7
BeatLength[10] = 21.8

local BeatText = {}
BeatText[0] = "Perfectly Safe"
BeatText[1] = "Safe-ish"
BeatText[2] = "Unsafe"
BeatText[3] = "Impending Danger"
BeatText[4] = "Dangerous"
BeatText[5] = "Very Dangerous"
BeatText[6] = "Blood Bath"
BeatText[7] = "Horror Show"
BeatText[8] = "Zombie Survival"
BeatText[9] = "Zombie Cluster-Fuck"
BeatText[10] = "OH SHI-"

local BeatColors = {}
BeatColors[0]  = Color(  0,   0, 240, 255)
BeatColors[1]  = Color( 10,  10, 225, 255)
BeatColors[2]  = Color( 50,  85, 190, 255)
BeatColors[3]  = Color(145, 145,  40, 255)
BeatColors[4]  = Color(150, 190,  10, 255)
BeatColors[5]  = Color(210, 210,   5, 255)
BeatColors[6]  = Color(190, 160,   0, 255)
BeatColors[7]  = Color(220,  90,   0, 255)
BeatColors[8]  = Color(220,  40,   0, 255)
BeatColors[9]  = Color(230,  15,   0, 255)
BeatColors[10] = Color(245,   0,   0, 255)

local ZombieHordeText = {}
ZombieHordeText[0] = "Nobody Around"
ZombieHordeText[1] = "So Ronery"
ZombieHordeText[2] = "Undead Duo"
ZombieHordeText[3] = "Undead Trio"
ZombieHordeText[4] = "Zombie Assault"
ZombieHordeText[5] = "Flesh Pile"
ZombieHordeText[6] = "Zombie Party"
ZombieHordeText[7] = "Lawn Mower"
ZombieHordeText[8] = "Steam Roller"
ZombieHordeText[9] = "Zombie Horde"
ZombieHordeText[10] = "DEAD MEAT"

local ZombieHordeColors = {}
ZombieHordeColors[0]  = Color(  0,   0, 240, 210)
ZombieHordeColors[1]  = Color(  0,  10, 225, 210)
ZombieHordeColors[2]  = Color(  0,  30, 220, 210)
ZombieHordeColors[3]  = Color(  0,  65, 180, 210)
ZombieHordeColors[4]  = Color(  0,  95, 155, 210)
ZombieHordeColors[5]  = Color(  0, 108, 108, 210)
ZombieHordeColors[6]  = Color(  0, 130,  85, 210)
ZombieHordeColors[7]  = Color(  0, 170,  65, 210)
ZombieHordeColors[8]  = Color(  0, 210,  40, 210)
ZombieHordeColors[9]  = Color(  5, 240,   0, 210)
ZombieHordeColors[10] = Color( 25, 240,  20, 210)

local WATER_DROWNTIME = 30
local CRAMP_METER_TIME = 0

function GM:ResetWaterAndCramps()
	WATER_DROWNTIME = 30
	CRAMP_METER_TIME = 0
end

local NextAmmoDropOff = AMMO_REGENERATE_RATE

function GM:InitPostEntity()
	NextAmmoDropOff = math.ceil(CurTime() / AMMO_REGENERATE_RATE) * AMMO_REGENERATE_RATE
end

local NextHordeCalculate = 0
local DisplayHorde = 0
local ActualHorde = 0
local NextThump = 0

function GM:SetLastHumanText()
	if LASTHUMAN then
		BeatText[10] = "LAST HUMAN!"
		ZombieHordeText[10] = "LAST HUMAN!"
		NextHordeCalculate = 999999
		NearZombies = 10
		DisplayHorde = 10
		ActualHorde = 10
	end
end


/*--------------------------------------------------------
       Called on GM:SetUnlife ( bool ) -- Loops, too
---------------------------------------------------------*/
function PlayUnlife()
	if ENDROUND or not util.tobool(GetConVar( "_zs_enablemusic" )) then return end
	
	//Play the sound right now
	local Duration = UNLIFESOUNDLENGTH //SoundDuration ( "../sound/"..UNLIFESOUND )
	surface.PlaySound ( UNLIFESOUND )
	
	//Create a timer so it plays after it has finished
	timer.Create ( "LoopUnlife", Duration, 0, function() 
		if UNLIFE and util.tobool(GetConVar( "_zs_enablemusic" )) and not ENDROUND and not LASTHUMAN and not DEADLIFE then 
			surface.PlaySound ( UNLIFESOUND )  
		end
	end)  
end

function PlayDeadlife()
	if LASTHUMAN or ENDROUND or not util.tobool(GetConVar( "_zs_enablemusic" )) then return end
	//if TranslateMapTable[ game.GetMap() ] and TranslateMapTable[ game.GetMap() ].DisableMusic then return end
	
	//Stop sounds
	RunConsoleCommand( "stopsound" )
	
	//Play sound right now
	local Duration = 277
	
	local song = "deadlife_mrgreen.mp3"
	
	if BOSSACTIVE or GAMEMODE:IsBossAlive() then
		Duration = 215
		song = "deadlife_mrgreen_insane.mp3"
	end
	
	timer.Simple( 0.3, function() surface.PlaySound( song ) end )
	
	//Create timer
	timer.Create ( "LoopDeadlife", Duration, 0, function() 
		if LASTHUMAN or ENDROUND then return end
		surface.PlaySound ( song )  
	end )
end

util.PrecacheSound("deadlife_mrgreen.mp3")
util.PrecacheSound("deadlife_mrgreen_insane.mp3")

function GM:SetUnlifeText() -- Unused
	if UNLIFE then
		-- In originele ZS 2.0 code is het level 10 (bij BeatText en ZombieHordeText). Maar lijkt me logischer als het bij het minimale getal is.
		BeatText[8] = "Un-Life"
		ZombieHordeText[8] = "Un-Life"
		NearZombies = 7.5
	end
end

function GM:SetHalflifeText() -- Unused
	if HALFLIFE then
		BeatText[5] = "Half-Life"
		ZombieHordeText[5] = "Half-Life"
		NearZombies = 5
	end
end

//CreateClientConVar("_zs_enablebeats", 1, true, false)
local ENABLE_BEATS = util.tobool(GetConVarNumber("_zs_enablebeats"))
local function EnableBeats(sender, command, arguments)
	ENABLE_BEATS = util.tobool(arguments[1])

	if ENABLE_BEATS then
		RunConsoleCommand("_zs_enablebeats", "1")
		MySelf:ChatPrint("Beats enabled.")
	else
		RunConsoleCommand("_zs_enablebeats", "0")
		MySelf:ChatPrint("Beats disabled.")
	end
end
concommand.Add("zs_enablebeats", EnableBeats)

CreateClientConVar("_zs_enableoldbeats", 0, true, false)
local ENABLE_OLDBEATS = util.tobool(GetConVarNumber("_zs_enableoldbeats"))
local function EnableOldBeats(sender, command, arguments)
	ENABLE_OLDBEATS = util.tobool(arguments[1])

	if ENABLE_OLDBEATS then
		RunConsoleCommand("_zs_enableoldbeats", "1")
		MySelf:ChatPrint("Old beats enabled.")
	else
		RunConsoleCommand("_zs_enableoldbeats", "0")
		MySelf:ChatPrint("Old beats disabled.")
	end
end
concommand.Add("zs_enableoldbeats", EnableOldBeats)

CreateClientConVar("_zs_enableoldbeats1", 0, true, false)
local ENABLE_OLDBEATS1 = util.tobool(GetConVarNumber("_zs_enableoldbeats1"))
local function EnableOldBeats1(sender, command, arguments)
	ENABLE_OLDBEATS1 = util.tobool(arguments[1])

	if ENABLE_OLDBEATS1 then
		RunConsoleCommand("_zs_enableoldbeats1", "1")
		MySelf:ChatPrint("Old zombie beats enabled.")
	else
		RunConsoleCommand("_zs_enableoldbeats1", "0")
		MySelf:ChatPrint("Old zombie beats disabled.")
	end
end
concommand.Add("zs_enableoldbeats1", EnableOldBeats1)

//CreateClientConVar("_zs_customweaponpos", 1, true, false)
local ENABLE_WEPPOS = util.tobool(GetConVarNumber("_zs_customweaponpos"))
local function EnableCustomPos(sender, command, arguments)
	ENABLE_WEPPOS = util.tobool(arguments[1])

	if ENABLE_WEPPOS then
		RunConsoleCommand("_zs_customweaponpos", "1")
		MySelf:ChatPrint("Custom weapon positions enabled.")
	else
		RunConsoleCommand("_zs_customweaponpos", "0")
		MySelf:ChatPrint("Custom weapon positions disabled.")
	end
end
concommand.Add("zs_customweaponpos", EnableCustomPos)

//CreateClientConVar("_zs_enablehptext", 1, true, false)
local ENABLE_HPTEXT = util.tobool(GetConVarNumber("_zs_enablehptext"))
local function EnableHPText(sender, command, arguments)
	ENABLE_HPTEXT = util.tobool(arguments[1])

	if ENABLE_HPTEXT then
		RunConsoleCommand("_zs_enablehptext", "1")
		MySelf:ChatPrint("Health bar text enabled.")
	else
		RunConsoleCommand("_zs_enablehptext", "0")
		MySelf:ChatPrint("Health bar text disabled.")
	end
end
concommand.Add("zs_enablehptext", EnableHPText)

//CreateClientConVar("_zs_enablelighthud", 0, true, false)
local LIGHTHUD = util.tobool(GetConVarNumber("_zs_enablelighthud"))
local function LightHud(sender, command, arguments)
	LIGHTHUD = util.tobool(arguments[1])

	if LIGHTHUD then
		RunConsoleCommand("_zs_enablelighthud", "1")
		MySelf:ChatPrint("Light HUD enabled.")
	else
		RunConsoleCommand("_zs_enablelighthud", "0")
		MySelf:ChatPrint("Light HUD disabled.")
	end
end
concommand.Add("zs_enablelighthud", LightHud)

//CreateClientConVar("_zs_enablemusic", 1, true, false)
ENABLE_MUSIC = util.tobool(GetConVarNumber("_zs_enablemusic"))
local function EnableMusic(sender, command, arguments)
	ENABLE_MUSIC = util.tobool(arguments[1])

	if ENABLE_MUSIC then
		RunConsoleCommand("_zs_enablemusic", "1")
		MySelf:ChatPrint("Music enabled.")
	else
		RunConsoleCommand("_zs_enablemusic", "0")
		MySelf:ChatPrint("Music disabled.")
	end
end
concommand.Add("zs_enablemusic", EnableMusic)

//Small turret's names from IW
local randnames = { "Joseph", "Finger", "Beer", "Blob", "Chicken" }
CreateClientConVar("_zs_turretnicknamefix", table.Random(randnames), true, true)
TurretNickname = GetConVarString("_zs_turretnicknamefix")
function SetTurretNick( pl,commandName,args )
	if not args[1] then return end
	if not ValidTurretNick(pl,tostring(args[1])) then return end
	TurretNickname = args[1]

	RunConsoleCommand("_zs_turretnicknamefix",tostring(args[1]))
	RunConsoleCommand("turret_nickname",tostring(args[1]))
end
concommand.Add("zs_turretnickname",SetTurretNick) 

//CreateClientConVar("_zs_showhorde", 1, true, false)
SHOWHORDE = util.tobool( GetConVarNumber("_zs_showhorde") )
local function EnableHordeHUD(sender, command, arguments)
	SHOWHORDE = util.tobool( arguments[1] )

	if SHOWHORDE then
		RunConsoleCommand("_zs_showhorde", "1")
		MySelf:ChatPrint("Enabled HUD for horde status.")
	else
		RunConsoleCommand("_zs_showhorde", "0")
		MySelf:ChatPrint("Disabled HUD for horde status.")
	end
end
concommand.Add("zs_showhorde", EnableHordeHUD)

//CreateClientConVar("_zs_hcolormod", 1, true, false)
HCOLORMOD = util.tobool( GetConVarNumber("_zs_hcolormod") )
local function EnableHColorMod(sender, command, arguments)
	HCOLORMOD = util.tobool( arguments[1] )

	if HCOLORMOD then
		RunConsoleCommand("_zs_hcolormod", "1")
		MySelf:ChatPrint("Enabled darker color mod.")
	else
		RunConsoleCommand("_zs_hcolormod", "0")
		MySelf:ChatPrint("Disabled darker color mod.")
	end
end
concommand.Add("zs_hcolormod", EnableHColorMod)

CreateClientConVar("_zs_wepfov", 75, true, true)

--[[CreateClientConVar("_zs_enablescreenblood", 1, true, false)
local ENABLE_BLOOD = util.tobool(GetConVarNumber("_zs_enablescreenblood"))
local function EnableBlood(sender, command, arguments)
	ENABLE_BLOOD = util.tobool(arguments[1])

	if ENABLE_BLOOD then
		RunConsoleCommand("_zs_enablescreenblood", "1")
		MySelf:ChatPrint("On screen blood enabled.")
	else
		RunConsoleCommand("_zs_enablescreenblood", "0")
		MySelf:ChatPrint("On screen blood disabled.")
	end
end
concommand.Add("zs_enablescreenblood", EnableBlood)]]

local NextBeat = 0
local LastBeatLevel = 0
function GM:PlayBeats(teamid, am)
	
	local ENABLE_BEATS = util.tobool(GetConVarNumber("_zs_enablebeats"))

	if RealTime() <= NextBeat or not ENABLE_BEATS then return end

	if ENDROUND or LASTHUMAN or DEADLIFE then return end

	if am <= 0 then return end

	local beats = teamid == TEAM_HUMAN and Beats or ZBeats
	if not beats then return end

	LastBeatLevel = math.Approach(LastBeatLevel, math.ceil(am), 1)

	local snd = beats[LastBeatLevel][1]
	if snd then
		MySelf:EmitSound(snd, 0, 100, 0.8)
		NextBeat = RealTime() + SoundDuration(snd) - 0.025
	end
end


//Good old beats :D
function GM:_Think()
	MySelf = LocalPlayer()
	if not MySelf:IsValid() then return end

	
	local myteam = MySelf:Team()
	
	local am = myteam == TEAM_UNDEAD and MySelf:GetHordeCount(true) or math.Round(math.min(GetZombieFocus3(MySelf:GetPos(), 260, 0.001, 0) * 10, 10))
	
	self:PlayBeats(myteam, am)
	
	
	for _, pl in ipairs(player.GetAll()) do
		local cl = pl:GetZombieClass()
		if pl:Team() == TEAM_UNDEAD and UndeadBuildBonePositions[cl] then
			pl.WasBuildingBonePositions = true
			pl:ResetBones()
			UndeadBuildBonePositions[cl](pl)
		elseif pl.WasBuildingBonePositions then
			pl.WasBuildingBonePositions = nil
			pl:ResetBones()
		end
	end
	
end
//2 functions from old zs for better calculating
function GetZombieFocus2(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, pl in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
		if pl ~= MySelf and pl:Team() == TEAM_UNDEAD and pl:Alive() then
			local dist = pl:GetPos():Distance(mypos)
			if dist < range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	return math.min(zombies, 1)
end

function GetZombieFocus3(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, pl in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		if pl:Team() == TEAM_UNDEAD and pl:Alive() then
			local dist = pl:GetPos():Distance(mypos)
			if dist <= range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	if UNLIFE then
		return math.max(0.75, math.min(zombies, 1))
	elseif HALFLIFE then
		return math.max(0.5, math.min(zombies, 1))
	else
		return math.min(zombies, 1)
	end
end

function DrawInvasionNotice()
	if not IsEntityValid ( MySelf ) or ENDROUND then return end
	if not MySelf:Alive() then return end
	if not MySelf.ReadySQL then return end
	if IsClassesMenuOpen() then return end
	if CurTime() > FIRST_ZOMBIE_SPAWN_DELAY then return end
	if team.NumPlayers(TEAM_UNDEAD) > 0 then return end
	
	draw.SimpleTextOutlined("Time until zombie invasion: "..ToMinutesSeconds(math.Clamp ( math.Round(FIRST_ZOMBIE_SPAWN_DELAY - CurTime()), 0, 500 )), "ArialBoldTwelve", w/2, h/3.8, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))

end
--hook.Add( "HUDPaint", "DrawInvasionNotice", DrawInvasionNotice )


local matUIBottomLeft = surface.GetTextureID("mrgreen/zs_mrgreenhud")
local function DrawUI()
	surface.SetDrawColor(255, 255, 255, 240)
	surface.SetTexture(matUIBottomLeft)
	surface.DrawTexturedRect(0, h - 72, 256, 72)
end

local matBulletUI = surface.GetTextureID("mrgreen/zs_bullethud")
local matBulletTexture = surface.GetTextureID("mrgreen/zs_bullet")

--local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")
local matUIBottomLeft = surface.GetTextureID("hud3/healthbar_bg_1")
local ScratchHudTop = surface.GetTextureID("hud3/scratch_hud_top") 
local HealthBar = surface.GetTextureID("hud3/healthbar_white") 
local ScalableHealth = surface.GetTextureID("hud3/scalepanel")
local HudScratchTop = surface.GetTextureID("hud3/detail_scratches_top_1")	
local HudScratchBottom = surface.GetTextureID("hud3/detail_scratches_bottom_1")	
local HudTop = surface.GetTextureID("hud3/hud_l4d_up")
local HudSplash = surface.GetTextureID("hud3/hud_splash")
local PanelSelect = surface.GetTextureID("hud3/panel_select")
local PanelShotgun = surface.GetTextureID("hud3/panel_shotgun")
local PanelPistol = surface.GetTextureID("hud3/panel_pistol")
local PanelSmall = surface.GetTextureID("hud3/panel_small")
local PanelSmg = surface.GetTextureID("hud3/panel_smg")
local Crouching = surface.GetTextureID("hud3/crouch")
local PanelGreencoins = surface.GetTextureID("hud3/panel_greencoins")
local PanelAmmo = surface.GetTextureID("hud3/panel_ammo")
local HudTimer = surface.GetTextureID("hud3/hud_timer")
local HudFlashlight = surface.GetTextureID("hud3/hud_flashlight")
local HudDistance = surface.GetTextureID("hud3/hud_distance")

local regenSound = Sound("buttons/weapon_confirm.wav")
function GM:HumanHUD(MySelf)
	if MySelf:Team() == TEAM_SPECTATOR then return end
	
	

	-- Health
	local entityhealth = math.max( MySelf:Health(), 0 )
	local maxhealth
	
	//if HumanClasses[MySelf:GetHumanClass()].Health then
	//	maxhealth = HumanClasses[MySelf:GetHumanClass()].Health or 100
	//else
		maxhealth = 100
	//end		
	
	if MySelf:GetHumanClass() == 2 and HumanClasses[MySelf:GetHumanClass()].Health then
		maxhealth = HumanClasses[MySelf:GetHumanClass()].Health+(HumanClasses[MySelf:GetHumanClass()].Health* ( HumanClasses[2].Coef[2]* ( MySelf.DataTable["ClassData"]["commando"].level+1 ) ) / 100 ) or 100
	end
	if not actualhpbar then
		actualhpbar = 1
	end
	
	maxhealth = MySelf:GetMaximumHealth()
	actualhpbar = math.Clamp ( math.Approach ( actualhpbar, entityhealth / maxhealth, FrameTime() * 1.8 ), 0, 1 )	
	local percenthealth = entityhealth / maxhealth

	
	local colortouse, colHealthBar
	
	if 0.8 < percenthealth then
		colortouse = Color(28,151,24,255)  
	elseif 0.5 < percenthealth then
		colortouse = COLOR_HUD_SCRATCHED
	elseif 0.3 < percenthealth then
		colortouse = COLOR_HUD_HURT
	else
		colortouse = COLOR_HUD_CRITICAL
	end
	
	//Infected
	if MySelf:IsTakingDOT() then
		if percenthealth > 0.3 then 
			colortouse = COLOR_HUD_HURT 
		end
	end
	
	colHealthBar = colortouse
	if MySelf:IsTakingDOT() or percenthealth < 0.3 then
		colHealthBar = Color( colHealthBar.r, colHealthBar.g, colHealthBar.b, math.abs( math.sin( RealTime() * 4 ) ) * 255 )
	end	
	
	local mag_left = -1
	local mag_extra = 0
	local weapon
	
	if (MySelf:IsValid() and MySelf:Alive() and MySelf:GetActiveWeapon().Clip1) then
		weapon = MySelf:GetActiveWeapon()
		mag_left = MySelf:GetActiveWeapon():Clip1() 
    	mag_extra = MySelf:GetAmmoCount(MySelf:GetActiveWeapon():GetPrimaryAmmoType())
	end
	
	local rounded = math.Round(NearZombies)
	if not DRAW_BETA_HUD then
	if w/h > 1.24 and w/h < 1.35 and MySelf:Alive() then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(matUIBottomLeft)
		surface.DrawTexturedRect(0, h*0.84,ScaleW(512), ScaleH(256))
		
		surface.SetDrawColor(colortouse) 
		surface.SetTexture(HudScratchTop)
		surface.DrawTexturedRect(w*0.06, h*0.876 ,ScaleW(256), ScaleH(64))	 --- SCRATCHTOP
		surface.SetTexture(HudScratchBottom)
		surface.DrawTexturedRect(w*0.01, h*0.955 ,ScaleW(256), ScaleH(128))	 --- SCRATCHBOTTOm
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 and MySelf:Alive() then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(matUIBottomLeft)
		surface.DrawTexturedRect(0, h*0.80,w*0.4, h*0.32)
		
		surface.SetDrawColor(colortouse) 
		surface.SetTexture(HudScratchTop)
		surface.DrawTexturedRect(w*0.06, h*0.867 ,ScaleW(256), ScaleH(64))	 --- SCRATCHTOP
		surface.SetTexture(HudScratchBottom)
		surface.DrawTexturedRect(w*0.01, h*0.953 ,ScaleW(256), ScaleH(128))	 --- SCRATCHBOTTOm
	end
	
    local ARE_THERE_WEAPONS = false
    local DISTANCE_WEAPON = 99999 -- Default distance. Don't look further.
        for _,weapon in pairs (ents.GetAll()) do
                if weapon:IsValid() and weapon:IsWeapon() and not weapon:GetOwner():IsPlayer() then
                        local DISTANCE_WEAPON_CURRENT = math.Round ((MySelf:GetPos():Distance(weapon:GetPos()))/52.5)
                        if DISTANCE_WEAPON_CURRENT < DISTANCE_WEAPON then
                                DISTANCE_WEAPON = DISTANCE_WEAPON_CURRENT
                                ARE_THERE_WEAPONS = true
                        end
                end
        end


	if w/h > 1.24 and w/h < 1.35 then
		if MySelf:Alive() then
			draw.SimpleText("+"..math.Round( percenthealth * 100 ), "L4D_HP", w*0.0335, h*0.906, colortouse, TEXT_ALIGN_BOTTOM)  --hp
			
			surface.SetDrawColor (255,255,255,255)  
			surface.SetTexture(ScalableHealth)
			surface.DrawTexturedRect(w*0.0296, h*0.9390, w*0.1747, h*0.0195)  ----  GREY PANEL
			surface.SetDrawColor (colortouse)
			surface.DrawOutlinedRect(w*0.0296, h*0.9390, w*0.1747, h*0.0195)  ----- GREEN GREYPANEL OUTLINE
		
			surface.SetDrawColor (colHealthBar)
			surface.SetTexture(HealthBar)
			surface.DrawTexturedRect(w*0.0335,h*0.9429, w*( ((actualhpbar) * 213) / 1280 ), h*0.0117) ---- HEALTHBAR
		end
		
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetTexture(HudTop)
		surface.DrawTexturedRect(0, 0,ScaleW(512), ScaleH(256))  --- HUDTOP 
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		if MySelf:Alive() then
			draw.SimpleText("+"..math.Round( percenthealth * 100 ), "L4D_HP", w*0.0335, h*0.889, colortouse, TEXT_ALIGN_BOTTOM)  --hp
		
			surface.SetDrawColor (255,255,255,255)  
			surface.SetTexture(ScalableHealth)
			surface.DrawTexturedRect(w*0.0296, h*0.9310, w*0.1747, h*0.021)  ----  GREY PANEL
			surface.SetDrawColor (colortouse) 
			surface.DrawOutlinedRect(w*0.0296, h*0.9310, w*0.1747, h*0.021)  ----- GREEN GREYPANEL OUTLINE
		
			surface.SetDrawColor (colHealthBar)
			surface.SetTexture(HealthBar)
			surface.DrawTexturedRect(w*0.0332,h*0.9350, w*( ((actualhpbar) * 216) / 1280 ), h*0.0126) ---- HEALTHBAR
		end
		
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetTexture(HudTop)
		surface.DrawTexturedRect(0, 0,w*0.4, h*0.3)  --- HUDTOP 
	end
	end
	if w/h > 1.24 and w/h < 1.35 then
		surface.SetDrawColor(255, 255, 255, 180)
		--surface.SetTexture(PanelGreencoins)
		--surface.DrawTexturedRect(0, h*0.18, ScaleW(256), ScaleH(128)) --- HUDTOP GREENCOINS
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		surface.SetDrawColor(255, 255, 255, 180)
		--surface.SetTexture(PanelGreencoins)
		---surface.DrawTexturedRect(0, h*0.21, w*0.185, h*0.125) --- HUDTOP GREENCOINS	
	end
	if not DRAW_BETA_HUD then
	if w/h > 1.24 and w/h < 1.35 then
		surface.SetDrawColor(255, 255, 255, 180)
		--surface.SetTexture(PanelGreencoins)
		--surface.DrawTexturedRect(0, h*0.26, ScaleW(256), ScaleH(128)) --- HUDTOP AMMO PANEL
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		surface.SetDrawColor(255, 255, 255, 180)
		--surface.SetTexture(PanelGreencoins)
		--surface.DrawTexturedRect(0, h*0.29, w*0.185, h*0.125) --- HUDTOP AMMO PANEL
	end

	if w/h > 1.24 and w/h < 1.35 then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(HudSplash)
		surface.DrawTexturedRect(w*0.019, h*0.045,ScaleW(128), ScaleH(128))  --- HUDTOP SPLASH RED
	
		--surface.SetDrawColor(255, 255, 255, 195)  --- PANEL SELECT BIG
		--surface.SetTexture(PanelSelect)
		--surface.DrawTexturedRect(w*0.8, h*0.4,ScaleW(256), ScaleH(128))
		if mag_left ~= -1  and (weapon.DrawAmmo and weapon.DrawAmmo == true) then
			-- surface.SetDrawColor(255, 255, 255, 195)  --- PANEL SELECT SMALL
			-- surface.SetTexture(PanelSmall)
			-- surface.DrawTexturedRect(w*0.844, h*0.46,ScaleW(256), ScaleH(256))
		end
		
		--surface.SetDrawColor(255, 255, 255, 195)  --- PANEL SELECT SMALL
		--surface.SetTexture(PanelSmall)
		--surface.DrawTexturedRect(w*0.844, h*0.57,ScaleW(256), ScaleH(256))
		
		-- surface.SetDrawColor(255, 255, 255, 180)
		-- surface.SetTexture(PanelAmmo)      -- PANEL AMMO REGEN
		-- surface.DrawTexturedRect(w*0.4, h*0.875,ScaleW(256), ScaleH(128))
		-- if ARE_THERE_WEAPONS then
			-- surface.SetDrawColor(255, 255, 255, 180)
			-- surface.SetTexture(HudDistance)      -- PANEL AMMO REGEN
			-- surface.DrawTexturedRect(w*0.4, 0,ScaleW(256), ScaleH(128))
--		end
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(HudSplash)
		surface.DrawTexturedRect(w*0.023, h*0.05,w*0.09, h*0.16)  --- HUDTOP SPLASH RED
	
		--surface.SetDrawColor(255, 255, 255, 195)  --- PANEL SELECT BIG
		--surface.SetTexture(PanelSelect)
		--surface.DrawTexturedRect(w*0.82, h*0.4,w*0.18, h*0.125)
		if mag_left ~= -1  and (weapon.DrawAmmo and weapon.DrawAmmo == true) then
			-- surface.SetDrawColor(255, 255, 255, 195)  --- PANEL SELECT SMALL
			-- surface.SetTexture(PanelSmall)
			-- surface.DrawTexturedRect(w*0.882, h*0.46,w*0.12, h*0.25)
		end
		
		--surface.SetDrawColor(255, 255, 255, 195)  --- PANEL SELECT SMALL
		--surface.SetTexture(PanelSmall)
		--surface.DrawTexturedRect(w*0.882, h*0.57,w*0.12, h*0.25)
	
		-- surface.SetDrawColor(255, 255, 255, 180)
		-- surface.SetTexture(PanelAmmo)      -- PANEL AMMO REGEN WS
		-- surface.DrawTexturedRect(w*0.41, h*0.875,w*0.17, h*0.125)
		-- if ARE_THERE_WEAPONS then
			-- surface.SetDrawColor(255, 255, 255, 180)
			-- surface.SetTexture(HudDistance)      -- PANEL WEP DISTANCE WS
			-- surface.DrawTexturedRect(w*0.40, 0,w*0.19, h*0.125)
		-- end
	end

	if MySelf:FlashlightIsOn() == true and MySelf:Alive() then
		surface.SetDrawColor (255,255,255,255)
		surface.SetTexture(HudFlashlight)
		if w/h > 1.24 and w/h < 1.35 then
			surface.DrawTexturedRect(w*0.1, h*0.83, w*0.05, h*0.03125) ---- FLASHLIGHT
		elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
			surface.DrawTexturedRect(w*0.1, h*0.80, w*0.05, h*0.03125) ---- FLASHLIGHT
		end
	end
	
	if MySelf:Alive() and MySelf:Crouching() and MySelf:GetGroundEntity():IsWorld() then
		surface.SetDrawColor (255,255,255,255)  
		surface.SetTexture(Crouching)
		if w/h > 1.24 and w/h < 1.35 then
			surface.DrawTexturedRect(w*0.03, h*0.8, w*0.05, h*0.0625)  -- CROUCHING
		elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
			surface.DrawTexturedRect(w*0.03, h*0.76, w*0.05, h*0.0625)  -- CROUCHING
		end
	end
	end
	if w/h > 1.24 and w/h < 1.35 then
		--surface.SetDrawColor(255, 255, 255, 255)  --- SHOTGUN
		--surface.SetTexture(PanelShotgun)
		--surface.DrawTexturedRect(w*0.844, h*0.43, ScaleW(256), ScaleH(64))
		if mag_left ~= -1  and (weapon.DrawAmmo and weapon.DrawAmmo == true) then
			-- surface.SetDrawColor(255, 255, 255, 255)  ---  PISTOL
			-- surface.SetTexture(PanelPistol)
			-- surface.DrawTexturedRect(w*0.93, h*0.538,ScaleW(256), ScaleH(64))
		end
		
		--surface.SetDrawColor(255, 255, 255, 255)  ---  SMG
		--surface.SetTexture(PanelSmg)
		--surface.DrawTexturedRect(w*0.925, h*0.64,ScaleW(256), ScaleH(64))
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		--surface.SetDrawColor(255, 255, 255, 255)  --- SHOTGUN
		--surface.SetTexture(PanelShotgun)
		--surface.DrawTexturedRect(w*0.857, h*0.43, w*0.18, h*0.0625)
		
		if mag_left ~= -1 and (weapon.DrawAmmo and weapon.DrawAmmo == true) then
			-- surface.SetDrawColor(255, 255, 255, 255)  ---  PISTOL
			-- surface.SetTexture(PanelPistol)
			-- surface.DrawTexturedRect(w*0.945, h*0.538,ScaleW(256), ScaleH(64))
		end
		
		--surface.SetDrawColor(255, 255, 255, 255)  ---  SMG
		--surface.SetTexture(PanelSmg)
		--surface.DrawTexturedRect(w*0.925, h*0.64,ScaleW(256), ScaleH(64))
	end
	

	
	if w/h > 1.24 and w/h < 1.35 then
		--draw.DrawText(mag_left, "AMMO",w*0.89, h*0.46, Color(255,255,255,255), TEXT_ALIGN_CENTER) -- SHOTGUNAMMO
		if mag_left ~= -1 and MySelf:GetActiveWeapon().DrawAmmo then
			--draw.DrawText(mag_left, "AMMO",w*0.941, h*0.570, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		--draw.DrawText(mag_left, "AMMO",w*0.941, h*0.67, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		--draw.DrawText("Kills: "..MySelf:Frags(), "L4DDIFF",w*0.5, h*0.975, Color (168,27,26,230), TEXT_ALIGN_CENTER)
		if ARE_THERE_WEAPONS then
			--draw.DrawText("Weapon: "..DISTANCE_WEAPON.." M", "GC",w*0.492, h*0.01, Color (255,255,255,255), TEXT_ALIGN_CENTER)
		end
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then	
		--draw.DrawText(mag_left, "AMMO",w*0.91, h*0.46, Color(255,255,255,255), TEXT_ALIGN_CENTER) -- SHOTGUNAMMO
		if mag_left ~= -1 and (weapon.DrawAmmo and weapon.DrawAmmo == true) then
			--draw.DrawText(mag_left, "AMMO",w*0.951, h*0.570, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end
		--draw.DrawText(mag_left, "AMMO",w*0.948, h*0.67, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		--draw.DrawText("Kills: "..MySelf:Frags(), "FRAGS",w*0.495, h*0.975, Color (168,27,26,230), TEXT_ALIGN_CENTER)
		if ARE_THERE_WEAPONS then
			--draw.DrawText("Weapon: "..DISTANCE_WEAPON.." M", "GC",w*0.492, h*0.01, Color (91,106,23,255), TEXT_ALIGN_CENTER)
		end
	end

	//Greencoins and regeneration timer
	local coins = MySelf:GreenCoins()
	local TimeToRegenAmmo, RegenColor = "Ammo regen:"..string.FormattedTime ( math.Round ( math.Clamp ( MySelf:GetAmmoTime(), 0, 500 ) ), "%2i:%02i" ), Color( 122, 124, 87, 255 )
	
	//Change ammunition text to "Regenerated!"
	local bRegenerated = false
	if not MySelf.IsFirstRegeneration and MySelf:GetAmmoTime() <= AMMO_REGENERATE_RATE and MySelf:GetAmmoTime() > AMMO_REGENERATE_RATE - 3 then bRegenerated = true TimeToRegenAmmo = "Ammo Regenerated!" end
	
	//Flash red when the ammo regenerated
	if bRegenerated then RegenColor = Color( 180, 36, 36, 240 * math.abs ( math.sin ( CurTime() * 2.4 ) ) ) end
	
	if w/h > 1.24 and w/h < 1.35 then
	if not DRAW_BETA_HUD then
		draw.DrawText(team.NumPlayers(TEAM_HUMAN), "L4DNUM", w*0.063, h*0.055, Color(148,125,75,255), TEXT_ALIGN_CENTER)
		draw.DrawText(team.NumPlayers(TEAM_UNDEAD), "L4DNUM", w*0.063, h*0.090, Color(53,101,49,255), TEXT_ALIGN_CENTER)
		draw.DrawText( TimeToRegenAmmo, "GC", w*0.005, h*0.305, RegenColor, TEXT_ALIGN_LEFT)
	end
		--draw.DrawText("Greencoins: "..coins, "GC", w*0.005, h*0.227, Color(30,94,27,255), TEXT_ALIGN_LEFT) -- GREENCOINS
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
	if not DRAW_BETA_HUD then
		draw.DrawText(team.NumPlayers(TEAM_HUMAN), "L4DNUM", w*0.063, h*0.0635, Color(148,125,75,255), TEXT_ALIGN_CENTER)
		draw.DrawText(team.NumPlayers(TEAM_UNDEAD), "L4DNUM", w*0.063, h*0.110, Color(53,101,49,255), TEXT_ALIGN_CENTER)	
		draw.DrawText( TimeToRegenAmmo, "GC", w*0.005, h*0.3325, RegenColor, TEXT_ALIGN_LEFT)
	end
		--draw.DrawText("Greencoins: "..coins, "GC", w*0.005, h*0.255, Color(30,94,27,255), TEXT_ALIGN_LEFT) -- GREENCOINS
	

	end
	
	--Drowning code for humans
	if 2 < MySelf:WaterLevel() then
		WATER_DROWNTIME = math.max(WATER_DROWNTIME - FrameTime(), 0)
		if WATER_DROWNTIME <= 0 then
			RunConsoleCommand("water_death")
			WATER_DROWNTIME = 30
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
		surface.DrawRect(wx+5 , wy+5,((WATER_DROWNTIME/30)*ww)-10, wh-10 )
		
		draw.SimpleTextOutlined("Oxygen: "..math.Round(WATER_DROWNTIME).." sec left", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		
		
		/*draw.RoundedBox (6,ScaleW(851),ScaleH(239), ScaleW(331),ScaleH(83), Color (1,1,1,200))
		draw.SimpleText ("BREATH METER","ArialBoldNine",ScaleW(1014), ScaleH(250), Color (240,240,240,255),TEXT_ALIGN_CENTER)
		surface.SetDrawColor (66,58,58,255)
		surface.DrawRect (ScaleW(870),ScaleH(282),ScaleW(292),ScaleH(20))
		surface.SetDrawColor (98,17,17,255)
		surface.DrawRect (ScaleW(870),ScaleH(282),w*( ((WATER_DROWNTIME/30) * 292) / 1280 ),ScaleH(20))
		draw.SimpleText ("Timeleft: "..math.Round(WATER_DROWNTIME).." sec","ArialBoldFive",ScaleW(1014), ScaleH(283), Color (230,228,228,255),TEXT_ALIGN_CENTER)*/
	elseif WATER_DROWNTIME > 0 and WATER_DROWNTIME ~= 30 then
		WATER_DROWNTIME = math.min(WATER_DROWNTIME + FrameTime() * 3, 30)
		if WATER_DROWNTIME <= 30 then
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
		surface.DrawRect(wx+5 , wy+5,((WATER_DROWNTIME/30)*ww)-10, wh-10 )
		
		draw.SimpleTextOutlined("Recharging breath: "..math.Round(math.abs (WATER_DROWNTIME - 30)).." sec left", "ArialBoldFive", w/2, wy-2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		
		
		/*draw.RoundedBox (6,ScaleW(851),ScaleH(239), ScaleW(331),ScaleH(83), Color (1,1,1,200))
		draw.SimpleText ("BREATH METER","ArialBoldNine",ScaleW(1014), ScaleH(250), Color (240,240,240,255),TEXT_ALIGN_CENTER)
		surface.SetDrawColor (66,58,58,255)
		surface.DrawRect (ScaleW(870),ScaleH(282),ScaleW(292),ScaleH(20))
		surface.SetDrawColor (98,17,17,255)
		surface.DrawRect (ScaleW(870),ScaleH(282),w*( ((WATER_DROWNTIME/30) * 292) / 1280 ),ScaleH(20))
		draw.SimpleText ("Recharging breath: "..math.Round( math.abs (WATER_DROWNTIME - 30) ).." sec left","ArialBoldFive",ScaleW(1014), ScaleH(283), Color (230,228,228,255),TEXT_ALIGN_CENTER)*/
	end
	
	if ANTI_VENT_CAMP and LocalPlayer():GetHumanClass() == 3 then
			local mypos = LocalPlayer():GetPos()
			local cramped = util.TraceLine({start = mypos, endpos = mypos + Vector(0,0,64), filter = MySelf, mask=COLLISION_GROUP_DEBRIS}).HitWorld
		if cramped and LocalPlayer():Crouching() then
				CRAMP_METER_TIME = math.min(CRAMP_METER_TIME + FrameTime(), 75)
				
				if 75 <= CRAMP_METER_TIME then
					RunConsoleCommand("cramped_death")
					CRAMP_METER_TIME = 0
				end
			elseif 0 < CRAMP_METER_TIME then
				CRAMP_METER_TIME = math.max(CRAMP_METER_TIME - FrameTime() * 3, 0)
			end
		if LocalPlayer():Crouching() and cramped then
		draw.RoundedBox (6,ScaleW(851),ScaleH(239), ScaleW(331),ScaleH(83), Color (1,1,1,200))
		draw.SimpleText ("WATCH YOUR ASS!!","ArialBoldNine",ScaleW(1014), ScaleH(250), Color (240,240,240,255),TEXT_ALIGN_CENTER)
		surface.SetDrawColor (66,58,58,255)
		surface.DrawRect (ScaleW(870),ScaleH(282),ScaleW(292),ScaleH(20))
		surface.SetDrawColor (98,17,17,255)
		surface.DrawRect (ScaleW(870),ScaleH(282),w*( ((CRAMP_METER_TIME/75) * 292) / 1280 ),ScaleH(20))
		draw.SimpleText ("Time until ass explosion: "..math.Round(75-CRAMP_METER_TIME).." sec","ArialBoldFive",ScaleW(1014), ScaleH(283), Color (230,228,228,255),TEXT_ALIGN_CENTER)	
		end
		end
	
	//MedicAuraThink()
	--DrawBackgroundSelect()
end

function GM:ZombieHUD(MySelf)
	local entityhealth = math.max( MySelf:Health(), 0 )
	local class = MySelf:GetZombieClass()
	local maxhealth

	maxhealth = MySelf.MaximumHealth or 220
	if not actualhpbarzombie then
		actualhpbarzombie = 1
	end
	
	maxhealth = MySelf:GetMaximumHealth()
	local percenthealth =  math.Clamp (entityhealth / maxhealth, 0, 1)
	actualhpbarzombie = math.Clamp ( math.Approach (actualhpbarzombie, entityhealth / maxhealth, FrameTime() * 2), 0, 1)
	
	local colortouse
	
	if 0.8 < percenthealth then
		colortouse = COLOR_HUD_OK
	elseif 0.5 < percenthealth then
		colortouse = COLOR_HUD_SCRATCHED
	elseif 0.3 < percenthealth then
		colortouse = COLOR_HUD_HURT
	else
		colortouse = COLOR_HUD_CRITICAL
	end
	
	//Flashing health for howler protection
	local HealthColor = Color( 136,29,21,255 )
	if MySelf:HasHowlerProtection() then
		HealthColor = Color( math.random( 240,255 ), 10, 8, math.abs( math.sin( RealTime() * 6 ) ) * 100 )
	end		

	local realtime = RealTime()
if not DRAW_BETA_HUD then
	if 30 < entityhealth then
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, 255)
	else
		surface.SetDrawColor(colortouse.r, colortouse.g, colortouse.b, math.sin(RealTime() * 6) * 127.5 + 127.5)
	end
	
	if w/h > 1.24 and w/h < 1.35 and MySelf:Alive() then
		if MySelf:Alive() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(matUIBottomLeft)
			surface.DrawTexturedRect(0, h*0.84,ScaleW(512), ScaleH(256))
			
			surface.SetDrawColor( Color( 136,29,21,255 ) ) 
			surface.SetTexture(HudScratchTop)
			surface.DrawTexturedRect(w*0.06, h*0.876 ,ScaleW(256), ScaleH(64))	 --- SCRATCHTOP
			surface.SetTexture(HudScratchBottom)
			surface.DrawTexturedRect(w*0.01, h*0.955 ,ScaleW(256), ScaleH(128))	 --- SCRATCHBOTTOm
		end
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6  then
		if MySelf:Alive() then
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(matUIBottomLeft)
			surface.DrawTexturedRect(0, h*0.80,w*0.4, h*0.32)
			
			surface.SetDrawColor( Color( 136,29,21,255 ) ) 
			surface.SetTexture(HudScratchTop)
			surface.DrawTexturedRect(w*0.06, h*0.867 ,ScaleW(256), ScaleH(64))	 --- SCRATCHTOP
			surface.SetTexture(HudScratchBottom)
			surface.DrawTexturedRect(w*0.01, h*0.953 ,ScaleW(256), ScaleH(128))	 --- SCRATCHBOTTOm
		end
	end

	if w/h > 1.24 and w/h < 1.35 then
		if MySelf:Alive() then
			draw.SimpleText("+"..entityhealth, "L4D_HP", w*0.0335, h*0.906, Color(136,29,21,255), TEXT_ALIGN_BOTTOM)  --hp
			
			surface.SetDrawColor (255,255,255,255)  
			surface.SetTexture(ScalableHealth)
			surface.DrawTexturedRect(w*0.0296, h*0.9390, w*0.1747, h*0.0195)  ----  GREY PANEL
			surface.SetDrawColor ( Color( 136,29,21,255 ) )
			surface.DrawOutlinedRect(w*0.0296, h*0.9390, w*0.1747, h*0.0195)  ----- GREEN GREYPANEL OUTLINE
		
			surface.SetDrawColor ( HealthColor )
			surface.SetTexture(HealthBar)
			surface.DrawTexturedRect(w*0.0335,h*0.9429, w*( ((actualhpbarzombie) * 213) / 1280 ), h*0.0117) ---- HEALTHBAR
		end
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetTexture(HudTop)
		surface.DrawTexturedRect(0, 0,ScaleW(512), ScaleH(256))  --- HUDTOP 
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		if MySelf:Alive() then
			draw.SimpleText("+"..entityhealth, "L4D_HP", w*0.0335, h*0.889, Color(136,29,21,255), TEXT_ALIGN_BOTTOM)  --hp
		
			surface.SetDrawColor (255,255,255,255)  
			surface.SetTexture(ScalableHealth)
			surface.DrawTexturedRect(w*0.0296, h*0.9310, w*0.1747, h*0.021)  ----  GREY PANEL
			surface.SetDrawColor ( Color( 136,29,21,255 ) )
			surface.DrawOutlinedRect(w*0.0296, h*0.9310, w*0.1747, h*0.021)  ----- GREEN GREYPANEL OUTLINE
		
			surface.SetDrawColor ( HealthColor )
			surface.SetTexture(HealthBar)
			surface.DrawTexturedRect(w*0.0332,h*0.9350, w*( ((actualhpbarzombie) * 216) / 1280 ), h*0.0126) ---- HEALTHBAR
		end
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetTexture(HudTop)
		surface.DrawTexturedRect(0, 0,w*0.4, h*0.3)  --- HUDTOP 
	end
end	
	if w/h > 1.24 and w/h < 1.35 then
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetTexture(PanelGreencoins)
	--	surface.DrawTexturedRect(0, h*0.18, ScaleW(256), ScaleH(128)) --- HUDTOP GREENCOINS
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		surface.SetDrawColor(255, 255, 255, 180)
		surface.SetTexture(PanelGreencoins)
	--	surface.DrawTexturedRect(0, h*0.21, w*0.185, h*0.125) --- HUDTOP GREENCOINS	
	end
if not DRAW_BETA_HUD then	
	if w/h > 1.24 and w/h < 1.35 then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(HudSplash)
		surface.DrawTexturedRect(w*0.019, h*0.045,ScaleW(128), ScaleH(128))  --- HUDTOP SPLASH RED
	
		-- surface.SetDrawColor(255, 255, 255, 180)
		-- surface.SetTexture(PanelAmmo)      -- PANEL AMMO REGEN
		-- surface.DrawTexturedRect(w*0.4, h*0.875,ScaleW(256), ScaleH(128))
		
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(HudSplash)
		surface.DrawTexturedRect(w*0.023, h*0.05,w*0.09, h*0.16)  --- HUDTOP SPLASH RED
	
		-- surface.SetDrawColor(255, 255, 255, 180)
		-- surface.SetTexture(PanelAmmo)      -- PANEL AMMO REGEN WS
		-- surface.DrawTexturedRect(w*0.41, h*0.875,w*0.17, h*0.125)
		
	end
	
	if MySelf:Alive() and MySelf:Crouching() and MySelf:GetGroundEntity():IsWorld() then
		surface.SetDrawColor (255,255,255,255)  
		surface.SetTexture(Crouching)
		if w/h > 1.24 and w/h < 1.35 then
			surface.DrawTexturedRect(w*0.03, h*0.8, w*0.05, h*0.0625)  -- CROUCHING
		elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
			surface.DrawTexturedRect(w*0.03, h*0.76, w*0.05, h*0.0625)  -- CROUCHING
		end
	end
end	
	local coins = MySelf:GreenCoins()
	
	if w/h > 1.24 and w/h < 1.35 then
	if not DRAW_BETA_HUD then 
		draw.DrawText(team.NumPlayers(TEAM_HUMAN), "L4DNUM", w*0.063, h*0.055, Color(148,125,75,255), TEXT_ALIGN_CENTER)
		draw.DrawText(team.NumPlayers(TEAM_UNDEAD), "L4DNUM", w*0.063, h*0.090, Color(53,101,49,255), TEXT_ALIGN_CENTER)
	end
	--	draw.DrawText("Greencoins: "..coins, "GC", w*0.005, h*0.227, Color(30,94,27,255), TEXT_ALIGN_LEFT) -- GREENCOINS
	elseif w/h > 1.45 and w/h < 1.8 or w/h == 1.6 then
	if not DRAW_BETA_HUD then 
		draw.DrawText(team.NumPlayers(TEAM_HUMAN), "L4DNUM", w*0.063, h*0.0635, Color(148,125,75,255), TEXT_ALIGN_CENTER)
		draw.DrawText(team.NumPlayers(TEAM_UNDEAD), "L4DNUM", w*0.063, h*0.110, Color(53,101,49,255), TEXT_ALIGN_CENTER)	
	end
		--draw.DrawText("Greencoins: "..coins, "GC", w*0.005, h*0.255, Color(30,94,27,255), TEXT_ALIGN_LEFT) -- GREENCOINS
	end
	
	local killz = MySelf:Frags()
	local redeemkillz = REDEEM_KILLS
	if MySelf and MySelf:HasBought("quickredemp") then
	//	redeemkillz = REDEEM_FAST_KILLS
	end
	
	//Manage soul effects
	//ZombieAuraThink()
end

/*---------------------------------------------------------
      Generates those "soul" patterns on humans
---------------------------------------------------------*/
local NextAura = 0
function ZombieAuraThink ()
	if not ValidEntity ( MySelf ) then return end
	if not MySelf:Alive() then return end
	if NextAura > CurTime() then return end
	
	local Position, MaxAuras, AuraTable = MySelf:GetPos(), 0, {}
	
	//Run through the humans and check who is alive
	for _, pl in pairs( team.GetPlayers ( TEAM_HUMAN ) ) do
		if pl:Alive() and not (pl:GetSuit() == "stalkersuit" and pl:GetVelocity():Length() < 10) then
			local HumanPosition = pl:GetPos()
			if HumanPosition:Distance ( Position ) < 1024 and HumanPosition:ToScreen().visible then
				AuraTable[pl] = HumanPosition
				MaxAuras = MaxAuras + 1
				
				//We have reached our aura limit ( 10 )
				if MaxAuras >= 10 then break end
			end
		end
	end
	
	//End this if there are no player souls to render
	if MaxAuras <= 0 then return end
	
	//Render the souls
	local Emitter = ParticleEmitter( EyePos() )
	for pl, HumanPosition in pairs( AuraTable ) do
		local vel = pl:GetVelocity() * 0.95
		local health = pl:Health()
		
		//Get the position of the chest
		local attach = pl:GetAttachment( pl:LookupAttachment("chest") )
		if not attach then
			attach = { Pos = pl:GetPos() + Vector(0,0,48) }
		end
		
		//Centered particle		
		local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand(0.4, 0.8) )
			particle:SetStartAlpha(255)
			particle:SetStartSize( math.Rand(14, 18) )
			particle:SetEndSize( 4 )
			particle:SetColor( 255 - health * 2, health * 2.1, 30 )
			particle:SetRoll( math.Rand(0, 359) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			
		//Moving around particles
		for x = 1, math.random(1, 3) do
			local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos + VectorRand() * 3 )
				particle:SetVelocity( vel )
				particle:SetDieTime( math.Rand(0.4, 0.8) )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand(10, 14) )
				particle:SetEndSize(0)
				particle:SetColor( 255 - health * 2, health * 2.1, 30 )
				particle:SetRoll( math.Rand(0, 359) )
				particle:SetRollDelta( math.Rand(-2, 2) )
		end
		
		Emitter:Finish()
	end
	
	//Apply cooldown to the effect
	NextAura = CurTime() + 0.4
end

// Almost same aura effect as above but for medic

local NextMAura = 0
function MedicAuraThink ()
	if not ValidEntity ( MySelf ) then return end
	if MySelf:GetHumanClass() != 1 then return end
	if not MySelf:Alive() then return end
	if NextMAura > CurTime() then return end
	
	local Position, MaxAuras, AuraTable = MySelf:GetPos(), 0, {}
	
	//Run through the humans and check who is alive
	for _, pl in pairs( team.GetPlayers ( TEAM_HUMAN ) ) do
		if pl:Alive() and pl != MySelf then
			local HumanPosition = pl:GetPos()
			if HumanPosition:Distance ( Position ) < 500 and HumanPosition:ToScreen().visible then
				AuraTable[pl] = HumanPosition
				MaxAuras = MaxAuras + 1
				
				//We have reached our aura limit ( 10 )
				if MaxAuras >= 7 then break end
			end
		end
	end
	
	//End this if there are no player souls to render
	if MaxAuras <= 0 then return end
	
	//Render the souls
	local Emitter = ParticleEmitter( EyePos() )
	for pl, HumanPosition in pairs( AuraTable ) do
		local vel = pl:GetVelocity() * 0.95
		local health = pl:Health()
		
		//Get the position of the chest
		local attach = pl:GetAttachment( pl:LookupAttachment("chest") )
		if not attach then
			attach = { Pos = pl:GetPos() + Vector(0,0,48) }
		end
		
		//Centered particle		
		local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand(0.4, 0.8) )
			particle:SetStartAlpha(255)
			particle:SetStartSize( math.Rand(14, 18) )
			particle:SetEndSize( 4 )
			particle:SetColor( 255 - health * 2, health * 2.1, 30 )
			particle:SetRoll( math.Rand(0, 359) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			
		//Moving around particles
		for x = 1, math.random(1, 3) do
			local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos + VectorRand() * 3 )
				particle:SetVelocity( vel )
				particle:SetDieTime( math.Rand(0.4, 0.8) )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand(10, 14) )
				particle:SetEndSize(0)
				particle:SetColor( 255 - health * 2, health * 2.1, 30 )
				particle:SetRoll( math.Rand(0, 359) )
				particle:SetRollDelta( math.Rand(-2, 2) )
		end
		
		Emitter:Finish()
	end
	
	//Apply cooldown to the effect
	NextMAura = CurTime() + math.Rand(0.2,0.7)
end

