-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

-- Melee base
SWEP.Base = "weapon_zs_melee_base"

-- Model paths
SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_punch.mdl" )--models/weapons/v_punch.mdl
SWEP.WorldModel = Model ( "models/weapons/w_hands.mdl" )

-- Name and fov
SWEP.PrintName = "Fists"
SWEP.ViewModelFOV = 60

-- Slot pos
SWEP.Slot = 2
SWEP.SlotPos = 3

SWEP.HoldType = "fists"

-- Damage, distane, delay
SWEP.Primary.Damage = 3
SWEP.Primary.Delay = 0.75
SWEP.Primary.Distance = 40
SWEP.TotalDamage = SWEP.Primary.Damage
-- Killicons
if CLIENT then killicon.AddFont( "weapon_zs_fists", "HL2MPTypeDeath", "6", Color( 255, 80, 0, 255 ) ) end

Bones = {
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine",
	"ValveBiped.Bip01_Spine1",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Spine4",
	"ValveBiped.Bip01_Neck1",
	"ValveBiped.Bip01_Head1",
	-- "ValveBiped.Bip01_R_Clavicle",
	-- "ValveBiped.Bip01_L_Clavicle",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0"
}

local function BuildNewBonePositions(self)
			for _, bonetoscale in pairs(Bones) do
				local Bone = self:LookupBone(bonetoscale)
					if Bone then
						local mMatrix = self:GetBoneMatrix(Bone)
						if mMatrix then
						mMatrix:Scale(Vector(0.0000001, 0.0000001, 0.0000001))
						self:SetBoneMatrix(Bone, mMatrix)
						if bonetoscale ==  "ValveBiped.Bip01_Spine1" then
							mMatrix:Translate(Vector(-50,-50,1000))
						end
						end
					end
			end
end

function SWEP:DoAnimation()
	
	-- 1st person animation
	if math.random ( 1,2 ) == 2 then self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) else self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) end
	
	-- Thirdperson animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end


function SWEP:Initialize() 
	if CLIENT then
		self:MakeNewArms()
	end
end

function SWEP:OnRemove()
	if CLIENT then
		self:RemoveNewArms()
	end
end 

if CLIENT then

function SWEP:ViewModelDrawn() 
	local vm = self.Owner:GetViewModel();
	if IsValid(self.Arms) then
	render.SetBlend(1)
    self.Arms:DrawModel()
	render.SetBlend(1)
	vm:SetColor(255,255,255,255)
	end
end

function SWEP:MakeNewArms()
	local vm = self.Owner:GetViewModel();
	if not vm then return end
	self.Arms = ClientsideModel(self.Owner:GetModel(), RENDER_GROUP_OPAQUE_ENTITY) --self.Owner:GetModel()
	if (IsValid(self.Arms)) and (IsValid(vm)) then 
		self.Arms:SetPos(self.Owner:GetPos() - self.Owner:GetForward()*56)
		-- self.Arms:SetAngles(vm:GetAngles())
		self.Arms:SetParent(vm) 
		self.Arms:AddEffects(EF_BONEMERGE and EF_BONEMERGE_FASTCULL and EF_PARENT_ANIMATES)
		self.Arms:SetNoDraw(true) 
		self.Arms.BuildBonePositions = BuildNewBonePositions
		vm:SetColor(255,255,255,255)
	else
		self.Arms = nil
	end
end

function SWEP:RemoveNewArms()
if (IsValid(self.Arms)) then
	self.Arms:Remove()
end
	self.Arms = nil
end

end

