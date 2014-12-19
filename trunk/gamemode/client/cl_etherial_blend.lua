-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--28/11/2014
--Duby: Removed from the main cl_init file as it wasn't needed in the main client side file. Placed here for optimizations. 

local undomodelblend = false
local undowraithblend = false
function GM:_PrePlayerDraw(pl)
	if pl.IsZombie and pl:IsZombie() and pl.IsWraith and pl:IsWraith() then
		if IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsDisguised and pl:GetActiveWeapon():IsDisguised() then
			render.SetBlend(1)
		else
			--local col = math.random( 1, 35 ) == 1 and 1 or 0.04
			local col = math.random( 1, 70 ) == 1 and 1 or 0.17
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
		render.SetColorModulation(40, 20, 30)
		undomodelblend = false
	end
	if undowraithblend then
		render.SetBlend(1)
		undowraithblend = false
	end
end