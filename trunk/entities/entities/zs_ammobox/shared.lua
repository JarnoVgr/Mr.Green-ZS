AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Pufulet"
ENT.Purpose			= ""
--ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

util.PrecacheSound("items/ammo_pickup.wav")
util.PrecacheModel("models/items/boxmrounds.mdl")

function ENT:Initialize()
	if SERVER then	
		self:DrawShadow(false)
		self.Entity:SetModel("models/items/boxmrounds.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		local phys = self.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(true) 
		end
	end
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
		
			--local Automatic, Pistol = activator:GetAutomatic(), activator:GetPistol()
			--if Automatic or Pistol then
				local WeaponToFill = activator:GetActiveWeapon()		
				local AmmoType

				--print(WeaponToFill:GetPrimaryAmmoTypeString());
				--if IsValid(WeaponToFill) and (GetWeaponCategory ( WeaponToFill:GetClass() ) == "Pistol" or GetWeaponCategory ( WeaponToFill:GetClass() ) == "Automatic" or GetWeaponCategory ( WeaponToFill:GetClass() ) == "tool1") then
					AmmoType = WeaponToFill:GetPrimaryAmmoTypeString() or "pistol"
				--else
				--	AmmoType = "pistol"
				--end
						
				if AmmoType == "slam" or AmmoType == "grenade" or AmmoType == "none" then
					WeaponToFill:SetClip1(WeaponToFill:Clip1() + 1)
				else
				
				--print(WeaponToFill:GetClass())
				--if WeaponToFill:GetClass() == "weapon_zs_tools_hammer" then
				--	WeaponToFill:SetClip2(WeaponToFill:Clip2()+2)
				--end
				
				-- How much ammo to give
				local HowMuch = GAMEMODE.AmmoRegeneration[AmmoType]
				
				local mul = 1
					
				if activator:GetPerk("Support") then
					mul = (mul+0.1) + activator:GetRank()*0.02
				end	
				
				if activator:GetPerk("support_ammo") then
					mul = mul + 0.4
				end					
				
				if activator:HasBought("ammoman") then
					mul = mul + 0.5
				end		

				activator:GiveAmmo(math.Round(HowMuch * mul), AmmoType)							
			end
		end

			self:EmitSound("items/gift_pickup.wav" )
			self:Remove()
		--end
	end
end
	
if CLIENT then
	--ENT.LineColor = Color(210, 0, 0, 100)
	function ENT:Draw()
	    self:DrawModel()
		
	    if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
	        return
		end

	    self.LineColor = Color(0, 200, 100, 100)
	end

	--function ENT:OnRemove()
	--    hook.Remove("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self))
	--end
end