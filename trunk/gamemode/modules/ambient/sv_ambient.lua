-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_ambient.lua")

--[[local function AmbientThink()
	if ENDROUND or not LocalPlayer():IsValid() then
		return
	end

	local team = LocalPlayer():Team()

	if team == TEAM_HUMAN then

	end
	

	PlayAmbient()
end
timer.Create( "AmbientThink", 10, 0, AmbientThink )]]
--hook.Add("Think", "AmbientThink", AmbientThink)
