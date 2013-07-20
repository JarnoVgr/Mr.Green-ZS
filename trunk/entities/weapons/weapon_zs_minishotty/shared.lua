-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.PrintName = "'Farter' Shotgun"
end

if CLIENT then
	SWEP.PrintName = "'Farter' Shotgun"			
	SWEP.Author	= "NECROSSIN"
	SWEP.Slot = 0
	SWEP.SlotPos = 17
	SWEP.ViewModelFOV = 50
	SWEP.ViewModelFlip = false
	
	SWEP.IconLetter = "0"
	surface.CreateFont( "HL2MP", ScreenScale( 30 ), 500, true, true, "HL2KillIcons" )
	surface.CreateFont( "HL2MP", ScreenScale( 60 ), 500, true, true, "HL2SelectIcons" )
	
	SWEP.AlwaysDrawViewModel = true
	
	killicon.AddFont( "weapon_zs_minishotty", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 255, 255, 255 ) )
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_supershorty/v_supershorty.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_supershorty.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "shotgun"

SWEP.Primary.Sound			= Sound("Weapon_Shotgun.Single")
SWEP.Primary.Recoil			= 22 -- 2
SWEP.Primary.Unrecoil		= 2
SWEP.Primary.Damage			= 12 -- because its a tiny tiny shotgun!
SWEP.Primary.NumShots		= 6
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.75
SWEP.Primary.DefaultClip	= 28
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.Cone			= 0.08
SWEP.ConeMoving				= 0.1 -- 0.4
SWEP.ConeCrouching			= 0.09
SWEP.IsShotgun = true
SWEP.MaxAmmo			    = 50
SWEP.WalkSpeed = 190 -- but it has better speed

SWEP.Cone = 0.08
SWEP.ConeMoving = 0.1
SWEP.ConeCrouching = 0.09

SWEP.IronSightsPos = Vector(-4.321, -6.886, 4.239)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.OverridePos = Vector(-1.68, -5.082, 2.4)
SWEP.OverrideAng = Vector(0, 0, 0)

---SWEP.IronSightsPos = Vector(-3.36, -9.016, 2.2)
---SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0
SWEP.ReloadDelay = 0.4

function SWEP:Reload()
	if self.reloading then return end

	if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:RestartGesture(ACT_HL2MP_GESTURE_RELOAD_SHOTGUN)
	end

	self:SetIronsights(false)
end

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
		self:EmitSound("Weapon_M3.Pump")
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self.nextreloadfinish = 0
	end

	if self:GetIronsights() and not self.Owner:KeyDown(IN_ATTACK2) then
		self:SetIronsights(false)
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then return false end

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

