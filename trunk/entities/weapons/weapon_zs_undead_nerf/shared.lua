-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end


local math = math
local team = team
local util = util
local timer = timer
local ents = ents

if CLIENT then

	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
	SWEP.IgnoreFov = true
end



SWEP.Base = "weapon_zs_base_undead_dummy"

SWEP.Author = "NECROSSIN"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Fast Zombie"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.ViewModel = Model ( "models/weapons/v_fza.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.NextAnim = 0

function SWEP:InitializeClientsideModels()

	
	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(1.069, 0, 0), angle = Angle(0, 56.855, 0) },
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(2.493, 0, 0), angle = Angle(0, 2.256, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0.486, -0.463, 0.493), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1.6, 1.6, 1.6), pos = Vector(0, 0, 0), angle = Angle(0, 63.905, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(0.685, 0.685, 0.685), pos = Vector(0, 0, 0), angle = Angle(0, 10.312, 0) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.225, 1.225, 1.225), pos = Vector(3.131, 0, 0), angle = Angle(0, 6.699, 0) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(0.768, 0.768, 0.768), pos = Vector(0, 0, 0), angle = Angle(0, 21.493, 0) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(2.75, 0, 0), angle = Angle(0, 11.43, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(0.962, 0.962, 0.962), pos = Vector(0, 0, 0), angle = Angle(1.919, -1.351, -13.695) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(1.174, 0, 0), angle = Angle(0, 23.606, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1.406, 1.406, 1.406), pos = Vector(1.644, 0, 0), angle = Angle(0, 10.906, 0) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.481, 0.481, 0.481), pos = Vector(1.955, 0, 0), angle = Angle(0, 7.756, 0) },
		["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(0.843, 0.843, 0.843), pos = Vector(0, 0, 0), angle = Angle(0, 61.275, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.205, 1.205, 1.205), pos = Vector(0, 0, 0), angle = Angle(0, 3.23, 13.274) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(0.412, 0.412, 0.412), pos = Vector(3.394, 0, 0), angle = Angle(0, -0.625, -4.888) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(0.936, 0.936, 0.936), pos = Vector(0, 0, 0), angle = Angle(0, 17.781, 0) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(0.765, 0.765, 0.765), pos = Vector(0, 0, 0), angle = Angle(0, 13.637, 0) },
		["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(1.506, 0, 0), angle = Angle(0, 66.125, 0) },
		["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(0.919, 0.919, 0.919), pos = Vector(0, 0, 0), angle = Angle(0, 56.025, 0) },
		["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(0.906, 0.906, 0.906), pos = Vector(1.218, 0, 0), angle = Angle(0, 29.437, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(0.986, 0.986, 0.986), pos = Vector(1.069, 0, 0), angle = Angle(0, 42.7, 0) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(0.957, 0.957, 0.957), pos = Vector(0, 0, 0), angle = Angle(-10.707, 2.305, 19.763) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.855, 1.855, 1.855), pos = Vector(2.043, 0, 0), angle = Angle(0, 5.118, 23.888) }
	}

	
	self.VElements = {}
	
	self.WElements = {}
	
	
end

SWEP.SwapAnims = false

SWEP.DistanceCheck = 85
SWEP.NextRoar = 0
function SWEP:OnDeploy()
	if SERVER then
		self.Owner:DrawViewModel( true )
		self.Owner:DrawWorldModel( false )
		
		timer.Simple(0.5,function()
		if not IsValid(self.Owner) or not IsValid(self.Weapon) then return end
		if self.Weapon ~= self.Owner:GetActiveWeapon() then return end
			self.BreathSound = CreateSound(self.Owner,Sound("NPC_AntlionGuard.BreathSound"))-- "npc/antlion_guard/growl_high.wav"
			
			if self.BreathSound then
				-- self.BreathSound:Play()
			end
		end)
	
	end
	--self.Owner.IsRoar = false
	
	
	
end

function SWEP:Think()
	local Owner = self.Owner
	if not ValidEntity ( Owner ) then return end
	
	local ct = CurTime()
	
	if SERVER then
		if self.BreathSound then
			self.BreathSound:PlayEx(0.3, 100) 
		end
		
	end
	
	-- Leaping
	if self.Leaping then
		local trFilter = team.GetPlayers( TEAM_UNDEAD )
		local nTrace = Owner:TraceLine ( 45, MASK_SHOT, trFilter )
		-- local Sphere = ents.FindInSphere ( Owner:GetShootPos() + Owner:GetAimVector() * 15, 20 )
		
		local pos = Owner:GetShootPos() + Owner:GetAimVector() * 15
		
		-- Easier way to bump players
		local Victim = NULL		
		for k,v in ipairs ( team.GetPlayers(TEAM_HUMAN) ) do
			if IsValid(v) and v:GetPos():Distance(pos) <= 20 and v:IsPlayer() and v ~= Owner then
				local vStart, vEnd = Owner:GetShootPos(), v:LocalToWorld ( v:OBBCenter() )
				local glitchTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
				
				-- Trace matches with entity found in sphere
				if glitchTrace.Entity == v then
					Victim = v
					break
				end
			end
		end

		-- We hit something while leaping
		if nTrace.Hit or ValidEntity ( Victim ) then
			if Owner.ViewPunch then Owner:ViewPunch( Angle( math.random(0, 70), math.random(0, 70), math.random(0, 70) ) ) end
			if SERVER then Owner:EmitSound( "physics/flesh/flesh_strider_impact_bullet1.wav" ) end
			
			-- Bump the victim!
			--if ValidEntity ( Victim ) then self:DamageEntity ( Victim, math.random(0,1) ) end
			
			-- Stopped leaping
			self.Leaping = false
			
			-- Stop, so we don't bounce around
			Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
			
			-- Cooldown
			self.NextLeap = ct + 3
			
			return
		end
		
		-- always update leap status
		if Owner:OnGround() or Owner:WaterLevel() > 0 then
			self.Leaping = false
		end
	end

	if Owner:KeyDown( IN_ATTACK ) and not self.Leaping then
		if self:GetRoar() >= 6 and not self:IsRoar() then
			self:SetRoar(0)
			self.NextAttack = ct + 2
			--self.Owner.IsRoar = true
			-- self.Owner:DoAnimationEvent( CUSTOM_SECONDARY )
			self:SetRoarEndTime(ct + 2)
			--self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			if SERVER then
				GAMEMODE:SetPlayerSpeed( self.Owner, 1 )
				self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
				self.Owner:SetJumpPower( 0 ) 
				self.Owner:EmitSound("NPC_Ichthyosaur.AttackGrowl",160, math.random(90,100)) -- "npc/ichthyosaur/attack_growl"..math.random(1,3)..".wav"-- npc/fast_zombie/fz_frenzy1.wav
				
			end 
	
				--[==[timer.Simple ( 2, function( pl )
				if not ValidEntity ( pl ) then return end
					if not pl:Alive() or not pl:IsFastZombie() then return end
						GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
						pl:SetJumpPower( ZombieClasses[ pl:GetZombieClass() ].JumpPower ) 
					end, self.Owner )
					
					if SERVER then self.Owner:EmitSound("NPC_FastZombie.Frenzy") end]==]
					
		end
	end	
	
	self:CheckRoar()
	self:CheckRoar2()
	
	-- Attacking
	if not Owner:KeyDown( IN_ATTACK ) then
		self.Swinging = false
		--self.NextRoar = 0
		-- return
	end
	self:NextThink(CurTime())
	return true

end

function SWEP:CheckRoar()
	local rend = self:GetRoarEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetRoarEndTime(0)
	
	if SERVER then
		local pl = self.Owner
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
		pl:SetJumpPower( ZombieClasses[ pl:GetZombieClass() ].JumpPower ) 
	end
	
end

function SWEP:CheckRoar2()
	local rend = self:GetRoarEndTime2()
	if rend == 0 or CurTime() < rend then return end
	self:SetRoarEndTime2(0)
	
	if SERVER then
		local pl = self.Owner
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
		pl:SetJumpPower( ZombieClasses[ pl:GetZombieClass() ].JumpPower ) 
	end
	
end

function SWEP:SetRoarEndTime(time)
	self:SetDTFloat(0,time)
end

function SWEP:GetRoarEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsRoar()
	return self:GetRoarEndTime() > 0
end

function SWEP:SetRoarEndTime2(time)
	self:SetDTFloat(1,time)
end

function SWEP:GetRoarEndTime2()
	return self:GetDTFloat(1)
end

function SWEP:IsRoar2()
	return self:GetRoarEndTime2() > 0
end

function SWEP:SetRoar(count)
	self:SetDTInt(0,count)
end

function SWEP:AddRoar(am)
	self:SetRoar(self:GetRoar()+am)
end

function SWEP:GetRoar()
	return self:GetDTInt(0)
end
SWEP.ClimbTime = 0
local climblerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	climblerp = math.Approach(climblerp, ((self.ClimbTime > CurTime()) and 1) or 0, FrameTime() * ((climblerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * climblerp)
	return pos + -8 * climblerp * ang:Up() + -12 * climblerp * ang:Forward(), ang
end

SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if self.NextAttack > CurTime() then return end
	if self.Leaping then return end
	if self.Owner.IsRoar then return end
	self.Owner:DoAnimationEvent ( CUSTOM_PRIMARY )
	local Owner = self.Owner
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	self:AddRoar(1)
	-- Cooldown
	self.NextAttack = CurTime() + self.Primary.Delay
	
	-- Calculate damage done
	local Damage = math.Rand(7,8)
	
	-- Trace an object
	local nTrace = Owner:TraceLine ( 85, MASK_SHOT, trFilter )
	local Victim = nTrace.Entity
	
	-- Play miss sound anyway
	if SERVER then Owner:EmitSound( "npc/zombie/claw_miss"..math.random(1, 2)..".wav" ) end
	
	-- Animation
	Owner:SetAnimation( PLAYER_ATTACK1 )
	if self.NextAnim < CurTime() then 
		if self.SwapAnims then self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER ) else self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) end
		--self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		self.SwapAnims = not self.SwapAnims
		self.NextAnim = CurTime() + 0.5
	end
	
	-- First trace
	if CLIENT then return end
	if ValidEntity ( Victim ) then self:DamageEntity ( Victim, Damage ) return end
	
	-- Tracehull attack ( second trace if the first one doesn't hit )
	local TraceHull = util.TraceHull( { start = Owner:GetShootPos(), endpos = Owner:GetShootPos() + ( Owner:GetAimVector() * 20 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector ( 20,20,20 ) } )
	local TraceHit = ValidEntity ( TraceHull.Entity )	

	-- Hit nothing
	if not TraceHit then return end
	
	-- Do a trace so that the tracehull won't push or damage objects over a wall or something
	local vStart, vEnd = Owner:GetShootPos(), TraceHull.Entity:LocalToWorld ( TraceHull.Entity:OBBCenter() )
	local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
	-- Hitting through wall
	if TraceHull.Entity ~= ExploitTrace.Entity then return end
	
	-- Damage entity with tracehull
	self:DamageEntity ( TraceHull.Entity, Damage ) 
end
	
function SWEP:DamageEntity ( ent, Damage )
	if not ValidEntity ( ent ) then return end
	local Owner = self.Owner
	
	if CLIENT then return end
	
	-- Don't hurt other zombies
	if ent.Team and ent:Team() == TEAM_UNDEAD then return end
	
	-- Get phys object
	local phys = ent:GetPhysicsObject()
	
	-- Break glass
	if ent:GetClass() == "func_breakable_surf" then
		ent:Fire( "break", "", 0 )
	end
	
	-- Play the hit sound
	Owner:EmitSound( "npc/zombie/claw_strike"..math.random(1, 3)..".wav" )
		
	-- Take damage
	ent:TakeDamage ( Damage, Owner, self )
	
	-- Push for whatever it hits
	local Velocity = Owner:EyeAngles():Forward() * 1000
	
	-- Push the target off is leaping
	if self.Leaping and ent:IsPlayer() then
		Velocity.z = 150
		if ent:OnGround() then ent:SetVelocity( Velocity * 0.5 ) else ent:SetVelocity ( Velocity * 0.1 ) end
		if ent.ViewPunch then ent:ViewPunch( Angle( math.random(-20, 20), math.random(-20, 20), math.random(-20, 20) ) ) end
	end
	
	-- Apply force to the correct object
	if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
		if Velocity.z < 200 then Velocity.z = 200 end
				
		phys:ApplyForceCenter( Velocity * 2 )
		ent:SetPhysicsAttacker( Owner )
	end	
end

SWEP.NextLeap = 0
SWEP.NextClimb = 0
SWEP.NextSlash = 0

function SWEP:SecondaryAttack()
	if self.Swinging then return end
	if self:IsRoar() then return end
	local Owner = self.Owner
	
	-- See where the player is ( on ground or flying )
	local bOnGround, bCrouching = Owner:OnGround(), Owner:Crouching()
	
	-- Trace filtering climb factors
	local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,20 ), Owner:GetAimVector()
	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 35 ), filter = Owner } )
	
	-- Climbing
	if CurTime() >= self.NextClimb and not bCrouching and trClimb.HitWorld and not trClimb.HitSky then

		-- Climb!
		local Velocity = Vector ( 0,0,150 )
		if bOnGround then Velocity.z = 280 end
		Owner:SetLocalVelocity( Velocity )
			
		-- Cooldown
		self.NextClimb = CurTime() + self.Secondary.Delay
		self.ClimbTime = CurTime() + 0.5
		
		-- Set the thirdperson animation
		local iSeq, iDuration = Owner:LookupSequence( "climbloop" )
		Owner.iZombieSecAttack = iDuration + CurTime()
			
		-- Sound
		if SERVER then Owner:EmitSound( "player/footsteps/metalgrate"..math.random(1,4)..".wav" ) end
			
		-- Climbing animation
		if self.NextAnim < CurTime() then 
			self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			self.NextAnim = CurTime() + 0.4
		end
		Owner:SetAnimation( PLAYER_SUPERJUMP )
		
		return
	end
	
	local trFilter = team.GetPlayers( TEAM_UNDEAD )
	local nTrace = Owner:TraceLine ( 45, MASK_SHOT, trFilter )
	
	if nTrace.Hit and nTrace.Entity and ValidEntity(nTrace.Entity) and CurTime() >= self.NextSlash and
		(nTrace.Entity:IsPlayer() and nTrace.Entity:IsHuman() and nTrace.Entity:Alive()) then

		local target = nTrace.Entity
		
		if not target.KnockedDown then
		
			local Velocity = self.Owner:GetAngles():Forward() * 400
			Velocity.z = 450 
				
			target:SetGroundEntity( NULL )
			target:SetLocalVelocity( Velocity )
			if SERVER then 
				target:GiveStatus("knockdown",math.Rand(3,6)) 
				target:TakeDamage(1, Owner, self )
				--target:EmitSound("npc/zombie/zombie_pound_door.wav",130,95)
				target:EmitSound("npc/antlion_guard/shove1.wav",130,95)
				target:EmitSound ( table.Random ( VoiceSets[ target.VoiceSet or 1 ].Frightened ) )
				
				GAMEMODE:SetPlayerSpeed( self.Owner, 1 )
				self.Owner:SetLocalVelocity ( Vector ( 0,0,0 ) )
				self.Owner:SetJumpPower( 0 ) 
				
			end
			
			self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
			if Owner.ViewPunch then Owner:ViewPunch( Angle( math.random(0, 70), math.random(0, 70), math.random(0, 70) ) ) end
				
			self:SetRoarEndTime2(CurTime() + 2)
			
			self.NextSlash = CurTime() + 3
			self.SlashAnimation = CurTime() + 1.5
			self.NextLeap = CurTime() + 2
			
			Owner:DoAnimationEvent( CUSTOM_SECONDARY )
			return
		end
	end
	
	
	if trClimb.HitWorld then return end
	
	-- Leap cooldown / player flying
	if CurTime() < self.NextLeap or not bOnGround or self.Leaping then return end
	
	-- Set flying velocity
	local Velocity = self.Owner:GetAngles():Forward() * 600
	if Velocity.z < 200 then Velocity.z = 400 end
	
	-- Apply velocity and set leap status to true
	Owner:SetGroundEntity( NULL )
	Owner:SetLocalVelocity( Velocity )
	
	self.Leaping = true
	
	-- Leap cooldown
	self.NextLeap = CurTime() + 2
	
	-- Fast zombie scream
	if SERVER then Owner:EmitSound( "npc/antlion_guard/angry"..math.random(1,3)..".wav", 140, math.random(80,90) ) end-- npc/fast_zombie/fz_scream1.wav
end

function SWEP:Reload()
	return false
end

function SWEP:_OnRemove()
	if SERVER then
		if self.BreathSound then
			self.BreathSound:Stop()
		end
	end
return true
end

function SWEP:_OnDrop()
	if self and self:IsValid() then
		self:Remove()
	end
end

-- Shutup.
function SWEP:Precache()
	util.PrecacheSound("npc/fast_zombie/fz_scream1.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombie/zo_attack1.wav")
	util.PrecacheSound("npc/fast_zombie/fz_alert_close1.wav")
	util.PrecacheSound("npc/zombie/zombie_die1.wav")
	util.PrecacheSound("npc/fast_zombie/fz_frenzy1.wav")
	util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	util.PrecacheSound("player/footsteps/metalgrate1.wav")
	util.PrecacheSound("player/footsteps/metalgrate2.wav")
	util.PrecacheSound("player/footsteps/metalgrate3.wav")
	util.PrecacheSound("player/footsteps/metalgrate4.wav")
	util.PrecacheSound("npc/fast_zombie/gurgle_loop1.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[2].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[2].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end