-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AmmoDropPoints = { X = {}, Y = {}, Z = {}, Switch = {}, ID = {} }
RealCrateSpawns = {}
FullCrateSpawns = {}

local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg

local function AddCratesToPVS( pl )
	
	for _, pos in ipairs(RealCrateSpawns) do
		AddOriginToPVS( pos )
	end
end


function GM:SetCrates()
	local filename = "zombiesurvival/crates/".. game.GetMap() ..".txt"
	
	if file.Exists(filename,"DATA") then
		local tbl = util.JSONToTable(file.Read(filename))
		
		for i,stuff in pairs(tbl) do
			local minitable = { pos = Vector ( stuff.Pos[1] or 0, stuff.Pos[2] or 0,  stuff.Pos[3] or 0 ), switch = tobool ( stuff.Switch )}
			local minitable2 = Vector ( stuff.Pos[1] or 0, stuff.Pos[2] or 0,  stuff.Pos[3] or 0 )
			table.insert(FullCrateSpawns,minitable)
			table.insert(RealCrateSpawns,minitable2)
		end
		
		hook.Add( "SetupPlayerVisibility", "AddCratesToPVS", AddCratesToPVS )
		
		print("-< Loaded Crate Spawnpoints! >-")
	end
end

function ConvertOldCratesToNew(pl,cmd,args)
	if not pl:IsAdmin() then return end
	
	for i, filename in ipairs(file.Find("zombiesurvival/gamemode/server/maps/ammobox/*.lua","lsv")) do
		local tbl = {}
		
		-- print("Found file: "..filename)
		
		AmmoDropPoints = { X = {}, Y = {}, Z = {}, Switch = {}, ID = {} }
		include( "zombiesurvival/gamemode/server/maps/ammobox/"..filename ) 
		
		if #AmmoDropPoints["X"] > 0 then 
			for i,j in pairs ( AmmoDropPoints["X"] ) do
				local P = { Pos = {AmmoDropPoints.X[i] or 0, AmmoDropPoints.Y[i] or 0, AmmoDropPoints.Z[i] or 0}, Switch = tobool ( AmmoDropPoints.Switch[i] )}
				table.insert(tbl,P)
			end
		end
		
		local output = string.gsub(filename,".lua",".txt")
		
		file.Write( "zombiesurvival/crates/"..output,util.TableToJSON(tbl or {}) )
		
		
	end
	AmmoDropPoints = { X = {}, Y = {}, Z = {}, Switch = {}, ID = {} }
	
	pl:ChatPrint("All old spawns were successfully converted!")
end
concommand.Add("zs_convertcrates",ConvertOldCratesToNew)

function ImportCratesFromClient(pl,cmd,args)
	if not pl:IsAdmin() or not args then
		return
	end
		
	ImportCrateFile = ImportCrateFile or nil
	ImportCrateTable = ImportCrateTable or {}
	
	local name = args[1]
	local data = args[2]
	
	local fixed = string.gsub(data,"'","\"")
	
	local decoded = util.JSONToTable(fixed)
	
	ImportCrateFile = name
	table.insert(ImportCrateTable,decoded)
end
concommand.Add("zs_importcrates",ImportCratesFromClient)

function ConfirmCratesFromClient(pl,cmd,args)
	if not pl:IsAdmin() or not ImportCrateFile then
		return
	end
	
	file.Write( "zombiesurvival/crates/"..ImportCrateFile..".txt",util.TableToJSON(ImportCrateTable or {}) )
	
	ImportCrateFile = nil
	ImportCrateTable = {}
	
	pl:ChatPrint("Successfully imported map file!")	
end
concommand.Add("zs_importcrates_confirm",ConfirmCratesFromClient)

-- Copy all positions so we can use them later
if #AmmoDropPoints["X"] > 0 then 
	for i,j in pairs ( AmmoDropPoints["X"] ) do
		local P = Vector ( AmmoDropPoints.X[i] or 0, AmmoDropPoints.Y[i] or 0, AmmoDropPoints.Z[i] or 0 )
		-- table.insert(RealCrateSpawns,P)
	end
end
PrintTable(RealCrateSpawns)

if #AmmoDropPoints["X"] > 0 then 
	for i,j in pairs ( AmmoDropPoints["X"] ) do
		local P = { pos = Vector ( AmmoDropPoints.X[i] or 0, AmmoDropPoints.Y[i] or 0, AmmoDropPoints.Z[i] or 0 ), switch = tobool ( AmmoDropPoints.Switch[i] ), id = AmmoDropPoints.ID[i]}
		-- table.insert(FullCrateSpawns,P)
	end
end
PrintTable(FullCrateSpawns)

