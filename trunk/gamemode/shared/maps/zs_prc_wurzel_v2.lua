--MAPCODER FILE
--zs_prc_wurzel_v2

-- Few checks so it wont rebuild cache each time it changes
if not TranslateMapTable[ game.GetMap() ] then
	return
end
if game.GetMap() ~= "zs_prc_wurzel_v2" then
	return
end

if SERVER then
	hook.Add("InitPostEntity", "MapC_Init", function()
		GAMEMODE:SetNightMode(true)
	end)
end