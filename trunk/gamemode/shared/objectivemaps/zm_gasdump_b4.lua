-- Everything is in alpha fucking stage!

-- Few checks so it wont rebuild cache each time it changes
if not TranslateMapTable[ game.GetMap() ] then return end
if not TranslateMapTable[ game.GetMap() ].Objective then return end
if game.GetMap() ~= "zm_gasdump_b4" then return end

OBJECTIVE = true

GM.ObjectiveStage = 0

Objectives = Objectives or {}

Objectives.Entities = {"battery1","battery2","battery3","c4"}

Objectives.RemoveEntities = {"weapon_zm_shotgun","info_zombiespawn","info_player_zombiemaster","weapon_zm_rifle","weapon_zm_pistol","weapon_zm_sledge","trigger_blockspotcreate","weapon_zm_mac10","item_ammo_*"}

ROUNDTIME = 16*60

Objectives[1] = {

	Trigger = nil,
	TriggerOutputHook = nil,
	TriggerOutputFunction = nil,
	Info = "Search the abandoned gas station.",
	ZombieSpawns = function()
	
	SpawnPoints = {}

	table.insert ( SpawnPoints, { Vector(-173.32545471191,-1639.1025390625,-292.96875), Angle(11.86344909668,42.873687744141,0) } ) 
	table.insert ( SpawnPoints, { Vector(23.507293701172,-1711.0484619141,-292.96875), Angle(9.034779548645,97.484504699707,0) } ) 
	table.insert ( SpawnPoints, { Vector(-853.48541259766,-1132.9022216797,-294.96875), Angle(5.7371325492859,18.906997680664,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-1042.9177246094,1032.8117675781,-283.78939819336), Angle(7.6248545646667,-45.849624633789,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-889.97338867188,-2136.8391113281,-294.96875), Angle(2.4382772445679,65.756843566895,0) } ) 
	table.insert ( SpawnPoints, { Vector(-957.35394287109,-1993.6730957031,-294.96875), Angle(1.3356013298035,61.85765838623,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-746.25,-2062.705078125,-294.96875), Angle(3.0362100601196,39.86994934082,0) } ) 
	table.insert ( SpawnPoints, { Vector(-751.33233642578,-1937.7236328125,-294.96875), Angle(4.7209048271179,46.985069274902,-0) } ) 
	
	return SpawnPoints
	
	end
	
}

