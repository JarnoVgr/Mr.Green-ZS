-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

util.AddNetworkString( "cratemove" )

AmmoDropPoints = { X = {}, Y = {}, Z = {}, Switch = {}, ID = {} }
CrateSpawnsPositions = {}
AllCrateSpawns = {}

--Load crates from map file
function GM:SetCrates()
	local filename = "zombiesurvival/crates/".. game.GetMap() ..".txt"
	
	if file.Exists(filename,"DATA") then
		local tbl = util.JSONToTable(file.Read(filename))
		
		for i,stuff in pairs(tbl) do
			if not stuff.Pos then
				Debug("[DIRECTOR] Skipped loading Supply Crate due to missing Pos")
				continue
			end

			--Fix for possible missing Angles
			if not stuff.Angles then
				stuff.Angles = {}
			end

			local miniTable = {
				pos = Vector(stuff.Pos[1] or 0, stuff.Pos[2] or 0, stuff.Pos[3] or 0),
				angles = Angle(stuff.Angles[1] or 0, stuff.Angles[2] or 0, stuff.Angles[3] or 0),
				switch = false
			}
			table.insert(AllCrateSpawns,miniTable)
		end
				
		Debug("[DIRECTOR] Loaded Crate Spawnpoints")
	end
end

--Import crates
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

local function sortByItemPricing(a, b)
	return a.Price > b.Price
end

