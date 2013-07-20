local table = table
local math = math
local string = string
local util = util
local pairs = pairs
local team = team
local player = player
local timer = timer
local umsg = umsg
local ents = ents

util.AddNetworkString( "recwavestart" )
util.AddNetworkString( "recwaveend" )



CAPPED_INFLICTION = 0

function GM:SetRandomsToZombie()
	local allplayers = player.GetAll()
	local numplayers = #allplayers
	

	if numplayers <= 4 then return end

	local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))

	local vols = 0
	local voltab = {}
	for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do
		for _, ent in pairs(ents.FindInSphere(gasses:GetPos(), 256)) do
			if ent:IsPlayer() and not table.HasValue(voltab, ent) then
				vols = vols + 1
				table.insert(voltab, ent)
			end
		end
	end

	for _, pl in pairs(allplayers) do
		if pl:Team() == TEAM_UNDEAD then
			vols = vols + 1
			table.insert(voltab, pl)
		end
	end

	if vols == desiredzombies then
		for _, pl in pairs(voltab) do
			if pl:Team() ~= TEAM_UNDEAD then
				--[=[local ID = pl:UniqueID() or "UNCONNECTED"
				pl:StripWeapons()
				pl:SetTeam(TEAM_UNDEAD)
				self:SetFrags ( 0 )
				DataTableConnected[ID].IsDead = true
				
				pl:Spawn()]=]
				pl:SetFirstZombie()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
			end
		end
	elseif vols < desiredzombies then
		local spawned = 0
		for i, pl in ipairs(voltab) do
			if pl:Team() ~= TEAM_UNDEAD then
				--[=[local ID = pl:UniqueID() or "UNCONNECTED"
				pl:SetTeam(TEAM_UNDEAD)
				DataTableConnected[ID].IsDead = true
				pl:StripWeapons()
				pl:Spawn()]=]
				pl:SetFirstZombie()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
				spawned = i
			end
		end

		for i = 1, desiredzombies - spawned do
			local humans = team.GetPlayers(TEAM_HUMAN)

			if 0 < #humans then
				local pl = humans[math.random(1, #humans)]
				if pl:Team() ~= TEAM_UNDEAD then
					--[=[local ID = pl:UniqueID() or "UNCONNECTED"
					pl:SetTeam(TEAM_UNDEAD)
					DataTableConnected[ID].IsDead = true
					pl:StripWeapons()
					pl:Spawn()]=]
					pl:SwitchToZombie()
					umsg.Start("recranfirstzom", pl)
					umsg.End()
				end
			end
		end
	elseif desiredzombies < vols then
		for i, pl in ipairs(voltab) do
			if desiredzombies < i and pl:Team() == TEAM_HUMAN then
				pl:SetPos(self:PlayerSelectSpawn(pl):GetPos())
			else
				--[=[local ID = pl:UniqueID() or "UNCONNECTED"
				pl:SetTeam(TEAM_UNDEAD)
				DataTableConnected[ID].IsDead = true
				pl:StripWeapons()
				pl:Spawn()]=]
				pl:SetFirstZombie()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
			end
		end
	end
end

function GM:SetRandomsToFirstZombie()
	local allplayers = player.GetAll()
	local numplayers = #allplayers
	

	if numplayers <= 4 then return end

	local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))
	
	
	
	for i=1, desiredzombies do
		local humans = team.GetPlayers(TEAM_HUMAN)
		local undead = team.GetPlayers(TEAM_UNDEAD)
		if 4 < #humans then
				local pl = humans[math.random(1, #humans)]
				if pl:Team() ~= TEAM_UNDEAD then
					pl:SetFirstZombie()
					umsg.Start("recranfirstzom", pl)
					umsg.End()
				end
		end
	end
	
end

function GM:CalculateInfliction()
	if ENDROUND then return end

	local players = 0
	local zombies = 0
	local humans = 0
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD then
			zombies = zombies + 1
		elseif pl:Team() == TEAM_HUMAN then
			humans = humans + 1
		end
		players = players + 1
	end
	INFLICTION = math.max(math.Clamp(zombies / players, 0.001, 1), CAPPED_INFLICTION)
	CAPPED_INFLICTION = INFLICTION

	if humans == 1 and 3 < zombies then
		-- spawn all guys
		for _,pl in pairs(team.GetPlayers(TEAM_SPECTATOR)) do
			pl:ConCommand("ChangeClass 1")
		end
		self:LastHuman()
	elseif 1 <= INFLICTION then
		self:OnEndRound(TEAM_UNDEAD)
		return
	elseif 0.75 <= INFLICTION then
		UNLIFE = true
		HALFLIFE = true
	elseif 0.5 <= INFLICTION then
		HALFLIFE = true
	end

	self:SendInfliction()
end

function GM:OnPlayerReady(pl)
	if pl:IsValid() then
		self:SendInflictionInit(pl)
		self:FullGameUpdate(pl)
	end
end

util.AddNetworkString( "reczsgamestate" )

function GM:FullGameUpdate(pl)

	net.Start("reczsgamestate")
		net.WriteDouble(self:GetWave())
		net.WriteFloat(self:GetWaveStart())
		net.WriteFloat(self:GetWaveEnd())
	net.Send(pl)
end

util.AddNetworkString( "SetInf" )

function GM:SendInfliction()

	net.Start("SetInf")
		net.WriteFloat(INFLICTION)
	net.Broadcast()
end

util.AddNetworkString( "SetInfInit" )

function GM:SendInflictionInit(to)

	net.Start("SetInfInit")
		net.WriteFloat(INFLICTION)
		net.WriteDouble(self:GetWave())
	net.Send(to)
end

function GM:GetLivingZombies()
	local tab = {}

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD and pl:Alive() and not pl:IsCrow() and not timer.Exists(pl:UniqueID().."secondwind") then
			table.insert(tab, pl)
		end
	end

	self.LivingZombies = #tab
	return tab
end

function GM:NumLivingZombies()
	return self.LivingZombies
end

function DefaultRevive(pl)
	timer.Create(pl:UniqueID().."secondwind", 2, 1, SecondWind, pl)
	pl:GiveStatus("revive", 3.5)
end

function SecondWind(pl)
	if pl and pl:IsPlayer() then
		if pl.Gibbed or pl:Alive() or pl:Team() ~= TEAM_UNDEAD then return end
		local pos = pl:GetPos()
		local angles = pl:EyeAngles()
		--local lastattacker = pl.LastAttacker
		local dclass = pl.DeathClass
		pl.DeathClass = nil
		pl.Revived = true
		pl:Spawn()
		pl.Revived = nil
		pl.DeathClass = dclass
		--pl.LastAttacker = lastattacker
		pl:SetPos(pos)
		pl:SetHealth(pl:Health() * 0.2)
		pl:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav", 100, 85)
		pl:SetEyeAngles(angles)
		timer.Destroy(pl:UniqueID().."secondwind")
	end
end

function GM:DefaultRevive(pl)
	-- local status = pl:GiveStatus("revive")
	local status = pl:GiveStatus("revive")
	if status then
		status:SetReviveTime(CurTime() + 2.25)
	end
end

function GM:KeyPress(pl, key)
	if key == IN_USE then
		if pl:Team() == TEAM_HUMAN and pl:Alive() then
			self:TryHumanPickup(pl, pl:TraceLine(64,MASK_SHOT).Entity)
		end
	end
end

function GM:PlayerUse(pl, entity)
	if not pl:Alive() then return false end

	if pl:Team() == TEAM_HUMAN and pl:Alive() and pl:KeyPressed(IN_USE) then
		self:TryHumanPickup(pl, entity)
	end
	
	return true
end

function GM:TryHumanPickup(pl, entity)
	if self:IsRetroMode() then return end
	if IsValid(entity) and not entity.m_NoPickup then
		local entclass = entity:GetClass()
		if (entclass == "prop_physics" or entclass == "prop_physics_multiplayer" or entclass == "prop_physics_respawnable" or entclass == "func_physbox" or entity.HumanHoldable and entity:HumanHoldable(pl)) and pl:Team() == TEAM_HUMAN and not entity.Nails and pl:Alive() and entity:GetMoveType() == MOVETYPE_VPHYSICS and entity:GetPhysicsObject():GetMass() <= CARRY_MAXIMUM_MASS and entity:GetPhysicsObject():IsMoveable() and entity:OBBMins():Length() + entity:OBBMaxs():Length() <= CARRY_MAXIMUM_VOLUME then
			-- (string.sub(entclass, 1, 12) == "prop_physics"
			local holder, status = entity:GetHolder()
			if holder == pl and (pl.NextUnHold or 0) <= CurTime() then
				status:Remove()
				pl.NextHold = CurTime() + 0.25
			elseif not holder and not pl:IsHolding() and (pl.NextHold or 0) <= CurTime() and pl:GetShootPos():Distance(entity:NearestPoint(pl:GetShootPos())) <= 64 and pl:GetGroundEntity() ~= entity then
				local newstatus = ents.Create("status_human_holding")
				if newstatus:IsValid() then
					pl.NextHold = CurTime() + 0.25
					pl.NextUnHold = CurTime() + 0.05
					newstatus:SetPos(pl:GetShootPos())
					newstatus:SetOwner(pl)
					newstatus:SetParent(pl)
					newstatus:SetObject(entity)
					newstatus:Spawn()
					
				end
			end
		end
	end
end


function GM:AddRandomSales()
	
	self.WeaponsOnSale = self.WeaponsOnSale or {}
	
	local salechance = 1/(SKILLSHOP_SALE/100)
	
	if math.random(1,salechance) ~= 1 then return end
	
	print("Sale chance is: "..SKILLSHOP_SALE.."%")
	
	-- if passed then
	
	self.Sale = true
	
	local actualitems = math.random(1,SKILLSHOP_SALE_MAXITEMS)
	local TempWeps = {}
	local counter = 0
	
	-- filter weapons with price
	for wep,tab in pairs(GAMEMODE.HumanWeapons) do
		if tab.Price then
			table.insert(TempWeps,wep)
		end
	end
	
	print("Today there are "..actualitems.." item(s) on sale")
	print("Weapons - discount in percentages")
	
	-- Add X random weapons
	while counter < actualitems do
		
		local wep = table.Random(TempWeps)
		if not self.WeaponsOnSale[wep] then
			self.WeaponsOnSale[wep] = math.random(SKILLSHOP_SALE_SALE_MINRANGE,SKILLSHOP_SALE_SALE_MAXRANGE)
			counter = counter + 1
			-- Change actual price 
			GAMEMODE.HumanWeapons[wep].Price = math.ceil(GAMEMODE.HumanWeapons[wep].Price - GAMEMODE.HumanWeapons[wep].Price*(self.WeaponsOnSale[wep]/100))
		end
		
	end
	
	self.ItemsOnSale = counter
	
	PrintTable(self.WeaponsOnSale)
	

end

util.AddNetworkString( "SendSales" )

function GM:SendSalesToClient(pl)
	
	if pl:IsBot() then return end
	if not self.WeaponsOnSale then return end
	-- if #self.WeaponsOnSale < 1 then return end
	
	
	net.Start("SendSales")
		net.WriteDouble(self.ItemsOnSale or 0)
			for wep, tab in pairs(self.WeaponsOnSale) do
				net.WriteString(wep)
				net.WriteDouble(self.WeaponsOnSale[wep])
			end
	net.Send(pl)
	--[==[umsg.Start( "SendSales",pl )
		-- Define amount of items
		umsg.Short(self.ItemsOnSale)
			-- send the stuff
			for wep, tab in pairs(self.WeaponsOnSale) do
				umsg.String(wep)
				umsg.Short(self.WeaponsOnSale[wep])
			end
	umsg.End()]==]
	
end
--small function that fixes weird errors
function FixNotUpdatedSales(pl,cmd,args)

	if not ValidEntity(pl) then return end
	if ENDROUND then return end
	
	GAMEMODE:SendSalesToClient(pl)
	print("Player "..tostring(pl).." requested serverside sales because of error! Sending a new ones.")
end
concommand.Add("mrgreen_fixdeadsales",FixNotUpdatedSales)

function GM:EnableSuperBoss()
	
	if math.random(SUPER_BOSS_CHANCE) == SUPER_BOSS_CHANCE then
		SUPER_BOSS = true
		print("--Super Boss activated!--")
	end
	
	-- SUPER_BOSS = true
	
	if SUPER_BOSS then
	
		for index, tbl in pairs(ZombieClasses) do
			if ZombieSuperBosses[index] then
				ZombieClasses[index] = ZombieSuperBosses[index]
			end
		end
	
	end
end

function GM:SuperBossNotify(pl)
	if pl:IsBot() then return end
	if SUPER_BOSS then
		umsg.Start( "SuperBossNotify",pl )
		umsg.End()
	end
	
end