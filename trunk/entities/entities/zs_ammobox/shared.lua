AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Pufulet"
ENT.Purpose			= ""
ENT.AmmoType 		= "pistol"
--ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

util.PrecacheSound("items/ammo_pickup.wav")
util.PrecacheModel("models/items/boxmrounds.mdl")

ammoRandom = {"ar2","alyxgun","pistol","smg1","357", "buckshot", "battery", "Supply"}

ammoTypes = {    
	["ar2"] = Model("models/Items/combine_rifle_cartridge01.mdl"), --Rifle
	["alyxgun"] = Model("models/Items/combine_rifle_ammo01.mdl"),
	["pistol"] = Model("models/Items/BoxSRounds.mdl"), --Pistol
	["smg1"] = Model("models/Items/BoxMRounds.mdl"), --SMG
	["357"] = Model("models/Items/357ammobox.mdl"), --Sniper
	["buckshot"] = Model("models/Items/BoxBuckshot.mdl"),
	["Battery"] = Model("models/healthvial.mdl"), --Medkit
	["Supply"] = Model("models/Items/item_item_crate.mdl")
}

function ENT:Initialize()
	if SERVER then	
	
	local raw_types = {}
	for k, v in pairs( ammoTypes ) do
	  table.insert( raw_types, k )
	end

	self:SetAmmoType(table.Random(raw_types))	
		self:DrawShadow(false)
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		local phys = self.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(true) 
		end
	end
end

function ENT:SetAmmoType(ammoType)

	if (ammoType == "Supply") then
		self:SetModelScale(0.5,0)
	end
	self.Entity:SetModel(ammoTypes[ammoType])
	self.AmmoType = (ammoType)
end

if SERVER then
	function ENT:Use(activator, caller)
	
		if not IsValid(activator) then
			return
		end
		
		if activator:IsZombie() then
			return
		end
	
		if activator:IsPlayer() and activator:IsHuman() then
			activator:GiveAmmoPack(self.AmmoType)	
			self:EmitSound("items/gift_pickup.wav" )
			self:Remove()			
		end
	end
end
	

--if SHARED then
	--function ENT:Draw()
	--	self:RenderGlowEffect( Color(100/ 255, 180/ 255, 110/ 255) )		
	--end
--end
