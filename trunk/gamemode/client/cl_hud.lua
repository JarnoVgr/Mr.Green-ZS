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

-- Our local functions
local death = {}

-- Materials we need
local matInfo = surface.GetTextureID ( "hud3/hud_info" )

-- Initialize nextspawn
hook.Add ( "PlayerInitialSpawn", "InitNextSpawnTime", function( pl ) if pl == MySelf then pl.NextSpawn = 0 end end )

--[==[---------------------------------------------------------------------
                     Called when myself ( as human ) dies
----------------------------------------------------------------------]==]
function death.HumanDeath( pl, attacker )
	if not IsEntityValid ( pl ) then return end
	if pl ~= MySelf or not pl:IsHuman() then return end

	-- Predict spawn countdown timer
	MySelf.NextSpawn = CurTime() + 4--( math.Clamp ( GetInfliction() * 10, 3, 8 ) )
	
	-- Shuffle random notice
	death.ShuffleRandomNotice()
	
	-- Status
	MySelf.FirstHumanDeath = true
end
hook.Add ( "DoPlayerDeath", "SpawnCountdown", death.HumanDeath )

--[==[---------------------------------------------------------------------
               Called when myself ( as zombie ) dies
----------------------------------------------------------------------]==]
function death.ZomboDeath( pl, attacker )
	if not IsEntityValid ( pl ) then return end
	if not pl:IsZombie() or pl ~= MySelf then return end
	
	-- Spawn timer
	MySelf.NextSpawn = CurTime() + 4--( math.Clamp ( GetInfliction() * 14, 1, 4 ) )
	
	-- Status
	MySelf.FirstHumanDeath = false
end
hook.Add ( "DoPlayerDeath", "ZombieSpawnCountdown", death.ZomboDeath )

--[==[---------------------------------------------------------------
               Shuffle our random notice text
--------------------------------------------------------------]==]
function death.ShuffleRandomNotice()
	sRandomNotice = "Hint: "..table.Random ( GameDeathHints )
end

