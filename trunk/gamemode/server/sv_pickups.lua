--Pickups!

PICKUP_WAVE = math.random(1,5)

MIN_PICKUPS = 2
MAX_PICKUPS = 7

GM.PickupsLocations = {}


GM.PickupsTable = {

	[1] = {
		OnSpawn = function(pos) 
					local pickup = CreatePickup("models/props_junk/garbage_milkcarton002a.mdl","_base",pos)
					return pickup
				end,
		OnUse = function(ent,a,c)
					local heal = ent.Activator:RestoreHumanHealth(math.random(5,14))
					if heal then
						ent:Remove()
					end
				end},
				
	[2] = {OnSpawn = function(pos) 
					local pickup = CreatePickup("models/Items/BoxSRounds.mdl","_base",pos)
					pickup:SetCollisionGroup(COLLISION_GROUP_WEAPON)
					return pickup
				end,
		OnUse = function(ent,a,c)
					ent.Activator:GiveAmmo(math.random(14,25),"pistol")
					ent:Remove()
				end},
				
	[3] = {OnSpawn = function(pos) 
					local pickup = CreatePickup("models/weapons/w_grenade.mdl","_base",pos)
					pickup:SetMaterial("models/debug/debugwhite")				
					return pickup
				end,
		OnUse = function(ent,a,c)
					if ent.Activator.CurrentWeapons["Misc"] < 1 then
						ent.Activator:Give("weapon_zs_pickup_flare")
						ent:Remove()
					end
				end},	
				
	[4] = {OnSpawn = function(pos) 
					local pickup = CreatePickup(nil,"pickup_gascan",pos,true)
					return pickup
				end},

	[5] = {OnSpawn = function(pos) 
					local pickup = CreatePickup(nil,"pickup_propane",pos,true)
					return pickup
				end},	

	[6] = {
		OnSpawn = function(pos) 
					local pickup = CreatePickup("models/props_junk/watermelon01.mdl","_base",pos)
					return pickup
				end,
		OnUse = function(ent,a,c)
					local heal = ent.Activator:RestoreHumanHealth(math.random(10,24))
					if heal then
						ent:Remove()
					end
				end},
				
	[7] = {
		OnSpawn = function(pos) 
					local pickup = CreatePickup(nil,"pickup_gasmask",pos,true)
					return pickup
				end},				

			
	
}


function GM:SpawnPickup(max)
	
	self:CalculateRandomLocations()
	
	max = max or #self.PickupsTable
	
	local maxpickups = max-- math.min(max,#self.PickupsTable)
	
	for count=1,maxpickups do
	
		local result = table.Random(self.PickupsTable)
		local spawn = table.Random(self.PickupsLocations)
		local pickup = result.OnSpawn(spawn)
		
		if result.OnUse then
			pickup.SetUse = function()
				result.OnUse(pickup)
			end
		end
		
		--PrintTable(result)
	end	
	
end

function GM:CalculateRandomLocations()
	
	self.PickupsLocations = {}
	
	local spawns = team.GetSpawnPoint(TEAM_HUMAN)
	
	--TODO: Fix code here.
	--local cratespawns = CrateSpawnsPositions or {}
	
	print("[PICKUPS] Check CalculateRandomLocations code")
	
	for i, spwn in pairs(spawns) do
		table.insert(self.PickupsLocations,spwn:GetPos()+Vector(VectorRand().x*40,VectorRand().y*40,math.random(50,90)))
	end
		
	for i, spwn in pairs(cratespawns) do
		table.insert(self.PickupsLocations,spwn+Vector(VectorRand().x*90,VectorRand().y*90,math.random(80,110)))
	end
	
	
	table.Shuffle(self.PickupsLocations)
	
end

function CreatePickup(mdl,name,pos,override)
	
	local pickup
	if override then
		pickup = ents.Create(name)
	else
		pickup = ents.Create("pickup_"..name)
		pickup:SetModel(mdl)
	end
		pickup:SetPos(pos)
		pickup:Spawn()
		--pickup:DropToFloor()
	
	return pickup
end

