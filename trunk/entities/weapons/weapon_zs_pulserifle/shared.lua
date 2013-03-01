-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Pulse Rifle"			
	SWEP.Slot = 0
	SWEP.SlotPos = 14
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55
	SWEP.IconLetter = "2"
	SWEP.SelectFont = "HL2MPTypeDeath"
	killicon.AddFont("weapon_zs_pulserifle", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= Model ( "models/weapons/v_IRifle.mdl" )
SWEP.WorldModel			= Model ( "models/weapons/w_IRifle.mdl" )

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("Weapon_AR2.Single")
SWEP.Primary.Recoil			= 1.25 * 12.5 -- 1.25
SWEP.Primary.Unrecoil		= 8
SWEP.Primary.Damage			= 8.2
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 90
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Cone			= 0.13
SWEP.ConeMoving				= 0.23
SWEP.ConeCrouching			= 0.06

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Tracer = "AR2Tracer"

SWEP.MaxBulletDistance 		= 2900 -- Uses pulse power, FTW!
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.WalkSpeed = 170
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.25
SWEP.startcharge = 1
SWEP.MaxClip = 90

SWEP.IronSightsPos = Vector(-5.88, -8.03, 2.191)
SWEP.IronSightsAng = Vector(0.625, -0.695, 0)

SWEP.OverridePos = Vector(-1.64, -6.231, 1.22)
SWEP.OverrideAng = Vector(0, 0, 0)

function SWEP:Think()
	if SERVER then
		local ply = self.Owner
		
		
		-- Show reload animation when player stops firing. Looks cool.
		if ply:KeyDown(IN_ATTACK) then	
			self.fired = true
			self.lastfire = CurTime()
		else
			if self.Owner:IsPlayer() and self.Owner:GetHumanClass() == 4 then
				self.MaxClip = self.Primary.DefaultClip + (self.Primary.DefaultClip * ((HumanClasses[4].Coef[2]*(self.Owner:GetTableScore ("engineer","level")+1)) / 100))
				self.startcharge = 0.4
			else 
				self.MaxClip = self.Primary.DefaultClip
				self.startcharge = 1
			end
			
			if self.lastfire < CurTime()- self.startcharge and self.rechargetimer < CurTime() then
				self.Weapon:SetClip1(math.min(self.MaxClip,self.Weapon:Clip1() + 1))
				if self.Owner:IsPlayer() and self.Owner:HasBought("lastmanstand") and self.Owner:GetHumanClass() == 4 and LASTHUMAN then
					self.rechargerate = 0.1
				else
					self.rechargerate = 0.2
				end
				self.rechargetimer = CurTime() + self.rechargerate 
			end
			if self.fired then 
				self.fired = false
				self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			end
		end
	end
end

function SWEP:Reload()
	return false
end