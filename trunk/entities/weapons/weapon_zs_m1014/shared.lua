-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "M1014 Shotgun"
	SWEP.Author	= "ClavusElite"
	SWEP.Slot = 0
	SWEP.SlotPos = 10
	SWEP.IconLetter = "B"
	killicon.AddFont("weapon_zs_m1014", "CSKillIcons", SWEP.IconLetter, Color(255, 255, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/cstrike/c_shot_xm1014.mdl" )
SWEP.UseHands = true
SWEP.WorldModel			= Model ( "models/weapons/w_shot_xm1014.mdl" )

SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "shotgun"


SWEP.ReloadDelay = 0.4

SWEP.Primary.Sound			= Sound("Weapon_XM1014.Single")
SWEP.Primary.Recoil			= 8
SWEP.Primary.Damage			= 14
SWEP.Primary.NumShots		= 7
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= 16
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.ReloadDelay	= 0.4

SWEP.Cone = 0.095
SWEP.ConeMoving = SWEP.Cone *1.05
SWEP.ConeCrouching = SWEP.Cone *0.95


SWEP.MaxAmmo			    = 70
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize * SWEP.Primary.NumShots)
SWEP.IsShotgun = true


SWEP.WalkSpeed = 190
SWEP.MaxBulletDistance 		= 2300

SWEP.IronSightsPos = Vector(-6.881, -11.261, 2.68)
SWEP.IronSightsAng = Vector(0, -0.828, 0)

SWEP.OverridePos = Vector(2.559, -3.28, 1.399)
SWEP.OverrideAng = Vector( 0,0,0 )

if CLIENT then
	SWEP.VElements = {
		["xms_lights"] = { type = "Model", model = "models/player/items/scout/xms_scattergun.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(0, -1.282, 2.513), angle = Angle(-90, 90, 0), size = Vector(0.5, 0.5, 1.126), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

--SWEP.IronSightsPos = Vector(2.559, -3.28, 1.399)
--SWEP.IronSightsAng = Vector(0, 0, 0)
--[=[
SWEP.NextReload = 0
function SWEP:Reload()
	local Magazine = self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )	
	
	--  If the player hasn't anymore ammo then stop running this
	if self.Weapon:Clip1() == self.Primary.ClipSize or Magazine == 0 then return end
	
	-- Disable ironsights
	self:SetIronsights( false )
	
	-- Reload cooldown
	if CurTime() < self.NextReload then return end
	self.NextReload = CurTime() + self.Primary.Delay * 3
	
	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		timer.Simple( 0.25, function( self, owner ) 
			if not IsValid ( self ) or not IsValid ( owner ) then return end
			
			-- Don't play the animation if it isn't the active weapon anymore
			local ActiveWeapon = owner:GetActiveWeapon()
			if ActiveWeapon ~= self then return end
			
			-- Weapon animation special for shotguns
			self.Weapon:SendWeaponAnim ( ACT_SHOTGUN_RELOAD_FINISH )
		end, self, self.Owner )
			
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
	
	if SERVER then --  Reloading voice effect
		if self.Weapon:Clip1() <= math.floor (self.Primary.ClipSize / 1.5) and math.random(1,2) == 1 then
			local rlsnd = VoiceSets[self.Owner.VoiceSet].ReloadSounds
			timer.Simple (0.2, function ( self )
				if IsEntityValid ( self ) then
					self:EmitSound(rlsnd[math.random(1, #rlsnd)])
				end
			end, self )
		end
	end
end
]=]

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

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

		
	if IsValid(self:GetOwner()) and self:GetOwner():GetSuit() == "Rambo" then
			self:SetClip1(self:Clip1() + 4)
		end
		
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
	if self.Owner.KnockedDown or self.Owner:IsHolding() then return end

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
