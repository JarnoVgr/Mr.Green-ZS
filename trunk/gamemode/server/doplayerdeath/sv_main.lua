-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Include all files inside this folder
for k, sFile in pairs ( file.Find( "zombiesurvival/gamemode/server/doplayerdeath/*.lua","lsv" ) ) do
	if not string.find( sFile, "main" ) then
		include(sFile)
	end
end

util.AddNetworkString("PlayerKilledSelfZS")
util.AddNetworkString("PlayerKilledByPlayerZS")
util.AddNetworkString("PlayerKilledZS")

function GM:PlayerDeath(pl, inflictor, attacker)
end

-- Main death event
function GM:DoPlayerDeath ( pl, attacker, dmginfo )

	pl:RemoveStatus("overridemodel", false, true)

	-- Set last attacker
	if pl.LastAttackers then
		if #pl.LastAttackers > 0 then
			for i = #pl.LastAttackers, 1, -1 do
			
				-- Check for inflictor
				if pl.LastAttackers[i] then
					if IsValid( pl.LastAttackers[i].Inflictor ) then
						dmginfo:SetInflictor( pl.LastAttackers[i].Inflictor )
					end
				end
			
				-- Check attackers
				if pl:IsAttackerPlayer( i ) then
					if pl.LastAttackers[i].Team == pl.LastAttackers[i].Attacker:Team() then
						pl.IsFinished = true
						dmginfo:SetAttacker( pl.LastAttackers[i].Attacker )
						pl:RemoveDamage( i )
						break
					end
				end
			end
		end
	end
		
	-- Resets last damage table
	pl.LastAttackers = nil
	
	-- Process assists
	dmginfo:ProcessAssist( pl ) 
	
	-- Resets the attacker's assistant
	timer.Simple(0.05, function()
		if IsValid(dmginfo:GetAttacker()) then
			dmginfo:GetAttacker().AttackerAssistant = nil
		end
	end)
	
	-- Stop the player/camera
	self:SetPlayerSpeed( pl, 0 )
	
	-- Assisted death
	if dmginfo:IsAssistValid() then
		if gamemode.Call( "OnAssist", pl, dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo:GetAssist(), dmginfo ) then
			return
		end
	end
	
	--  Undead death event
	if pl:IsZombie() then
		if gamemode.Call( "OnZombieDeath", pl, dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo ) then 
			return 
		end
	end
	
	--  Human death event
	if pl:IsHuman() then
		if gamemode.Call( "OnHumanDeath", pl, dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo ) then 
			return 
		end
	end
	
	-- General death event with dmginfo arguments
	if gamemode.Call( "OnPlayerDeath", pl, dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo ) then 
		return
	end
	
	local headshot = false
	local inflictor 
	
	if pl.NoDeathNotice then
		pl.NoDeathNotice = nil
		return
	end
		
	-- Send death status to clients
	if dmginfo:IsAttackerPlayer() then
		-- Player suicided
		if dmginfo:IsSuicide(pl) then
			net.Start("PlayerKilledSelfZS")
				net.WriteEntity(pl)
			net.Broadcast()
		else
		-- Killing between other players
			if pl:GetAttachment(1) then 
				if (dmginfo:GetDamagePosition():Distance(pl:GetAttachment( 1 ).Pos)) < 15 and not dmginfo:IsMeleeDamage() then
					headshot = true
				end	
			else
				headshot = false
			end

			if dmginfo:GetInflictor():GetClass() == "env_explosion" then
				if dmginfo:GetInflictor().Inflictor then
					inflictor = dmginfo:GetInflictor().Inflictor
				else
					inflictor = dmginfo:GetInflictor():GetClass()
				end
			elseif dmginfo:GetInflictor():GetClass() == "zs_turret" or dmginfo:GetInflictor():GetClass() == "zs_miniturret" then
				inflictor = "zs_turret"
			else
				inflictor = dmginfo:GetInflictor():GetClass()
				if attacker:IsPlayer() and attacker:IsHuman() and attacker:GetActiveWeapon() and attacker:GetActiveWeapon():IsValid() then
					if inflictor ~= attacker:GetActiveWeapon():GetClass() then
						inflictor = attacker:GetActiveWeapon():GetClass()
					end
				end
			end

			net.Start("PlayerKilledByPlayerZS")
				net.WriteEntity(pl)
				net.WriteString(inflictor)
				net.WriteEntity(dmginfo:GetAttacker())
				net.WriteDouble(pl:Team())
				net.WriteDouble(dmginfo:GetAttacker():Team())
				net.WriteBit(headshot)
				if dmginfo:IsAssistValid() then
					net.WriteDouble(dmginfo:GetAssist():EntIndex())
				end
			net.Broadcast()
		end
	end
	
	--Player got killed by something else
	if not dmginfo:IsAttackerPlayer() then
		net.Start("PlayerKilledZS")
			net.WriteEntity(pl)
			net.WriteString(dmginfo:GetInflictor():GetClass())
			net.WriteString(dmginfo:GetAttacker():GetClass())
		net.Broadcast()
	end
end


function GM:PlayerDeathThink(pl,attacker,dmginfo)
	if pl.Revive then
		return
	end

	if pl:GetObserverMode() == OBS_MODE_CHASE then
		local target = pl:GetObserverTarget()
		if not target or not target:IsValid() or not target:Alive() then
			pl:StripWeapons()
			pl:Spectate(OBS_MODE_ROAMING)
			pl:SpectateEntity(NULL)
		end
	end
	
	if pl:Team() ~= TEAM_UNDEAD then
		return
	end
	
	if pl:IsBot() then
		pl.NextSpawn = nil

		pl:RefreshDynamicSpawnPoint()
		pl:UnSpectateAndSpawn()
	elseif pl:GetObserverMode() == OBS_MODE_NONE or pl:GetObserverMode() == OBS_MODE_FREEZECAM then -- Not in spectator yet.
		if not pl.NextSpawn or CurTime() >= pl.NextSpawn then
			pl:StripWeapons()
	
			--Attempt to get best Undead to spectate
			local best = self:GetBestDynamicSpawn(pl)
			if best then
				--Chase Undead
				pl:Spectate(OBS_MODE_CHASE)
				pl:SpectateEntity(best)
			else
				--Just go into freeroam
				pl:Spectate(OBS_MODE_ROAMING)
				pl:SpectateEntity(NULL)
			end
		end
	else -- In spectator.
		if pl:KeyDown(IN_ATTACK) and (not pl.NextSpawn or (pl.NextSpawn and pl.NextSpawn < CurTime())) then
			pl:RefreshDynamicSpawnPoint()
			pl:UnSpectateAndSpawn()
		elseif pl:KeyPressed(IN_ATTACK2) then
			pl.SpectatedPlayerKey = (pl.SpectatedPlayerKey or 0) + 1

			local livingzombies = {}
			for k, v in pairs(team.GetPlayers(TEAM_ZOMBIE)) do
				if v:Alive() then
					table.insert(livingzombies, v)
				end
			end

			pl:StripWeapons()
			
			local specplayer = livingzombies[pl.SpectatedPlayerKey]
			if specplayer then
				pl:Spectate(OBS_MODE_CHASE)
				pl:SpectateEntity(specplayer)
			else
				pl:Spectate(OBS_MODE_ROAMING)
				pl:SpectateEntity(NULL)
				pl.SpectatedPlayerKey = nil
			end
		end
	end
end

Debug("[MODULE] Loaded Do-Player-Death file")