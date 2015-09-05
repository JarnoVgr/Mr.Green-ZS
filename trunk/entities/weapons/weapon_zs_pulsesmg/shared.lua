-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
AddCSLuaFile()
--[[
if CLIENT then
	SWEP.PrintName = "Pulse SMG"
	SWEP.Author	= "NECROSSIN and Deluvas"	
	SWEP.Slot = 5
	SWEP.SlotPos = 14
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
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
end]]

if CLIENT then

SWEP.PrintName = "Pulse SMG"
SWEP.Author	= "NECROSSIN and Deluvas"	
SWEP.Slot = 5
SWEP.SlotPos = 14
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 60
SWEP.IconLetter = "/"
SWEP.SelectFont = "HL2MPTypeDeath"

SWEP.HoldType = "smg"
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {}




SWEP.VElements = {
	["smg2"] = { type = "Model", model = "models/items/car_battery01.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.118, -0.39, -8.738), angle = Angle(4.191, 0.01, 2.924), size = Vector(0.186, 0.186, 0.186), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["smg4"] = { type = "Model", model = "models/props_urban/fence_barbwire001_128.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.93, -1.991, -3.646), angle = Angle(-0.986, 0.634, 88.175), size = Vector(0.092, 0.092, 0.092), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["smg+"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(1.07, -0.876, 3.809), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["smg"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(1.067, -0.728, -4.494), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["smg3"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.136, -1.647, -4.711), angle = Angle(-1.816, 1.735, -1.214), size = Vector(0.085, 0.085, 0.085), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
["OP Smg3"] = { type = "Model", model = "models/Items/car_battery01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.624, 1.493, -3.758), angle = Angle(-99.206, 0, 0), size = Vector(0.168, 0.168, 0.168), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
["OP Smg2"] = { type = "Model", model = "models/Items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.199, 0.587, -4.947), angle = Angle(14.553, 85.567, 101.813), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
["OP Smg"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.472, 0.953, -4.992), angle = Angle(-11.238, 91.967, 102.177), size = Vector(0.101, 0.101, 0.101), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
 

end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

--SWEP.ViewModel = "models/Weapons/v_smg1.mdl"
SWEP.ViewModel = "models/weapons/c_smg1.mdl" 
SWEP.WorldModel = "models/Weapons/w_smg1.mdl"
SWEP.UseHands = true
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "smg"
SWEP.HumanClass = "engineer"
SWEP.Primary.Sound			= Sound("weapons/airboat/airboat_gun_lastshot"..math.random(1,2)..".wav")
SWEP.Primary.Recoil			= 0.7
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 20
SWEP.Primary.Delay			= 0.085
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= true
SWEP.TracerName = "AR2Tracer"

SWEP.Primary.Ammo			= "none"

SWEP.Cone 			= 0.06
SWEP.ConeMoving		 = SWEP.Cone *1.3
SWEP.ConeCrouching 	 = SWEP.Cone *0.90
SWEP.ConeIron 		 = SWEP.Cone *0.95
SWEP.ConeIronCrouching   	= SWEP.ConeCrouching *0.9
SWEP.ConeIronMoving	 = SWEP.ConeMoving *0.9

--SWEP.IronSightsPos = Vector(-2, -4, 1.5)
--SWEP.IronSightsAng = Vector(0,0,0)

SWEP.IronSightsPos = Vector(-2, -4, 0.92)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.MaxBulletDistance 		= 2900 -- Uses pulse power, FTW!
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.WalkSpeed = SPEED_SMG
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.475
SWEP.startcharge = 1
SWEP.MaxClip = 20

function SWEP:Think()
	if SERVER then
		local ply = self.Owner
		
		if ply:KeyDown(IN_ATTACK) then
			if not self.fired then
				self.fired = true
			end

			self.lastfire = CurTime()
		else
		
			if self:GetOwner():GetPerk("_engineer") then
				self.MaxClip = 20 + (20*(5*self:GetOwner():GetRank())/100)
				self.rechargerate = 0.45 - (0.45*(2*self:GetOwner():GetRank())/100)				
			end
			
			if (CurTime() - self.startcharge) > self.lastfire and CurTime() > self.rechargetimer then
				self.Weapon:SetClip1(math.min(self.MaxClip, self.Weapon:Clip1() + 1))
				self.rechargerate = 0.1
				self.rechargetimer = CurTime() + self.rechargerate 
			end
			if self.fired then 
				self.fired = false
			end
		end
	end

	return self.BaseClass.Think(self)
end

function SWEP:Reload()
	return false
end