--[==[-------------------------------------------------------------
      Manage player +USE on the ammo supply boxes
--------------------------------------------------------------]==]
local function OnPlayerUse(pl, key)
	--Ignore all keys but IN_USE
	if key ~= IN_USE then
		return
	end
	
	--Is our player valid
	if not ValidEntity ( pl ) then
		return
	end
	
	--Check if player is zombie
	if pl:Team() ~= TEAM_HUMAN then
		return
	end
		
	--Main use trace
	local vStart = pl:GetShootPos()
	local tr = util.TraceLine ( { start = vStart, endpos = vStart + ( pl:GetAimVector() * 90 ), filter = pl, mask = MASK_SHOT } )
	local entity = tr.Entity
	
	--Check for valid entity
	if not IsValid(entity) then
		return
	end
	
	--Check if not ammo crate
	if not entity.AmmoCrate then
		return
	end
	
	-- end this if the entity has no owner or isn't the parent
	local Parent = entity:GetOwner()
	
	if entity:GetClass() ~= "spawn_ammo" and entity:GetClass() ~= "prop_physics" then
		return
	end
	
	if entity:GetClass() == "prop_physics" and ( Parent == NULL or ( IsValid ( Parent ) and Parent:GetClass() ~= "spawn_ammo" ) ) then
		return
	end
	
	--Prevent using supplies when fighting, unless it's the latest wave
	--[[if GAMEMODE:GetFighting() and GAMEMODE:GetWave() ~= 6 then
		if not pl.SupplyMessageTimer then
			pl.SupplyMessageTimer = 0
		end
		
		if pl.SupplyMessageTimer <= CurTime() then 
			pl:Message("Wait till end of wave for supplies", 1, "white") 
			pl.SupplyMessageTimer = CurTime() + 3.1
		end
		
		return
	end]]
	
	--Open shop menu
	pl:SendLua("DoSkillShopMenu()")
	
	--Debug
	Debug("[CRATES] ".. tostring (pl) .." used Supply Crate")
end
hook.Add("KeyPress", "KeyPressedHook", OnPlayerUse)

--[==[-------------------------------------------------------------
      Disable default use for the parent entity
--------------------------------------------------------------]==]
local function DisableDefaultUseOnSupply ( pl, entity )
	if ValidEntity ( entity ) and entity:GetClass() == "spawn_ammo" then return false end
end
hook.Add ( "PlayerUse", "DisableUseOnSupply", DisableDefaultUseOnSupply )

--[==[-------------------------------------------------------------
            Used to spawn the Supply Crate
--------------------------------------------------------------]==]
function SpawnSupply ( ID, Pos, Switch )
	ID, Pos, Switch = ID or 1, Pos or Vector ( 0,0,0 ), Switch or false

	-- Create the entity, set it's ID, switch bool and position
	local Crate = ents.Create("spawn_ammo")
	Crate.ID, Crate.Switch = ID, tobool ( Switch )
	Crate:SetPos ( Pos )
	Crate:Spawn()
end

--[==[-------------------------------------------------------------
		TODO: Move to shared utils. 
--------------------------------------------------------------]==]
function ClampWorldVector ( vec )
	vec.x = math.Clamp( vec.x , -16380, 16380 )
	vec.y = math.Clamp( vec.y , -16380, 16380 )
	vec.z = math.Clamp( vec.z , -16380, 16380 )
	
	return vec
end

--[==[-------------------------------------------------------------
      Used to check if there's something in that spot 
	      and delete it if it's small enough
--------------------------------------------------------------]==]
local function TraceHullSupplyCrate(Pos, Switch)
	-- Check to see if the spawn area isn't blocked
	local TraceHulls = { 
		[1] = { Mins = Vector (-20,-33,0), Maxs = Vector ( 20, 33, 56 ) }, --  Vector (-30,-35,56), Maxs = Vector ( 25, 40, 0 ) },
		[2] = { Mins = Vector (-33,-20,0), Maxs = Vector ( 33, 20, 56 ) }, -- Vector (-35,-30,56), Maxs = Vector ( 40, 25, 0 ) },
	}
	
	local Position = 1
	if Switch == false then Position = 2 end
	
	-- Filters (to delete)
	local Filters = { "vial", "mine", "nail", "gib", "supply", "turret", "spawn_ammo", "func_brush", "breakable", "player","weapon" } -- func brush shit
	
	-- Find them in box
	-- local Ents, Found = ents.FindInBox ( ClampWorldVector ( Pos + TraceHulls[Position].Mins ), ClampWorldVector ( Pos + TraceHulls[Position].Maxs ) ), 0
	local Ents, Found = ents.FindInBox ( ClampWorldVector ( Pos + TraceHulls[Position].Mins ), ClampWorldVector ( Pos + TraceHulls[Position].Maxs ) ), 0
	for k,v in pairs ( Ents ) do
		local Phys = v:GetPhysicsObject()
		if ValidEntity ( Phys ) then
			if not v:IsPlayer() and v:GetClass() ~= "spawn_ammo" and v:GetClass() ~= "prop_physics_multiplayer" then 
				if v:OBBMins():Length() < TraceHulls[Position].Mins:Length() and v:OBBMaxs():Length() < TraceHulls[Position].Maxs:Length() or v:GetClass() == "prop_physics" then 
					Debug ( "Removing object "..tostring ( v ).." to make space for Supply Crate Spawn!" )
					v:Remove()
					Ents[k] = nil
				end
			end
		end
		
		if not ValidEntity ( Phys ) then
			Ents[k] = nil
		end
		
		for i,j in pairs ( Filters ) do
			if string.find ( v:GetClass(), j ) then
				Ents[k] = nil
			end
		end
	end
	
	-- We are blocked	
	if #Ents > 0 then return false end
	
	return true
