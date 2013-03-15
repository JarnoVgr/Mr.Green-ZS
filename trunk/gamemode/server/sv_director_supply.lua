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
	
	if not pl:IsAdmin() then return end
	
	if not args then return end
	
	ImportCrateFile = ImportCrateFile or nil
	ImportCrateTable = ImportCrateTable or {}
	
	
	local name = args[1]
	local data = args[2]
	
	-- print("For map "..name)
	-- print("Received "..data)
	
	local fixed = string.gsub(data,"'","\"")
	
	local decoded = util.JSONToTable(fixed)
	
	ImportCrateFile = name
	table.insert(ImportCrateTable,decoded)
	

end
concommand.Add("zs_importcrates",ImportCratesFromClient)

function ConfirmCratesFromClient(pl,cmd,args)
	
	if not pl:IsAdmin() then return end
	
	if not ImportCrateFile then return end
	
	-- PrintTable(ImportCrateTable)
	
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

local function CalculateGivenSupplies ( pl )
	if not ValidEntity ( pl ) or pl:Team() ~= TEAM_HUMAN then return end
	
	-- Calculate what weapons to give away
	local Infliction = GetInfliction()
	
	local Available = { Pistols = {}, Automatic = {}, Melee = {}, Snipers = {} }
	local PistolToGive, AutomaticToGive, MeleeToGive
	
	-- Calculate and add every avaialable weapon to table
	for k,v in pairs ( GAMEMODE.HumanWeapons ) do
		if not v.Restricted then
		if GetInfliction() >= 0.6 then
			if Infliction >= v.Infliction and v.Infliction > Infliction - 0.65 then
				if GetWeaponType ( k ) == "pistol" then
					table.insert ( Available.Pistols, k ) 
				end
			end
		end
		
		if GetInfliction() >= 0.75 then		
			if Infliction >= v.Infliction and v.Infliction > Infliction - 0.25 then
				if GetWeaponType ( k ) == "rifle" or GetWeaponType ( k ) == "smg" or GetWeaponType ( k ) == "shotgun" then
					table.insert ( Available.Automatic, k )
				end
			end
		end	
			if GetWeaponType ( k ) == "melee" then
				table.insert ( Available.Melee, k )
			end
		end
	end
	
	--[==[--------------------------- PISTOLS ----------------------------]==]
	if #Available.Pistols >= 1 then
		local RandomPistol, Pistol = table.Random ( Available.Pistols ), pl:GetPistol()
		if not Pistol then PistolToGive = RandomPistol end
		
		-- Player has pistol, see if the one from the box is powerful than the one he has
		if Pistol then
			if pl:HasWeapon ( RandomPistol ) then
				RandomPistol = table.Random ( Available.Pistols )
			end
		
			if GAMEMODE.HumanWeapons[ RandomPistol ].DPS > GAMEMODE.HumanWeapons[ Pistol:GetClass() ].DPS then
				pl:StripWeapon ( Pistol:GetClass() ) 
				PistolToGive = RandomPistol
			end
		end
	end
	
	--[==[--------------------------- AUTOMATIC GUNS ----------------------------]==]
	if #Available.Automatic >= 1 then
		local RandomAutomatic, Automatic = table.Random ( Available.Automatic ), pl:GetAutomatic()
		if not Automatic then AutomaticToGive = RandomAutomatic end
		
		if Automatic then
			if pl:HasWeapon ( RandomAutomatic ) then
				RandomAutomatic = table.Random ( Available.Automatic )
			end
			
			if GAMEMODE.HumanWeapons[ RandomAutomatic ].DPS > GAMEMODE.HumanWeapons[ Automatic:GetClass() ].DPS then
				pl:StripWeapon ( Automatic:GetClass() ) 
				AutomaticToGive = RandomAutomatic
			end	
		end
	end
	
	--[==[--------------------------- MELEE WEAPONS ----------------------------]==]
	local RandomMelee, Melee = table.Random ( Available.Melee ), pl:GetMelee()
	local RandomMelee1 = { "weapon_zs_melee_pot","weapon_zs_melee_keyboard", "weapon_zs_melee_fryingpan", "weapon_zs_melee_plank" }
	if not Melee then MeleeToGive = table.Random ( RandomMelee1 ) end
	--[=[
	if Melee then
		if GAMEMODE.HumanWeapons[ RandomMelee ].DPS > GAMEMODE.HumanWeapons[ Melee:GetClass() ].DPS then
			pl:StripWeapon ( Melee:GetClass() ) 
			MeleeToGive = RandomMelee
		end	
	end
	]=]	
	-- Active weapon
	local ActiveWeapon = pl:GetActiveWeapon()
	if ValidEntity ( ActiveWeapon ) then ActiveWeapon = ActiveWeapon:GetClass() end
	
	-- Give the weapons ( in order - Melee, Pistol, Automatic )
	if MeleeToGive ~= nil then 
		if not pl:HasWeapon( MeleeToGive ) then
			pl:Give ( MeleeToGive ) 
		end
	end
	
	if PistolToGive ~= nil then 
		if not pl:HasWeapon ( PistolToGive ) then
			pl:Give ( PistolToGive )
			pl:SelectWeapon ( PistolToGive ) 
		end 
	end
	
	if AutomaticToGive ~= nil then 
		if not pl:HasWeapon ( AutomaticToGive ) then
			pl:Give ( AutomaticToGive ) 
			pl:SelectWeapon ( AutomaticToGive ) 
		end 
	end
	
	--[==[--------------------------- AMMUNITION ----------------------------]==]
	local AmmoList =  { "pistol", "ar2", "smg1", "buckshot", "xbowbolt", "357" }
	for k,v in pairs ( AmmoList ) do
		local HowMuch = GAMEMODE.AmmoRegeneration[v] or 50
		HowMuch = HowMuch * 0.8
		
		-- Double for ammoman upgrade
		if pl:HasBought ( "ammoman" ) then HowMuch = HowMuch * 2 end
		
		-- Double for infliction
		if Infliction >= 0.8 then HowMuch = HowMuch * 1.5 end
		pl:GiveAmmo ( math.Clamp ( HowMuch, 1, 250 ), v )
		
		if pl:GetHumanClass() == 5 then
		 if pl:GetTableScore("support","level") == 0 and pl:GetTableScore("support","achlevel0_1") < 25000 then
		  pl:AddTableScore ("support","achlevel0_1",math.Clamp ( HowMuch, 1, 250 ))
		  elseif pl:GetTableScore("support","level") == 1 and pl:GetTableScore("support","achlevel0_1") < 100000 then
		  pl:AddTableScore ("support","achlevel0_1",math.Clamp ( HowMuch, 1, 250 ))
		  
		 end
		
		end
	end
	
	-- Special case : mines, nailing hammers, barricade kits
	local Special = { "weapon_zs_barricadekit" , "weapon_zs_tools_hammer", "mine", "grenade", "syringe","supplies" }
	for i,j in pairs ( pl:GetWeapons() ) do
		for k,v in pairs ( Special ) do
			if string.find ( j:GetClass(), v ) then
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
		end
	end
	
	--[==[--------------------------- HEALTH ----------------------------]==]
	local CurrentHealth, MaxHealth, AmountHeal = pl:Health(), pl:GetMaximumHealth(), 0
	if CurrentHealth < MaxHealth then
		AmountHeal = ( MaxHealth - CurrentHealth ) * 0.6
	end
	
	if AmountHeal > 5 then
		pl:EmitSound ( Sound ("items/smallmedkit1.wav") )
		pl:SetHealth ( math.Clamp ( CurrentHealth + AmountHeal, 0, MaxHealth ) )
		pl:PrintMessage ( HUD_PRINTTALK, "[CRATES] You just got ammunition for your weapons and tools and restored "..math.Round ( AmountHeal ).." health!" )
		
		-- Clear dot damage
		pl:ClearDamageOverTime()
	end
	
	-- New perk requirements
	
	if pl:GetHumanClass() == 1 then
		if pl:GetTableScore("medic","level") == 0 and pl:GetTableScore("medic","achlevel0_2") < 100 then
		 pl:AddTableScore("medic","achlevel0_2",1)
		elseif pl:GetTableScore("medic","level") == 1 and pl:GetTableScore("medic","achlevel0_2") < 250 then
		 pl:AddTableScore("medic","achlevel0_2",1)
		elseif pl:GetTableScore("medic","level") == 2 and pl:GetTableScore("medic","achlevel2_2") < 1000 then
		 pl:AddTableScore("medic","achlevel2_2",math.Round(AmountHeal))
		elseif pl:GetTableScore("medic","level") == 3 and pl:GetTableScore("medic","achlevel2_2") < 2100 then
		 pl:AddTableScore("medic","achlevel2_2",math.Round(AmountHeal))		 
		end
	elseif pl:GetHumanClass() == 2 then	
		if pl:GetTableScore("commando","level") == 4 and pl:GetTableScore("commando","achlevel4_1") < 500 then
		 pl:AddTableScore("commando","achlevel4_1",1)
		elseif pl:GetTableScore("commando","level") == 5 and pl:GetTableScore("commando","achlevel4_1") < 1200 then
		 pl:AddTableScore("commando","achlevel4_1",1)
		end
	elseif pl:GetHumanClass() == 5 then
		if pl:GetTableScore("support","level") == 2 and pl:GetTableScore("support","achlevel2_2") < 300 then
		 pl:AddTableScore("support","achlevel2_2",1)
		elseif pl:GetTableScore("support","level") == 3 and pl:GetTableScore("support","achlevel2_2") < 1100 then
		 pl:AddTableScore("support","achlevel2_2",1)
		end
	
	
	end
		pl:CheckLevelUp()
	
	if math.random(1,6) == 1 then
	local snd = VoiceSets[pl.VoiceSet].SupplySounds
		timer.Simple ( 0.2, function ()
			if ValidEntity ( pl ) then pl:EmitSound(snd[math.random(1, #snd)]) end
		end, pl )
	end
	
	Debug ( "[CRATES] Giving supplies to "..tostring ( pl ) )
end

--[==[-------------------------------------------------------------
      Manage player +USE on the ammo supply boxes
--------------------------------------------------------------]==]
local function OnPlayerUse ( pl, key )
	if not ValidEntity ( pl ) then return end
	if key ~= IN_USE then return end
	
	-- Main use trace
	local vStart = pl:GetShootPos()
	local tr = util.TraceLine ( { start = vStart, endpos = vStart + ( pl:GetAimVector() * 90 ), filter = pl, mask = MASK_SHOT } )
	local entity = tr.Entity
	
	if not IsValid ( entity ) or pl:Team() ~= TEAM_HUMAN then return end
	
	if not entity.AmmoCrate then return end
	-- end this if the entity has no owner or isn't the parent
	local Parent = entity:GetOwner()
	if entity:GetClass() ~= "spawn_ammo" and entity:GetClass() ~= "prop_physics" then return end
	if entity:GetClass() == "prop_physics" and ( Parent == NULL or ( IsValid ( Parent ) and Parent:GetClass() ~= "spawn_ammo" ) ) then return end
	
	if GAMEMODE:GetFighting() then--  and GAMEMODE:GetWave() ~= 6 then 
	if not pl.SupplyMessageTimer then pl.SupplyMessageTimer = 0 end
		if pl.SupplyMessageTimer <= CurTime() then 
			pl:Message ("Wait for the end of wave to get supplies!", 1, "white") 
			pl.SupplyMessageTimer = CurTime() + 3.1 
		end
	return end
	
	pl:SendLua("DoSkillShopMenu()")
	
	Debug ( "[CRATES] "..tostring ( pl ).." used Supply Crate." )
end
hook.Add( "KeyPress", "KeyPressedHook", OnPlayerUse )

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
	local Crate = ents.Create ( "spawn_ammo" ) 
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
local function TraceHullSupplyCrate ( Pos, Switch )

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
	if ENDROUND then return end
	if #FullCrateSpawns < 1 then return end
	
	for k,v in ipairs ( ents.FindByClass( "spawn_ammo" ) ) do
		if IsValid(v) then			
			-- Remove sound
			WorldSound ( Sound ( "physics/wood/wood_crate_break"..math.random( 1,5 )..".wav" ), v:GetPos(), 150, 100 )
			v:Remove()
		end
	end
	
    -- Spawn them!
	timer.Simple ( 0.1, function()
		if ENDROUND then return end
		if #FullCrateSpawns < 1 then return end
	
		self:SpawnCratesFromTable(FullCrateSpawns)
		
		-- Tell client about crates
		timer.Simple ( 0.05, function() 
		    UpdateClientArrows() 
		end )
	end )
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
	Debug ( "[CRATES] Spawned Supply Crate." )
end

-- Precache the gib models
for i = 1, 9 do
	util.PrecacheModel ( "models/items/item_item_crate_chunk0"..i..".mdl" )
end


Debug ( "[MODULE] Loaded Supply-Crates Director." )