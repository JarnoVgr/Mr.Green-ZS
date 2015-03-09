AddCSLuaFile()
--Made by Duby :P
if CLIENT then
	SWEP.PrintName = "Spitter"
	SWEP.ViewModelFOV = 0
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = false

	SWEP.FakeArms = true

	SWEP.ViewModelBoneMods = {
		-- ["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-10.202, 19.533, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, -7.493, -45.569) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(5.802, 1.06, 0.335), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(52.678, 0, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(45.873, -0.348, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-59.774, -9.223, 18.572) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(10.701, -7.301, 42.666) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 9.659, 6.218) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-6.42, 28.499, 7.317) }
	}
	
	
end


SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
--SWEP.ViewModel = Model("")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.Automatic = true
SWEP.Primary.Duration = 0.5
SWEP.Primary.Delay = 1.5
SWEP.Primary.Damage = 1.1
SWEP.Primary.Reach = 45

SWEP.SwapAnims = false

function SWEP:StartPrimaryAttack()			
	local pl = self.Owner
	local angles = pl:GetAngles()

	if angles.pitch < -10 or angles.pitch > 10 then
		--pl:EmitSound(Sound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav"))
		return
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
			
	if SERVER then
		pl:EmitSound(Sound("npc/zombie_poison/pz_throw".. math.random(2,3) ..".wav"))
	end
	
end

function SWEP:PostPerformPrimaryAttack(hit)
	local pl = self.Owner
	local angles = pl:GetAngles()

	if angles.pitch > 55 or angles.pitch < -55 then
		return 
	end
		
	--Swap Anims
	if self.SwapAnims then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	self.SwapAnims = not self.SwapAnims
		
	if CLIENT then
		return
	end

	local shootpos = pl:GetShootPos()
	local startpos = pl:GetPos()
	startpos.z = shootpos.z
	local aimvec = pl:GetAimVector()
	aimvec.z = math.max(aimvec.z, 0.01)
	

	local ent = ents.Create("projectile_spitterspit")
	if IsValid(ent) then
		local heading = aimvec
		ent:SetPos(startpos + heading * 10)
		ent:SetOwner(pl)
		ent:Spawn()
		ent.TeamID = pl:Team()
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:SetVelocityInstantaneous(heading * math.Rand(520, 550))
		end
		ent:SetPhysicsAttacker(pl)
	end

	--pl:EmitSound(Sound("physics/body/body_medium_break"..math.random(2,4)..".wav"), 80, math.random(70, 80))
	self.Owner:EmitSound("npc/barnacle/barnacle_die2.wav")
	--self.Owner:EmitSound("npc/barnacle/barnacle_digesting1.wav")
	--self.Owner:EmitSound("npc/barnacle/barnacle_digesting2.wav")

	--pl:TakeDamage(self.Secondary.Damage, pl, self.Weapon)
end