local function CalculateGivenSupplies(pl)
	if not ValidEntity(pl) or pl:Team() ~= TEAM_HUMAN then
		return
	end

	--Start with message
	pl:Message("You've been given Supplies", 1, "white")
	
	--Calculate what weapons to give away

	local Available = { Pistols = {}, Automatic = {}, Melee = {} }
	local PistolToGive, AutomaticToGive, MeleeToGive
	
	--Calculate and add every available weapon to table
	for itemClass, item in pairs(GAMEMODE.HumanWeapons) do
		if item.Restricted or not item.Price then
			continue
		end

		--Workaround for not having key
		item.Class = itemClass
		
		if GetWeaponType(itemClass) == "pistol" then
			table.insert(Available.Pistols, item)
		elseif GetWeaponType(itemClass) == "rifle" or GetWeaponType(itemClass) == "smg" or GetWeaponType(itemClass) == "shotgun" then
			table.insert(Available.Automatic, item)
		elseif GetWeaponType(itemClass) == "melee" then
			table.insert(Available.Melee, item)
		end
	end

	table.sort(Available.Pistols,sortByItemPricing)
	table.sort(Available.Automatic,sortByItemPricing)
	table.sort(Available.Melee,sortByItemPricing)
	
	--[[--------------------------- PISTOLS ----------------------------]]
	if #Available.Pistols >= 1 then
		local holdingItem = pl:GetPistol()

		for k, item in pairs(Available.Pistols) do
			--Skip when score is insufficient
			if (pl:GetScore() < item.Price)  then
				continue
			end			

			--Skip when we already have it
			if pl:HasWeapon(item.Class) or (holdingItem and IsValid(holdingItem) and ((GAMEMODE.HumanWeapons[holdingItem:GetClass()].Price or 0) >= item.Price)) then
				continue
			end

			--Drop current item
			if holdingItem and IsValid(holdingItem) then
				pl:StripWeapon(holdingItem:GetClass())
			end

			--Give new item
			PistolToGive = item.Class

			--Stop here
			break
		end
	end

	--[[--------------------------- AUTOMATIC GUNS ----------------------------]]
	if #Available.Automatic >= 1 then
		local holdingItem = pl:GetAutomatic()

		for k, item in pairs(Available.Automatic) do
			--Skip when score is insufficient
			if (pl:GetScore() < item.Price)  then
				continue
			end			

			--Skip when we already have it
			if pl:HasWeapon(item.Class) or (holdingItem and IsValid(holdingItem) and ((GAMEMODE.HumanWeapons[holdingItem:GetClass()].Price or 0) >= item.Price)) then
				continue
			end

			--Drop current item
			if holdingItem and IsValid(holdingItem) then
				pl:StripWeapon(holdingItem:GetClass())
			end

			--Give new item
			AutomaticToGive = item.Class

			--Stop here
			break
		end
	end
	
	--[[--------------------------- MELEE WEAPONS ----------------------------]]
	if #Available.Melee >= 1 then
		local holdingItem = pl:GetMelee()

		for k, item in pairs(Available.Melee) do
			--Skip when score is insufficient
			if (pl:GetScore() < item.Price)  then
				continue
			end			

			--Skip when we already have it
			if pl:HasWeapon(item.Class) or (holdingItem and IsValid(holdingItem) and ((GAMEMODE.HumanWeapons[holdingItem:GetClass()].Price or 0) >= item.Price)) then
				continue
			end

			--Drop current item
			if holdingItem and IsValid(holdingItem) then
				pl:StripWeapon(holdingItem:GetClass())
			end

			--Give new item
			MeleeToGive = item.Class

			--Stop here
			break
		end
	end

	--Active weapon
	local ActiveWeapon = pl:GetActiveWeapon()
	if ValidEntity(ActiveWeapon) then
		ActiveWeapon = ActiveWeapon:GetClass()
	end
	
	--Give the weapons ( in order - Melee, Pistol, Automatic )
	if MeleeToGive ~= nil and not pl:HasWeapon(MeleeToGive) then 
		pl:Give(MeleeToGive)
		pl:SelectWeapon(MeleeToGive)
	end
	
	if PistolToGive ~= nil and not pl:HasWeapon(PistolToGive) then 
		pl:Give(PistolToGive)
		pl:SelectWeapon(PistolToGive)
	end
	
	if AutomaticToGive ~= nil and not pl:HasWeapon(AutomaticToGive) then
		pl:Give(AutomaticToGive)
		pl:SelectWeapon(AutomaticToGive) 
	end
	
	--skillpoints.AddSkillPoints(pl, -1*GAMEMODE.HumanWeapons[weapon].Price)
	
	--[[--------------------------- AMMUNITION ----------------------------]]
	--local AmmoList = {"pistol", "ar2", "smg1", "buckshot", "xbowbolt", "357", "slam", "grenade", "Battery"}
	for ammoType, ammoAmount in pairs(GAMEMODE.AmmoRegeneration) do
		--Double for ammoman upgrade
		--[[if pl:HasBought("ammoman") then
			ammoAmount = ammoAmount * 2
		end]]
