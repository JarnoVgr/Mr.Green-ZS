-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information



local RandomAmbientSounds = {}
for _, filename in pairs(file.Find("sound/mrgreen/ambient/random/*.mp3", "GAME" ) ) do
	local sPath = "mrgreen/ambient/random/".. string.lower(filename)
	table.insert(RandomAmbientSounds, sPath)
	util.PrecacheSound(sPath)
end

local function AmbientThink()
	if ENDROUND or not LocalPlayer():IsValid() then
		return
	end

	local team = LocalPlayer():Team()

	if team == TEAM_HUMAN then
		LocalPlayer():EmitSound(RandomAmbientSounds[math.random(1, #RandomAmbientSounds)] , math.random(50,100), math.random(80,120))
	end
	
	--Reset timer
	timer.Simple(30 + math.random(30), AmbientThink)
end

--timer.Create( "AmbientThink", 10, 0, AmbientThink )
timer.Simple(5, AmbientThink)
--hook.Add("Think", "AmbientThink", AmbientThink)