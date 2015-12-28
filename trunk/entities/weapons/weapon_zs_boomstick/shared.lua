AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'Boomstick'"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 17
	SWEP.ViewModelFOV = 60	
	killicon.AddFont( "weapon_zs_boomstick", "HL2MPTypeDeath", "0", Color( 255, 255, 255, 255 ) )
end

SWEP.Base = "weapon_zs_base"

SWEP.Weight = 10
SWEP.ReloadDelay = 0.4

util.PrecacheSound("weapons/shotgun/shotgun_dbl_fire.wav")
SWEP.Primary.Sound = "weapons/shotgun/shotgun_dbl_fire.wav"
SWEP.Primary.Recoil = 8
SWEP.Primary.Damage = 34
SWEP.Primary.NumShots = 9
SWEP.Primary.Delay = 1.6
SWEP.Primary.ClipSize = 4
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"

SWEP.ConeMoving = 0.11
SWEP.Cone = 0.082
SWEP.ConeCrouching = 0.061

SWEP.IsShotgun = true
SWEP.MaxAmmo = 55
SWEP.WalkSpeed = SPEED_HEAVY

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.IronSightsPos = Vector(-8.975, -5, 3.3)
SWEP.IronSightsAng = Vector(1, 0, 0)

SWEP.OverridePos = Vector(-3.36, -9.016, 2.2)
SWEP.OverrideAng = Vector(0, 0, 0)

SWEP.VElements = {
	["chamber"] = { type = "Model", model = "models/props_junk/garbage_metalcan002a.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(-0.424, -4.538, -4.647), angle = Angle(180, 0, 0), size = Vector(0.061, 0.061, 0.236), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/props_lab/tank_glass001", skin = 0, bodygroup = {} },
	["shell"] = { type = "Model", model = "models/Items/grenadeAmmo.mdl", bone = "v_weapon.M3_SHELL", rel = "", pos = Vector(0, 0, -0.93), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.337), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["pump"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "v_weapon.M3_PUMP", rel = "", pos = Vector(0, 0.446, -4.586), angle = Angle(0, 0, 0), size = Vector(0.207, 0.207, 0.31), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thing"] = { type = "Model", model = "models/props_lab/teleportbulkeli.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(-0, -7.61, -3.994), angle = Angle(90, 90, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["thing"] = { type = "Model", model = "models/props_lab/teleportbulkeli.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.359, 0.896, -7.804), angle = Angle(10, 180, 0), size = Vector(0.017, 0.017, 0.017), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["pump"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(20.055, 0.763, -5.19), angle = Angle(0, 90, 99.418), size = Vector(0.272, 0.277, 0.331), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.HoldType = "shotgun"
SWEP.ViewModel = "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.UseHands = true
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}

function SWEP:SetIronsights()
end

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then
		return
	end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		--self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
	end

	self:SetIronsights(false)
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self.nextreloadfinish = 0
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
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_VM_IDLE)
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end

function SWEP:SecondaryAttack()
end