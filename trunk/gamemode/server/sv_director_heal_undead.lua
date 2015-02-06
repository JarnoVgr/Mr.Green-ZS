local Undead = {}

local function RefreshCache()
	Undead = team.GetPlayers(TEAM_UNDEAD)
end
timer.Create("HU-RefreshCache", 15, 0, RefreshCache)

--Time in seconds after last hit or hurt to wait before healing
local HealTimeout = 8

--Amount to heal per cycle
local HealAmount = 20

--Interval time in seconds to heal
local HealInterval = 4

local function Heal()
	local Time = CurTime()
	for i=1, #Undead do
		local pl = Undead[i]
		if not IsValid(pl) or not pl:Alive() or not pl:Team() == TEAM_UNDEAD or pl:Health() >= pl:GetMaximumHealth() then
			continue
		end

		if Time < (pl.LastHit + HealTimeout) or Time < (pl.LastHurt + HealTimeout) then
			continue
		end

		pl:SetHealth(math.min(pl:Health() + HealAmount, pl:GetMaximumHealth()))
	end
end
timer.Create("HU-Heal", HealInterval, 0, Heal)