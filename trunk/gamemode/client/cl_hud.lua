-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Our local functions
local death = {}

-- Materials we need
local matInfo = surface.GetTextureID ( "hud3/hud_info" )

--Initialize nextspawn
--TODO: Move to something not HUD related.
hook.Add("PlayerInitialSpawn", "InitNextSpawnTime", function(pl)
	if pl == MySelf then
		pl.NextSpawn = 0
	end
end)

function GM:Initialize() --Stop the lag in its tracks with this 
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(20), 700, true, false, "NewZombieFont23")
	surface.CreateFontLegacy("Arial", ScreenScale(14), 500, true, false, "ArialFourteen2")
end

--[==[---------------------------------------------------------------------
                     Called when myself ( as human ) dies
----------------------------------------------------------------------]==]
local function Death( pl, attacker )
	if not IsValid(pl) or pl ~= MySelf then
		return
	end

	local Team = pl:Team()

	if Team == TEAM_HUMAN then
		MySelf.FirstHumanDeath = true
	elseif Team == TEAM_ZOMBIE then
		MySelf.FirstHumanDeath = false
	end
end
hook.Add("DoPlayerDeath", "SpawnCountdown", Death)

--[==[----------------------------------------------------
          Draws the spectator death hud
----------------------------------------------------]==]
function death.DeathSpectatorHUD()
	if ENDROUND or not IsValid(MySelf) or MySelf:Team() ~= TEAM_SPECTATOR or not MySelf.ReadySQL or IsLoadoutOpen() or MySelf:Alive() then
		return
	end	
	--local textw, texth = surface.GetTextSize( sRandomNotice )
	
	-- Draw the black boxes
	surface.SetDrawColor(0,0,0,210)
--	surface.SetTexture(TEX_GRADIENT_TOP)
	surface.DrawRect(0,0, ScaleW(1280), ScaleH(162)) --ScaleH(162)

	draw.DrawText("You're spectating. Press LMB to play.", "NewZombieFont23", ScaleW(642), ScaleH(34), Color(115, 115, 115, 255), TEXT_ALIGN_CENTER)
	
	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:SpectatorHUD(obsmode, false)
	end
end
hook.Add("HUDPaint", "DeathSpectatorHUD", death.DeathSpectatorHUD)

--[==[----------------------------------------------------
          Draws the human death hud
----------------------------------------------------]==]
--local TEX_GRADIENT_TOP = surface.GetTextureID("vgui/gradient-u")

function death.DeathHumanHUD()
	if ENDROUND or not IsValid(MySelf) then
		return
	end

	if not MySelf:IsZombie() or IsClassesMenuOpen() or not MySelf.FirstHumanDeath or MySelf:Alive() then
		return
	end
	
	--local textw, texth = surface.GetTextSize( sRandomNotice )
	
	-- Draw the black boxes
	surface.SetDrawColor(0,0,0,210)
