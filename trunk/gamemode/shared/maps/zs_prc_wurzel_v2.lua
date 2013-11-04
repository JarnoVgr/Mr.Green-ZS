--MAPCODER FILE
--zs_prc_wurzel_v2

-- Few checks so it wont rebuild cache each time it changes
if game.GetMap() ~= "zs_prc_wurzel_v2" or not TranslateMapTable[ game.GetMap() ] then
	return
end

--Used to be nightmode until it got removed