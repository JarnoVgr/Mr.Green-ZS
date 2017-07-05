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

	timer.Simple(1, function()
		VoiceToPanic(mVictim)
	end)

	--local tr = mVictim:TraceLine(54, MASK_SHOT, team.GetPlayers(TEAM_HUMAN))
	--local pos = tr.HitPos
	--local norm = tr.HitNormal

	--local eff = EffectData()
	--eff:SetOrigin( pos )
	--eff:SetNormal( norm )
	--eff:SetScale( math.Rand(0.9,1.2) )
	--eff:SetMagnitude( math.random(5,20) )
	--util.Effect( "gib_player", eff, true, true )

	--Smash off current hat
	GAMEMODE:DropHat(mVictim)
	GAMEMODE:DropSuit(mVictim)
		
	--Drop active weapon
	if mVictim:GetActiveWeapon() ~= NULL and CurTime() > WARMUPTIME then
		--Loop through all player weapons
		for i,j in pairs(mVictim:GetWeapons()) do
			local wepCategory = GetWeaponCategory(j:GetClass())
			--if (wepCategory == "Pistol" or wepCategory == "Automatic" or wepCategory == "Melee") and mVictim:CanDropWeapon(j) then
			if mVictim:CanDropWeapon(j) then			
				--Save ammo information from weapon
				if wepCategory ~= "Melee" and j.Primary then
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
	mVictim.Weight = 0
	mVictim:PlayDeathSound()
	
	mVictim.WalkingBackwards = false
		
	--Revival
	
	if not mVictim.Gibbed and not dmginfo:IsSuicide(mVictim) then
		mVictim:SetZombieClass(0)
		mVictim.ForcePlayerModel = true
		local status = mVictim:GiveStatus("revive_slump_human")
		if status then
			status:SetReviveTime(CurTime() + 3)
			status:SetZombieInitializeTime(CurTime() + 3)
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
	
	if LASTHUMAN then
		mVictim:AddXP(400)
		mAttacker:AddXP(200)	
	end
	
	if dmginfo:IsSuicide( mVictim ) and CurTime() < ROUNDTIME * 0.12 then
		if mVictim:IsHuman() then
			mVictim.Suicided = true
		end
	end
	
	-- Retrieval upgrade
	if IsValid ( mVictim ) then
		mVictim.WeaponTable = {}
		for k, v in pairs( mVictim:GetWeapons() ) do
			table.insert( mVictim.WeaponTable,v:GetClass() )
		end	
	end
	
	-- Case 1: Human is being atacked by a zombie
	if mAttacker:IsPlayer() and mVictim:IsHuman() and mAttacker:IsZombie() and not dmginfo:IsSuicide(mVictim) then
		mAttacker:AddScore(2)
		mAttacker:AddToCounter("humanskilled", 1)
		
		skillpoints.AchieveSkillShot(mAttacker,mVictim,"freshfood")
		mAttacker:AddXP(200)
	
		
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
	
	
	
	
end
hook.Add( "OnHumanDeath", "OnHumanKilled", OnHumanDeath )
