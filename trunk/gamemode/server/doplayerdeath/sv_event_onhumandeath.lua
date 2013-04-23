-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
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

-- Died as human status
hook.Add( "OnHumanDeath", "TeamDeathMechanism", function( pl )
	pl.IsHumanDeath = true
end )

-- Died as human status
hook.Add( "PlayerSpawnZS", "TeamDeathMechanism", function( pl )
	pl.IsHumanDeath = false
end )

-- Called when a human is killed
local function OnHumanDeath( mVictim, mAttacker, mInflictor, dmginfo )

	--  Smash off current hat
	GAMEMODE:DropHat( mVictim )
	GAMEMODE:DropSuit( mVictim )
	
	-- Reset score on death
	timer.Simple( 0, function( ) if IsEntityValid ( mVictim ) then mVictim:SetFrags( 0 ) end end )
	
	-- timer.Create("DelayedCalculate", 0.2, 1, function() GAMEMODE:CalculateInfliction() end)
	
	skillpoints.Clean(mVictim)
	
	mVictim:PlayDeathSound()
	
	local revive = false
	
	-- local NextSpawn = math.Clamp ( GetInfliction() * 14, 1, 4 )
	mVictim.NextSpawn = CurTime() + 4--NextSpawn
	
	local ct = CurTime()
	
	if not mVictim.Gibbed and not dmginfo:IsSuicide( mVictim ) then
		-- timer.Create(mVictim:UniqueID().."secondwind", 2.5, 1, SecondWind, mVictim)
		-- mVictim:GiveStatus("revive2", 3.5)
		mVictim:SetZombieClass(0)
		local status = mVictim:GiveStatus("revive_slump_human")
		if status then
			status:SetReviveTime(CurTime() + 4)
			status:SetZombieInitializeTime(CurTime() + 2)
		end
		
		-- local status2 = mVictim:GiveStatus("overridemodel")
		-- if status2:IsValid() then
		-- 	status2:SetModel(mVictim:GetModel())
		-- end
		--mVictim:GiveStatus("fakecorpse", -1)
		revive = true
		mVictim.MyBodyIsReady = true -- no jokes about this one
	end
	
	if not revive then
		if GAMEMODE.WaveEnd <= ct or GAMEMODE:GetWave() == 0 then
			-- mVictim.StartSpectating = ct + 3-- math.Clamp(NextSpawn-0.1,0.2,4)
		end
	end

	-- Emo achievment
	if dmginfo:IsSuicide( mVictim ) or mAttacker:IsWorld() then
		if mVictim:IsHuman() then
			mVictim:UnlockAchievement( "emo" )
			if LASTHUMAN then
				mVictim:UnlockAchievement( "iamlegend" )
			end	
		end
	end
	
	if dmginfo:IsSuicide( mVictim ) and CurTime() < ROUNDTIME * 0.12 then
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
	if mAttacker:IsPlayer() and mVictim:IsHuman() and mAttacker:IsZombie() and not dmginfo:IsSuicide( mVictim ) then
		mAttacker:AddFrags ( 2 )
		mAttacker:AddScore( "humanskilled", 1 )
		
		-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"freshfood")
		mAttacker:AddXP(100)
		if FromBehind(mAttacker,mVictim) and not (mAttacker:IsHeadcrab() or mAttacker:IsPoisonCrab() or mAttacker:IsHowler()) then
			skillpoints.AchieveSkillShot(mAttacker,mVictim,"backbreaker")
		end
		
		if mAttacker:IsHeadcrab() then
			-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"brainsucker")
		elseif mAttacker:IsPoisonCrab() then
			-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"bleeder")
		end
		
		if mVictim.IsInfected and not mAttacker:IsPoisonCrab() then
			-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"detoxication")
		end
		
		if mVictim:IsAdmin() then
			-- skillpoints.AchieveSkillShot(mAttacker,mVictim,"noregrets")
		end
		
		-- Add brains eaten and greencoins
		mAttacker.BrainsEaten = mAttacker.BrainsEaten + 1	
		mAttacker:GiveGreenCoins( COINS_PER_HUMAN )
		mAttacker.GreencoinsGained[ mAttacker:Team() ] = mAttacker.GreencoinsGained[ mAttacker:Team() ] + COINS_PER_HUMAN
		
		-- Check brains and redeem
			if mAttacker:CanRedeem() then
				timer.Simple( 0, function() 
					if mAttacker:CanRedeem() then
						if REDEEM_PUNISHMENT then
							if (GAMEMODE:GetWave()) >= REDEEM_PUNISHMENT_TIME then
								mAttacker:ChatPrint("You can't redeem at wave "..REDEEM_PUNISHMENT_TIME)
							else	
								mAttacker:Redeem()
							end
						else
							mAttacker:Redeem()
						end
					end
				end)
			end
		
		-- Steamroller upgrade
		if mAttacker:HasBought( "steamroller" ) then
			if mAttacker:Alive() then
				-- local MaxHealth = mAttacker:GetMaximumHealth()
				local MaxHealth = ZombieClasses[mAttacker:GetZombieClass()].Health
				--mAttacker:SetHealth( math.min( MaxHealth, mAttacker:Health() + math.floor ( MaxHealth / 2 ) ) )
			end
		end
	end
		
	-- Survival times (TODO : FIX)
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
	
	-- Change victim team a frame later
	timer.Simple( 0, function() 
		if IsValid( mVictim ) then	
			if mVictim:IsHuman() then
				mVictim:SetTeam( TEAM_UNDEAD ) 
				
				GAMEMODE:CalculateInfliction()
				--  logging
				--log.PlayerJoinTeam( mVictim, TEAM_UNDEAD )
				--log.PlayerRoleChange( mVictim, mVictim:GetClassTag() )
			end
		end
	end)
	
	DataTableConnected[ mVictim:UniqueID() or "UNCONNECTED" ].IsDead = true
	
	-- Spawn wait time
	-- mVictim.NextSpawn = CurTime() + math.Clamp ( GetInfliction() * 10, 3, 8 )
	
	mVictim:StopAllLuaAnimations()
	
	--remove everything from cart
	
	-- umsg.Start("CleanWeaponsFromCart",mVictim)
	-- umsg.End()
	
	mVictim.SupplyCart.Weapons = {}

	mVictim.GotWeapon.Pistol = false
	mVictim.GotWeapon.Automatic = false
	mVictim.GotWeapon.Melee = false
	
	-- umsg.Start("CleanAmmoFromCart",mVictim)
	-- umsg.End()
	
	mVictim.SupplyCart.Ammo = {}
	
	for k,v in pairs (GAMEMODE.SkillShopAmmo) do
		mVictim.AmmoMultiplier[k] = 1
	end
	
end
hook.Add( "OnHumanDeath", "OnHumanKilled", OnHumanDeath )
