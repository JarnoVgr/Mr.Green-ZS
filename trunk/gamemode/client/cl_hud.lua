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
	surface.CreateFontLegacy("Face Your Fears", ScreenScale(20), 700, true, false, "NewZombieFont40")
	surface.CreateFontLegacy("Arial", ScreenScale(14), 500, true, false, "ArialFourteen2")
end

--[==[---------------------------------------------------------------------
                     Called when myself ( as human ) dies
----------------------------------------------------------------------]==]
function death.HumanDeath( pl, attacker )
	if not IsValid(pl) or pl ~= MySelf or not pl:IsHuman() then
		return
	end

	--Status
	MySelf.FirstHumanDeath = true
end
hook.Add("DoPlayerDeath", "SpawnCountdown", death.HumanDeath)

--[==[---------------------------------------------------------------------
               Called when myself ( as zombie ) dies
----------------------------------------------------------------------]==]
function death.ZomboDeath( pl, attacker )
	if not IsValid(pl) or not pl:IsZombie() or pl ~= MySelf then
		return
	end
	
	-- Status
	MySelf.FirstHumanDeath = false
end
hook.Add ( "DoPlayerDeath", "ZombieSpawnCountdown", death.ZomboDeath )

--[==[----------------------------------------------------
          Draws the human death hud
----------------------------------------------------]==]
--local TEX_GRADIENT_TOP = surface.GetTextureID("vgui/gradient-u")
function death.DeathHumanHUD()

	if ENDROUND or not IsValid( MySelf ) then
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

	draw.DrawText("You've failed to survive", "ArialFourteen2", ScaleW(642), ScaleH(34), Color(115, 115, 115, 255), TEXT_ALIGN_CENTER)

	local timeleft = math.max(0,math.Round((MySelf.NextSpawn or 0) - CurTime()) + 1)
	
	local bCanSpawn = false

	if timeleft ~= 0 then
	 	draw.DrawText("You can resurrect as an Undead in ".. timeleft .." seconds", "ArialFourteen2", ScaleW(641), ScaleH(83), Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	else
		bCanSpawn = true
	end

	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:ZombieObserverHUD(obsmode,bCanSpawn)
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
	draw.DrawText("YOU ARE DEAD", "ArialFourteen2", ScrW()/2, ScaleH(34), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

	--Display timeleft for respawning
	local timeleft = math.max(0, math.Round(MySelf.NextSpawn - CurTime()) + 1)
	if timeleft ~= 0 then
		draw.DrawText("You can resurrect in ".. timeleft .." seconds", "ArialFourteen2", ScrW()/2, ScaleH(83), Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end
	
	--Spectate
	local obsmode = MySelf:GetObserverMode()
	if obsmode ~= OBS_MODE_NONE then
		GAMEMODE:ZombieObserverHUD(obsmode, timeleft == 0)
	elseif timeleft == 0 then
		draw.DrawText("You can resurrect shortly", "ArialFourteen2", ScrW()/2, ScaleH(83), Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end
end
hook.Add("HUDPaint", "DeathZombieHUD", death.DeathZombieHUD)	


function death.Draw3DZombieHUD()
	if ENDROUND or not IsEntityValid(MySelf) or not MySelf:IsZombie() or MySelf.FirstHumanDeath or IsClassesMenuOpen() or MySelf:Alive() then
		return
	end
	
	-- Never died
	if not MySelf.InitialDeath then return end
	
	if MySelf:IsFreeSpectating() then return end
	
	GAMEMODE:DrawCustomDeathNotice()	
end
hook.Add("PostDrawOpaqueRenderables","Draw3DZombieHUD",death.Draw3DZombieHUD)

function GM:ZombieObserverHUD(obsmode, bCanSpawn)
	if obsmode == OBS_MODE_FREEZECAM then
		return
	end
	
	surface.SetFont("ArialBoldTen")
	local texw, texh = surface.GetTextSize("W")

	local HasValidTarget
	if obsmode == OBS_MODE_CHASE then
		local target = MySelf:GetObserverTarget()
		if IsValid(target) and target:IsPlayer() and target:Team() == TEAM_UNDEAD then
			draw.SimpleText("Observing ".. target:Name() .." (+"..math.max(0, target:Health())..")", "ArialBoldTen", w * 0.5, h * 0.75 - texh - 32, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
			HasValidTarget = self:DynamicSpawnIsValid(target)
		end
	end

	if bCanSpawn then
		draw.DrawText(HasValidTarget and "Press LMB to resurrect here" or "Press LMB to resurrect", "ArialFourteen2", ScrW()/2, ScaleH(83),HasValidTarget and Color(0, 150, 0, 255) or Color(135, 135, 135, 255), TEXT_ALIGN_CENTER)
	end

	draw.SimpleText("Cycle targets by pressing RMB", "ArialFourteen2", w * 0.5, h * 0.75 + texh + 8, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
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

