util.AddNetworkString("recwavestart")
util.AddNetworkString("recwaveend")

CAPPED_INFLICTION = 0

function GM:UpdateHumanTable()

	local humans = team.GetPlayers(TEAM_HUMAN)			

	-- Sort the human table so that the closest ones to gas are the victims!
	--print("test")
	
	for k,v in pairs(humans) do
		local pos = v:GetPos()
		local closest = 9999999
		for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do	
			local dist = gasses:GetPos():Distance(pos)
			if dist < closest then
				closest = dist
			end
		end
		v.GasDistance = closest		
	end

	--	
end

function GM:SetRandomsToZombie() --Duby: I took Necro's old code and modified it a little.
	local allplayers = player.GetAll()
	local numplayers = #allplayers
	

	if numplayers <= 3 then return end

	--local desiredzombies = math.max(1, math.ceil(3))
	--local desiredzombies = math.max(UNDEAD_START_AMOUNT_MINIMUM, math.Round(3 * UNDEAD_START_AMOUNT_PERCENTAGE))
	local desiredzombies = math.max(UNDEAD_START_AMOUNT, math.Round(numplayers * UNDEAD_START_AMOUNT_PERCENTAGE))
	
	local humans = team.GetPlayers(TEAM_HUMAN)			
	
	local vols = 0
	local voltab = {}
	for _, gasses in pairs(ents.FindByClass("zs_poisongasses")) do
		for _, ent in pairs(ents.FindInSphere(gasses:GetPos(), UNDEAD_VOLUNTEER_DISTANCE)) do
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
			if pl:Team() != TEAM_UNDEAD then
				pl:SetFirstZombie()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
			end
		end
	elseif vols < desiredzombies then
		local spawned = 0
		for i, pl in ipairs(voltab) do
			if pl:Team() != TEAM_UNDEAD then

				pl:SetFirstZombie()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
				spawned = i
			end
		end		
		for i = 1, desiredzombies - spawned - vols do
	table.sort(humans,self.ZombieSpawnDistanceSort)		
			if 0 < #humans then
				local pl = humans[i]				
				if pl:Team() != TEAM_UNDEAD then
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
				pl:SetFirstZombie()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
			end
		end
	end
end

function GM:ZombieSpawnDistanceSort(other)
	return self.GasDistance < other.GasDistance
end


function GM:SetRandomsToFirstZombie()
	--Get num of players
	local numPlayers = #player.GetAll()
	
	--Require atleast 5 players
	if numPlayers <= 3 then
		return
	end

	--Get Humans and Undead
	local tblHumans = team.GetPlayers(TEAM_HUMAN)
	local tblUndead = team.GetPlayers(TEAM_UNDEAD)
	
	--Calculate required Undead amount
	local numRequiredUndead = math.max(UNDEAD_START_AMOUNT_MINIMUM, math.Round(numPlayers * UNDEAD_START_AMOUNT_PERCENTAGE))
	
	--
	
	--Check if there are already zombies
	if #tblUndead > 0 then
		numRequiredUndead = numRequiredUndead - #tblUndead
	end
	
	--Check if we still need undead
	if numRequiredUndead <= 0 then
		return
	end
	
	local numAcquiredUndead, whileFailedAttempts = 0, 0

	--Keep going till we have either failed at a lot of attempts or when we have the number that's required
	while numAcquiredUndead < numRequiredUndead and whileFailedAttempts < 40 do
		--Get random player
		local pl = tblHumans[math.random(1, #tblHumans)]

		if pl:Team() ~= TEAM_UNDEAD then
			--Set as first Undead
			pl:SetFirstZombie()
			
			--Send message
			umsg.Start("recranfirstzom", pl)
			umsg.End()
			
			--Increase number
			numAcquiredUndead = numAcquiredUndead + 1
		else
			whileFailedAttempts = whileFailedAttempts + 1
		end
	end
	
	Debug("[WAVES] Acquired ".. numAcquiredUndead .." of ".. numRequiredUndead .." required Undead")
end

function GM:CalculateInfliction()
	if ENDROUND then return end
	
	local progressTime = CurTime() / ROUNDTIME
	
	INFLICTION = math.Round(progressTime,2)
	CAPPED_INFLICTION = INFLICTION
	
	self:CalculateUnlife()
	self:SendInfliction()
end

function GM:CalculateUnlife()
	if ENDROUND or UNLIFE or LASTHUMAN then
		return
	end
	
	if not UNLIFE then
		local allplayers = #player.GetAll()
		local zombies = team.NumPlayers(TEAM_UNDEAD)
		local infliction = math.Round((zombies/allplayers) * 100)
	
		if infliction >= 75 then
			UNLIFE = true
			
			net.Start("unlife")
				net.WriteBit(true)
			net.Broadcast()			
			
			local Survivors = team.GetPlayers(TEAM_HUMAN)
			for i=1, #Survivors do
				local pl = Survivors[i]
				if not IsValid(pl) or not pl:Alive() then
					continue
				end

				skillpoints.AddSkillPoints(pl, 100)
				pl:SendLua("GAMEMODE:Add3DMessage(100,\"Unlife Mode! Double SP Received!\",nil,\"ssNewAmmoFont7\")")	
				pl:AddXP(100)
			end			
		end
	end	
end
util.AddNetworkString( "unlife" )

function GM:OnPlayerReady(pl)
	if not pl:IsValid() then
		return
	end
	
	self:SendInflictionTo(pl)
end
util.AddNetworkString("SetInf")

---
-- FIXME: This function affects network performance. It is used by GM:CalculateInfliction which is being extensively 
-- used by the gamemode. Since GM:CalculateInfliction uses shared variables, my suggestion would be to transform 
-- GM:CalculateInfliction into a shared function which simply computes the infliction on the spot instead of saving it.
-- 
function GM:SendInfliction()
	net.Start("SetInf")
		net.WriteFloat(INFLICTION)
		net.WriteBit(false)
	net.Broadcast()
end

function GM:SendInflictionTo(to)
	net.Start("SetInf")
		net.WriteFloat(INFLICTION)
		net.WriteBit(true)
	net.Send(to)
end

function GM:GetLivingZombies()
	local tab = {}

	for _, pl in pairs(player.GetAll()) do
		--if pl:Team() == TEAM_UNDEAD and pl:Alive() and not pl:IsCrow() and not timer.Exists(pl:UniqueID().."secondwind") then
		if pl:Team() == TEAM_UNDEAD and pl:Alive() and not timer.Exists(pl:UniqueID().."secondwind") then
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
		pl:SetHealth(pl:Health() * 0.3)
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
	if not pl:Alive() then
		return false
	end

	if pl:Team() == TEAM_HUMAN and pl:Alive() and pl:KeyPressed(IN_USE) then
		self:TryHumanPickup(pl, entity)
	end
	
	return true
end

function GM:TryHumanPickup(pl, entity)
	if IsValid(entity) and not entity.m_NoPickup then
		local entclass = entity:GetClass()
		if (entclass == "prop_physics" or entclass == "prop_physics_multiplayer" or entclass == "prop_physics_respawnable" or entclass == "func_physbox" or entity.HumanHoldable and entity:HumanHoldable(pl)) and pl:Team() == TEAM_HUMAN and not entity.Nails and pl:Alive() and entity:GetMoveType() == MOVETYPE_VPHYSICS and entity:GetPhysicsObject():GetMass() <= CARRY_MAXIMUM_MASS and entity:GetPhysicsObject():IsMoveable() and entity:OBBMins():Length() + entity:OBBMaxs():Length() <= CARRY_MAXIMUM_VOLUME then
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
