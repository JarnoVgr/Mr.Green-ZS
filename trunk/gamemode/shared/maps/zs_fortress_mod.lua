--MAPCODER FILE
--zs_fortress_mod

-- Few checks so it wont rebuild cache each time it changes
if (game.GetMap() ~= "zs_fortress_mod") or (not TranslateMapTable[game.GetMap()]) then
	return
end


--[[
function Fog:FindFogEntity( bDontCreate )
	local k, v
	
	for k, v in ipairs( ents.GetAll( ) ) do
		if v:GetClass( ) == "env_fog_controller" then
			print("[FOGWRAPPER] Found env_fog_Controller")
			self._ent = v
			break
		end
	end
	
	if not bDontCreate and not self._ent:IsValid( ) then
		print("[FOGWRAPPER] Created env_fog_controller")
		v = ents.Create( "env_fog_controller" )
		v:Spawn()
		v:Activate()
		self._ent = v
	end
end]]

--Make map darker
--timer.Simple(1,function() engine.LightStyle(0,"b") end)
if SERVER then
	hook.Add("InitPostEntity", "MapC_Init", function()
		env_skypaint = ents.Create("env_skypaint")
		env_skypaint:Spawn()
		env_skypaint:Activate()
	
		env_skypaint:SetTopColor(Vector(0,0,0))
		env_skypaint:SetBottomColor(Vector(0,0,0))
		env_skypaint:SetDuskIntensity(0)
		env_skypaint:SetSunColor(Vector(0,0,0))
		env_skypaint:SetStarScale(1.1)
	
		game.ConsoleCommand("sv_skyname painted\n")

		engine.LightStyle(0,"b")
	end)
end

if CLIENT then
	local fogEnd = 4000 --10000

	--Probably not working because map lacks env_fog_controller
	local function MapCAddNightFog()
		render.FogMode(MATERIAL_FOG_LINEAR) 
		render.FogStart(0)
		render.FogEnd(fogEnd)
		render.FogMaxDensity(1)
		render.FogColor(0,0,0)

		return true
	end

	local function MapCAddNightFogSkybox(skyboxscale)
		render.FogMode(MATERIAL_FOG_LINEAR) 
		render.FogStart(0*skyboxscale)
		render.FogEnd(fogEnd*skyboxscale)
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
end