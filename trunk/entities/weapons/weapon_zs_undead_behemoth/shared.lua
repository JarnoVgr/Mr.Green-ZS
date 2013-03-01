-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.PrintName = "weapon"
end

if CLIENT then
	SWEP.PrintName = "Behemoth"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = true
	SWEP.CSMuzzleFlashes = false
	
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = false
	
end
SWEP.Base = "weapon_zs_base_undead_dummy"

SWEP.Author = "NECROSSIN"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model("models/weapons/v_zombine.mdl")
SWEP.WorldModel = Model("models/Weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DistanceCheck = 88

SWEP.SwapAnims = false
SWEP.AttackAnimations = { "attackD", "attackE", "attackF" }

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0.63, 0) },
		["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -24.8, 0) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1.1, 1.1, 1.1), pos = Vector(3.194, 0, 0), angle = Angle(-19.664, 6.831, 9.673) },
		["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(0.987, 0.987, 0.987), pos = Vector(0, 0, 0), angle = Angle(-6.939, 3.457, 19.375) },
		["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-12.358, 1.713, 9.805), angle = Angle(70.4, 10.623, -21.525) },
		["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -52.845, 0) },
		["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -31.17, 0) },
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(39.657, -4.375, -4.325) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.1, 1.1, 1.1), pos = Vector(0, 0, 0), angle = Angle(53.729, 15.331, 47) },
		["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -38.395, 0) },
		["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -50.112, 0) },
		["ValveBiped.Bip01_R_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -27.014, 0) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15.839, -14.563, -43.345) },
		["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -77.625, 0) },
		["ValveBiped.Bip01_R_Finger32"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -11.837, 0) }
	}
	
	self.VElements = {
		["crowbar"] = { type = "Model", model = "models/Weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.75, -1.869, -0.745), angle = Angle(108.43, 108.362, 45.393), size = Vector(1, 1.399, 1.399), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
	}

	self.WElements = {
		["bone1+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.127, 5.98, 4.98), angle = Angle(78.624, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.489, 6.668, -4.731), angle = Angle(109.05, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["eye1"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, 2.168, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(10.206, -0.014, 0.361), angle = Angle(-180, -93.051, -91.457), size = Vector(1.605, 1.605, 1.605), color = Color(211, 211, 211, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["crowbar"] = { type = "Model", model = "models/Weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.857, 0.418, 1.325), angle = Angle(0, -107.212, -97.001), size = Vector(1, 1.715, 1.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["eye1+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, -2.438, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	}
	
end

function SWEP:Reload()
	return false
end

function SWEP:OnDeploy()
	if SERVER then
		self.Owner.Moaning = false
	end
	self.Owner.IsMoaning = false 
	self.Owner.ZomAnim = math.random(1, 3)
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	
	//Delay secondary attack
	self.Weapon:SetNextPrimaryFire ( CurTime() + 1.7 )
	
	//Make things easier
	local pl = self.Owner
	self.PreHit = nil
	
	//Trace filter
	local trFilter = self.Owner//team.GetPlayers( TEAM_ZOMBIE )
		
	//Hacky way for the animations
	//if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	//self.SwapAnims = not self.SwapAnims

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)


	
	//Set the thirdperson animation and emit zombie attack sound
	pl:DoAnimationEvent( CUSTOM_PRIMARY )
	//if SERVER then self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav") end
	 
	//Trace an object
	local trace = pl:TraceLine( self.DistanceCheck, MASK_SHOT, trFilter )
	if trace.Hit and ValidEntity ( trace.Entity ) and not trace.Entity:IsPlayer() then //no more Mr. Long arms
		self.PreHit = trace.Entity
	end
	
	if SERVER then
		GAMEMODE:SetPlayerSpeed( self.Owner, 120, 120 )
	end 
	
	timer.Simple ( 1.6, function()
		if not ValidEntity ( pl ) then return end
		
		if not pl:Alive() or not pl:GetZombieClass() == 11 then return end
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed, ZombieClasses[ pl:GetZombieClass() ].Speed )
	end)
	
	//Delayed attack function (claw mechanism)
	if SERVER then timer.Simple ( 0.5,function() self:DoPrimaryAttack(trace, pl, self.PreHit) end ) end

	// Set the next swing attack for cooldown
	self.NextSwing = CurTime() + 2.1
	self.NextHit = CurTime() + 2
end

function SWEP:DoPrimaryAttack ( trace, pl, victim )
	if not ValidEntity ( self.Owner ) then return end

	//Trace filter
	local trFilter = self.Owner//team.GetPlayers( TEAM_UNDEAD )
	//Calculate damage done
	local Damage = math.random(60,75)
	local TraceHit, HullHit = false, false

	//Push for whatever it hits
	local Velocity = self.Owner:EyeAngles():Forward() * math.Clamp ( Damage * 1000, 25000, 37000 )
	Velocity = Velocity * 0.4
	
	//Tracehull attack
	local trHull = util.TraceHull( { start = pl:GetShootPos(), endpos = pl:GetShootPos() + ( pl:GetAimVector() * 20 ), filter = trFilter, mins = Vector( -15,-10,-18 ), maxs = Vector( 20,20,20 ) } )
	
	local tr
	if not ValidEntity ( victim ) then	
		tr = pl:TraceLine ( self.DistanceCheck, MASK_SHOT, trFilter )
		victim = tr.Entity
	end
	
	TraceHit = ValidEntity ( victim )
	HullHit = ValidEntity ( trHull.Entity )
	
	//Play miss sound anyway
	pl:EmitSound("player/zombies/b/swing.wav",math.random(100,130),math.random(95,100))
	
	//Punch the prop / damage the player if the pretrace is valid
	if ValidEntity ( victim ) then
		local phys = victim:GetPhysicsObject()
		
		//Break glass
		if victim:GetClass() == "func_breakable_surf" then
			victim:Fire( "break", "", 0 )
		end
						
		//Take damage
		victim:TakeDamage ( Damage, self.Owner, self )
			
		//Claw sound
		//pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
		if victim:IsPlayer() then
			pl:EmitSound("player/zombies/b/hitflesh.wav",math.random(100,130),math.random(95,100))
			if SERVER then util.Blood(tr.HitPos, math.Rand(Damage * 0.25, Damage * 0.6), (tr.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(Damage * 6, Damage * 12), true) end
		else
			pl:EmitSound("player/zombies/b/hitwall.wav",math.random(100,130),math.random(95,100))
		end
				
		//Case 2: It is a valid physics object
		if phys:IsValid() and not victim:IsNPC() and phys:IsMoveable() and not victim:IsPlayer() then
			if Velocity.z < 1800 then Velocity.z = 1800 end
					
			//Apply force to prop and make the physics attacker myself
			phys:ApplyForceCenter( Velocity )
			victim:SetPhysicsAttacker( pl )
		end
	end
	
	-- //Verify tracehull entity
	if HullHit and not TraceHit then
		local ent = trHull.Entity
		local phys = ent:GetPhysicsObject()
		
		//Do a trace so that the tracehull won't push or damage objects over a wall or something
		local vStart, vEnd = self.Owner:GetShootPos(), ent:LocalToWorld ( ent:OBBCenter() )
		local ExploitTrace = util.TraceLine ( { start = vStart, endpos = vEnd, filter = trFilter } )
		
		if ent != ExploitTrace.Entity then 

		return end
		
		//Break glass
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire( "break", "", 0 )
		end
		
		//Play the hit sound
		//pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
		
		if victim:IsPlayer() then
			pl:EmitSound("player/zombies/b/hitflesh.wav",math.random(100,130),math.random(95,100))
			if SERVER then util.Blood(tr.HitPos, math.Rand(Damage * 0.25, Damage * 0.6), (tr.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(Damage * 6, Damage * 12), true) end
		else
			pl:EmitSound("player/zombies/b/hitwall.wav",math.random(100,130),math.random(95,100))
		end
		
		//Take damage
		ent:TakeDamage ( Damage, self.Owner, self )
	
		//Apply force to the correct object
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

	if SERVER then self.Owner:EmitSound( "player/zombies/b/scream.wav",math.random( 130, 150 ),math.random( 80, 110 )  ) end

	self.NextYell = CurTime() + math.random(8,13)
end

function SWEP:_OnRemove()


end

function SWEP:Reload()
	return false
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end