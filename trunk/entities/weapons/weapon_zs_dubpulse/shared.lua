-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
--This weapon was created and recoded due to a gmod update.

AddCSLuaFile()

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Dub Pulse"
	SWEP.Author = "Duby"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFOV = 60
	killicon.AddFont( "weapon_zs_deagle", "CSKillIcons", "f", Color(255, 255, 255, 255 ) )

	SWEP.IgnoreThumbs = true



end

SWEP.Spawnable = true  
SWEP.AdminSpawnable = true
--SWEP.DrawAmmo = true 
SWEP.base = "weapon_zs_base"



SWEP.ViewModel		= Model ( "models/weapons/v_smg1.mdl" )
--SWEP.ViewModel 			= Model ("models/weapons/v_irifle.mdl")
SWEP.WorldModel			= Model ( "models/weapons/w_smg1.mdl" )
--SWEP.WorldModel			= Model ("models/props_phx/construct/metal_dome360.mdl")
SWEP.ViewModelFlip = false

SWEP.WalkSpeed = 210
SWEP.HoldType = "ar2"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.DrawAmmo = true

SWEP.Primary.NumShots		= 4
SWEP.Primary.Ammo = "ar2"                      
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.13
SWEP.Primary.Recoil = 6
SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= 25

SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "pistol"
SWEP.Secondary.Recoil = 5

 SWEP.LastReload = 0

 	
SWEP.VElements = {
	["Pulse Rifle"] = { type = "Model", model = "models/props_combine/bunker_gun01.mdl", bone = "Base", rel = "", pos = Vector(0, 11.465, 7.752), angle = Angle(83.305, -94.769, 4.453), size = Vector(0.777, 0.777, 0.777), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Pulse Rifle2"] = { type = "Model", model = "models/weapons/c_arms_refugee.mdl", bone = "Base", rel = "Pulse Rifle", pos = Vector(-21.467, -23.573, 41.561), angle = Angle(162.212, -157.275, -8.691), size = Vector(1.003, 1.003, 1.003), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


SWEP.WElements = {
	["Pulse Rifle"] = { type = "Model", model = "models/props_combine/bunker_gun01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.746, -0.174, 4.901), angle = Angle(-6.948, 3.631, 171.473), size = Vector(0.68, 0.68, 0.68), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	if ( SERVER ) then
    self:SetWeaponHoldType(self.HoldType)
	end
	
	

end


 function SWEP:Think()
local ct = CurTime()
if (self.LastReload + 0.02 <= ct) then
self.LastReload = ct + 0.2

if (self:Clip1() < 25) then
self:SetClip1(self:Clip1() + 1)
end
end

if (self:Clip1() < 1) then
self.Weapon:EmitSound(Sound("weapons/grenade/tick1.wav"))
end
end

 

function SWEP:OnRemove()
timer.Destroy("regen_ammo"..self:EntIndex())
end

function SWEP:PrimaryAttack()
--if ( !self:CanPrimaryAttack() ) then return end
 if (!self:CanPrimaryAttack()) then return end

	

	local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector(0.02,0.02,0.02)
		bullet.Tracer = 1
		bullet.Force = 30
		bullet.Damage = 13
	self:ShootEffects()
	self.Owner:FireBullets( bullet )
	self.Weapon:EmitSound(Sound("Airboat.FireGunHeavy"))
	
	self.Weapon:EmitSound(Sound("weapons/crossbow/fire1.wav"))
	self.Weapon:EmitSound(Sound("weapons/fx/nearmiss/bulletLtoR03.wav"))
--	self.Weapon:EmitSound(Sound("weapons/rpg/shotdown.wav"))
	
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	 self:TakePrimaryAmmo(1)

	
	 
	
end

function SWEP:SecondaryAttack()

self.Weapon:EmitSound(Sound("vo/npc/male01/pain09.wav"))
--self.Weapon:EmitSound(Sound("physics/metal/metal_barrel_impact_hard1.wav"))

local fire = function()


    self.Weapon:EmitSound(Sound("Airboat.FireGunHeavy"))
	self.Weapon:EmitSound(Sound("weapons/crossbow/fire1.wav"))
	self.Weapon:EmitSound(Sound("weapons/fx/nearmiss/bulletLtoR03.wav"))
--	self.Weapon:EmitSound(Sound("weapons/rpg/shotdown.wav"))
	
                        self:ShootBullet( 0.01, 0, 0 )
                        self:TakePrimaryAmmo( 1 )
                        self.Owner:ViewPunch( Angle( math.random( -4, -5),
                                                     math.random( -2, 3),
                                                     math.random( -1, 2)))
                     end
                                 
        timer.Create("burst", 0.1, 30, fire)
		
end



 function SWEP:CustomAmmoDisplay()

self.AmmoDisplay = self.AmmoDisplay or {} 
self.AmmoDisplay.Draw = true
self.AmmoDisplay.PrimaryClip = self:Clip1()

return self.AmmoDisplay

end

function SWEP:Reload()
return false 
end


