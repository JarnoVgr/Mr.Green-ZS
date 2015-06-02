local Human = {}

local function RefreshCache()
	Human = team.GetPlayers(TEAM_HUMAN)
end
timer.Create("HU-RefreshCache", 15, 0, RefreshCache)

--Time in seconds after last hit or hurt to wait before healing
--local HealTimeout = 60
local HealTimeout = 6

--Amount to heal per cycle
--local HealAmount = 20
local HealAmount = 1

local maxheal = 100

--Interval time in seconds to heal
--local HealInterval = 4
local HealInterval = 6

local function Heal()
	local Time = CurTime()
	
	for i=1, #Human do	
		local pl = Human[i]
		if not IsValid(pl) or not pl:Alive() or not pl:Team() == TEAM_HUMAN or not pl:GetPerk("_supportregen") or pl:Health() >= maxheal then
			continue
		end

		if Time < (pl.LastHit + HealTimeout) or Time < (pl.LastHurt + HealTimeout) then
			continue
		end

		pl:SetHealth(math.min(pl:Health() + HealAmount, maxheal))	
	end
end
timer.Create("HU-Heal", HealInterval, 0, Heal)
