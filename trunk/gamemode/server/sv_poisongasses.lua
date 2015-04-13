PoisonGasses = PoisonGasses or {}

function MapPoisonGassesWrite()
	local path = "poisongasses/"..game.GetMap()..".txt"
	
	if #PoisonGasses <= 0 then 
		if file.Exists( path ) then
			file.Delete( path )
		end
		
		return 
	end

	local contentstring = "--Generated automatically\n"
	contentstring = "PoisonGasses = PoisonGasses or {}\n"
	
	for k, v in pairs( PoisonGasses ) do
		contentstring = contentstring.."table.insert( PoisonGasses, { origin = Vector( "..v.origin.x..","..v.origin.y..","..v.origin.z.." ), radius = "..v.radius.."} )\n"
	end
	
	file.Write( path, contentstring )
end	

ToxicTime = 0
ToxicWarningTime = 0
function GM:SpawnPoisonGasses()
	--Gasses
	local spawnedGasPositions = {}

	for _, spawn in pairs(team.GetSpawnPoint(TEAM_ZOMBIE)) do
		--local spawnPos = spawn[1]
		local spawnPos = spawn:GetPos()

		local blockEntSpawn = false
				
		--Don't place nearby Survivor spawnpoints
		for _, humanSpawn in pairs(team.GetSpawnPoint(TEAM_HUMAN)) do
			if humanSpawn:GetPos():Distance(spawnPos) < 272 then
				blockEntSpawn = true
				break
			end
		end
		if blockEntSpawn == true then
			continue
		end
			
		--Don't place nearby other gasses
		for _, gasPos in pairs(spawnedGasPositions) do
			if gasPos:Distance(spawnPos) < 128 then
				blockEntSpawn = true
				break
			end
		end
		if blockEntSpawn == true then
			continue
		end
			
		--Spawn gas
		local ent = ents.Create("zs_poisongasses")
		if ent:IsValid() then
			ent:SetPos(spawnPos)
			ent:Spawn()
			table.insert(spawnedGasPositions,spawnPos)
		end
	end
	
end

--[[ --I will fix this and integrate it into this system above perhaps..
-- Toxic damage
ToxicPoints = {}
ToxicTime = 0
ToxicWarningTime = 0
function ToxicDamager() 
	if ToxicTime > CurTime() then return end
	
	--Damage humans that enter toxic fumes, but don't kill them
	for _,pl in pairs ( team.GetPlayers( TEAM_HUMAN ) ) do
		if pl:IsInToxicFumes ( ToxicPoints ) then
			local MaxHealth = pl:GetMaximumHealth()
			if pl:Health() > MaxHealth * 0.15 then
				pl:TakeDamage ( MaxHealth * 0.05, nil, nil )
				pl:Message ("Stay out of the infected areas as they might get you killed!", 2, "white")
			end
		end
	end
	
	--Heal the undead within the toxic fumes
	for _,pl in pairs ( team.GetPlayers( TEAM_UNDEAD ) ) do
		if pl:IsInToxicFumes ( ToxicPoints ) then
			local MaxHealth = pl:GetMaximumHealth()
			if pl:Health() < MaxHealth then
				pl:SetHealth ( math.Clamp ( pl:Health() + ( MaxHealth * 0.25 ), 0, MaxHealth ) )
			end
		end
	end
	
	ToxicTime = CurTime() + 1
end
]]--