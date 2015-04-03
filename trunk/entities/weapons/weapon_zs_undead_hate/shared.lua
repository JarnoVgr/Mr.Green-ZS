-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile ()

if CLIENT then
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
end

SWEP.Base = "weapon_zs_base_undead_dummy"

SWEP.Author = "NECROSSIN"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model("models/weapons/v_pza.mdl")
SWEP.WorldModel = Model("models/weapons/w_chainsaw.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.PrintName = "Hate"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 45
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"
SWEP.SwapAnims = false
SWEP.DistanceCheck = 95

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.343, 1.343, 1.343), pos = Vector(0, 0, 0), angle = Angle(-16.043, 20.868, -15.419) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.462, 1.462, 1.462), pos = Vector(0, 0, 0), angle = Angle(0, 3.68, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 1.419, -10.006), angle = Angle(0, 14.248, 12.737) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.406, 1.406, 1.406), pos = Vector(0, 0, 0), angle = Angle(-2.5, -26.681, 9.494) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(4.4, -0.888, -3.712), angle = Angle(-4.75, 2.081, 0.675) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, -3.675, 0), angle = Angle(-0.445, -3.039, 19.518) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.263, 1.263, 1.263), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1.156, 1.156, 1.156), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-1.55, 1.069, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(0.518, 0.518, 0.518), pos = Vector(0, 0, 0), angle = Angle(0, -3.294, -5.969) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.179, 1.179, 1.179), pos = Vector(0, 0, 0), angle = Angle(19.468, 16.761, -3.776) }
}
	
SWEP.VElements = {
	["chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.368, -2.464, 1.712), angle = Angle(4.574, 93.4, 0), size = Vector(1.088, 1.088, 1.088), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
	
SWEP.WElements = {}

function SWEP:OnDeploy()
	if SERVER then
		self.DeployTime = CurTime() + 3.5
		self.ChainSound = CreateSound( self.Owner, "weapons/melee/chainsaw_idle.wav" ) 
		if not self.Deployed then
			self.Owner:EmitSound("weapons/melee/chainsaw_start_0"..math.random(1,2)..".wav")
			self.Deployed = true
		end
	end
end

function SWEP:Think()
	if SERVER then
		if self.ChainSound and self.DeployTime < CurTime() then
			self.ChainSound:PlayEx(0.3, 100) 
		end 
	end
end

-- Primary attack
SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextAttack then
		return
	end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 3)
	
	-- Make things easier
	local pl = self.Owner
	self.PreHit = nil
	
	-- Trace filter
	local trFilter = self.Owner -- team.GetPlayers( TEAM_ZOMBIE )
	
	-- Set the thirdperson animation and emit zombie attack sound
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	 
	--[[if SERVER then
		GAMEMODE:SetPlayerSpeed(self.Owner, 1,1)
		self.Owner:SetLocalVelocity(Vector(0, 0, 0))
	end]]

	timer.Simple(0.4, function()
		if not IsValid(pl) then
			return
		end

		pl:DoAnimationEvent( CUSTOM_PRIMARY )	
	end)

	--[[timer.Simple(1.3, function()
		if not IsValid(pl) then
			return
		end
			
		--Conditions
		if not pl:Alive() then
			return
		end
	
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed,ZombieClasses[ pl:GetZombieClass() ].Speed )
	end)]]
		
	if SERVER then
		self.Owner:EmitSound(table.Random ( ZombieClasses[10].AttackSounds ), 120, math.random( 70, 80 ) )
	end
	 
	--Trace an object
	local trace = pl:TraceLine( self.DistanceCheck, MASK_SHOT, trFilter )
	if trace.Hit and IsValid ( trace.Entity ) and not trace.Entity:IsPlayer() then
		self.PreHit = trace.Entity
	end
	
	--Delayed attack function (claw mechanism)
	if SERVER then
		timer.Simple(0.7, function()
			self:DoPrimaryAttack(trace, pl, self.PreHit)
		end)
	end

	timer.Simple(0.55, function()
			if not IsValid(pl) or not IsValid(self.Weapon) then
				return
			end
			
			if self.SwapAnims then
				self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			else
				self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			end
			self.SwapAnims = not self.SwapAnims
		end)	
				
	--Set the next swing attack for cooldown
	self.NextAttack = CurTime() + 3
	self.NextHit = CurTime() + 0.7
end

