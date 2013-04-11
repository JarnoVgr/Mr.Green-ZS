-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

local math = math

-- Credits the assistant on death (if there is one) 
local function OnAssistDeath ( mVictim, mAttacker, mInflictor, mAssist, dmginfo )

	-- Case 1: Undead assistant
	if mAssist:IsZombie() then
		mAssist:AddFrags ( 1 )
		mAssist:AddXP(50)
		--skillpoints.AchieveSkillShot(attacker,pl,"freshfood")
				
		-- Give greencoins to undead assistant
		mAssist:GiveGreenCoins ( COINS_PER_HUMAN )
		mAssist.GreencoinsGained[ mAssist:Team() ] = mAssist.GreencoinsGained[ mAssist:Team() ] + COINS_PER_HUMAN
		mAssist.Assists = mAssist.Assists + 1
			
		-- Add brains 
		mAssist.BrainsEaten = mAssist.BrainsEaten + 1
		
		-- Redeem assistant if he has sufficient brains/score
		if mAssist:CanRedeem() then
			mAssist:Redeem()
		end
	end
			
	-- Case 2: Human assistant
	if mAssist:IsHuman() then
		--mAssist:AddFrags ( 1 )
		mAssist:GiveGreenCoins ( COINS_PER_ZOMBIE )
				
		-- Give greencoins and add assists counter and increment zombies killed
		mAssist.GreencoinsGained[ mAssist:Team() ] = mAssist.GreencoinsGained[ mAssist:Team() ] + COINS_PER_ZOMBIE
		mAssist.Assists = mAssist.Assists + 1
		mAssist.ZombiesKilled = mAssist.ZombiesKilled + 1

		-- Check level up ( human only )
		-- mAssist:CheckLevelUp()
		
		local reward = ZombieClasses[mVictim:GetZombieClass()].SP/2
		
		if GAMEMODE:IsRetroMode() then
			reward = 1
			if math.random(1,3) == 1 then
				-- reward = 1
			end
			if mVictim:IsCrow() then 
				reward = 0
			end
		end
		
		
		
		mAssist:AddXP(math.ceil(ZombieClasses[mVictim:GetZombieClass()].Bounty/2))
		
		skillpoints.AddSkillPoints(mAssist, math.ceil(reward))
		mVictim:FloatingTextEffect( math.ceil(reward), mAssist )
		
		--[=[if mVictim:IsHeadcrab() or mVictim:IsPoisonCrab() then
			skillpoints.AchieveSkillShot(mAssist,mVictim,"hkillassist")	
		else
			skillpoints.AchieveSkillShot(mAssist,mVictim,"killassist")	
		end]=]
	end
	
	--  logging
	if (mVictim:IsPlayer() and mAttacker:IsPlayer() and mAssist:IsPlayer()) then
		
		local properties = {}
		properties["victim_position"] = mVictim:GetPos()
		properties["attacker_position"] = mAttacker:GetPos()
		properties["assister_position"] = mAssist:GetPos()
		
		--log.PlayerOnPlayerAction( mAssist, mVictim, "kill_assist", properties )
		
	end	
	
end
hook.Add( "OnAssist", "OnAssistEvent", OnAssistDeath )
