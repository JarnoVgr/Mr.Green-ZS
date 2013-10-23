--Based on SligWolf's GrenadeLauncher
--Can be found in Workshop

if SERVER then
	AddCSLuaFile()

	SWEP.Weight				= 10
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if CLIENT then
	SWEP.DrawPrimaryAmmo = true
	SWEP.DrawSecondaryAmmo = false
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFlip		= false
	SWEP.Slot = 0
	SWEP.SlotPos = 17

	--Killicon
	killicon.AddFont("weapon_zs_grenadelauncher", "HL2MPTypeDeath", "0", Color(255, 255, 255, 255))
end

SWEP.PrintName = "Grenade Launcher"
SWEP.Base				= "weapon_zs_base"
SWEP.Category = "Other"
SWEP.Author			= "SligWolf"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.FiresUnderwater = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.HoldType = "smg"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_sw_grenadelauncher.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_sw_grenadelauncher.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true

SWEP.Primary.Recoil			= 5
SWEP.Primary.NumShots		= 1

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip    = 18
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.TakeAmmo       = 1
SWEP.Primary.Tracer			= 1
SWEP.Primary.TracerName		= "none"

SWEP.ConeMoving = 0.20
SWEP.Cone = 0.186
SWEP.ConeCrouching = 0.176

SWEP.WalkSpeed = 185

function SWEP:Initialize()
    self:SetWeaponHoldType(self.HoldType)

	function table.FullCopy( tab )
		if not tab then
			return nil
		end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v)
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
	end
end

function SWEP:Reload()
	if self:Clip1() == 5 then
		if self.Weapon:DefaultReload( ACT_VM_RELOAD ) then
			self.Weapon:EmitSound("weapons/sw_grenadelauncher/sw_gl_reload.wav");
		end
	end
	if self:Clip1() == 4 then
		if self.Weapon:DefaultReload( ACT_VM_RECOIL1 ) then
			self.Weapon:EmitSound("weapons/sw_grenadelauncher/sw_gl_reload.wav");
		end
	end
	if self:Clip1() == 3 then
		if self.Weapon:DefaultReload( ACT_VM_RECOIL2 ) then
			self.Weapon:EmitSound("weapons/sw_grenadelauncher/sw_gl_reload.wav");
		end
	end
	if self:Clip1() == 2 then
		if self.Weapon:DefaultReload( ACT_VM_RECOIL3 ) then
			self.Weapon:EmitSound("weapons/sw_grenadelauncher/sw_gl_reload.wav");
		end
	end
	if self:Clip1() == 1 then
		if self.Weapon:DefaultReload( ACT_VM_PICKUP ) then
			self.Weapon:EmitSound("weapons/sw_grenadelauncher/sw_gl_reload.wav");
		end
	end
	if self:Clip1() == 0 then
		if self.Weapon:DefaultReload( ACT_VM_RELEASE ) then
			self.Weapon:EmitSound("weapons/sw_grenadelauncher/sw_gl_reload.wav");
		end
	end
end

function SWEP:Think()	
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then
		return
	end

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.9)
	self:EmitSound("weapons/sw_grenadelauncher/sw_gl_fire.wav")
	self:ShootEffects(self)
	self:TakePrimaryAmmo(1)
	
	if not SERVER then
		return
	end
	
	local Forward = self.Owner:EyeAngles():Forward()
	local Right = self.Owner:EyeAngles():Right()
	local Up = self.Owner:EyeAngles():Up()
	
	local ent = ents.Create("grenade_ar2")
	if IsValid(ent) then
		ent:SetPos( self.Owner:GetShootPos() + Forward * 12 + Right * 6 + Up * -5)
		ent:SetAngles(self.Owner:EyeAngles())
		ent:SetOwner(self.Owner)
		ent:Spawn()	
		ent:SetVelocity(Forward * 1800)
	end

	local ent2 = ents.Create("grenade_ar2")
	if IsValid(ent2) then	
		ent2:SetPos( self.Owner:GetShootPos() + Forward * 12 + Right * 6 + Up * -5)
		ent2:SetAngles( self.Owner:EyeAngles() )
		ent2:SetOwner(self.Owner)
		ent2:Spawn()	
		ent2:SetVelocity(Forward * 1800)
		ent2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
end

function SWEP:SecondaryAttack()	
	return false
end

function SWEP:ShouldDropOnDie()
	return false
end