end

function GM:CalculateSupplyDrops()
	if ENDROUND or #FullCrateSpawns < 1 then
		return
	end
	
	for k,v in ipairs(ents.FindByClass("spawn_ammo")) do
		if IsValid(v) then			
			v:Remove()
		end
	end
	
    -- Spawn them!
	timer.Simple ( 0.1, function()
		if ENDROUND or #FullCrateSpawns < 1 then
			return
		end
	
		self:SpawnCratesFromTable(FullCrateSpawns)
		
		--Tell clients about crates
		timer.Simple ( 0.05, function()
		    UpdateClientArrows()
		end)
	end)
end

local function SortByHumens(a, b)
	return a._Hum > b._Hum
end

function GM:GetClosestCrate(cratetable)
	if #cratetable > 0 then
		local tab = {}
		
		local humans = team.GetPlayers(TEAM_HUMAN)
		for _, hm in pairs(humans) do
			if IsValid(hm) and hm:Alive() then
					-- count humans
				hm._Hum = 0
				local buddies = team.GetPlayers(TEAM_HUMAN)-- ents.FindInSphere( hm:GetPos(), 700 )
				for k, bud in pairs(buddies) do
					if IsValid(bud) and bud:IsPlayer() and bud:Alive() and bud ~= hm and bud:IsHuman() and hm:GetPos():Distance(bud:GetPos()) <= 700 then
						hm._Hum = hm._Hum + 1
					end
				end
				table.insert(tab, hm)
			end
		end
		
		table.sort(tab, SortByHumens)
		
		-- we got the guy with most buddies around
		
		local luckyguy = tab[1]
		
		if luckyguy then
				
			local nearpos = luckyguy:GetPos()
			local Closest = 1000000
			-- local dist = 0
			local ind = 1
			
			for _, tbl in pairs(cratetable) do
				local pos = tbl.pos
				local dist = nearpos:Distance( pos )
				
				if dist < Closest then
					Closest = dist
					ind = _
				end
			end
			return cratetable[ind]
		
		end
		return cratetable[math.random(1,#cratetable)] or nil
	end
end

function GM:SpawnCratesFromTable(cratetable)
	local idTable = {}
	local tab = table.Copy(cratetable)
	
	table.Shuffle(tab)
	
	local maxcrates = math.min(#cratetable,MAXIMUM_CRATES)
	
	local crate = self:GetClosestCrate(cratetable)
	
	local SpawnPos,Switch,ID = crate.pos, tobool(crate.switch), crate.id
			
	if TraceHullSupplyCrate ( SpawnPos, Switch ) then
		SpawnSupply ( ID, SpawnPos, Switch )	
	end
	
	table.insert(idTable,ID)
	
	for i=1,maxcrates do
		if i~=1 then
			for ind, crt in pairs(tab) do
				local SpawnPos,Switch,ID = crt.pos, tobool(crt.switch), crt.id
				
				if not table.HasValue(idTable,ID) then	
					if TraceHullSupplyCrate ( SpawnPos, Switch ) then
						SpawnSupply ( ID, SpawnPos, Switch )
					end
					
					table.insert(idTable,ID)
					
					break
				end
			end
		end
	end
	Debug("[CRATES] Spawned Supply Crate")
end

-- Precache the gib models
for i = 1, 9 do
	util.PrecacheModel("models/items/item_item_crate_chunk0"..i..".mdl")
end

--Info
Debug( "[MODULE] Loaded Supply-Crates Director" )