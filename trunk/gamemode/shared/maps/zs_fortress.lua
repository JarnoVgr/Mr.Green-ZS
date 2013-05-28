-- Everything is in alpha fucking stage!

-- Few checks so it wont rebuild cache each time it changes
if not TranslateMapTable[ game.GetMap() ] then return end
if game.GetMap() ~= "zs_fortress" then return end
if not SERVER then return end


--Make map darker
--timer.Simple(1,function() engine.LightStyle(0,"b") end)
hook.Add("InitPostEntity", "ZS_Fortress_Init", function()
	engine.LightStyle(0,"b")
end)

