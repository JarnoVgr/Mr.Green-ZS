--MAPCODER FILE
--zs_the_pub_beta1

AddCSLuaFile()

-- Few checks so it wont rebuild cache each time it changes
if game.GetMap() ~= "zs_the_pub_beta1" then
	return
end

MAPCODER_CLIENT_ACTIVE = true

if SERVER then
	hook.Add("InitPostEntity", "MapC_Init", function()
		--Find or create fog entity
		Fog:FindFogEntity()

		env_skypaint = ents.Create("env_skypaint")
		env_skypaint:Spawn()
		env_skypaint:Activate()
	
		env_skypaint:SetTopColor(Vector(0,0,0))
		env_skypaint:SetBottomColor(Vector(0,0,0))
		env_skypaint:SetDuskIntensity(0)
		env_skypaint:SetSunColor(Vector(0,0,0))
		env_skypaint:SetStarScale(1.1)
	
		game.ConsoleCommand("sv_skyname painted\n")

		--timer.Simple(1,function() engine.LightStyle(0,"b") end)
	end)
elseif CLIENT then
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
	
		hook.Add("SetupWorldFog","MapC_AddNightFog", MapCAddNightFog)
		hook.Add("SetupSkyboxFog","MapC_AddNightFogSkybox", MapCAddNightFogSkybox)
	end)
end