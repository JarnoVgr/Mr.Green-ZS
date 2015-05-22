-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--28/11/2014
--Duby: Removed from the main cl_init file as it wasn't needed in the main client side file. Placed here for optimizations. 

local undomodelblend = false
local undowraithblend = false
local function PrePlayerDraw(pl)
	if pl.IsZombie and pl:IsZombie() and pl.IsWraith and pl:IsWraith() then
		if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsDisguised and pl:GetActiveWeapon():IsDisguised() then
			render.SetBlend(1)
		else
			--local col = math.random( 1, 35 ) == 1 and 1 or 0.04
			local col = math.random( 1, 20 ) == 1 and 1 or 0.17
			render.SetBlend(col)
		end
		undowraithblend = true
	end

	if pl.IsZombie and pl:IsZombie() and pl.IsWraith2 and pl:IsWraith2() then
		if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsDisguised and pl:GetActiveWeapon():IsDisguised() then
			render.SetBlend(1)
		else
			--local col = math.random( 1, 35 ) == 1 and 1 or 0.04
			local col = math.random( 1, 20 ) == 1 and 1 or 0.17
			render.SetBlend(col)
		end
		undowraithblend = true
	end
	
	if pl.status_overridemodel and pl.status_overridemodel:IsValid() and GAMEMODE:_ShouldDrawLocalPlayer(MySelf) then
		undomodelblend = true
		render.SetBlend(0)
	end	
end

local function PostPlayerDraw(pl)
	if undomodelblend then
		render.SetBlend(1)
		render.ModelMaterialOverride()
		render.SetColorModulation(10, 10, 10)
		undomodelblend = false
	end
	if undowraithblend then
		render.SetBlend(1)
		undowraithblend = false
	end
end

--Ethereal hiding
hook.Add("PrePlayerDraw", "EtherealPreDraw", PrePlayerDraw)
hook.Add("PostPlayerDraw", "EtherealPreDraw", PostPlayerDraw)
