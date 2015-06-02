local Zombie = {}

local function RefreshCache()
	Zombie = team.GetPlayers(TEAM_UNDEAD)
end
timer.Create("ZO-RefreshCache", 15, 0, RefreshCache)

--Time in seconds after last hit or hurt to wait before healing
--local HealTimeout = 60
local HealTimeout = 3

--Amount to heal per cycle
--local HealAmount = 20
local HealAmount = 1

--Interval time in seconds to heal
--local HealInterval = 4
local HealInterval = 1

local function Heal()
	local Time = CurTime()
	
	for i=1, #Zombie do	
		local pl = Zombie[i]
		if not IsValid(pl) or not pl:Alive() or not pl:Team() == TEAM_UNDEAD pl:Health() >= pl:GetMaximumHealth() then
			continue
		end

		if Time < (pl.LastHit + HealTimeout) or Time < (pl.LastHurt + HealTimeout) then
			continue
		end

		pl:SetHealth(math.min(pl:Health() + HealAmount, pl:GetMaximumHealth()))	
	end
end
timer.Create("ZO-Heal", HealInterval, 0, Heal)
