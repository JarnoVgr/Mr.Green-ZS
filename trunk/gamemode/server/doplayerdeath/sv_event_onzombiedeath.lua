-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Called when a zombie is killed
local function OnZombieDeath( mVictim, mAttacker, mInflictor, dmginfo )
	-- Calculate spawn cooldown
	if CurTime() <= WARMUPTIME then
		mVictim.NextSpawn = WARMUPTIME+2
		mVictim:SendLua("MySelf.NextSpawn = ".. (WARMUPTIME+2))
	else
		mVictim.NextSpawn = CurTime() + 2
		mVictim:SendLua("MySelf.NextSpawn = CurTime() + 2")
	end

	--Recalculate infliction
	if team.NumPlayers(TEAM_HUMAN) < 1 then
		GAMEMODE:CalculateInfliction()
	end
		
	local revive = false
	local headshot = false
	
	local Class = mVictim:GetZombieClass()
	local Tab = ZombieClasses[Class]
	
	if not revive and not dmginfo:IsMeleeDamage() and mVictim:GetAttachment(1) and (dmginfo:GetDamagePosition():Distance(mVictim:GetAttachment(1).Pos )) < 15 then 
		mVictim:EmitSound(Sound("physics/body/body_medium_break"..math.random( 2, 4 )..".wav"))
				
		headshot = true
				
		-- Effect
		local effectdata = EffectData()
		effectdata:SetOrigin( mVictim:GetAttachment(1).Pos )
		effectdata:SetNormal( dmginfo:GetDamageForce():GetNormal() )
		effectdata:SetMagnitude( dmginfo:GetDamageForce():Length() * 3 )
		effectdata:SetEntity( mVictim )
		util.Effect( "headshot", effectdata, true, true )
					
		if mInflictor.IsTurretDmg then
			skillpoints.AddSkillPoints(mAttacker, 3)
			mAttacker:AddXP(ZombieClasses[mVictim:GetZombieClass()].Bounty)			
			mVictim:FloatingTextEffect(3, mAttacker)	

			if mAttacker:GetPerk("_turretsp") then
				mVictim:FloatingTextEffect(5, mAttacker)	
				skillpoints.AddSkillPoints(mAttacker, 5)				
			end
		end
	end
	
	--Possible revive
	if CurTime() > WARMUPTIME and not mVictim.Gibbed and Tab.Revives and not headshot and not (dmginfo:IsSuicide( mVictim ) or dmginfo:GetDamageType() == DMG_BLAST) and (mVictim.ReviveCount and mVictim.ReviveCount < 1) then
		if math.random(1,3) == 1 and dmginfo:IsBulletDamage() then
			GAMEMODE:DefaultRevive(mVictim)
			revive = true
			mVictim.NoDeathNotice = true
		end
	end		
		
	
		
	-- melee	
	if not revive and mVictim:GetAttachment( 1 ) then 
		if (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos )) < 24 then
			if dmginfo:IsMeleeDamage() and not mInflictor.IsTurretDmg then
				if dmginfo:IsDecapitationDamage() then
					
					if math.random(1,2) == 1 then
						skillpoints.AddSkillPoints(mAttacker,3)

						mVictim:Dismember("DECAPITATION",dmginfo)
							
						headshot = true

					end
				end
			end
		end
	end

	--Boss is gone
	if mVictim:IsBoss() then
		GAMEMODE:SetBoss(false)
	end
	
	--Check if we're for real dead
	if not revive then
		--Play sound
		mVictim:PlayZombieDeathSound()

		if math.random(1,10) > 2 then
		local item = "zs_ammobox"	

		if not MOBILE_SUPPLIES then
			item = "weapon_zs_tools_supplies"
			MOBILE_SUPPLIES = true
		end	
		
		local dropChance = math.random(1,10)
			if dropChance <= 2 then
				local delta = 1 - math.Clamp( ( ROUNDSTART_TIME - CurTime()) / ROUNDTIME, 0, 1 )
				local babyPrice = math.Round(delta*150) + 50			
				local possibleWeapons = {}
				
				for wep,tab in pairs(GAMEMODE.HumanWeapons) do
					if tab.Price and tab.HumanClass then
						if tab.Price <= babyPrice then
							table.insert(possibleWeapons,wep)				
						end
					end
				end
				
				item = table.Random(possibleWeapons)
				
			elseif dropChance == 3 then
				item = "item_healthvial"		
			end

			local itemToSpawn = ents.Create(item)			
			
			if IsValid(itemToSpawn) then
			
				if mVictim:Crouching() then
					itemToSpawn:SetPos(mVictim:GetPos()+Vector(0,0,20))			
				else
					itemToSpawn:SetPos(mVictim:GetPos()+Vector(0,0,32))			
				end

				itemToSpawn:Spawn()
				
				local phys = itemToSpawn:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:ApplyForceCenter(Vector(math.Rand(25, 175),math.Rand(25, 175),math.Rand(50, 375)))
					phys:SetAngles(Angle(math.Rand(0, 180),math.Rand(0, 180),math.Rand(0, 180)))
				end
			end		
		end
		local floaty = 0
		
		if headshot then
			skillpoints.AddSkillPoints(mAttacker,3)
			mAttacker:AddXP(10)
			floaty = floaty + 3
		end
		
		--Put victim in spectator mode
		if IsValid(mAttacker) and mAttacker:IsPlayer() and mAttacker ~= mVictim then
			--mVictim:SpectateEntity(mAttacker)
			--mVictim:Spectate(OBS_MODE_FREEZECAM)
			--mVictim:SendLua("surface.PlaySound(Sound(\"UI/freeze_cam.wav\"))")

			--disable getting points from teamkilling anyway
			if mAttacker:IsHuman() and mVictim:IsZombie() and not mVictim.NoBounty then
				mAttacker:AddToCounter("undeadkilled", 1)
					
				local reward = Tab.SP
					
				if UNLIFE then
					skillpoints.AddSkillPoints(mAttacker,reward)
					floaty = floaty + reward	
				end				

				if mAttacker:GetPerk("_commando") then --Double checker, just in case..
					if mAttacker:GetPerk("_profitable") then
						skillpoints.AddSkillPoints(mAttacker,reward/1.3)
						floaty = floaty + (reward/1.3)	
					end
				else 
			end
				skillpoints.AddSkillPoints(mAttacker,reward)
				mAttacker:AddXP(ZombieClasses[mVictim:GetZombieClass()].Bounty)
				mVictim:FloatingTextEffect((floaty + reward), mAttacker)
				-- Add GreenCoins and increment zombies killed counter
				mAttacker.ZombiesKilled = mAttacker.ZombiesKilled + 1
				mAttacker:GiveGreenCoins(COINS_PER_ZOMBIE)
				mAttacker.GreencoinsGained[mAttacker:Team()] = mAttacker.GreencoinsGained[ mAttacker:Team() ] + COINS_PER_ZOMBIE
					
				-- When the human kills a zombie he says (GOT ONE)
				if math.random(1,6) == 1 then
					timer.Simple(1, function()
						VoiceToKillCheer(mAttacker)
					end)
				end		
		end	
	end end
end
hook.Add("OnZombieDeath", "OnZombieKilled", OnZombieDeath)