AddCSLuaFile("cl_compass.lua")

util.AddNetworkString("UpdateCompass")

local CachedCrates

local function UpdateCompass(SupplyCrates, pl)
	if SupplyCrates then
		--Cache for late spawners
		CachedCrates = SupplyCrates
	else
		--Get from cache
		if not CachedCrates or #CachedCrates == 0 then
			return
		end

		SupplyCrates = CachedCrates
	end

	net.Start("UpdateCompass")
	net.WriteInt(#SupplyCrates, 32)
	if #SupplyCrates > 0 then
		for i=1,#SupplyCrates do
			local Crate = SupplyCrates[i]
			if not IsValid(Crate) then
				continue
			end

			net.WriteVector(Crate:GetPos())
		end
	end

	if IsValid(pl) then
		net.Send(pl)
		Debug("[COMPASS] Sending ".. #SupplyCrates .." Supply Crates to ".. tostring(pl))
	else
		net.Broadcast()
		Debug("[COMPASS] Broadcasted ".. #SupplyCrates .." Supply Crates")
	end
end
hook.Add("SpawnedSupplyCrates", "UpdateCompass", UpdateCompass)
hook.Add("RemovedSupplyCrates", "UpdateCompass", function()
	UpdateCompass({})
end)
hook.Add("PlayerReady", "UpdateCompassOnSpawn", function(pl)
	UpdateCompass(nil, pl)
end)