-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Pulse SMG"
	SWEP.Author	= "NECROSSIN and Deluvas"	
	SWEP.Slot = 0
	SWEP.SlotPos = 14
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 55
	SWEP.IconLetter = "/"
	SWEP.SelectFont = "HL2MPTypeDeath"
	
	SWEP.VElements = {
	["thingy2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01", rel = "disp", pos = Vector(-0.719, -0.694, 3.319), angle = Angle(0, -91.975, -0.051), size = Vector(0.115, 0.115, 0.229), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["disp"] = { type = "Model", model = "models/props_combine/Combine_Dispenser.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.744, -0.399, -4.869), angle = Angle(0, 0, 0), size = Vector(0.059, 0.041, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thingy"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01", rel = "disp", pos = Vector(0.018, 0.03, 9.244), angle = Angle(-0.689, -180, 1.194), size = Vector(0.159, 0.159, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sights"] = { type = "Model", model = "models/props_combine/combine_bridge.mdl", bone = "ValveBiped.Bip01", rel = "disp", pos = Vector(-0.708, -2.895, -3.908), angle = Angle(-91.269, 90.231, 180), size = Vector(0.013, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
	["thingy2"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "disp", pos = Vector(-0.77, -0.945, 2.23), angle = Angle(0, -91.975, -0.051), size = Vector(0.115, 0.159, 0.216), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["thingy"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "disp", pos = Vector(0.018, 0.03, 9.244), angle = Angle(-0.689, -180, 1.194), size = Vector(0.159, 0.159, 0.159), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["disp"] = { type = "Model", model = "models/props_combine/Combine_Dispenser.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.086, 2.213, -4.838), angle = Angle(0, -90.495, -100.344), size = Vector(0.059, 0.041, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sights"] = { type = "Model", model = "models/props_combine/combine_bridge.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "disp", pos = Vector(-0.708, -2.895, -3.908), angle = Angle(-91.269, 88.111, 180), size = Vector(0.013, 0.013, 0.013), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	killicon.AddFont("weapon_zs_pulsesmg", "HL2MPTypeDeath", SWEP.IconLetter, Color(0, 96, 255, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/Weapons/v_smg1.mdl"
SWEP.WorldModel = "models/Weapons/w_smg1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "ar2"

SWEP.Primary.Sound			= Sound("weapons/airboat/airboat_gun_lastshot"..math.random(1,2)..".wav")
SWEP.Primary.Recoil			= 4
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.085
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true


SWEP.Primary.Ammo			= "none"

SWEP.ConeMoving				= 0.077
SWEP.Primary.Cone			= 0.068
SWEP.ConeCrouching			= 0.055

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.MaxBulletDistance 		= 2900 -- Uses pulse power, FTW!
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.WalkSpeed = 185
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.40
SWEP.startcharge = 1
SWEP.MaxClip = 20


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
				self.rechargerate = 0.1
				self.rechargetimer = CurTime() + self.rechargerate 
				
				if ValidEntity(self:GetOwner()) and self:GetOwner():GetSuit() == "freeman" then --Ability for freeman suit!
			self.Weapon:SetClip1(math.min(self.MaxClip,self.Weapon:Clip1() + 1))
			self.rechargerate = 0.01
					end
			end
			if self.fired then 
				self.fired = false
				--self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
			end
		end
	end
end

function SWEP:Reload()
	return false
end