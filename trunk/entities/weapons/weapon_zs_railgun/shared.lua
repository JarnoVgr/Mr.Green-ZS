-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then
	AddCSLuaFile("shared.lua")
end

SWEP.Base = "weapon_zs_base"
SWEP.PrintName = "Railgun"
SWEP.Author	= "Pufulet"
	
if CLIENT then		
	SWEP.ViewModelBoneMods = {
		["v_weapon.xm1014_Parent"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
	}

	SWEP.VElements = {
		["Pulse Shotgun6+"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "v_weapon.xm1014_Parent", rel = "Pulse Shotgun5", pos = Vector(-0.055, 0.004, 0.085), angle = Angle(175.679, 5.567, -180), size = Vector(0.035, 0.039, 0.061), color = Color(50, 19, 0, 255), surpresslightning = false, material = "models/props_combine/portalball001_sheet", skin = 0, bodygroup = {} },
		["Pulse Shotgun"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(-0.556, -3.951, -7.731), angle = Angle(0, 180, 0), size = Vector(0.035, 0.039, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun2"] = { type = "Model", model = "models/props_lab/generator.mdl", bone = "v_weapon.xm1014_Parent", rel = "Pulse Shotgun", pos = Vector(-0.801, -0.233, 17.627), angle = Angle(-180, 93.324, 0.128), size = Vector(0.027, 0.019, 0.122), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun6"] = { type = "Model", model = "models/maxofs2d/hover_propeller.mdl", bone = "v_weapon.xm1014_Parent", rel = "Pulse Shotgun5", pos = Vector(-0.065, 0, -0.561), angle = Angle(-1.991, 6.984, -1.407), size = Vector(0.035, 0.039, 0.03), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun3+"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "v_weapon.xm1014_Parent", rel = "Pulse Shotgun2", pos = Vector(2.868, 0.061, 8.35), angle = Angle(-2.3, -50.905, -89.383), size = Vector(0.221, 0.666, 0.221), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/effects/comball_sphere", skin = 0, bodygroup = {} },
		["Pulse Shotgun3"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "v_weapon.xm1014_Parent", rel = "Pulse Shotgun2", pos = Vector(2.868, 0.061, 8.35), angle = Angle(-2.129, -3.366, -88.297), size = Vector(0.175, 0.635, 0.175), color = Color(255, 166, 0, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun5"] = { type = "Model", model = "models/maxofs2d/hover_plate.mdl", bone = "v_weapon.xm1014_Parent", rel = "", pos = Vector(-1.354, -4.784, 5.631), angle = Angle(96.26, -4.4, -85.106), size = Vector(0.054, 0.054, 0.108), color = Color(255, 152, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun4"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "v_weapon.xm1014_Parent", rel = "Pulse Shotgun3+", pos = Vector(-2.024, 11.036, -1.704), angle = Angle(57.305, -1.318, -0.852), size = Vector(0.13, 0.896, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["Pulse Shotgun4"] = { type = "Model", model = "models/props_lab/reciever01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pulse Shotgun3+", pos = Vector(-2.024, 11.036, -1.704), angle = Angle(57.305, -1.318, -0.852), size = Vector(0.13, 0.896, 0.13), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.428, 1.689, -4.094), angle = Angle(-4.514, -90.486, 80.837), size = Vector(0.035, 0.039, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun2"] = { type = "Model", model = "models/props_lab/generator.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pulse Shotgun", pos = Vector(-0.801, -0.233, 17.627), angle = Angle(-180, 93.324, 0.128), size = Vector(0.027, 0.025, 0.116), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Pulse Shotgun3+"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pulse Shotgun2", pos = Vector(2.868, 0.061, 8.35), angle = Angle(-2.3, -50.905, -89.383), size = Vector(0.221, 0.666, 0.221), color = Color(0, 255, 255, 255), surpresslightning = false, material = "models/effects/comball_sphere", skin = 0, bodygroup = {} },
		["Pulse Shotgun3"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Pulse Shotgun2", pos = Vector(2.868, 0.061, 8.35), angle = Angle(-2.129, -3.366, -88.297), size = Vector(0.175, 0.635, 0.175), color = Color(255, 166, 0, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.IronSightsPos = Vector(-5.2, -11.495, 2.4)
SWEP.IronSightsAng = Vector(0.765, 0, 0)
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.UseHands = true

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.Primary.ClipSize = 8;
SWEP.Primary.DefaultClip = 20;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "357";
 
SWEP.Sound = Sound ("weapon_357.Single")
SWEP.Damage = 50
SWEP.Spread = 0.02
SWEP.NumBul = 1
SWEP.Delay = 0.7
SWEP.Force = 3
 
function SWEP:PrimaryAttack() -- when secondary attack happens
 
	-- Make sure we can shoot first
	if ( !self:CanPrimaryAttack() ) then return end
 
	local eyetrace = self.Owner:GetEyeTrace();
	-- this gets where you are looking. The SWep is making an explosion where you are LOOKING, right?
 
	self:EmitSound ( self.Sound )
	-- this makes the sound, which I specified earlier in the code
 
	self.BaseClass.ShootEffects (self);
	-- this makes the shooting animation for the 357 for view model and world model. 
 
	local explode = ents.Create( "env_explosion" ) -- creates the explosion
	explode:SetPos( eyetrace.HitPos )
	-- this creates the explosion through your self.Owner:GetEyeTrace, which is why I put eyetrace in front
	explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
	explode:Spawn() --this actually spawns the explosion
	explode:SetKeyValue( "iMagnitude", "220" ) -- the magnitude
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 ) -- the sound for the explosion, and how far away it can be heard
 
	self:SetNextPrimaryFire( CurTime() + self.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Delay )
	-- this sets the delay for the next primary and secondary fires.
 
	self:TakePrimaryAmmo(1) -- removes 1 ammo from our clip
 
end -- telling Gmod that it's the end of the function