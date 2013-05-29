--MAPCODER FILE
--zs_fortress

-- Few checks so it wont rebuild cache each time it changes
if not TranslateMapTable[ game.GetMap() ] then
	return
end
if game.GetMap() ~= "zs_fortress" then
	return
end

--Make map darker
--timer.Simple(1,function() engine.LightStyle(0,"b") end)
if SERVER then
	hook.Add("InitPostEntity", "MapC_Init", function()
		--[[env_skypaint = ents.Create("env_skypaint")
		env_skypaint:Spawn()
		env_skypaint:Activate()
	
		env_skypaint:SetTopColor(Vector(0,0,0))
		env_skypaint:SetBottomColor(Vector(0,0,0))
		env_skypaint:SetDuskIntensity(0)
		env_skypaint:SetSunColor(Vector(0,0,0))
		env_skypaint:SetStarScale(1.1)
	
		game.ConsoleCommand("sv_skyname painted\n")]]

		engine.LightStyle(0,"b")
	end)
end
--[[
if CLIENT then
	--Probably not working because map lacks env_fog_controller
	local function MapCAddNightFog()
		print("[MAPC] GOT ITTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT")

		render.FogMode(MATERIAL_FOG_LINEAR) 
		render.FogStart(0)
		render.FogEnd(10000)
		render.FogMaxDensity(1)
		render.FogColor(0,0,0)

		return true
	end

	local function MapCAddNightFogSkybox(skyboxscale)
		render.FogMode(MATERIAL_FOG_LINEAR) 
		render.FogStart(0*skyboxscale)
		render.FogEnd(10000*skyboxscale)
		render.FogMaxDensity(1)
		render.FogColor(0,0,0)

		return true
	end

	local createdFog = false
	
	hook.Add("Think","MapC_Think",function()
		if createdFog then
			return
		end
	
		createdFog = true
	
		hook.Add( "SetupWorldFog","MapC_AddNightFog", MapCAddNightFog )
		hook.Add( "SetupSkyboxFog","MapC_AddNightFogSkybox", MapCAddNightFogSkybox )	

		print("[MAPC] ADDED FOG")
	end)
end]]