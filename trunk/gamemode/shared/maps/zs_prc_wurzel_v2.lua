--MAPCODER FILE
--zs_prc_wurzel_v2

AddCSLuaFile()

-- Few checks so it wont rebuild cache each time it changes
if game.GetMap() ~= "zs_prc_wurzel_v2" then
	return
end

MAPCODER_CLIENT_ACTIVE = true

--Used to be nightmode until it got removed