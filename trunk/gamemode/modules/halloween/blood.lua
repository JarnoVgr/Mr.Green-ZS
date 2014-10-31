--[[---------------------------------------------------------
   Register the convars that will control this effect
-----------------------------------------------------------]]
local pp_tickrate = CreateClientConVar( "pp_snow_tickrate", "0.5", true, false )

local pp_snow = CreateClientConVar( "pp_snow", "1", false, false )
local pp_snow_radius = CreateClientConVar( "pp_snow_radius", "512", false, false )
local pp_snow_magnitude = CreateClientConVar( "pp_snow_magnitude", "20", false, false )
local pp_snow_gravity = CreateClientConVar( "pp_snow_gravity", "-70", false, false )

local lasttick = 0

local texture_replacements = 
{
	"metastruct_2/grass",
	"gm_construct/grass",
	"nature/grassfloor002a",
	"nature/blendgrassgravel001a",
	"metastruct_2/blendgrass",
	"nature/blenddirtgrass008b_lowfriction",
	"metastruct_2/blend_mud_rock",
	"nature/blenddirtgrass005a",
	"nature/blendsandgrass008a",
	"nature/red_grass",
	"metastruct_2/blendg",
	"gm_construct/grass-sand",
	"nature/grassfloor002a_replacement",
	"nature/blendgrassgrass001a",
	"nature/blendsandgr",
	"gm_construct/flatgrass",
	"gm_construct/grass",
	"gm_construct/grass-sand_13",
	"gm_construct/flatgrass_2",
	"gm_construct/grass_13",
	"nature/blendsandsand008a",
	"gm_construct/grass-sand_13",
	"nature/blendsandrock004a",
	"nature/blendrocksand004a",
	"nature/blendgrassdirt01",
	"nature/blendgrassdirt02_noprop",
	"nature/blendsandsand008b_antlion",
	"nature/blenddirtgrass008b",
}

local materials = materials or {}

materials.Replaced = {}

function materials.ReplaceTexture(path, to)
	if check then check(path, "string") end
	if check then check(to, "string", "ITexture", "Material") end

	path = path:lower()

	local mat = Material(path)

	if not mat:IsError() then

		local typ = type(to)
		local tex

		if typ == "string" then
			tex = Material(to):GetTexture("$basetexture")
		elseif typ == "ITexture" then
			tex = to
		elseif typ == "Material" then
			tex = to:GetTexture("$basetexture")
		else return false end

		materials.Replaced[path] = materials.Replaced[path] or {}	

		materials.Replaced[path].OldTexture = materials.Replaced[path].OldTexture or mat:GetTexture("$basetexture")
		materials.Replaced[path].NewTexture = tex

		mat:SetTexture("$basetexture",tex) 

		return true
	end

	return false
end


function materials.SetColor(path, color)
	if check then check(path, "string") end
	if check then check(color, "Vector") end

	path = path:lower()

	local mat = Material(path)

	if not mat:IsError() then
		materials.Replaced[path] = materials.Replaced[path] or {}
		materials.Replaced[path].OldColor = materials.Replaced[path].OldColor or mat:GetVector("$color")
		materials.Replaced[path].NewColor = color

		mat:SetVector("$color", color)

		return true
	end

	return false
end

function materials.RestoreAll()
	for name, tbl in pairs(materials.Replaced) do
		if 
			not pcall(function()
				if tbl.OldTexture then
					materials.ReplaceTexture(name, tbl.OldTexture)
				end

				if tbl.OldColor then
					materials.SetColor(name, tbl.OldColor)
				end
			end) 
		then 
			print("Failed to restore: " .. tostring(name)) 
		end
	end
end
hook.Add("ShutDown", "material_restore", materials.RestoreAll)

local function ChangeMats()

	if (!materials) then return end
	
	local sky = 
	{
		"up",
		"dn",
		"lf",
		"rt",		
		"ft",
		"bk",
	}

	local sky_name = GetConVarString("sv_skyname")
							
	for _, path in pairs(sky) do	
		path = "skybox/" .. sky_name .. path
		materials.ReplaceTexture(path, "Decals/decal_paintsplatterpink001")
		materials.SetColor(path, Vector(0.9,1,0.9)*0.9)
	end

	for _, path in pairs(texture_replacements) do
		materials.ReplaceTexture(path, "NATURE/SNOWFLOOR001A")
		materials.SetColor(path, Vector(1, 1, 1) * (ms and 0.6 or 1.2))
	end
end

local function CheckOutdoor()
	if (!IsValid(LocalPlayer():GetViewEntity())) then
		return false
	end

	local pos = LocalPlayer():GetViewEntity():GetPos() 

	local tracedata = {}
		
		tracedata.filter = LocalPlayer():GetViewEntity()
		tracedata.start = pos
		tracedata.endpos = pos+Vector(pos.x,pos.y,99999)
		tracedata.mask = MASK_SOLID + CONTENTS_MOVEABLE
	local tr = util.TraceLine(tracedata)
		
	if (tr.HitSky) then
		return true
	elseif(tr.Hit) then
		return false
	end
	return true
end

local lasttick = -1
local function Snow()
	if (!lasttick or lasttick > CurTime()) then
		return
	end

	local PLAYER = LocalPlayer()
	PLAYER.IsOutdoor = CheckOutdoor()
	
	lasttick = CurTime() + tonumber(PLAYER:GetInfo("pp_snow_tickrate"))
		
	if (pp_snow:GetBool()) then
		--print("IsOutdoor: ".. tostring(PLAYER.IsOutdoor))
		ChangeMats()

		if (PLAYER.IsOutdoor) then
			local effect = EffectData()
				effect:SetOrigin( PLAYER:GetViewEntity():GetPos() )
				effect:SetMagnitude(tonumber(PLAYER:GetInfo("pp_snow_magnitude")))
				effect:SetScale(tonumber(PLAYER:GetInfo("pp_snow_gravity")))
				effect:SetRadius(tonumber(PLAYER:GetInfo("pp_snow_radius")))
			util.Effect("weather_blood", effect)
		end
	elseif (materials) then
		materials.RestoreAll()	
	end
end
hook.Add("Think", "SnowThink", Snow)