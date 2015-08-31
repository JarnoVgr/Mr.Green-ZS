-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Pulse Pistol"
	SWEP.Author	= "Pufulet"	
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 60
	SWEP.WElements = {
	["battery"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.201, -3.201, 1.557), angle = Angle(0, 90, -176.495), size = Vector(0.449, 0.4, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["front"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "battery", pos = Vector(0.5, 0, -2.597), angle = Angle(0, 0, 180), size = Vector(0.349, 0.349, 0.335), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.VElements = {
	["battery"] = { type = "Model", model = "models/items/battery.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3, -3.5), angle = Angle(0, 90, 0), size = Vector(0.349, 0.4, 0.6), color = Color(142, 211, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["battery+++"] = { type = "Model", model = "models/Items/combine_rifle_cartridge01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -1.601, -2.597), angle = Angle(90, 0, 90), size = Vector(0.2, 0.6, 0.2), color = Color(203, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["battery+"] = { type = "Model", model = "models/Items/combine_rifle_ammo01.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(0, -3, -9.87), angle = Angle(0, 0, 0), size = Vector(0.3, 0.3, 0.3), color = Color(142, 211, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["battery++"] = { type = "Model", model = "models/Items/AR2_Grenade.mdl", bone = "v_weapon.FIVESEVEN_PARENT", rel = "", pos = Vector(-0.5, -3.201, -4.676), angle = Angle(-90, 0, 0), size = Vector(0.4, 0.4, 0.4), color = Color(0, 120, 208, 255), surpresslightning = false, material = "models/error/new light1", skin = 0, bodygroup = {} }
	}
	
	SWEP.IconLetter = "u"	
	killicon.AddFont("weapon_zs_pulsepistol", "CSKillIcons", SWEP.IconLetter, Color(0, 96, 255, 255))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel = "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.UseHands = true
SWEP.HumanClass = "engineer"
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType = "pistol"

SWEP.Primary.Sound = Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Recoil			= 0.6
SWEP.Primary.Damage			= 11
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 8
SWEP.Primary.Delay			= 0.12
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false

SWEP.Primary.Ammo			= "none"

SWEP.Cone 			= 0.048
SWEP.ConeMoving		 = SWEP.Cone *1.3
SWEP.ConeCrouching 	 = SWEP.Cone *0.8
SWEP.ConeIron 		 = SWEP.Cone *0.8
SWEP.ConeIronCrouching   	= SWEP.ConeCrouching *0.8
SWEP.ConeIronMoving	 = SWEP.ConeMoving *0.8

SWEP.IronSightsPos = Vector(-5.95, 7, 2 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )

SWEP.OverridePos = Vector(1.559, -3.116, 1.6)
SWEP.OverrideAng = Vector(0, 0, 0)

SWEP.TracerName = "AR2Tracer"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.MaxBulletDistance 		= 2900 -- Uses pulse power, FTW!
SWEP.FirePower = ( SWEP.Primary.Damage * SWEP.Primary.ClipSize )
SWEP.WalkSpeed = SPEED_PISTOL
SWEP.fired = false
SWEP.lastfire = 0
SWEP.rechargetimer = 0
SWEP.rechargerate = 0.55
SWEP.startcharge = 1
SWEP.MaxClip = 10




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
				self.MaxClip = 12 + (12*(5*self:GetOwner():GetRank())/100)
				self.rechargerate = 0.55 - (0.55*(2*self:GetOwner():GetRank())/100)				
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

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 80, math.random(115,125))
end

function SWEP:Reload()
	return false
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local e = EffectData()
		e:SetOrigin(tr.HitPos)
		e:SetNormal(tr.HitNormal)
		e:SetRadius(0.8)
		e:SetMagnitude(0.2)
		e:SetScale(0.2)
	util.Effect("cball_bounce", e)

	GenericBulletCallback(attacker, tr, dmginfo)
end