if pl:HasBought("ammoman") then
			ammoAmount = ammoAmount * 2 --Ammo man perk
		end
		--Multiply with Infliction
		--ammoAmount = math.Round(ammoAmount * (GetInfliction() + 0.5))
		ammoAmount = math.Round(ammoAmount * (GetInfliction() + 0.9))
		
		pl:GiveAmmo(math.Clamp(ammoAmount, 1, 250), ammoType)
	end
	
	--Special case : mines, nailing hammers, barricade kits
	--local Special = { "weapon_zs_barricadekit" , "weapon_zs_tools_hammer", "mine", "grenade", "syringe", "supplies"}
	--[[local Special = { "mine", "syringe", "supplies"}
	for i,j in pairs ( pl:GetWeapons() ) do
		for k,v in pairs ( Special ) do
			if not string.find ( j:GetClass(), v ) then
				continue
			end
			
			local MaximumAmmo = j.Primary.DefaultClip
			
			if v == "weapon_zs_tools_hammer" then MaximumAmmo = j.MaximumNails 
				j:SetClip2( 1 )
			end
			
			if v == "weapon_zs_tools_hammer" or v == "syringe" then
				j:SetClip1( math.Clamp ( MaximumAmmo, 1, MaximumAmmo ) )
			else
				j:SetClip1( math.Clamp ( j:Clip1() + math.ceil( MaximumAmmo/2 ), 1, MaximumAmmo ) )
			end
		end
	end]]
	
	--[[--------------------------- HEALTH ----------------------------]]
	local currentHealth, maxHealth, healAmount = pl:Health(), pl:GetMaximumHealth(), 0
	if currentHealth < maxHealth then
		--healAmount = math.Round((maxHealth - currentHealth) * GetInfliction())
		healAmount = 25 --Duby:Static health works better and zombies will not rage quit when a human gains 80 hp from a crate..
	end
	
	if healAmount > 5 then
		pl:EmitSound(Sound("items/smallmedkit1.wav"))
		pl:SetHealth(math.Clamp(currentHealth + healAmount, 0, maxHealth))
		pl:PrintMessage ( HUD_PRINTTALK, "[CRATES] You just got ammunition for your weapons and tools and restored "..math.Round ( healAmount ).." health!" )
		
		--Clear dot damage
		pl:ClearDamageOverTime()
	end
	
	--Play voice
	if math.random(1,4) == 1 then
		local snd = VoiceSets[pl.VoiceSet].SupplySounds
		timer.Simple( 0.2, function ()
			if ValidEntity(pl) then
				pl:EmitSound(Sound(snd[math.random(1, #snd)]))
			end
		end, pl)
	end
	
	--Debug
	--Debug("[CRATES] Given supplies to ".. tostring(pl))
end

--[==[-------------------------------------------------------------
      Manage player +USE on the ammo supply boxes
--------------------------------------------------------------]==]
local function OnPlayerUse(pl, key)
	--Ignore all keys but IN_USE
	if key ~= IN_USE or not ValidEntity(pl) then
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
	
	if entity:GetClass() ~= "game_supplycrate" and entity:GetClass() ~= "prop_physics" then
		return
	end
	
	if entity:GetClass() == "prop_physics" and ( Parent == NULL or ( IsValid ( Parent ) and Parent:GetClass() ~= "game_supplycrate" ) ) then
		return
	end
		
	--Open shop menu
	--pl:SendLua("DoSkillShopMenu()")
	
	--Give weap0nz
	if not pl.SupplyMessageTimer then
		pl.SupplyMessageTimer = 0
	end

	--Don't allow supplies early in the game	
	if (pl.NextSupplyUse or 0) > CurTime() then
		if pl.SupplyMessageTimer <= CurTime() then
			pl:Message("There are no Supplies available now", 1, "white")
			pl.SupplyMessageTimer = CurTime() + 3.1
		end
		
		return
	end
	
	pl:EmitSound(Sound("mrgreen/supplycrates/mobile_use.mp3"))
	CalculateGivenSupplies(pl)

	--Cooldown
	local nextUseDelay = math.Round(SUPPLYCRATE_RECHARGE_TIME + ((1 - GetInfliction()) * 10))
	pl.NextSupplyUse = CurTime() + nextUseDelay
	pl:SendLua("MySelf.NextSupplyTime = ".. pl.NextSupplyUse)
	
	--Debug
	Debug("[CRATES] ".. tostring(pl) .." used Supply Crate")
end
hook.Add("KeyPress", "UseKeyPressedHook", OnPlayerUse)

--[==[-------------------------------------------------------------
      Disable default use for the parent entity
--------------------------------------------------------------]==]
local function DisableDefaultUseOnSupply(pl, entity)
	if ValidEntity(entity) and entity:GetClass() == "game_supplycrate" then
		return false
	end
end
hook.Add("PlayerUse", "DisableUseOnSupply", DisableDefaultUseOnSupply)

--[==[-------------------------------------------------------------
            Used to spawn the Supply Crate
--------------------------------------------------------------]==]
function SpawnSupply(ID, Pos, Angles)
	ID, Pos = ID or 1, Pos or Vector ( 0,0,0 ), Angles or Vector(0,0,0)

	-- Create the entity, set it's ID, position and angles
	local Crate = ents.Create("game_supplycrate")
	Crate.ID = ID
	Crate:SetPos(Pos)
	Crate:SetAngles(Angles)
	Crate:Spawn()
	
	return Crate

	
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
	local Filters = {"vial", "mine", "nail", "gib", "supply", "turret", "game_supplycrate", "func_brush", "breakable", "player", "weapon"}
	
	-- Find them in box
	local Ents, Found = ents.FindInBox(ClampWorldVector(Pos + TraceHulls[Position].Mins), ClampWorldVector(Pos + TraceHulls[Position].Maxs)), 0
	for k,v in pairs ( Ents ) do
		local Phys = v:GetPhysicsObject()
		if ValidEntity(Phys) then
			if not v:IsPlayer() and v:GetClass() ~= "game_supplycrate" and v:GetClass() ~= "prop_physics_multiplayer" then 
				if v:OBBMins():Length() < TraceHulls[Position].Mins:Length() and v:OBBMaxs():Length() < TraceHulls[Position].Maxs:Length() or v:GetClass() == "prop_physics" then 
					Debug("[CRATES] Removing object ".. tostring(v) .." to make space" )
					v:Remove()
					Ents[k] = nil
				end
			end
		end
		
		if not ValidEntity(Phys) then
			Ents[k] = nil
		end
		
		for i,j in pairs(Filters) do
			if string.find(v:GetClass(), j) then
				Ents[k] = nil
			end
		end
	end
	
	-- We are blocked	
	if #Ents > 0 then
		return false
	end
	
	return true
end

function GM:CalculateSupplyDrops()
	--Check if we should calculate crates
	if ENDROUND or #AllCrateSpawns < 1 then
		return
	end
		
	--Spawn crates
	self:SpawnCratesFromTable(AllCrateSpawns)
end

local function SortByHumens(a, b)
	return a._Hum > b._Hum
end

function GM:SpawnCratesFromTable(crateSpawns,bAll)
	--Remove current supplies
	for k,v in ipairs(ents.FindByClass("game_supplycrate")) do
		if IsValid(v) then			
			v:Remove()
		end
	end
	
	local idTable = {}
	
	--Get crate table and shuffle it
	--local tab = table.Copy(crateSpawns)
	--table.Shuffle(tab)
	
	table.Shuffle(crateSpawns)
	
	local maxCrates = math.min(#crateSpawns,MAXIMUM_CRATES)
	if bAll then
		maxCrates = #crateSpawns
	end
	
	local spawnedCratesCount = 0
	
	--Loop through crate requests
	for i=1,maxCrates do
		--Loop through crate spawns
		for crateSpawnID, crateSpawn in pairs(crateSpawns) do			
			if not table.HasValue(idTable,crateSpawnID) then	
				if TraceHullSupplyCrate(crateSpawn.pos, false) then
					crateSpawn.ent = SpawnSupply(crateSpawnID, crateSpawn.pos, crateSpawn.angles)
					
					--Add to table to prevent it being used again
					table.insert(idTable,crateSpawnID)
					
					--Add crate position to easy-position table
					local miniPositionTable = Vector(crateSpawn.pos.x or 0, crateSpawn.pos.y or 0, crateSpawn.pos.z or 0)
					table.insert(CrateSpawnsPositions,miniPositionTable)
					
					--Increase count					
					spawnedCratesCount = spawnedCratesCount + 1
					
					break
				end
			end
		end
	end
	
	Debug("[DIRECTOR] Spawned ".. tostring(spawnedCratesCount) .."/".. tostring(maxCrates) .." Supply Crate(s)")
	
	
	
--[=[----------------------------------------------------------------------
     Dubys amazing method to the new crate!!
---------------------------------------------------------------------------]=]
--Duby: Its not the best method, but it works well! ^^
		--timer.Simple(30, function() --Remove the crate.
		timer.Simple(600, function() --Remove the crate.
	ents.FindByClass( "game_supplycrate" )[1]:Remove()
	ents.FindByClass( "game_supplycrate" )[2]:Remove()
--PrintMessage( HUD_PRINTCENTER, "The crate has moved! !" )
umsg.Start("cratemove")
		umsg.End()	
	end)
	
	
	--timer.Simple(500, function() --Add the crate.
	timer.Simple(605, function() --Add the crate.
	for i=1,maxCrates do
		--Loop through crate spawns
		for crateSpawnID, crateSpawn in pairs(crateSpawns) do			
			if not table.HasValue(idTable,crateSpawnID) then	
				if TraceHullSupplyCrate(crateSpawn.pos, false) then
					crateSpawn.ent = SpawnSupply(crateSpawnID, crateSpawn.pos, crateSpawn.angles)
					
					--Add to table to prevent it being used again
					table.insert(idTable,crateSpawnID)
					
					--Add crate position to easy-position table
					local miniPositionTable = Vector(crateSpawn.pos.x or 0, crateSpawn.pos.y or 0, crateSpawn.pos.z or 0)
					table.insert(CrateSpawnsPositions,miniPositionTable)
					
					--Increase count					
					spawnedCratesCount = spawnedCratesCount + 1
					
					break
				end
			end
		end
	end
	
	Debug("[DIRECTOR] Spawned ".. tostring(spawnedCratesCount) .."/".. tostring(maxCrates) .." Supply Crate(s)")
	
	end)
	
	timer.Simple(1200, function() --Remove the crate.
	ents.FindByClass( "game_supplycrate" )[1]:Remove()
	ents.FindByClass( "game_supplycrate" )[2]:Remove()
--PrintMessage( HUD_PRINTCENTER, "The crate has moved! !" )
umsg.Start("cratemove")
		umsg.End()	
	end)
	
	timer.Simple(1205, function() --Reset the crate spawn loctions. Also change the crate ID's again.
--Remove current supplies
	for k,v in ipairs(ents.FindByClass("game_supplycrate")) do
		if IsValid(v) then			
			v:Remove()
		end
	end
	
	local idTable = {}
	
	--Get crate table and shuffle it
	--local tab = table.Copy(crateSpawns)
	--table.Shuffle(tab)
	
	table.Shuffle(crateSpawns)
	
	local maxCrates = math.min(#crateSpawns,MAXIMUM_CRATES)
	if bAll then
		maxCrates = #crateSpawns
	end
	
	local spawnedCratesCount = 0
	
	--Loop through crate requests
	for i=1,maxCrates do
		--Loop through crate spawns
		for crateSpawnID, crateSpawn in pairs(crateSpawns) do			
			if not table.HasValue(idTable,crateSpawnID) then	
				if TraceHullSupplyCrate(crateSpawn.pos, false) then
					crateSpawn.ent = SpawnSupply(crateSpawnID, crateSpawn.pos, crateSpawn.angles)
					
					--Add to table to prevent it being used again
					table.insert(idTable,crateSpawnID)
					
					--Add crate position to easy-position table
					local miniPositionTable = Vector(crateSpawn.pos.x or 0, crateSpawn.pos.y or 0, crateSpawn.pos.z or 0)
					table.insert(CrateSpawnsPositions,miniPositionTable)
					
					--Increase count					
					spawnedCratesCount = spawnedCratesCount + 1
					
					break
				end
			end
		end
	end
	
	Debug("[DIRECTOR] Spawned ".. tostring(spawnedCratesCount) .."/".. tostring(maxCrates) .." Supply Crate(s)")
	
	
	end)
	
	

	
	
end

-- Precache the gib models
for i = 1, 9 do
	util.PrecacheModel("models/items/item_item_crate_chunk0"..i..".mdl")
end

--Info
Debug("[MODULE] Loaded Supply-Crates Director")