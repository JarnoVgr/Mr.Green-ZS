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

	local placed = {}
	for _,ent in pairs(ents.FindByClass("zombiegasses")) do
		if ent and IsValid(ent) then
			local p, a, r = ent:GetPos(), ent:GetAngles(), ent.Radius
			local gas = ents.Create ( "zs_poisongasses" )
			gas:SetPos ( p )
			gas:SetAngles( a )
			-- gas:SetNWInt("GasRadius", r )
			gas:SetDTInt(0,r)
			-- gas:SetNWBool("GasPipe", false)
			gas:SetDTBool(0,false)
			gas:Spawn()	
			table.insert(placed,gas)
		end
	end

	if #placed > 2 then return end
	
	local placed2 = {}	

	if #PoisonGasses <= 0 then 
	
		local humanspawns = team.GetSpawnPoint(TEAM_HUMAN)

		for _, spawn in pairs(team.GetSpawnPoint(TEAM_UNDEAD)) do
			local gasses = ents.FindByClass("zombiegasses")
			local numgasses = #gasses
			if 4 < numgasses then
				break
			elseif math.random(1, 4) == 1 or numgasses < 1 then
				local spawnpos = spawn:GetPos()
				local nearhum = false
				for _, humspawn in pairs(humanspawns) do
					if humspawn:GetPos():Distance(spawnpos) < 128 then
						nearhum = true
						break
					end
				end
				if not nearhum then
					for _, humspawn in pairs(gasses) do
						if humspawn:GetPos():Distance(spawnpos) < 128 then
							nearhum = true
							break
						end
					end
				end
				if not nearhum then
					local ent = ents.Create("zs_poisongasses")
					if ent:IsValid() then
						ent:SetPos(spawnpos)
						-- ent:SetNWBool("GasPipe", false)
						ent:SetDTBool(0,false)
						-- ent:SetNWInt("GasRadius", 300 )
						ent:SetDTInt(0,300)
						ent:Spawn()
					end
				end
			end
		end
	
	
	
	return end
	
	for k,v in pairs(PoisonGasses) do
		local pos = v.origin
		local rad = v.radius
		
			local gas = ents.Create ( "zs_poisongasses" )
			gas:SetPos ( pos )
			gas:SetAngles(Angle(90,0,0))
			-- gas:SetNWInt("GasRadius", rad)
			gas:SetDTInt(0,rad)
			-- gas:SetNWBool("GasPipe", ( k == 1 ))
			gas:SetDTBool(0,k==1)
			gas:Spawn()	
	end

end
-- hook.Add ( "InitPostEntity","SpawnPoisonGasses",SpawnPoisonGasses )