Objectives[2] = {

	Trigger = "-13.5 582.5 -177", --370
	TriggerOutputHook = "OnTrigger",
	TriggerOutputFunction = function()
	
	--[=[PrintMessageAll( HUD_PRINTTALK, "You have activated optional function!" )
	local sledge1 = ents.Create( "weapon_zs_melee_sledgehammer" )
	sledge1:SetPos(Vector(409.173767, 153.800476, -166.968750))
	sledge1:Spawn()
	
	local sledge2 = ents.Create( "weapon_zs_melee_sledgehammer" )
	sledge2:SetPos(Vector(449.173767, 153.800476, -166.968750))
	sledge2:Spawn()
	
	local sledge3 = ents.Create( "weapon_zs_melee_sledgehammer" )
	sledge3:SetPos(Vector(449.173767, 173.800476, -166.968750))
	sledge3:Spawn()
	
	local sledge4 = ents.Create( "weapon_zs_melee_sledgehammer" )
	sledge4:SetPos(Vector(449.173767, 173.800476, -156.968750))
	sledge4:Spawn()]=]
	
		local sledge = {}
		for i=1,math.random(2,math.max(team.NumPlayers(TEAM_HUMAN),3)) do
			sledge[i] = ents.Create( "weapon_zs_melee_sledgehammer" )
			sledge[i]:SetPos(Vector(409.173767, 153.800476+ i, -166.968750 + i))
			sledge[i]:Spawn()
		end
		
	local weps = {}
	local ent = {}
	weps[Vector(201, -144, 47)] = {"weapon_zs_sg552","weapon_zs_p90"}
	weps[Vector(-302, 176, 56)] = {"weapon_zs_sg552","weapon_zs_p90"}
	weps[Vector(-302, 176, 59)] = {"item_healthkit"}
	weps[Vector(-302, 176, 57)] = {"item_healthkit"}
	weps[Vector(201, -144, 46)] = {"item_healthkit"}
	
		local num = 1
		for vec,item in pairs(weps) do
			ent[num] = ents.Create( table.Random(item) )
			ent[num]:SetPos(vec)
			ent[num]:Spawn()
			num = num + 1
		end

		
	
	end,
	Info = "Keep searching.",
	ZombieSpawns = function()
	
	SpawnPoints = {}
	
	table.insert ( SpawnPoints, { Vector(-173.32545471191,-1639.1025390625,-292.96875), Angle(11.86344909668,42.873687744141,0) } ) 
	table.insert ( SpawnPoints, { Vector(23.507293701172,-1711.0484619141,-292.96875), Angle(9.034779548645,97.484504699707,0) } ) 
	table.insert ( SpawnPoints, { Vector(-853.48541259766,-1132.9022216797,-294.96875), Angle(5.7371325492859,18.906997680664,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-1042.9177246094,1032.8117675781,-283.78939819336), Angle(7.6248545646667,-45.849624633789,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-889.97338867188,-2136.8391113281,-294.96875), Angle(2.4382772445679,65.756843566895,0) } ) 
	table.insert ( SpawnPoints, { Vector(-957.35394287109,-1993.6730957031,-294.96875), Angle(1.3356013298035,61.85765838623,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-746.25,-2062.705078125,-294.96875), Angle(3.0362100601196,39.86994934082,0) } ) 
	table.insert ( SpawnPoints, { Vector(-751.33233642578,-1937.7236328125,-294.96875), Angle(4.7209048271179,46.985069274902,-0) } ) 
	
	return SpawnPoints
	
	end
	
}

Objectives[3] = {

	Trigger = "174 531 -173",--373
	TriggerOutputHook = "OnTrigger",
	TriggerOutputFunction = nil,
	Info = "Find 3 batteries to power up the elevator.",
	ZombieSpawns = Objectives[2].ZombieSpawns
	
}

Objectives[4] = {

	Trigger = nil,
	TriggerOutputHook = "OnHitMax",
	TriggerTargetName = "bat_zaehler",
	TriggerOutputFunction = nil,
	Info = "Get your ass into elevator!",
	ZombieSpawns = function()
	
	SpawnPoints = {}
	
	table.insert ( SpawnPoints, { Vector(-173.32545471191,-1639.1025390625,-292.96875), Angle(11.86344909668,42.873687744141,0) } ) 
	table.insert ( SpawnPoints, { Vector(23.507293701172,-1711.0484619141,-292.96875), Angle(9.034779548645,97.484504699707,0) } ) 
	table.insert ( SpawnPoints, { Vector(-853.48541259766,-1132.9022216797,-294.96875), Angle(5.7371325492859,18.906997680664,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-1042.9177246094,1032.8117675781,-283.78939819336), Angle(7.6248545646667,-45.849624633789,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-889.97338867188,-2136.8391113281,-294.96875), Angle(2.4382772445679,65.756843566895,0) } ) 
	table.insert ( SpawnPoints, { Vector(-957.35394287109,-1993.6730957031,-294.96875), Angle(1.3356013298035,61.85765838623,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-366.54077148438,-151.46217346191,83.404708862305), Angle(-0.40555292367935,79.901870727539,0) } ) 
	table.insert ( SpawnPoints, { Vector(102.33843231201,-192.71704101563,142.98588562012), Angle(4.0591378211975,148.41644287109,0) } ) 
	table.insert ( SpawnPoints, { Vector(197.95367431641,155.81251525879,110.65428161621), Angle(2.486040353775,88.479553222656,0) } ) 
	table.insert ( SpawnPoints, { Vector(-322.81097412109,349.79986572266,98.195472717285), Angle(10.638373374939,116.56560516357,0) } ) 
	table.insert ( SpawnPoints, { Vector(-122.73942565918,1164.7507324219,-38.96875), Angle(9.398736000061,-72.158409118652,-0) } ) 
	table.insert ( SpawnPoints, { Vector(77.520324707031,1103.3111572266,-38.96875), Angle(10.914490699768,-71.018051147461,-0) } ) 

	return SpawnPoints
	
	end
	
}

