if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Annabelle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 0
	SWEP.SlotPos = 7
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 66
	
	SWEP.ShowViewModel = false
	SWEP.IgnoreBonemerge = true
	SWEP.UseHL2Bonemerge = true
	SWEP.ShowWorldModel = true

	
	SWEP.IconLetter = "0"
	killicon.AddFont("weapon_zs_annabelle", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/Weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/Weapons/w_annabelle.mdl"

SWEP.Weight = 6
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.HoldType = "shotgun"

SWEP.Primary.Sound			= Sound("Weapon_Shotgun.Single")
SWEP.Primary.Recoil = 13
SWEP.Primary.Damage = 120
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1
SWEP.ReloadDelay = 0.4

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"

SWEP.MaxAmmo			    = 40

SWEP.ConeMoving = 0.067
SWEP.Cone = 0.050
SWEP.ConeIron = 0.021
SWEP.ConeCrouching = 0.031
SWEP.ConeIronCrouching = 0.009

SWEP.IsShotgun = true

SWEP.WalkSpeed = 195

SWEP.IronSightsPos = Vector(-10.889, -7.549, 5.587)
SWEP.IronSightsAng = Vector(-1.112, -5.194, 4.074)

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0


function SWEP:InitializeClientsideModels()
	
	--self.ViewModelBonescales = {["ValveBiped.Gun"] = Vector(0.009, 0.009, 0.009)}
	self.ViewModelBoneMods = {
		["ValveBiped.Pump"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Gun"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	
	self.VElements = {
		["annabelle"] = { type = "Model", model = "models/Weapons/w_annabelle.mdl", bone = "ValveBiped.Gun", pos = Vector(-0.993, 2.506, 1.774), angle = Angle(-100.194, 43.431, -48.5), size = Vector(1.23, 1.23, 1.23), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	self.WElements = {} 
	
end

SWEP.NextReload = 0
function SWEP:Reload()
	if self.reloading then return end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:DoReloadEvent()
	end
end

if SERVER then
function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
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
end

if CLIENT then
function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
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

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
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
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		else
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end
local function DoRicochet(attacker, hitpos, hitnormal, normal, damage)
	attacker.RicochetBullet = true
	attacker:FireBullets({Num = math.random(7,8), Src = hitpos, Dir = hitnormal, Spread = Vector(0.2, 0.2, 0), Tracer = 1, TracerName = "rico_trace", Force = damage * 0.15, Damage = damage, Callback = GenericBulletCallback})
	attacker.RicochetBullet = nil
end
function SWEP.BulletCallback(attacker, tr, dmginfo)
	if SERVER and tr.HitWorld and not tr.HitSky then
		timer.Simple(0,function()  DoRicochet(attacker, tr.HitPos, tr.HitNormal, tr.Normal, dmginfo:GetDamage() / 5) end)
	end

	GenericBulletCallback(attacker, tr, dmginfo)
end
