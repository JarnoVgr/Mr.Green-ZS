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

function GM:SetRandomsToFirstZombie()
	--Get num of players
	local numPlayers = #player.GetAll()
	
	--Require atleast 5 players
	if numPlayers <= 4 then
		return
	end

	--Get Humans and Undead
	local tblHumans = team.GetPlayers(TEAM_HUMAN)
	local tblUndead = team.GetPlayers(TEAM_UNDEAD)
	
	--Calculate required Undead amount
	local numRequiredUndead = math.max(1, math.ceil(numPlayers * WAVE_ONE_ZOMBIES))
	
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
	if ENDROUND then
		return
	end

	local zombies = team.NumPlayers(TEAM_UNDEAD)
	local humans = team.NumPlayers(TEAM_SURVIVORS)
	local players = humans + zombies
	
	local progressTime = CurTime() / ROUNDTIME
	
	INFLICTION = math.Round(math.max(math.Clamp(zombies / players, 0.001, 1), progressTime),2)
	CAPPED_INFLICTION = INFLICTION

	self:SendInfliction()
end

function GM:OnPlayerReady(pl)
	if not pl:IsValid() then
		return
	end
	
	self:SendInflictionTo(pl)
end

util.AddNetworkString( "SetInf" )

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
	
	if math.random(1,salechance) ~= 1 then
		return
	end
	
	print("[SKILLSHOP] Sale chance is: "..SKILLSHOP_SALE.."%")
	
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
	
	print("[SKILLSHOP] Today there are "..actualitems.." item(s) on sale")
	--print("[SKILLSHOP] Weapons - discount in percentages")
	
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
	
	--PrintTable(self.WeaponsOnSale)
	

end

util.AddNetworkString( "SendSales" )

function GM:SendSalesToClient(pl)
	if pl:IsBot() or not self.WeaponsOnSale then
		return
	end

	net.Start("SendSales")
		net.WriteDouble(self.ItemsOnSale or 0)
			for wep, tab in pairs(self.WeaponsOnSale) do
				net.WriteString(wep)
				net.WriteDouble(self.WeaponsOnSale[wep])
			end
	net.Send(pl)
end

--small function that fixes weird errors
function FixNotUpdatedSales(pl,cmd,args)
	if not ValidEntity(pl) or ENDROUND then return end
	
	GAMEMODE:SendSalesToClient(pl)
	print("[SKILLSHOP] Player "..tostring(pl).." requested serverside sales because of error! Sending a new ones.")
end
concommand.Add("mrgreen_fixdeadsales",FixNotUpdatedSales)

function GM:EnableSuperBoss()
	if math.random(SUPER_BOSS_CHANCE) == SUPER_BOSS_CHANCE then
		SUPER_BOSS = true
		print("[BOSS] Super Boss activated")
	end
	
	if SUPER_BOSS then
		for index, tbl in pairs(ZombieClasses) do
			if ZombieSuperBosses[index] then
				ZombieClasses[index] = ZombieSuperBosses[index]
			end
		end
	end
end

function GM:SuperBossNotify(pl)
	if pl:IsBot() then
		return
	end

	if SUPER_BOSS then
		umsg.Start( "SuperBossNotify",pl )
		umsg.End()
	end
end