Objectives[5] = {

	Trigger = "-39 518 17",--436
	TriggerOutputHook = "OnTrigger",
	TriggerOutputFunction = nil,
	Info = "Place 5 explosives at marked spots.",
	ZombieSpawns = function()
	
	SpawnPoints = {}
	 
	table.insert ( SpawnPoints, { Vector(-173.32545471191,-1639.1025390625,-292.96875), Angle(11.86344909668,42.873687744141,0) } ) 
	table.insert ( SpawnPoints, { Vector(23.507293701172,-1711.0484619141,-292.96875), Angle(9.034779548645,97.484504699707,0) } ) 
	table.insert ( SpawnPoints, { Vector(-853.48541259766,-1132.9022216797,-294.96875), Angle(5.7371325492859,18.906997680664,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-1042.9177246094,1032.8117675781,-283.78939819336), Angle(7.6248545646667,-45.849624633789,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-889.97338867188,-2136.8391113281,-294.96875), Angle(2.4382772445679,65.756843566895,0) } ) 
	table.insert ( SpawnPoints, { Vector(-957.35394287109,-1993.6730957031,-294.96875), Angle(1.3356013298035,61.85765838623,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-366.54077148438,-151.46217346191,83.404708862305), Angle(-0.40555292367935,79.901870727539,0) } ) 
	table.insert ( SpawnPoints, { Vector(102.33843231201,-192.71704101563,142.98588562012), Angle(4.0591378211975,148.41644287109,0) } ) 
	table.insert ( SpawnPoints, { Vector(197.95367431641,155.81251525879,110.65428161621), Angle(2.486040353775,88.479553222656,0) } ) 
	table.insert ( SpawnPoints, { Vector(-322.81097412109,349.79986572266,98.195472717285), Angle(10.638373374939,116.56560516357,0) } ) 
	table.insert ( SpawnPoints, { Vector(-122.73942565918,1164.7507324219,-38.96875), Angle(9.398736000061,-72.158409118652,-0) } ) 
	table.insert ( SpawnPoints, { Vector(77.520324707031,1103.3111572266,-38.96875), Angle(10.914490699768,-71.018051147461,-0) } ) 
	table.insert ( SpawnPoints, { Vector(-1109.7790527344,-909.85168457031,-294.96868896484), Angle(7.4629006385803,34.231048583984,0) } ) 
	table.insert ( SpawnPoints, { Vector(996.58270263672,-403.98196411133,-295.0146484375), Angle(-1.3475941419601,158.31617736816,0) } ) 
	table.insert ( SpawnPoints, { Vector(1075.5327148438,1150.8946533203,-281.67538452148), Angle(-2.7921588420868,-160.5224609375,0) } ) 
	table.insert ( SpawnPoints, { Vector(1152.0717773438,435.32733154297,-280.77270507813), Angle(-0.71678358316422,-167.98722839355,-0) } ) 

	return SpawnPoints
	
	end
	
}