-- Primary attack function
function SWEP:DoPrimaryAttack ( trace, pl, victim )
	if not IsValid ( self.Owner ) then
		return
	end
	local mOwner = self.Owner
	
	-- Trace filter
	local trFilter = self.Owner-- team.GetPlayers( TEAM_UNDEAD )
	
	-- Calculate damage done
	local Damage = math.random( 80, 90 )

	local TraceHit, HullHit = false, false
	
	-- Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * 5000
	
	-- Tracehull attack
	local trHull = util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 50 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector( 20,20,20 ) } )
	
	local tr
	if not IsValid ( victim ) then	
		tr = pl:TraceLine ( self.DistanceCheck, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = IsValid ( victim )
	HullHit = IsValid ( trHull.Entity )
	
	if SERVER then 
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, math.random( 70, 80 ) ) end
	
	-- Punch the prop / damage the player if the pretrace is valid
	if IsValid ( victim ) then
		local phys = victim:GetPhysicsObject()
		
		-- Break glass
		if victim:GetClass() == "func_breakable_surf" then
			victim:Fire( "break", "", 0 )
		end
		
		
		-- Take damage
		victim:TakeDamage ( math.Clamp( Damage, 1, 99 ), self.Owner, self )
		
		if victim:IsPlayer() and victim:IsZombie() then
			victim:TakeDamage ( Damage/4, victim, self )
		end

		-- Claw sound
		if victim:IsPlayer() then
			victim:EmitSound("weapons/melee/chainsaw_gore_0"..math.random(1,4)..".wav",100, math.random( 90, 110 ))
			if SERVER then util.Blood(tr.HitPos, math.Rand(Damage * 0.25, Damage * 0.6), (tr.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(Damage * 6, Damage * 12), true) end
		else
			-- Play the hit sound
			pl:EmitSound( "ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
		end
				
		-- Case 2: It is a valid physics object
		if phys:IsValid() and not victim:IsNPC() and phys:IsMoveable() and not victim:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			-- Apply force to prop and make the physics attacker myself
			phys:ApplyForceCenter( Velocity )
			victim:SetPhysicsAttacker( pl )
		end
	end
	
	-- -- Verify tracehull entity
	if HullHit and not TraceHit then
		local ent = trHull.Entity
		local phys = ent:GetPhysicsObject()
		
		-- Do a trace so that the tracehull won't push or damage objects over a wall or something
		local vStart, vEnd = self.Owner:GetShootPos(), ent:LocalToWorld ( ent:OBBCenter() )
		local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
		if ent ~= ExploitTrace.Entity then return end
		
		-- Break glass
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire( "break", "", 0 )
		end
	
		
		-- From behind
		if ent:IsPlayer() then
			ent:EmitSound("weapons/melee/chainsaw_gore_0"..math.random(1,4)..".wav",100, math.random( 90, 110 ))
			if SERVER then util.Blood(tr.HitPos, math.Rand(Damage * 0.25, Damage * 0.6), (tr.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(Damage * 6, Damage * 12), true) end
		else
			-- Play the hit sound
			pl:EmitSound( "ambient/machines/slicer1.wav", 100, math.random( 90, 110 ) )
		end
		
		-- Take damage
		ent:TakeDamage ( math.Clamp( Damage, 1, 99 ), self.Owner, self )
		
		if ent:IsPlayer() and ent:IsZombie() then
			ent:TakeDamage ( Damage/4, ent, self )
		end
	
		-- Apply force to the correct object
		if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() and not ent:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			phys:ApplyForceCenter( Velocity )
			ent:SetPhysicsAttacker( pl )
		end	
	end

end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	local mOwner = self.Owner
	
	-- Thirdperson animation
	--mOwner:DoAnimationEvent( CUSTOM_SECONDARY )
		
	-- Emit both claw attack sound and weird funny sound
	if SERVER then self.Owner:EmitSound( table.Random ( ZombieClasses[10].IdleSounds ),math.random( 110, 160 ),math.random( 85, 110 )  ) end

	self.NextYell = CurTime() + math.random(8,13)
end


function SWEP:Reload()
	return false
end

function SWEP:_OnRemove()
	if SERVER then
		if self.Owner and self.Owner:IsValid() then
			self.Owner:EmitSound("weapons/melee/chainsaw_die_01.wav")
		end
		self.ChainSound:Stop()
	end
end 

function SWEP:OnDrop()
	if self and self:IsValid() then
		self:Remove()
	end
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie_poison/pz_throw2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_throw3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn1.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle4.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_breathe_loop1.wav")
	
	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[3].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].IdleSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[3].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
	
	function SWEP:DrawWorldModel()
		--self:SetMaterial("models/flesh")
		self:DrawModel()
	end
	
end


if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
		draw.SimpleTextOutlined("'c' to change perspective", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
end
