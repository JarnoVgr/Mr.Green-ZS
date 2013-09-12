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

	if ServerTime() <= WARMUPTIME then
		MySelf.NextSpawn = WARMUPTIME+2
	else
		local NextSpawn = math.Clamp(GetInfliction() * 14, 1, 4)
		MySelf.NextSpawn = ServerTime() + NextSpawn
	end
	
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
	if ServerTime() <= WARMUPTIME then
		MySelf.NextSpawn = WARMUPTIME+2
	else
		local NextSpawn = math.Clamp(GetInfliction() * 14, 1, 4)
		MySelf.NextSpawn = ServerTime() + NextSpawn
	end
	
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
	
	-- Initialize the hint
	--[[if not sRandomNotice then sRandomNotice = "Hint: "..table.Random ( GameDeathHints ) end
	
	surface.SetFont("ArialBoldFifteen")
	local textw, texth = surface.GetTextSize( sRandomNotice )
	
	-- Draw the black boxes
	surface.SetDrawColor(0,0,0,210)
	surface.DrawRect(0,0, ScaleW(1280), ScaleH(162))
	surface.DrawRect(0,ScaleH(864), ScaleW(1280), ScaleH(160))
	
	-- Draw the info material
	surface.SetDrawColor (255,255,255,255)
	surface.SetTexture( matInfo )
	surface.DrawTexturedRectRotated(ScaleW(691 - 48) - ( textw / 2 ), ScaleH(941),ScaleW(64), ScaleW(64),0)

	--Draw hint
	draw.DrawText( sRandomNotice, "ArialBoldFifteen", ScaleW(641 + 50), ScaleH(926), Color (255,255,255,255), TEXT_ALIGN_CENTER )
	]]

	draw.DrawText( "YOU'VE BEEN INFECTED", "ArialBoldFifteen", ScaleW(642), ScaleH(44), Color ( 255,255,255,255 ), TEXT_ALIGN_CENTER )

	local timeleft = math.max(0,math.Round(MySelf.NextSpawn - ServerTime()))
	
	local bCanSpawn = false

	if timeleft ~= 0 then
	 	draw.DrawText( "You can resurrect as an Undead in ".. (timeleft) .." seconds", "NewZombieFont27", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
	else
		bCanSpawn = true
	end

	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:ZombieObserverHUD(obsmode,bCanSpawn)
	end
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
	
	--local respleft = math.max(0, GAMEMODE:GetWaveStart() - CurTime())
	
	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:ZombieObserverHUD(obsmode,true)
	else	
		local timeleft = math.max(0,math.Round(MySelf.NextSpawn - ServerTime())+2)

		--print("NextSpawn: ".. tostring(MySelf.NextSpawn) .. " - ServerTime: ".. tostring(ServerTime()) .." - Diff:" .. tostring(MySelf.NextSpawn - ServerTime()))
		--TODO: Figure out why +2 is needed

		if timeleft ~= 0 then
			draw.DrawText( "You can resurrect in ".. (timeleft) .." seconds", "NewZombieFont27", ScaleW(641), ScaleH(93), Color (135,135,135,255), TEXT_ALIGN_CENTER)
		end
	end
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

function GM:ZombieObserverHUD(obsmode,bCanSpawn)
	if obsmode == OBS_MODE_FREEZECAM then
		return
	end
	
	surface.SetFont("NewZombieFont19")
	local texw, texh = surface.GetTextSize("W")

	local dyn
	if obsmode == OBS_MODE_CHASE then
		local target = MySelf:GetObserverTarget()
		if target and target:IsValid() and target:IsPlayer() and target:Team() == TEAM_UNDEAD then
			draw.SimpleText("Observing "..target:Name().." (+"..math.max(0, target:Health())..")", "NewZombieFont19", w * 0.5, h * 0.75 - texh - 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			dyn = self:DynamicSpawnIsValid(target)
		end
	end

	if bCanSpawn then
		draw.DrawText(dyn and "Press LMB to resurrect here" or "Press LMB to resurrect", "NewZombieFont27", ScaleW(641), ScaleH(93),dyn and Color(0, 150, 0, 255) or Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end

	draw.SimpleText("Cycle targets by pressing RMB", "NewZombieFont14", w * 0.5, h * 0.75 + texh + 8, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end