Objectives[6] = {

	Trigger = nil,
	TriggerOutputHook = "OnHitMax",
	TriggerTargetName = "c4_counter",
	TriggerOutputFunction = function()
		--RELEASE THE TORNAAADOOOOO!!!!!!!!!!
		
	for _,zombie in pairs(team.GetPlayers(TEAM_UNDEAD)) do
		zombie:Message ("Destroy the truck!",1,"white")
	end
		
	for _, ent in pairs (ents.GetAll()) do
	
		if ent:GetKeyValues().targetname == "tracktrain" then
			ent:Fire("StartForward","",2)
		end
		if ent:GetKeyValues().targetname == "smokestack1" then
			ent:Fire("Toggle","",2)
		end
		if ent:GetKeyValues().targetname == "smokestack2" then
			ent:Fire("Toggle","",2)
		end
		if ent:GetKeyValues().targetname == "tornadosound" then
			ent:Fire("PlaySound","",2)
		end
			
	end
	
	--Add music for ambience
	
	local song
	local rand = math.random(1,3)
	if rand == 1 then
		song = "music/HL1_song10.mp3"
	elseif rand == 2 then
		song = "music/HL2_song29.mp3"
	else
		song = "deadlife_mrgreen.mp3"
	end
	

	umsg.Start("PlayClientsideSound")
		umsg.String(song)
	umsg.End()	
	
	local weps = {"weapon_zs_ak47","weapon_zs_deagle","weapon_zs_aug","weapon_zs_mp5","weapon_zs_shotgun","weapon_zs_melee_crowbar","weapon_zs_m249","weapon_zs_m4a1","weapon_zs_g3sg1","item_healthkit",
	"item_healthkit","item_healthkit","item_healthkit","item_healthkit",
	"weapon_zs_galil"
	}
	
	local ent = {}
	
		for i,item in pairs(weps) do
			ent[i] = ents.Create( item )
			ent[i]:SetPos(Vector(5716.922852, -1464.700317, -220.888474))
			ent[i]:Spawn()
		end
		
	end,
	Info = "Get back to the truck and defend it for 3 minutes!",
	PaintObjective = {"Defend the truck!", Vector(5729.058105, -1446.772949, -192.372635)},
	ZombieSpawns = function()
	
	SpawnPoints = {}
	 
	table.insert ( SpawnPoints, { Vector(2181.2448730469,-1184.1358642578,-294.96875), Angle(3.3800890445709,-12.524697303772,0) } ) 
	table.insert ( SpawnPoints, { Vector(2653.0385742188,-2184.1889648438,-261.21527099609), Angle(-0.10068944841623,15.365249633789,0) } ) 
	table.insert ( SpawnPoints, { Vector(2746.1247558594,-2230.7709960938,-212.16993713379), Angle(3.1543650627136,19.83152961731,0) } ) 
	table.insert ( SpawnPoints, { Vector(2879.09375,-2175.1804199219,-209.01657104492), Angle(5.3381223678589,30.427339553833,0) } ) 
	table.insert ( SpawnPoints, { Vector(2781.1667480469,-1255.9278564453,-291.26739501953), Angle(1.7630265951157,42.610813140869,-0) } ) 
	table.insert ( SpawnPoints, { Vector(1545.5473632813,-1613.1335449219,-292.96661376953), Angle(4.514431476593,-20.185451507568,-0) } ) 
	table.insert ( SpawnPoints, { Vector(1578.7197265625,-1493.3680419922,-292.96661376953), Angle(6.060875415802,-21.239910125732,-0) } ) 
	table.insert ( SpawnPoints, { Vector(1740.3231201172,-1811.9910888672,-292.96661376953), Angle(7.6293148994446,25.264228820801,0) } ) 
	table.insert ( SpawnPoints, { Vector(3625.7763671875,-1338.2828369141,-294.96875), Angle(-0.092320322990417,-22.354175567627,-0) } ) 
	table.insert ( SpawnPoints, { Vector(3964.5178222656,-1989.1810302734,-277.84915161133), Angle(-0.95134085416794,5.5278062820435,0) } ) 
	table.insert ( SpawnPoints, { Vector(4284.4970703125,-1975.3599853516,-282.22952270508), Angle(5.3713130950928,107.27388763428,-0) } ) 
	table.insert ( SpawnPoints, { Vector(4263.7685546875,-1322.4598388672,-294.96875), Angle(8.1642427444458,-41.066795349121,0) } ) 
	table.insert ( SpawnPoints, { Vector(4756.8525390625,-1248.3741455078,-281.66586303711), Angle(4.8093528747559,-86.840797424316,0) } ) 
	table.insert ( SpawnPoints, { Vector(4459.5004882813,-1995.5806884766,-273.75396728516), Angle(6.7417478561401,74.724998474121,-0) } ) 
	
	return SpawnPoints
	
	end
	
}