-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--local matHealthBar = surface.GetTextureID("zombiesurvival/healthbar_fill")

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
--Beats[10] = {"mrgreen/music/bosstheme3.mp3"}
--Beats[10] = {"mrgreen/music/bosstheme4.mp3"}

local BeatLength = {}
BeatLength[0] = 7
BeatLength[1] = 7
BeatLength[2] = 7
BeatLength[3] = 7
BeatLength[4] = 7
BeatLength[5] = 14
BeatLength[6] = 14
BeatLength[7] = 7
BeatLength[8] = 14
BeatLength[9] = 7
--BeatLength[10] = 400
BeatLength[10] = 14


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
--ZBeats[10] = {"zombiesurvival/_zbeat8.wav"}
--ZBeats[10] = {"mrgreen/music/bosstheme3.mp3"}
--ZBeats[10] = {"mrgreen/music/bosstheme4.mp3"}

local ZBeatLength = {}
ZBeatLength[0] = 7
ZBeatLength[1] = 7
ZBeatLength[2] = 7
ZBeatLength[3] = 7
ZBeatLength[4] = 7
ZBeatLength[5] = 7
ZBeatLength[6] = 6
ZBeatLength[7] = 6
ZBeatLength[8] = 6
ZBeatLength[9] = 6
ZBeatLength[10] = 6
--ZBeatLength[10] = 400

--Precache beats
for i=1,10 do
	util.PrecacheSound(Beats[i][1])
	util.PrecacheSound(ZBeats[i][1])
end

function playDragulaMusic()
	if LASTHUMAN or ENDROUND or UNLIFE or not util.tobool(GetConVar( "_zs_enablemusic" )) then return end	
	
	UNLIFE = true
	
	--Stop all sounds
	RunConsoleCommand("stopsound")
	
	--Play the music
	local songDuration = 277
	local song = "mrgreen/music/deadlife.mp3"
	
	--Delayed play because of stopsound in same frame
	timer.Simple(0.3, function()
		surface.PlaySound(Sound(song))
	end)
	
	-- Create timer
	timer.Create("LoopBossMusic", songDuration, 0, function() 
		if LASTHUMAN or ENDROUND then
			return
		end
		surface.PlaySound(Sound(song))
	end)

end


randomSongs = {"hl2_song8", "hl2_song7", "hl2_song30", "hl2_song0", "hl2_song1", "hl2_song17", "hl2_song33", "hl2_song2"}
local function ManageMusic()
	if not MySelf:IsHuman() then return end
	
	if not util.tobool(GetConVar( "_zs_ambientmusic" )) then return end
	
	if not MySelf:IsValid() then
		return
	end

	if (CurTime() - (WARMUPTIME + 120) > 0) then
		surface.PlaySound("music/" .. table.Random(randomSongs) .. ".mp3")
	end
end
timer.Create("ManageMusic", 180, 0, ManageMusic)

ENABLE_MUSIC = util.tobool(GetConVarNumber("zs_enablemusic"))
local function EnableMusic(sender, command, arguments)
	ENABLE_MUSIC = util.tobool(arguments[1])

	if ENABLE_MUSIC then
		MySelf:ChatPrint("Enabled music.")
	else
		MySelf:ChatPrint("Disabled music.")
	end
end
concommand.Add("zs_enablemusic", EnableMusic)

ENABLE_AMBIENT_MUSIC = util.tobool(GetConVarNumber("zs_ambientmusic"))
local function EnableMusic(sender, command, arguments)
	ENABLE_AMBIENT_MUSIC = util.tobool(arguments[1])

	if ENABLE_AMBIENT_MUSIC then
		MySelf:ChatPrint("Enabled ambient music.")
	else
		MySelf:ChatPrint("Disabled ambient music.")
	end
end
concommand.Add("zs_ambientmusic", EnableMusic)




--Small turret's names from IW
local randnames = { "Turret", "Terry", "Tim" }
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

HCOLORMOD = true

CreateClientConVar("zs_viewmodel_fov", 0, true, true)
CreateClientConVar("zs_wepfov", 60, true, true) --Obsolete

ENABLE_BLOOD = false

local NextBeat = 0
local LastBeatLevel = 0
local function PlayBeats(teamid, am)
	--if ENDROUND or LASTHUMAN or BOSSACTIVE or RealTime() <= NextBeat then
	if ENDROUND or LASTHUMAN or UNLIFE or RealTime() <= NextBeat then
		return
	end
	--print(am)
	local ENABLE_BEATS = util.tobool(GetConVarNumber("_zs_enablebeats"))
	if not ENABLE_BEATS then
		return
	end
	
	-- Apparently it takes ourselves into consideration..
	if am <= 1 then
		return
	end

	local beats = teamid == TEAM_HUMAN and Beats or ZBeats
	if not beats then
		return
	end

	LastBeatLevel = math.Approach(LastBeatLevel, math.ceil(am), 1)
	--print("LastBeatLevel: ".. LastBeatLevel)

	local snd = beats[LastBeatLevel][1]
	if snd then
		MySelf:EmitSound(snd, 0, 100, 0.8)
		NextBeat = RealTime() + SoundDuration(snd) - 0.025
	end
end


-- Good old beats :D
local function BeatsThink()
	if not MySelf:IsValid() then
		return
	end
	
	PlayBeats(MySelf:Team(), math.Clamp(MySelf:GetNearUndead(HORDE_MAX_DISTANCE),0,10))
end
hook.Add("Think", "BeatsThink", BeatsThink)

--[==[---------------------------------------------------------
      Generates those "soul" patterns on humans
---------------------------------------------------------]==]
local NextAura = 0
function ZombieAuraThink()
	if not IsValid(MySelf) or not MySelf:Alive() or NextAura > CurTime() then
		return
	end
	
	local Position, MaxAuras, AuraTable = MySelf:GetPos(), 0, {}
	
	-- Run through the humans and check who is alive
	local Survivors = team.GetPlayers(TEAM_HUMAN)

	--Shuffle to make it more random
	Survivors = table.Shuffle(Survivors)

	for i=1, #Survivors do
		local pl = Survivors[i]
		if not IsValid(pl) or not pl:Alive() then
			continue
		end

		local HumanPosition = pl:GetPos()
		if HumanPosition:Distance(Position) < 3024 and HumanPosition:ToScreen().visible then
			AuraTable[pl] = HumanPosition
			MaxAuras = MaxAuras + 1
				
			--We have reached aura limit
			if MaxAuras >= 10 then
				break
			end
		end
	end
	
	-- End this if there are no player souls to render
	if MaxAuras <= 0 then
		return
	end
	
	-- Render the souls
	local Emitter = ParticleEmitter( EyePos() )
	for pl, HumanPosition in pairs( AuraTable ) do
		local vel = pl:GetVelocity() * 0.95
		local health = pl:Health()
		
		-- Get the position of the chest
		local attach = pl:GetAttachment( pl:LookupAttachment("chest") )
		if not attach then
			attach = { Pos = pl:GetPos() + Vector(0,0,48) }
		end
		
		-- Centered particle		
		local particle = Emitter:Add( "Sprites/light_glow02_add_noz", attach.Pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand(0.2, 0.4) )
			particle:SetStartAlpha(255)
			particle:SetStartSize( math.Rand(14, 18) )
			particle:SetEndSize( 6 )
			particle:SetColor( 255 - health * 2, health * 2.1, 30 )
			particle:SetRoll( math.Rand(0, 359) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			
		-- Moving around particles
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
	
	-- Apply cooldown to the effect
	NextAura = CurTime() + 0.3
end