-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.PrintName = "Burner"

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true

	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -72.75, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -69.2, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -68.004, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58.772, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.871, -71.754, -22.512) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.777, 11.446, -35.982) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.693, 2.532, 25.214) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.1, -47.251) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.029, -52.984, -12.752) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -55.211, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.035, -8.169, -6.045) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.917, -14.115, -34.5) }
	}
		
	SWEP.VElements = {
		["crowbar"] = { type = "Model", model = "models/weapons/c_crowbar.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(-27.084, -15.171, -11.478), angle = Angle(-1.976, 0, -98.67), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["bone1+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.127, 5.98, 4.98), angle = Angle(78.624, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.489, 6.668, -4.731), angle = Angle(109.05, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["eye1"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, 2.168, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(10.206, -0.014, 0.361), angle = Angle(-180, -93.051, -91.457), size = Vector(1.605, 1.605, 1.605), color = Color(211, 211, 211, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["crowbar"] = { type = "Model", model = "models/Weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.857, 0.418, 1.325), angle = Angle(0, -107.212, -97.001), size = Vector(1, 1.715, 1.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["eye1+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, -2.438, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	}
end

SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/weapons/v_zombine.mdl")
SWEP.WorldModel = Model("models/Weapons/w_crowbar.mdl")

SWEP.Primary.Reach = 88
SWEP.Primary.Duration = 2.1
SWEP.Primary.Delay = 0.8
SWEP.Primary.Damage = math.random(60,75)

SWEP.Fires = {}
SWEP.MaxFires = 256

function SWEP:StartPrimaryAttack()
	self.BaseClass.StartPrimaryAttack(self)

	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	local pl = self.Owner

	--Set the thirdperson animation and emit zombie attack sound
	pl:DoAnimationEvent(CUSTOM_PRIMARY)	

	if CLIENT then
		return
	end
end

function SWEP:PerformPrimaryAttack()
	if CLIENT then
		return
	end

	local fire, tr

	tr = util.TraceLine{ 
		start = self.Owner:GetShootPos( ),
		endpos = self.Owner:GetShootPos( ) + self.Owner:GetAimVector( ) * 160,
		filter = self.Owner
	}
	
	if not tr.Hit then
		return
	end

	fire = ents.Create( "env_fire" )
	fire:SetKeyValue( "health", 20 )
	fire:SetKeyValue( "firesize", 36 )
	fire:SetKeyValue( "fireattack", .01 )
	--fire:SetKeyValue( "ignitionpoint", 6 )
	fire:SetKeyValue( "ignitionpoint", 0 )
	fire:SetKeyValue( "damagescale", 25 )

	--fire:Fire( "AddOutput", "OnExtinguished !self,Kill", 0 )
	
	fire:SetKeyValue( "spawnflags", 2 + 4 + 8 + ( IsValid( tr.Entity ) and 16 or 0 ) + 32 + 256 )
	
	fire:SetPos(tr.HitPos)
	fire:Spawn()
	
	fire:SetPhysicsAttacker( self.Owner )

	if IsValid( tr.Entity ) then
		fire:SetParent( tr.Entity )
	end

	fire:Activate()
	fire:Fire("StartFire","", 0)
	
	SafeRemoveEntity( table.remove( self.Fires, self.MaxFires ) )
	table.insert( self.Fires, 1, fire )
	
	SafeRemoveEntityDelayed( fire, 45 )
end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	self.Owner:EmitSound(Sound("player/zombies/b/swing.wav"),math.random(100,130),math.random(95,100))
end

function SWEP:PrimaryAttackHit(trace, ent)
	if CLIENT then
		return
	end

	if hit then
		if ent and IsValid(ent) and ent:IsPlayer() then
			pl:EmitSound(Sound("player/zombies/b/hitflesh.wav"),math.random(100,130),math.random(95,100))
			util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
		else
			pl:EmitSound(Sound("player/zombies/b/hitwall.wav"),math.random(100,130),math.random(95,100))
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/b/swing.wav"),math.random(100,130),math.random(95,100))
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then
		return
	end

	if SERVER then
		self.Owner:EmitSound("player/zombies/b/scream.wav", math.random(130, 150), math.random(80, 110))
	end

	self.NextYell = CurTime() + math.random(8,13)
end

function SWEP:Think()
	--Start idle animation when needed
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	return self.BaseClass.Think(self)
end