-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

-- Died as human status
hook.Add( "OnHumanDeath", "TeamDeathMechanism", function( pl )
	pl.IsHumanDeath = true
end )

-- Died as human status
hook.Add( "PlayerSpawn", "TeamDeathMechanism", function( pl )
	pl.IsHumanDeath = false
end )

-- Called when a human is killed
local function OnHumanDeath( mVictim, mAttacker, mInflictor, dmginfo )
	--Smash off current hat
	GAMEMODE:DropHat( mVictim )
	GAMEMODE:DropSuit( mVictim )
		
	--Drop active weapon
	if mVictim:GetActiveWeapon() ~= NULL and CurTime() > WARMUPTIME then
		--Loop through all player weapons
		for i,j in pairs (mVictim:GetWeapons()) do
			local wepCategory = GetWeaponCategory(j:GetClass())
			if (wepCategory == "Pistol" or wepCategory == "Automatic" or wepCategory == "Melee") and mVictim:CanDropWeapon(j) then
				--Save ammo information from weapon
				if wepCategory ~= "Melee" then
					j.Primary.RemainingAmmo = j:Clip1()
					j.Primary.Magazine = mVictim:GetAmmoCount(j:GetPrimaryAmmoTypeString())
				end
					
				--
				if wepCategory == "Tool1" or wepCategory == "Tool2" then
					j.Ammunition = j:Clip1()
					if wepname == "weapon_zs_medkit" then
						j.RemainingAmmunition = mVictim:GetAmmoCount(j:GetPrimaryAmmoTypeString())
					end
				end
			
				mVictim:DropWeapon(j)
			end
		end
	end
	
	--Reset score on death
	timer.Simple(0, function()
		if IsEntityValid(mVictim) then
			skillpoints.SetupSkillPoints(mVictim)
		end
	end)
		
	skillpoints.Clean(mVictim)
	
	mVictim:PlayDeathSound()
	
	if CurTime() <= WARMUPTIME then
		mVictim.NextSpawn = WARMUPTIME+2
		mVictim:SendLua("MySelf.NextSpawn = ".. (WARMUPTIME+2))
	else
		mVictim.NextSpawn = CurTime() + 2
		mVictim:SendLua("MySelf.NextSpawn = CurTime() + 2")
	end
	
	--Revival
	if not mVictim.Gibbed and not dmginfo:IsSuicide(mVictim) then
		mVictim:SetZombieClass(0)
		mVictim.ForcePlayerModel = true
		local status = mVictim:GiveStatus("revive_slump_human")
		if status then
			status:SetReviveTime(CurTime() + 4)
			status:SetZombieInitializeTime(CurTime() + 2)
		end

		mVictim.MyBodyIsReady = true -- no jokes about this one
	end
	
	-- Emo achievment
	if dmginfo:IsSuicide( mVictim ) or mAttacker:IsWorld() then
		if mVictim:IsHuman() then
			mVictim:UnlockAchievement("emo")
			if LASTHUMAN then
				mVictim:UnlockAchievement("iamlegend")
			end	
		end
	end
	
	if dmginfo:IsSuicide( mVictim ) and ServerTime() < ROUNDTIME * 0.12 then
		if mVictim:IsHuman() then
			mVictim.Suicided = true
		end
	end
	
	-- Retrieval upgrade
	if ValidEntity ( mVictim ) then
		mVictim.WeaponTable = {}
		for k, v in pairs( mVictim:GetWeapons() ) do
			table.insert( mVictim.WeaponTable,v:GetClass() )
		end	
	end
	
	-- Case 1: Human is being atacked by a zombie
	if mAttacker:IsPlayer() and mVictim:IsHuman() and mAttacker:IsZombie() and not dmginfo:IsSuicide(mVictim) then
		mAttacker:AddScore(2)
		mAttacker:AddToCounter("humanskilled", 1)
		
		-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"freshfood")
		mAttacker:AddXP(100)
		if FromBehind(mAttacker,mVictim) and not (mAttacker:IsHeadcrab() or mAttacker:IsPoisonCrab() or mAttacker:IsHowler()) then
			skillpoints.AchieveSkillShot(mAttacker,mVictim,"backbreaker")
		end
		
		--[[if mAttacker:IsHeadcrab() then
			skillpoints.AchieveSkillShot(mAttacker,mVictim,"brainsucker")
		elseif mAttacker:IsPoisonCrab() then
			skillpoints.AchieveSkillShot(mAttacker,mVictim,"bleeder")
		end]]
		
		--[[if mVictim.IsInfected and not mAttacker:IsPoisonCrab() then
			skillpoints.AchieveSkillShot(mAttacker,mVictim,"detoxication")
		end]]
		
		--[[if mVictim:IsAdmin() then
			skillpoints.AchieveSkillShot(mAttacker,mVictim,"noregrets")
		end]]
		
		-- Add brains eaten and greencoins
		mAttacker.BrainsEaten = mAttacker.BrainsEaten + 1
		mAttacker:GiveGreenCoins(COINS_PER_HUMAN)
		mAttacker.GreencoinsGained[ mAttacker:Team() ] = mAttacker.GreencoinsGained[ mAttacker:Team() ] + COINS_PER_HUMAN
		
		-- Check brains and redeem
		if mAttacker:CanRedeem() then
			timer.Simple( 0, function() 
				if mAttacker:CanRedeem() then
					mAttacker:Redeem()
				end
			end)
		end
		
		-- Steamroller upgrade
		--if mAttacker:HasBought("steamroller") then
			--if mAttacker:Alive() then
			--	local MaxHealth = ZombieClasses[mAttacker:GetZombieClass()].Health
			--	mAttacker:SetHealth( math.min( MaxHealth, mAttacker:Health() + math.floor ( MaxHealth / 2 ) ) )
			--end
		--end
	end
		
	--Survival times (TODO : FIX)
	if mVictim.SpawnedTime then
		local survtime = CurTime() - mVictim.SpawnedTime
		if mVictim.SurvivalTime then
			if survtime > mVictim.SurvivalTime then
				mVictim.SurvivalTime = survtime
			end
		else
			mVictim.SurvivalTime = CurTime() - mVictim.SpawnedTime
		end
	end
	
	-- TODO CLEAN	
	DeSpawnProtection( mVictim ) -- Disable his spawn protection as human!
	
	--Change victim team a frame later
	timer.Simple( 0, function() 
		if IsValid( mVictim ) and mVictim:IsHuman() then
			mVictim:SetTeam(TEAM_UNDEAD)
				
			GAMEMODE:CalculateInfliction()
		end
	end)
	
	DataTableConnected[ mVictim:UniqueID() or "UNCONNECTED" ].IsDead = true
	
	mVictim:StopAllLuaAnimations()
		
	mVictim.SupplyCart.Weapons = {}

	mVictim.GotWeapon.Pistol = false
	mVictim.GotWeapon.Automatic = false
	mVictim.GotWeapon.Melee = false
	
	mVictim.SupplyCart.Ammo = {}
	
	for k,v in pairs (GAMEMODE.SkillShopAmmo) do
		mVictim.AmmoMultiplier[k] = 1
	end
end
hook.Add( "OnHumanDeath", "OnHumanKilled", OnHumanDeath )