--	surface.SetTexture(TEX_GRADIENT_TOP)
	surface.DrawRect(0,0, ScaleW(1280), ScaleH(162)) --ScaleH(162)

	draw.DrawText("You've failed to survive", "NewZombieFont23", ScaleW(642), ScaleH(34), Color(115, 115, 115, 255), TEXT_ALIGN_CENTER)

	local timeleft = math.max(0,math.Round((MySelf.NextSpawn or 0) - CurTime()) + 1)
	
	local bCanSpawn = false

	if timeleft ~= 0 then
	 	draw.DrawText("You can resurrect as an Undead in ".. timeleft .." seconds", "NewZombieFont23", ScaleW(641), ScaleH(83), Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	else
		bCanSpawn = true
	end

	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:SpectatorHUD(obsmode, bCanSpawn)
	end
end
hook.Add("HUDPaint", "DeathHumanHUD", death.DeathHumanHUD)

--[==[----------------------------------------------------
          Draws the zombie death hud
-----------------------------------------------------]==]

function death.DeathZombieHUD()
	if ENDROUND or not IsValid(MySelf) then
		return
	end

	if not MySelf:IsZombie() or MySelf.FirstHumanDeath or IsClassesMenuOpen() or MySelf:Alive() then
		return
	end
	
	--Never died
	if not MySelf.InitialDeath then
		return
	end
	
	--Draw black box
	surface.SetDrawColor(0, 0, 0, 210)
	surface.DrawRect(0, 0, ScrW(), ScaleH(142))
	
	--Draw death text
	draw.DrawText("YOU ARE DEAD", "NewZombieFont23", ScrW()/2, ScaleH(34), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

	--Display timeleft for respawning
	local timeleft = math.max(0, math.Round(MySelf.NextSpawn - CurTime()))
	if timeleft ~= 0 then
		draw.DrawText("You can resurrect in ".. timeleft .." seconds", "NewZombieFont23", ScrW()/2, ScaleH(83), Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end
	
	--Spectate
	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:SpectatorHUD(obsmode, timeleft == 0)
	elseif timeleft == 0 then
		draw.DrawText("You can resurrect shortly", "NewZombieFont23", ScrW()/2, ScaleH(83), Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end
end
hook.Add("HUDPaint", "DeathZombieHUD", death.DeathZombieHUD)	

function death.Draw3DZombieHUD()
	if ENDROUND or not IsEntityValid(MySelf) or not MySelf:IsZombie() or MySelf.FirstHumanDeath or IsClassesMenuOpen() or MySelf:Alive() then
		return
	end
	
	-- Never died
	if not MySelf.InitialDeath or MySelf:IsFreeSpectating() then
		return
	end
	
	GAMEMODE:DrawCustomDeathNotice()	
end
hook.Add("PostDrawOpaqueRenderables","Draw3DZombieHUD",death.Draw3DZombieHUD)

function GM:SpectatorHUD(obsmode, bCanSpawn)
	if obsmode == OBS_MODE_FREEZECAM then
		return
	end
	
	surface.SetFont("NewZombieFont23")
	local texw, texh = surface.GetTextSize("W")

	local HasValidTarget = false
	if obsmode == OBS_MODE_CHASE then
		local target = MySelf:GetObserverTarget()
		if IsValid(target) then
			local text
			if target:IsPlayer() then
				text = "Observing ".. target:Name() .." (+"..math.max(0, target:Health())..")"
				if target:Team() == TEAM_UNDEAD then
					HasValidTarget = self:DynamicSpawnIsValid(target)
				end
			elseif target:GetClass() == "game_spawner" then
				text = "Observing Blood Spawner"
				HasValidTarget = self:DynamicSpawnIsValid(target)
			end

			if text then
				draw.SimpleText(text, "NewZombieFont23", w * 0.5, h * 0.75 - texh - 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			end
		end
	end

	if bCanSpawn then
		draw.DrawText(HasValidTarget and "Press LMB to resurrect here" or "Press LMB to resurrect", "NewZombieFont23", ScrW()/2, ScaleH(83),HasValidTarget and Color(0, 150, 0, 255) or Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end

	draw.SimpleText("Cycle targets by pressing RMB", "NewZombieFont23", w * 0.5, h * 0.75 + texh + 8, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
end

local GradientExample = surface.GetTextureID("gui/center_gradient")
function DrawBlackBox(x,y,w,h,overridealpha)
	local a = 1
	
	if overridealpha then
		a = overridealpha
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 240*a ) )
	surface.DrawRect( x, y, w, h )
		
	local Quad = {} 
	Quad.texture 	= GradientExample
	Quad.color		= Color(40,40,40,140*a)
 
	Quad.x = x
	Quad.y = y
	Quad.w = w
	Quad.h = h
	draw.TexturedQuad( Quad )
		
	surface.SetDrawColor( 30, 30, 30, 200*a )
	surface.DrawOutlinedRect( x, y, w, h )
	surface.SetDrawColor( 30, 30, 30, 255*a )
	surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )
end

local Quad = {}
function DrawPanelBlackBox(x,y,w,h,overridealpha)
	local a = 1
	
	if overridealpha then
		a = overridealpha
	end
	
	surface.SetDrawColor( Color( 0, 0, 0, 240*a ) )
	surface.DrawRect( x, y, w, h )
		
	
	Quad.texture = GradientExample
	Quad.color = Color(40,40,40,140*a)
 
	Quad.x = x
	Quad.y = y
	Quad.w = w
	Quad.h = h
	draw.TexturedQuad(Quad)
		
	surface.SetDrawColor( 30, 30, 30, 200*a )
	surface.DrawOutlinedRect( x, y, w, h )
	surface.SetDrawColor( 30, 30, 30, 255*a )
	surface.DrawOutlinedRect( x+1, y+1, w-2, h-2 )
end