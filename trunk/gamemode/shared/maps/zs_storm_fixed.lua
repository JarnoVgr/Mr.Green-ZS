--MAPCODER FILE
--zs_fortress_mod

-- Few checks so it wont rebuild cache each time it changes
if game.GetMap() ~= "zs_storm_fixed" then
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
	--Props to pick randomly from
	local props = {
		"models/props_junk/PlasticCrate01a.mdl",
		"models/props_borealis/bluebarrel001.mdl",
		"models/props_c17/chair02a.mdl",
		"models/props_junk/wood_crate001a_damaged.mdl",
		"models/props_junk/wood_crate001a.mdl",
		"models/props_junk/wood_crate002a.mdl",
		"models/props_junk/MetalBucket01a.mdl",
		"models/props_vehicles/tire001b_truck.mdl",
		"models/props_vehicles/tire001c_car.mdl",
		"models/props_vehicles/apc_tire001.mdl",
		"models/props_junk/TrafficCone001a.mdl"
	}

	local function MapCInitEntities()
		--Paint skybox
		env_skypaint = ents.Create("env_skypaint")
		env_skypaint:Spawn()
		env_skypaint:Activate()
	
		env_skypaint:SetTopColor(Vector(0,0,0))
		env_skypaint:SetBottomColor(Vector(0,0,0))
		env_skypaint:SetDuskIntensity(0)
		env_skypaint:SetSunColor(Vector(0,0,0))
		env_skypaint:SetStarScale(1.1)
	
		--Set skybox
		game.ConsoleCommand("sv_skyname painted\n")

		--Set lighting style (make it more dark)
		engine.LightStyle(0,"b")

		--Spawn random props througout map
		local maxProps = math.random(30,40)
		for i=1,maxProps do
			local e = ents.Create("prop_physics")
			--X: -1300 to 1200
			e:SetPos(Vector(math.random(-1000,1000), math.random(-1425,702), 800))
			e:SetModel(props[math.random(1,#props)])
			e:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
			e:Spawn()
		end
		Debug("[MAPCODER] Spawned ".. maxProps .." props")
	end

	hook.Add("InitPostEntity", "MapC_InitEntities", MapCInitEntities)
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

		print("[MAPCODER] Created fog")
	end)
--[[
Model: models/player/mossman.mdl
Position: 104.405632 -673.995178 192.031250
Team: Survivors
***END DEBUG***
***DEBUG***
Name: Ywa
S]]
end