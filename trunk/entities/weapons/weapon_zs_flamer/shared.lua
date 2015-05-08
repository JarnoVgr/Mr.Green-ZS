AddCSLuaFile()
--AddCSLuaFile("flamethrower_hk_fire.lua")
 
SWEP.Weight                = 7
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false

SWEP.PrintName             = "Flamethrower"
SWEP.Slot                  = 1
SWEP.SlotPos               = 3
SWEP.DrawAmmo              = false
SWEP.DrawCrosshair         = false




if CLIENT then

	SWEP.ViewModelFlip = false

SWEP.ViewModelBoneMods = {
	["base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-2.609, -1.833, -9.858), angle = Angle(-58.95, -48.734, 104.32) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-6.448, -41.484, -9.044) }
}

SWEP.VElements = {
	["Flamethrower4"] = { type = "Model", model = "models/effects/muzzleflash/minigunmuzzle.mdl", bone = "base", rel = "Flamethrower3", pos = Vector(-2.437, 0.009, -2.681), angle = Angle(1.603, -92.178, 34.143), size = Vector(0.025, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower7"] = { type = "Model", model = "models/props_lab/jar01a.mdl", bone = "base", rel = "Flamethrower6", pos = Vector(3.408, 0.136, -8.728), angle = Angle(88.864, -2.681, -0.809), size = Vector(0.352, 0.352, 0.352), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {} },
	["Flamethrower3"] = { type = "Model", model = "models/props/cs_assault/duct.mdl", bone = "base", rel = "", pos = Vector(7.197, 8.55, 16.875), angle = Angle(-144.221, -180, -4.395), size = Vector(0.09, 0.09, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower6"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "base", rel = "Flamethrower5", pos = Vector(-9.893, 0.324, 2.127), angle = Angle(7.475, -91.39, 89.01), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower2"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "base", rel = "", pos = Vector(11.416, 6.847, 7.521), angle = Angle(-85.066, -3.784, 87.272), size = Vector(1.036, 0.911, 1.036), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "base", rel = "", pos = Vector(6.883, 6.593, 5.328), angle = Angle(-3.247, 163.167, -7.038), size = Vector(0.23, 0.23, 0.493), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower5"] = { type = "Model", model = "models/props_mining/generator_steamgage01.mdl", bone = "base", rel = "Flamethrower", pos = Vector(1.35, -0.406, -5.898), angle = Angle(-88.193, -165.605, -2.076), size = Vector(0.333, 0.349, 0.233), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["FlamethrowerAmmo"] = { type = "Quad", bone = "base", rel = "Flamethrower5", pos = Vector(1.016, -0.176, 4.304), angle = Angle(-91.803, 4.942, 5.885), size = 0.05, draw_func = nil},

}

SWEP.WElements = {
	["Flamethrower4"] = { type = "Model", model = "models/effects/muzzleflash/minigunmuzzle.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flamethrower3", pos = Vector(-2.437, 0.009, -2.681), angle = Angle(1.603, -92.178, 34.143), size = Vector(0.025, 0.025, 0.025), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower5"] = { type = "Model", model = "models/props_mining/generator_steamgage01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flamethrower", pos = Vector(1.35, -0.406, -5.898), angle = Angle(-88.193, -165.605, -2.076), size = Vector(0.333, 0.349, 0.233), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower3"] = { type = "Model", model = "models/props/cs_assault/duct.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(30.458, 2.224, -7.978), angle = Angle(-0.375, -99.068, 76.25), size = Vector(0.09, 0.09, 0.09), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower2"] = { type = "Model", model = "models/props_c17/TrapPropeller_Lever.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.659, 6.25, -4.961), angle = Angle(0, -180, 0), size = Vector(1.036, 0.911, 1.036), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower6"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flamethrower5", pos = Vector(-9.893, 0.324, 2.127), angle = Angle(7.475, -91.39, 89.01), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower"] = { type = "Model", model = "models/props_c17/canister02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.218, 0.43, -4.639), angle = Angle(-5.158, 90.91, 102.494), size = Vector(0.395, 0.391, 0.691), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["Flamethrower7"] = { type = "Model", model = "models/props_lab/jar01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Flamethrower6", pos = Vector(3.408, 0.136, -8.728), angle = Angle(88.864, -2.681, -0.809), size = Vector(0.352, 0.352, 0.352), color = Color(255, 255, 255, 255), surpresslightning = false, material = "phoenix_storms/stripes", skin = 0, bodygroup = {} }
}

end

SWEP.Base                  = "weapon_zs_base"
SWEP.Author                = "Duby!"
SWEP.Contact               = ""
SWEP.Purpose               = "Boo boo!"
SWEP.Instructions          = ""

SWEP.Category              = "Other"
 
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
 
SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

 
SWEP.Primary.ClipSize      = 1500
SWEP.Primary.DefaultClip   = 1500
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Ammo          = "none"
SWEP.Primary.Automatic     = true
SWEP.MaxAmmo               = 1500

SWEP.UseHands              = true

SWEP.IronSightsPos = Vector(-3.8, -11.502, 3.72)
SWEP.IronSightsAng = Vector(0, 0, 0)



function SWEP:Initialize()
	self:SetWeaponHoldType("smg")
	
	if CLIENT then
	
	--	// Create a new table for every weapon instance
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements)-- // create viewmodels
		self:CreateModels(self.WElements)-- // create worldmodels
		
	--	// init view model bone build function
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
			--	// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
				--	// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
				--	// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
				--	// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end
end

function SWEP:PrimaryAttack()
	if self.Owner:WaterLevel() > 0 or not self:CanPrimaryAttack() then return end
	
	self:TakePrimaryAmmo(1)
	
	if not self.Sound then
		self.Sound = CreateSound(self.Owner, "thrusters/rocket04.wav")
		self.Sound:Play()
		self.Sound:ChangeVolume(1, 0.1)
	else
		self.Sound:ChangeVolume(1, 0.1)
	end

	local tr = util.TraceLine { 
		start = self.Owner:GetShootPos() /2,
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 300,
		filter = self.Owner
	}
	
	if SERVER then
		if IsValid(tr.Entity) then
			tr.Entity:Ignite(math.random(10, 20))
			
			if tr.Entity:IsNPC() or tr.Entity:IsPlayer() then
			tr.Entity:Fire("sethealth", "" ..tr.Entity:Health() - math.random(5, 10) .."", 0)
		end
		end
		
		local ef = EffectData()
		ef:SetOrigin(tr.HitPos)
		ef:SetStart(self.Owner:GetShootPos())
		ef:SetAttachment(1)
		ef:SetEntity(self.Weapon)
		util.Effect("flames", ef, true, true)
		
	end
	
	self:SetNextPrimaryFire(CurTime() + 0.06)
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	if self.Owner:KeyReleased(IN_ATTACK) or not self.Owner:KeyDown(IN_ATTACK) then
		if self.Sound then
			self.Sound:ChangeVolume(0, 0.1)
		end
	end
	
	local tr = util.TraceLine {
		start = self.Owner:GetShootPos(),
	--	endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() ,
		filter = self.Owner
	}
	
	local ent = tr.Entity
	
	if self.Owner:KeyDown(IN_RELOAD) and ent:IsValid() and ent:GetModel() == "models/props_junk/propanecanister001a.mdl" and self == self.Owner:GetActiveWeapon() and self:Clip1() <= self.MaxAmmo then
		if SERVER then
			ent:Remove()
		end
		
		self:SetClip1(math.min(self:Clip1() + 150, self.MaxAmmo))
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW) 
	
	return true
end

function SWEP:Holster()
	if self.Sound then self.Sound:ChangeVolume(0, 0.1) end
	return true
end

function SWEP:OnRemove()
	if self.Sound then self.Sound:ChangeVolume(0, 0.1) end
end



