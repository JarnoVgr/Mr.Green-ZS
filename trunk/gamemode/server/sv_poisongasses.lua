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