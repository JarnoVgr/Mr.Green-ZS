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
	["PulseSMG5"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.375, 1.587, -9.561), angle = Angle(-8.875, 179.457, 71.336), size = Vector(0.067, 0.067, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG2"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.base", rel = "PulseSMG", pos = Vector(4.044, 0.184, 9.319), angle = Angle(-79.792, -94.413, -89.52), size = Vector(0.273, 0.356, 0.333), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG4"] = { type = "Model", model = "models/props_combine/combine_emitter01.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.384, -0.357, -2.928), angle = Angle(-88.22, 0, 0), size = Vector(0.13, 0.13, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG9"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.377, 3.265, -2.708), angle = Angle(-0.445, -6.307, -107.764), size = Vector(0.034, 0.034, 0.034), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG6"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0, -2.773, -4.309), angle = Angle(2.865, 0.363, 0), size = Vector(0.082, 0.078, 0.146), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/spawn_effect2", skin = 0, bodygroup = {} },
	["PulseSMG3"] = { type = "Model", model = "models/gibs/manhack_gib02.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0.411, -0.588, -5.526), angle = Angle(96.745, 90.686, -7.461), size = Vector(0.275, 0.483, 0.331), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.019, -0.2, -2.668), angle = Angle(0, -86.018, 0), size = Vector(0.214, 0.214, 0.342), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG8"] = { type = "Model", model = "models/props_combine/pipes01_cluster02a.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(1.167, -0.361, -8.129), angle = Angle(-1.175, 180, 0), size = Vector(0.028, 0.039, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} },
	["PulseSMG3+"] = { type = "Model", model = "models/gibs/manhack_gib02.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(-0.29, 0.564, -9.318), angle = Angle(-37.954, -100.118, 84.945), size = Vector(0.275, 0.483, 0.279), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["pulseSMGSCREEN"] = { type = "Quad", bone = "ValveBiped.base", rel = "pulseSMG", pos = Vector(0.166, 0.85, 2.453), angle = Angle(2.45, 1.067, 58.862), size = 0.05, draw_func = nil},

}

SWEP.WElements = {
	["PulseSMG5"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.687, 1.587, -1.992), angle = Angle(178.716, -97.94, 17.966), size = Vector(0.067, 0.067, 0.067), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG2"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.854, 0.975, -3.283), angle = Angle(-173.314, -147.51, -161.209), size = Vector(0.273, 0.356, 0.333), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG4"] = { type = "Model", model = "models/props_combine/combine_emitter01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.551, 1.73, -3.773), angle = Angle(-11.004, 0.67, 93.953), size = Vector(0.13, 0.13, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG9"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.605, 0.994, -1.042), angle = Angle(0, 0, 0), size = Vector(0.048, 0.048, 0.048), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG6"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.047, 1.633, -6.783), angle = Angle(0, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/spawn_effect2", skin = 0, bodygroup = {} },
	["PulseSMG3"] = { type = "Model", model = "models/gibs/manhack_gib02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.038, 1.585, -1.482), angle = Angle(0, 0, 0), size = Vector(0.275, 0.483, 0.331), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.779, 1.315, -7.133), angle = Angle(82.132, 1.774, 0), size = Vector(0.214, 0.214, 0.342), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["PulseSMG8"] = { type = "Model", model = "models/props_combine/pipes01_cluster02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.685, 2.88, -7.773), angle = Angle(-0.005, 89.696, -81.195), size = Vector(0.028, 0.028, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} }
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

SWEP.Primary.Sound			= Sound("weapons/airboat/airboat_gun_lastshot"..math.random(1,2)..".wav")
SWEP.Primary.Recoil			= 1.2
SWEP.Primary.Damage			= 11
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

SWEP.IronSightsPos = Vector(-6.361, -7.047, 0.92)
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
SWEP.rechargerate = 0.45
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
				self.MaxClip = 20 + (20*(10*self:GetOwner():GetRank())/100)
				self.rechargerate = 0.45 - (0.45*(5*self:GetOwner():GetRank())/100)				
			end
			
			if (CurTime() - self.startcharge) > self.lastfire and CurTime() > self.rechargetimer then
				self.Weapon:SetClip1(math.min(self.MaxClip, self.Weapon:Clip1() + 1))
				self.rechargerate = 0.1
				self.rechargetimer = CurTime() + self.rechargerate 
				
				if IsValid(self:GetOwner()) and self:GetOwner():GetSuit() == "freeman" then --Ability for freeman suit!
					self.Weapon:SetClip1(math.min(self.MaxClip, self.Weapon:Clip1() + 1))
					self.rechargerate = 0.01
				end
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