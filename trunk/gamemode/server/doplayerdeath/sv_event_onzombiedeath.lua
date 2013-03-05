-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

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

-- Called when a zombie is killed
local function OnZombieDeath( mVictim, mAttacker, mInflictor, dmginfo )

	-- Calculate spawn cooldown
	local NextSpawn = math.Clamp ( GetInfliction() * 14, 1, 4 )
	-- mVictim.NextSpawn = CurTime() + 4-- NextSpawn
	
	-- Play that funny zombie death sound
	
	if team.NumPlayers(TEAM_HUMAN) < 1 then
		GAMEMODE:CalculateInfliction()
	end
	
	local revive = false
	local ct = CurTime()
	local headshot = false
	
	local Class = mVictim:GetZombieClass()
	local Tab = ZombieClasses[Class]
	
		if mVictim:GetAttachment( 1 ) then 
			if (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos )) < 15 then
				if not dmginfo:IsMeleeDamage() then

					mVictim:EmitSound( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav" )
					
					headshot = true
				
					-- Effect
					local effectdata = EffectData()
						effectdata:SetOrigin( mVictim:GetAttachment(1).Pos )
						effectdata:SetNormal( dmginfo:GetDamageForce():GetNormal() )
						effectdata:SetMagnitude( dmginfo:GetDamageForce():Length() * 3 )
						effectdata:SetEntity( mVictim )
					util.Effect( "headshot", effectdata, true, true )
					
					mVictim:Dismember("HEAD",dmginfo)
					
					if not mInflictor.IsTurretDmg then
						skillpoints.AddSkillPoints(mAttacker,15)
					elseif mInflictor.IsTurretDmg then
						skillpoints.AddSkillPoints(mAttacker,5)
					end
				end
			end
		end
		
	-- melee	
	if mVictim:GetAttachment( 1 ) then 
		if (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos )) < 24 then
			if dmginfo:IsMeleeDamage() and not mInflictor.IsTurretDmg then
				if dmginfo:IsDecapitationDamage() then
					
					if math.random(1,2) == 1 --[=[or mAttacker:HasBought("homerun") and math.random(1,2) == 1 ]=]then
						skillpoints.AddSkillPoints(mAttacker,5)

						mVictim:Dismember("DECAPITATION",dmginfo)
							
						headshot = true

					end
				end
			end
		end
	end
	
	if mVictim:IsCrow() then
		mVictim.NoDeathNotice = true
	end
	
	if not mVictim.Gibbed and Tab.Revives and not headshot and not (dmginfo:IsSuicide( mVictim ) or dmginfo:GetDamageType() == DMG_BLAST) and (mVictim.ReviveCount and mVictim.ReviveCount < 2) then
		if math.random(1,4) ~= 1 and dmginfo:IsBulletDamage() or dmginfo:IsMeleeDamage() and math.random(5) == 1 then -- 75% of reviving when hit by bullets, 30% when hit by melee
			GAMEMODE:DefaultRevive(mVictim)
			revive = true
			mVictim.NoDeathNotice = true
		end
	end
	
	if not revive then
	
		mVictim:PlayZombieDeathSound()
		
		if GAMEMODE:GetFighting() then
			mVictim.StartSpectating = ct + 4
			
			if IsValid( mAttacker ) and mAttacker ~= mVictim then
				mVictim:SpectateEntity( mAttacker )
				mVictim:Spectate( OBS_MODE_FREEZECAM )
				mVictim:SendLua("surface.PlaySound(\"UI/freeze_cam.wav\")")
			end
			
		else
			mVictim.StartCrowing = ct + 4.5
		end
		
		--[=[if GAMEMODE.WaveEnd <= ct then
			mVictim.StartSpectating = ct + 3--math.Clamp(NextSpawn-0.1,0.2,4)
		else
			if IsValid( mAttacker ) and mAttacker ~= mVictim then
				mVictim:SpectateEntity( mAttacker )
				mVictim:Spectate( OBS_MODE_FREEZECAM )
			end
		end
		
		if mVictim.MyBodyIsReady then
			mVictim.MyBodyIsReady = nil
		end]=]
	
	end
	-- Class achievements
	if mAttacker:IsPlayer() and mAttacker:IsHuman() and mAttacker ~= mVictim and mVictim:IsZombie() then	
		local HumanClass, ZombieClass = mAttacker:GetHumanClass(), mVictim:GetZombieClass()
			--print( mInflictor:GetClass())	:(
		--mAttacker:PrintMessage (HUD_PRINTTALK, "Damage done: "..dmginfo:GetDamage().." by "..mInflictor:GetClass().."")
		--mAttacker:PrintMessage (HUD_PRINTTALK, "Head dist: "..dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos ).."")
		
		-- Marksman
		if HumanClass == 3 then
			if mVictim:GetAttachment( 1 ) then  --why it was disabled? :O (because zombies don't have heads)
				if (dmginfo:GetDamagePosition():Distance( mVictim:GetAttachment( 1 ).Pos )) < 15 then
					if mAttacker:GetTableScore("berserker","level") == 0 and mAttacker:GetTableScore("berserker","achlevel0_1") < 1000 then
						-- mAttacker:AddTableScore("berserker","achlevel0_1",1)
					elseif mAttacker:GetTableScore("berserker","level") == 1 and mAttacker:GetTableScore("berserker","achlevel0_1") < 2500 then
						-- mAttacker:AddTableScore("berserker","achlevel0_1",1)
					end
					
					if (dmginfo:GetDamagePosition():Distance( mAttacker:GetShootPos() )) > 710 then
						if mAttacker:GetTableScore("berserker","level") == 4 then
							if mAttacker:GetTableScore("berserker","achlevel4_1") < 700 then
								-- mAttacker:AddTableScore ("berserker","achlevel4_1",1)
							end
						elseif mAttacker:GetTableScore("berserker","level") == 5 then
							if mAttacker:GetTableScore("berserker","achlevel4_1") < 1337 then
								-- mAttacker:AddTableScore ("berserker","achlevel4_1",1)
							end
						end
					end
				end
			end	
		elseif HumanClass == 2 then
			if mInflictor:IsWeapon() then
				if mInflictor:GetType() == "rifle" then
					if mAttacker:GetTableScore( "commando","level" ) == 2 and mAttacker:GetTableScore( "commando","achlevel2_2" ) < 1500 then
						-- mAttacker:AddTableScore( "commando","achlevel2_2",1 )
					elseif mAttacker:GetTableScore("commando","level") == 3 and mAttacker:GetTableScore("commando","achlevel2_2") < 3000 then
						-- mAttacker:AddTableScore( "commando","achlevel2_2",1 )
					end
				
					if ZombieClass == 5 then
						if mAttacker:GetTableScore("commando","level") == 2 and mAttacker:GetTableScore("commando","achlevel2_1") < 300 then
							-- mAttacker:AddTableScore("commando","achlevel2_1",1)
						elseif mAttacker:GetTableScore("commando","level") == 3 and mAttacker:GetTableScore("commando","achlevel2_1") < 600 then
							-- mAttacker:AddTableScore("commando","achlevel2_1",1)
						end
					end
				end
			end
		end
			
		-- Engineer 
		if HumanClass == 4 then
			if mInflictor:GetClass() == "env_explosion" then
				if mAttacker:GetTableScore("engineer","level") == 2 and mAttacker:GetTableScore("engineer","achlevel2_1") < 600 then
					-- mAttacker:AddTableScore( "engineer","achlevel2_1",1 )
				elseif mAttacker:GetTableScore("engineer","level") == 3 and mAttacker:GetTableScore("engineer","achlevel2_1") < 850 then
					-- mAttacker:AddTableScore( "engineer","achlevel2_1",1 )
				end
			end
			if mInflictor.IsTurretDmg and ZombieClass == 8 then
				-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"sector")
			end
		end
			
		-- Berserker
		if HumanClass == 3 then
			if mAttacker:GetTableScore("berserker","level") == 2 then
				if mAttacker:GetTableScore("berserker","achlevel2_1") < 300 and (ZombieClass == 4 or ZombieClass == 5 ) then
				--	mAttacker:AddTableScore ("berserker","achlevel2_1",1)
				elseif mAttacker:GetTableScore("berserker","achlevel2_2") < 1500 then
					mAttacker:AddTableScore ("berserker","achlevel2_2",1)
				end
			elseif mAttacker:GetTableScore("berserker","level") == 3 then
				if mAttacker:GetTableScore("berserker","achlevel2_1") < 600 and  (ZombieClass == 4 or ZombieClass == 5 ) then
		--			mAttacker:AddTableScore ("berserker","achlevel2_1",1)
				elseif mAttacker:GetTableScore("berserker","achlevel2_2") < 4000 then
					mAttacker:AddTableScore ("berserker","achlevel2_2",1)
				end
			end
		end
		if HumanClass == 5 then
			if mInflictor:IsWeapon() then
				if mInflictor:GetClass() == "weapon_zs_tools_hammer" then
					skillpoints.AchieveSkillShot(mAttacker,mVictim,"naild")
				end
			end
		end
	end
		
	if mAttacker:IsPlayer() and mAttacker:IsHuman() and mAttacker ~= mVictim and mVictim:IsZombie() then --disable getting points from teamkilling anyway
	
		if not revive then
			-- mAttacker:AddFrags ( 1 )
			mAttacker:AddScore( "undeadkilled", 1 )
		
			local reward = GAMEMODE:IsRetroMode() and 1 or ZombieClasses[mVictim:GetZombieClass()].SP
			
			if mVictim:IsCrow() and GAMEMODE:IsRetroMode() then reward = 0 end
		
			skillpoints.AddSkillPoints(mAttacker,reward)
			mAttacker:AddXP(ZombieClasses[mVictim:GetZombieClass()].Bounty)
			
		
		if LASTHUMAN then
			-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"hero")
		end
			
			
		-----------------------------
		
		
		
		-- Check the player class achievements stats and level up if nececsary
		-- mAttacker:CheckLevelUp()
		
		-- Add greencoins and increment zombies killed counter
		mAttacker.ZombiesKilled = mAttacker.ZombiesKilled + 1
		mAttacker:GiveGreenCoins( COINS_PER_ZOMBIE )
		mAttacker.GreencoinsGained[ mAttacker:Team() ] = mAttacker.GreencoinsGained[ mAttacker:Team() ] + COINS_PER_ZOMBIE
		
		-- Notice
		-- if math.random (1,3) == 1 then
		-- 	local killzombienotice = {"You have killed "..mVictim:Name().." ! Don't worry, he was zombie!","You have killed a zombie!","Good job on killing a zombie!"}
			-- mAttacker:Notice ( killzombienotice[math.random(1,#killzombienotice)],3, Color (190,210,210,255) )
		-- end
		
		-- When the human kills a zombie he says (GOT ONE)
		if ( math.random(1,10) == 1 ) then
			timer.Simple( 1, function() VoiceToKillCheer(mAttacker) end )
		end
		end
	end

end
hook.Add( "OnZombieDeath", "OnZombieKilled", OnZombieDeath )