-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.PrintName = "Behemoth"

if CLIENT then

SWEP.ShowViewModel = true --DO NOT MODIFY THIS
SWEP.ShowWorldModel = true --DO NOT MODIFY THIS

SWEP.VElements = {
	["Behemoth1"] = { type = "Model", model = "models/weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_R_Finger0", rel = "", pos = Vector(-8.0, -12.0, 0), angle = Angle(-4.758, 129.942, -25.379), size = Vector(1.917, 1.917, 1.917), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} }
}

	SWEP.WElements = {
		["bone1+"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.127, 5.98, 4.98), angle = Angle(78.624, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["bone1"] = { type = "Model", model = "models/Gibs/HGIBS_spine.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(3.489, 6.668, -4.731), angle = Angle(109.05, 121.805, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["eye1"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, 2.168, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["skull"] = { type = "Model", model = "models/Gibs/HGIBS.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(10.206, -0.014, 0.361), angle = Angle(-180, -93.051, -91.457), size = Vector(1.605, 1.605, 1.605), color = Color(211, 211, 211, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["crowbar"] = { type = "Model", model = "models/Weapons/w_crowbar.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.857, 0.418, 1.325), angle = Angle(0, -107.212, -97.001), size = Vector(1, 1.715, 1.763), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {} },
		["eye1+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "skull", pos = Vector(4.406, -2.438, 1.33), size = { x = 13, y = 13 }, color = Color(255, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
	} 
end

SWEP.Base = "weapon_zs_undead_base"

--SWEP.ViewModel = Model("models/weapons/v_zombine.mdl")
--SWEP.WorldModel = Model("models/Weapons/w_crowbar.mdl")

SWEP.HoldType = "pistol" --DO NOT MODIFY THIS
SWEP.ViewModelFOV = 60 --KEEP THIS AT 65-70
SWEP.ViewModelFlip = true --MAKE SURE THIS IS SET TO TRUE
SWEP.ViewModel = "models/weapons/v_zombine.mdl" --
--SWEP.WorldModel = "models/weapons/w_crowbar.mdl" --DO NOT MODIFY THIS
SWEP.WorldModel = "models/weapons/w_grenade.mdl" --DO NOT MODIFY THIS

SWEP.Primary.Delay = 0.65
SWEP.Primary.Duration = 1.5
SWEP.Primary.Reach = 48
SWEP.Primary.Damage = 35


function SWEP:StartPrimaryAttack()	
	--Make things easier
	local pl = self.Owner
	self.IdleAnimation = CurTime() + self:SequenceDuration()
	--Owner
	local mOwner, mWeapon = self.Owner, self.Weapon
	
	--Sequence to play
	local iSequence = table.Random(self.ZombineAttacks) 	
	self:SetAttackSeq(iSequence)	
	--self:SetAttackAnimEndTime(CurTime() + 0.00)
	self:SetAttackAnimEndTime(CurTime() + 1.5)

	--Hacky way for the animations
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	mOwner:DoAnimationEvent(CUSTOM_PRIMARY)

end

function SWEP:PostPerformPrimaryAttack(hit)
	if CLIENT then
		return
	end

	if hit then
		if ent and IsValid(ent) and ent:IsPlayer() then
			pl:EmitSound(Sound("player/zombies/b/hitflesh.wav"),math.random(80,90),math.random(95,100))
			util.Blood(trace.HitPos, math.Rand(self.Primary.Damage * 0.25, self.Primary.Damage * 0.6), (trace.HitPos - self.Owner:GetShootPos()):GetNormal(), math.Rand(self.Primary.Damage * 6, self.Primary.Damage * 12), true)
		else
			pl:EmitSound(Sound("player/zombies/b/hitwall.wav"),math.random(80,90),math.random(95,100))
		end
	else
		self.Owner:EmitSound(Sound("player/zombies/b/swing.wav"),math.random(80,90),math.random(95,100))
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then
		return
	end

	if SERVER then
		self.Owner:EmitSound("player/zombies/b/scream.wav", math.random(80, 90), math.random(80, 110))
	end

	self.NextYell = CurTime() + math.random(8,13)
end

function SWEP:Think()
	--Start idle animation when needed
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	return self.BaseClass.Think(self)
end


if CLIENT then
	function SWEP:DrawHUD()
		if not self.Owner:Alive() or ENDROUND then
			return
		end
		MeleeWeaponDrawHUD()
	--	draw.SimpleTextOutlined("'c' to change perspective", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	end
end