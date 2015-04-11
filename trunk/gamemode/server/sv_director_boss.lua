local boss = {}
boss.active = false
boss.pl = nil
boss.startTime = 0
boss.duration = 0
boss.endTime = 0
boss.nextBossTime = 0
boss.count = 3
boss.maxCount = math.random(4,5)


function GM:UnleashBoss()
	--No late bosses
	--[[if CurTime() >= ROUNDTIME-60 then
		return nil
	end]]

	--Set full health on players when in Arena Mode
	if ARENA_MODE then			
		for _, pl in pairs(player.GetAll()) do
			if pl:Team() ~= TEAM_HUMAN or not pl:Alive() then
				continue
			end
			
			local hp = 100
			if pl:GetPerk("_kevlar2") then
				hp = 120
			elseif pl:GetPerk("_kevlar") then
				hp = 110
			end

			pl:SetHealth(hp)
		end
	end
	
	
	pl = GAMEMODE:GetPlayerForBossZombie()
	if not IsValid(pl) then
		return nil
	end
	
	pl:SpawnAsZombieBoss() 

	boss.count = boss.count + 1
	
	--Start time
	boss.starTime = CurTime()
		
	--Calculate boss duration
--	boss.duration = math.min(math.Round(GAMEMODE:GetUndeadDifficulty() * 140),ROUNDTIME-CurTime())
--	boss.duration = math.min(230,ROUNDTIME-CurTime()) --Make it static so that we don't have a boss spawn for 10 seconds.

	--Set End time
	boss.endTime = CurTime() + boss.duration		

	--Create timer to kill boss and end of duration
	--[[if boss.duration and boss.duration > 0 then
		timer.Create("EndBoss", boss.duration, 1, function() 
			if not boss.pl or not IsValid(boss.pl) or not boss.pl:IsBoss() or not boss.pl:Alive() then
				--Just force disable it then
				GAMEMODE:SetBoss(false)
				return
			end

			local pl = boss.pl
				
			--Kill will trigger boss end

			pl.NoBounty = true
			pl:SetPhysicsAttacker(nil)
			pl:Kill()
		end)
	end]]--

	--Check if boss is still valid
	timer.Create("BossValidityCheck", 5, 0, function() 
		if not boss.pl then
			return
		end

		if not IsValid(boss.pl) or not boss.pl:IsBoss() or not boss.pl:Alive() then
			--Just force disable it then
			GAMEMODE:SetBoss(false)
			return
		end
	end)
	
	RunConsoleCommand("sv_alltalk", "1")
	
	return pl
end

function GM:CheckBoss()
	if GAMEMODE:GetBoss() then
		return false
	end

	if GetInfliction() <= 0.3 then
	RunConsoleCommand("sv_alltalk", "0")
		return false
	end

	if boss.active then
		return false
	end

	if CurTime() < boss.nextBossTime then
		return false
	end

	--[[if boss.count >= boss.maxCount then
		return false
	end]]

	--Start boss
	GAMEMODE:SetBoss(true)

	return true
end



function GM:GetBoss()
	return boss.active or false
end

function GM:GetBossPlayer()
	return boss.pl or nil
end

function GM:GetBossStartTime()
	return tonumber(boss.starTime) or 0
end

function GM:GetBossEndTime()
	return tonumber(boss.endTime) or 0
end

function GM:GetBossDuration()
	return tonumber(boss.duration) or 0
end

function GM:SetBoss(value)
	if boss.active == tobool(value) then
		return false
	end

	--Update global
	boss.active = tobool(value)
	
	if boss.active then
		boss.pl = GAMEMODE:UnleashBoss()
		
		if not IsValid(boss.pl) then
			return false
		end
		
		--Start the slowmo
		net.Start("SlowMoEffect")
		net.Broadcast()
		game.SetTimeScale(0.25)
		
		--Restore from slowmo
		timer.Simple(1.1, function() 
			game.SetTimeScale(1)
		end)

		--Insane mode for last boss
		local isInsane = false
		if boss.count >= boss.maxCount then
			isInsane = true
		end
		
		--Inform players
		net.Start("StartBoss")
		net.WriteBit(isInsane)
		net.WriteFloat(boss.duration)
		net.Broadcast()
	else
		--Kill end-boss timer
		--timer.Destroy("EndBoss")

		--Kill boss timers
		timer.Destroy("BossValidityCheck")
		
		--Reset boss player
		boss.pl = nil

		--Update end time
		boss.endTime = CurTime()

		boss.nextBossTime = boss.endTime + math.random(300,310)
	
		--Inform players
		net.Start("StopBoss")
		net.Broadcast()
	end
	
	return true
end
util.AddNetworkString("StartBoss")
util.AddNetworkString("StopBoss")
util.AddNetworkString("SlowMoEffect")
