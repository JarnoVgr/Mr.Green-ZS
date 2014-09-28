-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Duby"



if CLIENT then
	SWEP.ShowViewModel = false 

--SWEP.VElements = {
	--["1"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.118, -10.91), angle = Angle(-5.844, -10.52, 29.221), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} } 
--}

	
SWEP.VElements = {
	--["chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.368, -2.464, 1.712), angle = Angle(4.574, 93.4, 0), size = Vector(1.088, 1.088, 1.088), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	["chainsaw"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.941, 2.631, -6.678), angle = Angle(180, 90, -53.116), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/weapons/w_chainsaw.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.752, 0, -5.715), angle = Angle(-3.507, 66.623, 75.973), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


	--killicon.AddFont( "weapon_zs_melee_crowbar", "HL2MPTypeDeath", "6", Color(255, 255, 255, 255 ) )
end

SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/props_canal/mattpipe.mdl"

-- Name and fov
SWEP.HoldType = "melee2"
SWEP.PrintName = "Chainsaw!"
SWEP.ViewModelFOV = 60
SWEP.DeploySpeed = 0.6
-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 8

-- Damage, distane, delay
SWEP.Primary.Automatic	= true
SWEP.Primary.Damage = 60
SWEP.Primary.Delay = 0.5
SWEP.Primary.Distance = 73
SWEP.WalkSpeed = 177
SWEP.SwingTime = 0
--SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingRotation = Angle(0, 0, 0)
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.UseHands = true
-- Killicons
if CLIENT then
	killicon.AddFont( "weapon_zs_melee_pipe", "HL2MPTypeDeath", "6", Color( 255, 80, 0, 255 ) )
end

function SWEP:PlaySwingSound()
	self:EmitSound("ambient/machines/slicer1.wav")
	self:EmitSound("weapons/melee/chainsaw_gore_03.wav")
end

 function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/melee/chainsaw_gore_03.wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/melee_skull_break_01.wav")
	self:EmitSound("weapons/melee/chainsaw_gore_03.wav")
end

function SWEP:OnDeploy()
	if SERVER then
		self.DeployTime = CurTime() + 0
		self.ChainSound = CreateSound( self.Owner, "weapons/melee/chainsaw_idle.wav" ) 
		if not self.Deployed then
			self.Owner:EmitSound("weapons/melee/chainsaw_start_0"..math.random(1,2)..".wav")
			self.Deployed = true
		end
	end
	
end

function SWEP:_OnRemove() --Cheers Necro, this code is from the hate swep
	if SERVER then
		if self.Owner and self.Owner:IsValid() then
			self.Owner:EmitSound("weapons/melee/chainsaw_die_01.wav")
		end
		self.ChainSound:Stop()
	end
end 