-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if CLIENT then

SWEP.ViewModelFOV = 65
	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
	
	SWEP.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -72.75, 0) },
		["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -69.2, 0) },
		["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -68.004, 0) },
		["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -58.772, 0) },
		["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(11.871, -71.754, -22.512) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-4.777, 11.446, -35.982) },
		["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-8.693, 2.532, 25.214) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 16.1, -47.251) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 46.051) },
		["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(9.029, -52.984, -12.752) },
		["ValveBiped.Bip01_L_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -55.211, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.035, -8.169, -6.045) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(20.917, -14.115, -34.5) }
	}
		
	SWEP.VElements = {
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(23.111, 0.048, 1.35), angle = Angle(0, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(23.305, 0.048, -1.05), angle = Angle(180, 90, -85.6), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	--[[
	SWEP.WElements = {
		["body2"] = { type = "Model", model = "models/Humans/Charple02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(4.162, -1.362, 0.55), angle = Angle(-13.912, -180, -1.675), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["cleaver"] = { type = "Model", model = "models/props_lab/Cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(-16.514, 3.124, 34), angle = Angle(-67.575, -152.163, 24.312), size = Vector(0.563, 0.563, 0.563), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookleft"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_L_Forearm", rel = "", pos = Vector(12.744, -0.601, -0.758), angle = Angle(-157.594, 90.811, -98.482), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "body1", pos = Vector(-9.219, -4.031, 50), angle = Angle(-4.95, 95.3, -5.7), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["hookright"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.112, -0.732, -0.639), angle = Angle(-100.482, 105.314, -69.044), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["body1"] = { type = "Model", model = "models/Humans/Charple03.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-44, 0, 23.875), angle = Angle(67.311, 0.119, 180), size = Vector(0.899, 0.899, 0.899), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	]]--
	
end

SWEP.PrintName = "Seeker2"
SWEP.DrawAmmo = false
SWEP.ShowWorldModel = true
SWEP.CSMuzzleFlashes = false
SWEP.DrawCrosshair = true

SWEP.Base = "weapon_zs_undead_base"

SWEP.Author = "Duby"
SWEP.Contact = "Mr.Green"
SWEP.Purpose = "To terrify players of course!"
SWEP.Instructions = ""


SWEP.Base = "weapon_zs_undead_base"

SWEP.ViewModel = Model("models/weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_knife_t.mdl")

SWEP.Primary.Reach = 45
SWEP.Primary.Duration = 2.1
SWEP.Primary.Delay = 1.4
SWEP.Primary.Damage = math.random(45,50)

SWEP.ShowWorldModel = false

function SWEP:IsAttacking()
	return self:GetDTBool(0) or false
end

function SWEP:SetAttacking(bl)
	self:SetDTBool(0,bl)
end

function SWEP:StartPrimaryAttack()
local pl = self.Owner

if SERVER then
		self:SetAttacking(true)	
		self.Owner:EmitSound(Sound("ambient/machines/slicer1.wav"),math.random(100,130),math.random(95,100))--Only play the sound when his speed is reduced.
	end 

	--[[	timer.Simple ( 1.3, function()
		if not IsValid ( pl ) then return end
		
		-- Conditions
		if not pl:Alive() then return end
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
		if self and self.Weapon then self:SetAttacking(false) end
	end)]]--
	
	if self.SwapAnims then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	end
	
	self.SwapAnims = not self.SwapAnims
	self.Owner:DoAnimationEvent(CUSTOM_PRIMARY)

	if CLIENT then
	if self.WElements then-- This is for making the world props which are on him invisible.
						for k,v in pairs(self.WElements) do --Make him visible, but I need to re-write this!
							if self:IsAttacking() then
								 v.color = Color(255,255,255,225)
							else
								 v.color = Color(255,255,255,225)
							end
						end
					end
				end

--Lets make him visible then not visible. :O Spooky!
self.Owner:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(225,225,225,225))
timer.Simple(0.8, function() 
	self.Owner:SetRenderMode(RENDERMODE_GLOW) pl:SetColor(Color(225,225,225,1))
	--[[if CLIENT then--Has to be in an if CLIENT
	for k,v in pairs(self.WElements) do
	v.color = Color(255,255,255,0)--Make him invisible
	end
	end]]--
	end)
end

function SWEP:PostPerformPrimaryAttack(hit)
	--if CLIENT then
		--return
--end 
end


function SWEP:PrimaryAttackHit(trace, ent)
	--if CLIENT then
		--return
	--end
	pl:EmitSound(Sound("player/zombies/seeker/melee_0"..math.random(1,2)..".wav"),math.random(100,130),math.random(95,100))
	util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
end


SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	
if CurTime() < self.NextYell then
		return
	end

	if SERVER then
		self.Owner:EmitSound("ambient/creatures/town_child_scream1.wav", math.random(130, 150), math.random(80, 110))
	end
	
	self.NextYell = CurTime() + math.random(8,13)
end

function SWEP:OnDeploy()
		self.BaseClass.Deploy(self)
	if SERVER then
		self:SetAttacking(false)
		self.Owner:EmitSound(Sound("player/zombies/seeker/pain1.wav"),math.random(100,160),math.random(50,55))
	end

	local vm = self.Owner:GetViewModel()
	if vm:GetMaterial() == "" then
			vm:SetMaterial("Models/Charple/Charple1_sheet")
		end
	
end

function SWEP:Move(mv)
	if self:IsInPrimaryAttack() then --Slower him on the primary attack
		mv:SetMaxSpeed(145)
		return true
	end
end
	
function SWEP:_OnRemove()
	if SERVER then
		self.GrowlSound:Stop()
	end
	
end


if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
	end
end
