if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "shotgun"
end

if CLIENT then
	SWEP.PrintName = "Boom Stick"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 17
	SWEP.ViewModelFlip = false
	
	SWEP.ShowViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true
	
	killicon.AddFont( "weapon_zs_boomstick", "HL2MPTypeDeath", "0", Color( 255, 10, 0, 255 ) )
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Weight = 10
SWEP.ReloadDelay = 0.4

SWEP.HoldType = "shotgun"

util.PrecacheSound("weapons/shotgun/shotgun_dbl_fire.wav")
SWEP.Primary.Sound = "weapons/shotgun/shotgun_dbl_fire.wav"
SWEP.Primary.Recoil = 75
SWEP.Primary.Damage = 70
SWEP.Primary.NumShots = 6
SWEP.Primary.Delay = 1.6

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"

SWEP.Cone = 0.095
SWEP.ConeCrouching = 0.085
SWEP.ConeMoving = 0.1

SWEP.Primary.Cone			= 0.095
SWEP.ConeMoving				= 0.1
SWEP.ConeCrouching			= 0.085
SWEP.IsShotgun = true
SWEP.MaxAmmo			    = 55
SWEP.WalkSpeed = 175

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.IronSightsPos = Vector(-8.975, -5, 3.3)
SWEP.IronSightsAng = Vector(1, 0, 0)

SWEP.OverridePos = Vector(-3.36, -9.016, 2.2)
SWEP.OverrideAng = Vector(0, 0, 0)

function SWEP:InitializeClientsideModels()
	
	self.ViewModelBoneMods = {
		["ValveBiped.Pump"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01"] = { scale = Vector(1, 1, 1), pos = Vector(2.469, 0.28, -0.607), angle = Angle(0, 0, 0) }
	}
	
	self.VElements = {
		["part3"] = { type = "Model", model = "models/Weapons/w_grenade.mdl", bone = "ValveBiped.square", rel = "", pos = Vector(0, 0, -1.431), angle = Angle(0, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["part1"] = { type = "Model", model = "models/props_lab/teleportbulkeli.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0.231, -4.999, -7.783), angle = Angle(-90, -90, 0), size = Vector(0.021, 0.021, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["part2"] = { type = "Model", model = "models/props_lab/HEV_case.mdl", bone = "ValveBiped.Pump", rel = "", pos = Vector(0, 1.343, -2.938), angle = Angle(0, -90, 0), size = Vector(0.059, 0.059, 0.142), color = Color(90, 90, 90, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	self.WElements = {
		["part1"] = { type = "Model", model = "models/props_lab/teleportbulkeli.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.319, 1.636, -9.157), angle = Angle(6.718, -180, 4.506), size = Vector(0.017, 0.017, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["part2"] = { type = "Model", model = "models/props_lab/HEV_case.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.675, 1.1, -2.955), angle = Angle(97.574, -180, 1.136), size = Vector(0.059, 0.052, 0.148), color = Color(90, 90, 90, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end


function SWEP:SetIronsights()
end

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then return end

	if self:GetNextReload() <= CurTime() and self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:DoReloadEvent()
		self:SetNextReload(CurTime() + self:SequenceDuration())
	end
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:EmitSound(self.Primary.Sound)

		local clip = self:Clip1()

		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots * clip, self.Cone)

		self:TakePrimaryAmmo(clip)
		self.Owner:ViewPunch(clip * 0.5 * self.Primary.Recoil * Angle(math.Rand(-0.1, -0.1), math.Rand(-0.1, 0.1), 0))

		self.Owner:SetGroundEntity(NULL)
		self.Owner:SetVelocity(-80 * clip * self.Owner:GetAimVector())

		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 or not self.Owner:KeyDown(IN_RELOAD) then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self:EmitSound("Weapon_Shotgun.Special1")
		self.nextreloadfinish = 0
	end

	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return end


	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if self:Clip1() < self.Primary.ClipSize then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end