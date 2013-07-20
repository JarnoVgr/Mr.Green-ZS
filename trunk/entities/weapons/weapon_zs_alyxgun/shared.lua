-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Alyx Gun"
	SWEP.Author = "NECROSSIN"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFOV = 68
	SWEP.ViewModelFlip = false
	killicon.AddFont( "weapon_zs_alyxgun", "CSKillIcons", "f", Color( 245, 120, 0, 255 ) )
	
	--SWEP.ShowViewModel = true
	--SWEP.ShowWorldModel = true
	--SWEP.ViewModelBonescales = {["v_weapon.Deagle_Parent"] = Vector(0.009, 0.009, 0.009)}
	
	--SWEP.VElements = 
	--["sights"] = { type = "Model", model = "models/props_c17/Handrail04_cap.mdl", bone = "v_weapon.Deagle_Parent", pos = Vector(-0.062, 3.638, 3.914), angle = Angle(-0.301, 0.718, -89.574), size = Vector(0.068, 0.097, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/weapons/alyxgun/v_alyxgun", skin = 0, bodygroup = {} },
	--["gun"] = { type = "Model", model = "models/Weapons/W_Alyx_Gun.mdl", bone = "v_weapon.Deagle_Parent", pos = Vector(-0.612, 3.625, 0.899), angle = Angle(-101.913, -28.157, 72.9), size = Vector(0.837, 0.837, 0.837), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	--
end

SWEP.Base = "weapon_zs_base"

SWEP.MenuSlot 			= 1

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_alyxgun.mdl" )--Model ( "models/weapons/v_pist_deagle.mdl" )
SWEP.WorldModel			= Model ( "models/Weapons/W_Alyx_Gun.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound			= "weapons/alyxgun/fire0"..math.random(1,2)..".wav"
SWEP.Primary.Recoil			= 17.5
SWEP.Primary.Damage			= 11
SWEP.Primary.NumShots		= 3
SWEP.Primary.ClipSize		= 15
SWEP.Primary.Delay			= 0.25
SWEP.Primary.DefaultClip	= 30
SWEP.MaxAmmo			    = 9999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.06 --0.12
SWEP.ConeMoving				= 0.12 -- 0.18
SWEP.ConeCrouching			= 0.03 -- 0.06
SWEP.WalkSpeed = 200

SWEP.IronSightsPos = Vector(-5.401, -9.837, 4.084)
SWEP.IronSightsAng = Vector(0, -0.131, 1.281)

SWEP.OverridePos = Vector(-1.611, -6.722, 2.4)
SWEP.OverrideAng = Vector(0, 0, 0)
--[=[
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	if not self:CanPrimaryAttack() then return end
	
	for I = 0,2 do

	timer.Simple(I * 0.125,
	function()
	if not ValidEntity(self.Weapon) then return end
if not ValidEntity(self.Owner) then return end
if not self:CanPrimaryAttack() then return end
if self.Owner:GetActiveWeapon() ~= self.Weapon then return end
	self:BurstFire()
	end)
	end
end

function SWEP:BurstFire()
if not ValidEntity(self.Weapon) then return end
if not ValidEntity(self.Owner) then return end
if not self:CanPrimaryAttack() then return end
if self.Owner:GetActiveWeapon() ~= self.Weapon then return end

	-- Get owner
	local Owner = self.Owner

	-- Ironsight precision
	local iIronsightMul
	if self:GetIronsights() then iIronsightMul = self.IronSightMultiplier else iIronsightMul = 2 end
		
	-- Recoil 
	if Owner.ViewPunch then Owner:ViewPunch( Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil * 0.25, math.Rand(-0.1,0.1) * self.Primary.Recoil * 0.35, 0) ) end
	if ( ( SinglePlayer() and SERVER ) or ( not SinglePlayer() and CLIENT and IsFirstTimePredicted() ) ) then
		local eyeang = self.Owner:EyeAngles()
		local recoil = math.Rand( 0.1, 0.2 )
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	end
	
	local WeaponType = self:GetType()
	
	-- The crosshair enlarges
	if CLIENT then
		local Scale
		local Cone = self.WeaponCones[WeaponType].Cone
	
		-- Get the current action of the player
		if MySelf:GetVelocity():Length() > 25 then
			Scale = ( ScrW() / 1024 ) * 10 * Cone * 1.5
		else
			if MySelf:Crouching() then
				Scale = ( ScrW() / 1024 ) * 10 * Cone * 0.8
			else
				Scale = ( ScrW() / 1024 ) * 10 * Cone * 1.1
			end
		end
		
		local MaxRecoil = math.abs ( Scale * 15 )
		self.CrosshairGap = math.Clamp ( self.CrosshairGap + 7, 0, MaxRecoil * 1.5 )
	end


	-- Fire sound
	self:EmitSound ( "weapons/alyxgun/fire0"..math.random(1,2)..".wav" )
	
	-- Calculate cone
	local Cone = self.WeaponCones[WeaponType].Cone
	local fRunCone, fCrouchCone, fCone, fDamage, iNumShots = 1.7, 0.8, 1.3, self.Primary.Damage, self.Primary.NumShots
	
	-- Running or standing still or crouching cones
	if self.Owner:GetVelocity():Length() > 25 then
		self:ShootBullets ( fDamage, iNumShots, ( Cone * fRunCone ) * 0.25 * iIronsightMul )
	else
		if self.Owner:Crouching() then self:ShootBullets ( fDamage, iNumShots, ( Cone * fCrouchCone ) * 0.25 * iIronsightMul ) else self:ShootBullets ( fDamage, iNumShots, ( Cone * fCone ) * 0.25 * iIronsightMul ) end
	end
end

function SWEP:ShootBullets ( dmg, numbul, cone )
	local owner = self.Owner
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)  
	bullet.Tracer = 1
	bullet.Force = 1
	bullet.Damage = 0
	bullet.TracerName = self.Tracer or "Tracer"
	bullet.Callback = function ( a, b, c )
		self:BulletCallback ( a, b, c )
	end

	owner:FireBullets(bullet)
	self:TakePrimaryAmmo( 1 )
	self:ShootEffects()

end

function SWEP:CanPrimaryAttack()
	if self.Weapon:Clip1() <= 0 then
		self.Weapon:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		
		return false
	end
	
	return true
end
]=]