--[==[----------------------------------------------------
          Draws the human death hud
----------------------------------------------------]==]
function death.DeathHumanHUD()
	if not IsEntityValid ( MySelf ) then return end
	if not MySelf:IsZombie() or IsClassesMenuOpen() or not MySelf.FirstHumanDeath or MySelf:Alive() then return end
	
	-- Don't draw on endround
	if ENDROUND then return end
	
	if MySelf:IsFreeSpectating() then
	
		local respleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
	-- 	draw.DrawText( "Wait for next wave to respawn | "..ToMinutesSeconds(respleft).."", "NewZombieFont27", ScaleW(641), ScaleH(63), Color (155,155,155,255), TEXT_ALIGN_CENTER)
	
	else
	
	
	-- Initialize the hint
	if not sRandomNotice then sRandomNotice = "Hint: "..table.Random ( GameDeathHints ) end
	
	surface.SetFont ( "ArialBoldFifteen" )
	local textw, texth = surface.GetTextSize ( sRandomNotice )
	
	-- Draw the black boxes
	-- surface.SetDrawColor (0,0,0,210)
	-- surface.DrawRect (0,0, ScaleW(1280), ScaleH(162))
	-- surface.DrawRect (0,ScaleH(864), ScaleW(1280), ScaleH(160))
	
	-- Draw the info material
	-- surface.SetDrawColor (255,255,255,255)
	-- surface.SetTexture ( matInfo )
	-- surface.DrawTexturedRectRotated(ScaleW(691 - 48) - ( textw / 2 ), ScaleH(941),ScaleW(64), ScaleW(64),0)
	
	local timeleft = math.Round( math.Clamp ( MySelf.NextSpawn - CurTime(), 0, 100 ) ) 
	draw.DrawText( "You are dead!", "NewZombieFont27", ScaleW(641), ScaleH(63), Color (155,155,155,255), TEXT_ALIGN_CENTER)
	-- Draw text 
	-- draw.DrawText( "YOU ARE DEAD", "ArialBoldFifteen", ScaleW(642), ScaleH(44), Color ( 255,255,255,255 ), TEXT_ALIGN_CENTER )
	if timeleft ~= 0 then
	-- 	draw.DrawText( "You will spawn as a zombie in "..( timeleft ).." seconds.", "ArialTwelve", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
	else
	-- 	draw.DrawText( "Press LMB to spawn.", "ArialTwelve", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
	end
	-- draw.DrawText( sRandomNotice, "ArialBoldFifteen", ScaleW(641 + 50), ScaleH(926), Color (255,255,255,255), TEXT_ALIGN_CENTER )
	end
	-- Draw the red death notice
	--GAMEMODE:DrawCustomDeathNotice ()
end
hook.Add ( "HUDPaint", "DeathHumanHUD", death.DeathHumanHUD )

--[==[----------------------------------------------------
          Draws the zombie death hud
-----------------------------------------------------]==]
function death.DeathZombieHUD()
	if not IsEntityValid ( MySelf ) then return end
	if not MySelf:IsZombie() or MySelf.FirstHumanDeath or IsClassesMenuOpen() or (MySelf:OldAlive() and not MySelf:IsCrow()) then return end
	
	-- Never died
	if not MySelf.InitialDeath then return end
	
	-- Don't draw on endround
	if ENDROUND then return end
	
	-- Draw black box
	--surface.SetDrawColor (0,0,0,210)
	--surface.DrawRect (0,0, ScaleW(1280), ScaleH(162))
	
	-- Draw death text
	--draw.DrawText( "YOU ARE DEAD", "ArialBoldFifteen", ScaleW(642), ScaleH(44), Color (255,255,255,255), TEXT_ALIGN_CENTER )
	--draw.DrawText( "You will resurrect in "..( math.Round( math.Clamp ( MySelf.NextSpawn - CurTime(), 0, 100 ) ) ).." seconds.", "ArialTwelve", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
	
	local respleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
	
	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:ZombieObserverHUD(obsmode)
	elseif not GAMEMODE:GetFighting() or GAMEMODE:GetWave() == 0 then
		draw.DrawText( "You will spawn in "..ToMinutesSeconds(respleft + 1), "NewZombieFont27", ScaleW(641), ScaleH(63), Color (155,155,155,255), TEXT_ALIGN_CENTER)
	end
	
	--[=[if MySelf:IsFreeSpectating() then
		draw.DrawText( "Wait for next wave to respawn | "..ToMinutesSeconds(respleft).."", "NewZombieFont27", ScaleW(641), ScaleH(63), Color (155,155,155,255), TEXT_ALIGN_CENTER)
	else
		local timeleft = math.Round( math.Clamp ( MySelf.NextSpawn - CurTime(), 0, 100 ) )
		if timeleft ~= 0 then
			draw.DrawText( "You will resurrect in "..( timeleft ).." seconds.", "NewZombieFont27", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
		else
			draw.DrawText( "Press LMB to spawn.", "NewZombieFont27", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
		end
		
		-- Draw red deathnotice
		-- GAMEMODE:DrawCustomDeathNotice ( )
	end]=]
end
hook.Add ( "HUDPaint", "DeathZombieHUD", death.DeathZombieHUD )	


function death.Draw3DZombieHUD()
	if not IsEntityValid ( MySelf ) then return end
	if not MySelf:IsZombie() or MySelf.FirstHumanDeath or IsClassesMenuOpen() or MySelf:Alive() then return end
	
	-- Never died
	if not MySelf.InitialDeath then return end
	
	-- Don't draw on endround
	if ENDROUND then return end
	
	if MySelf:IsFreeSpectating() then return end
	
	GAMEMODE:DrawCustomDeathNotice ( )
	
	
end
hook.Add("PostDrawOpaqueRenderables","Draw3DZombieHUD",death.Draw3DZombieHUD)

function GM:ZombieObserverHUD(obsmode)
	if obsmode == OBS_MODE_FREEZECAM then return end
	
	surface.SetFont("NewZombieFont19")
	local texw, texh = surface.GetTextSize("W")

	local dyn
	if obsmode == OBS_MODE_CHASE then
		local target = MySelf:GetObserverTarget()
		if target and target:IsValid() and target:IsPlayer() and target:Team() == TEAM_UNDEAD then
			draw.SimpleText("Observing "..target:Name().." ("..math.max(0, target:Health())..")", "NewZombieFont19", w * 0.5, h * 0.75 - texh - 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			dyn = self:DynamicSpawnIsValid(target)
		end
	end

	if self:GetFighting() and self:GetWave() ~= 0 then
		draw.SimpleText(dyn and "Press LMB to spawn on top of them" or "Press LMB to spawn", "NewZombieFont19", w * 0.5, h * 0.75, dyn and Color(0, 150, 0, 255) or Color(185, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	draw.SimpleText("Press RMB to cycle targets", "NewZombieFont14", w * 0.5, h * 0.75 + texh + 8, Color(255,255,255, 255), TEXT_ALIGN_CENTER)
end




