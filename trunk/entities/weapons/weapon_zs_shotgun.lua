-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	SWEP.PrintName = "Shotgun"
end

if CLIENT then
	SWEP.PrintName = "Shotgun"			


	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.IgnoreBonemerge = false
	SWEP.UseHL2Bonemerge = true
	SWEP.ScaleDownLeftHand = true
	
	SWEP.IconLetter = "0"

	killicon.AddFont( "weapon_zs_shotgun", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 255, 255, 255 ) )
end

SWEP.Base				= "weapon_zs_base"

SWEP.UseHands = true
SWEP.ViewModel			= Model ( "models/weapons/c_shotgun.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_shotgun.mdl" )

SWEP.Slot = 2
SWEP.Weight	= 4
SWEP.Type = "Shotgun"
SWEP.HoldType = "shotgun"
SWEP.ConeMax = 0.085
SWEP.ConeMin = 0.08

SWEP.ReloadDelay = 0.4
SWEP.Primary.Sound			= Sound("Weapon_Shotgun.Single")
SWEP.Primary.Recoil			= 3
SWEP.Primary.Damage			= 8.5
SWEP.Primary.NumShots		= 6
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.55
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo	= "buckshot"



SWEP.IsShotgun = true

SWEP.IronSightsPos = Vector (-9.0313, 0, 3.3295)
SWEP.IronSightsAng = Vector (0.2646, -0.0374, 0)

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

function SWEP:Reload()
	if self.reloading then return end

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
        self:EmitSound("Weapon_Shotgun.Reload")		
		
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