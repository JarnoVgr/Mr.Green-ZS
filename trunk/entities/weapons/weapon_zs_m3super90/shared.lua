-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M3 Shotgun"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 7
	SWEP.IconLetter = "k"
	SWEP.ViewModelFOV = 60
	
	killicon.AddFont("weapon_zs_m3super90", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_shot_m3super90.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_shot_m3super90.mdl" )

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "shotgun"

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 13.5
SWEP.Primary.NumShots		= 8
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.8
SWEP.Primary.DefaultClip	= 18
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.MaxAmmo			    = 70
SWEP.IsShotgun = true

SWEP.Cone = 0.134
SWEP.ConeMoving = SWEP.Cone *1.10
SWEP.ConeCrouching = SWEP.Cone *0.95

SWEP.WalkSpeed = SPEED_SHOTGUN
SWEP.MaxBulletDistance 		= 1750

SWEP.IronSightsPos = Vector(-7.64, -10.315, 3.319)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )

SWEP.OverridePos = Vector(2.839, -4.591, 2)
SWEP.OverrideAng = Vector( 0,0,0 )



SWEP.ReloadDelay = 0.45

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

if CHRISTMAS then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.M3_PARENT", rel = "", pos = Vector(-0.32, -0.63, 5.836), angle = Angle(-88.977, 90, 0), size = Vector(0.5, 0.5, 1.343), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.009, 0.953, -7.064), angle = Angle(-9.205, 0.907, 0), size = Vector(0.774, 0.774, 1.118), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

function SWEP:Reload()
	if self.reloading then
		return
	end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
	end

	self:SetIronsights(false)
end

function SWEP:OnDeploy()
	if IsValid(self:GetOwner()) and self:GetOwner():GetPerk("_reload") then
		self.ReloadDelay = 0.45
		self.ReloadDelay = self.ReloadDelay * 0.5
	end
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