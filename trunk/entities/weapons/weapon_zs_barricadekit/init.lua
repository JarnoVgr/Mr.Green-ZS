AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.PrintName = "barricade kit"

SWEP.WalkSpeed = 190
--SWEP.Models = { "models/props_interiors/radiator01a.mdl", "models/props_junk/trashbin01a.mdl" }
SWEP.Models = { "models/props_debris/wood_board01a.mdl", "models/props_junk/trashbin01a.mdl" }
SWEP.Models = { "models/props_debris/wood_board06a.mdl", "models/props_junk/trashbin01a.mdl" }
SWEP.ModelOBB = { [1] = { Min = Vector( -5.2500, -25.2500, -18.4771 ) , Max = Vector ( 5.2500 ,25.0245 ,18.2500 )  }, [2] = { Min = Vector( -13.2614 ,-12.0523 ,-20.2876 ) , Max = Vector ( 13.2614, 12.0523 ,20.3897 )  } }
--SWEP.ModelOBB = { [1] = { Min = Vector( -5.2500 ,-5.0245 ,-5.2500 ) , Max = Vector ( 1.2500 ,1.0245 ,1.2500 )  }, [2] = { Min = Vector( -13.2614 ,-12.0523 ,-20.2876 ) , Max = Vector ( 13.2614, 12.0523 ,20.3897 )  } }

function SWEP:Deploy()
	self.Owner:DrawViewModel( true )
	self.Owner:DrawWorldModel( true )

	GAMEMODE:WeaponDeployed ( self.Owner, self )
end

function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")
	self:SetModelToSpawn ( 1 )
end

function SWEP:SetModelToSpawn ( int ) 
	self.Weapon:SetNetworkedInt ( "ModelToSpawn", int )
end

function SWEP:GetModelToSpawn()
	return self.Models [self.Weapon:GetNetworkedInt ( "ModelToSpawn" )]
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		if not ValidEntity ( self.Owner ) then return end
	
		//Grab position
		local aimvec = self.Owner:GetAimVector()
		local shootpos = self.Owner:GetShootPos()
		
		//Heavy shit
		local Index = self.Weapon:GetNetworkedInt ( "ModelToSpawn" )
		local Max, Min = self.ModelOBB[Index].Max, self.ModelOBB[Index].Min
		local Offset = math.abs ( Max.z )
		if math.Round ( math.abs ( Min.z ) ) != math.Round ( math.abs( Max.z ) ) then
			Offset = 2
		end
		
		//Trace the shit
		--local tr = util.TraceLine( { start = shootpos, endpos = shootpos + aimvec * 250, filter = self.Owner , mask = MASK_NPCWORLDSTATIC } )
		local tr = util.TraceLine( { start = shootpos, endpos = shootpos + aimvec * 80, filter = self.Owner , mask = MASK_NPCWORLDSTATIC } )
		local hTrace = util.TraceHull ( { start = tr.HitPos + Vector( 0,0, Offset ), endpos = tr.HitPos + Vector( 0,0, Offset ), filter = { self.Owner }, mins = Min, maxs = Max } )
		
		CanSpawn = false
		
		//Spawn conditions
	--	if hTrace.Entity == NULL or hTrace.Entity:IsWorld() then CanSpawn = true end	
		if hTrace.Entity:IsWorld() then CanSpawn = true else CanSpawn = false end	
		--if tr.HitPos.z < self.Owner:GetPos().z + 20 then CanSpawn = true else CanSpawn = false end
		if tr.HitPos.z < self.Owner:GetPos().z + 100 then CanSpawn = true else CanSpawn = false end

		if CanSpawn then
			--local ent = ents.Create ( "prop_physics_multiplayer" )
			local ent = ents.Create ( "aegis" )
			local angles = self.Owner:GetAngles()
			ent:SetPos ( tr.HitPos + Vector ( 0,0, Offset ) )
			ent:EmitSound( "npc/dog/dog_servo12.wav" )
			ent:SetModel( self:GetModelToSpawn() )
			ent.IsBarricade = true
			ent:SetHealth ( 0 )
			ent:Spawn()
			
			//Freeze it
			local Phys = ent:GetPhysicsObject()
			if Phys:IsValid() then
				Phys:EnableMotion ( false ) 
			end
			
			--//Take ammo and set cooldown
			self:TakePrimaryAmmo(1)
			self:SetNextPrimaryFire ( CurTime() + 1 )
		end
	end
end

local sIndex = 1
function SWEP:SecondaryAttack()

if self:CanSecondaryAttack() then
		if not ValidEntity ( self.Owner ) then return end
	
		//Grab position
		local aimvec = self.Owner:GetAimVector()
		local shootpos = self.Owner:GetShootPos()
		
		//Heavy shit
		local Index = self.Weapon:GetNetworkedInt ( "ModelToSpawn" )
		local Max, Min = self.ModelOBB[Index].Max, self.ModelOBB[Index].Min
		local Offset = math.abs ( Max.z )
		if math.Round ( math.abs ( Min.z ) ) != math.Round ( math.abs( Max.z ) ) then
			Offset = 2
		end
		
		//Trace the shit
		--local tr = util.TraceLine( { start = shootpos, endpos = shootpos + aimvec * 250, filter = self.Owner , mask = MASK_NPCWORLDSTATIC } )
		local tr = util.TraceLine( { start = shootpos, endpos = shootpos + aimvec * 80, filter = self.Owner , mask = MASK_NPCWORLDSTATIC } )
		local hTrace = util.TraceHull ( { start = tr.HitPos + Vector( 0,0, Offset ), endpos = tr.HitPos + Vector( 0,0, Offset ), filter = { self.Owner }, mins = Min, maxs = Max } )
		
		CanSpawn = false
		
		//Spawn conditions
	--	if hTrace.Entity == NULL or hTrace.Entity:IsWorld() then CanSpawn = true end	
		if hTrace.Entity:IsWorld() then CanSpawn = true else CanSpawn = false end	
		--if tr.HitPos.z < self.Owner:GetPos().z + 20 then CanSpawn = true else CanSpawn = false end
		if tr.HitPos.z < self.Owner:GetPos().z + 100 then CanSpawn = true else CanSpawn = false end

		if CanSpawn then
			--local ent = ents.Create ( "prop_physics_multiplayer" )
			local ent = ents.Create ( "aegis2" )
			local angles = self.Owner:GetAngles()
			ent:SetPos ( tr.HitPos + Vector ( 0,0, Offset ) )
			ent:EmitSound( "npc/dog/dog_servo12.wav" )
			ent:SetModel( self:GetModelToSpawn() )
			ent.IsBarricade = true
			ent:SetHealth ( 0 )
			ent:Spawn()
			
			//Freeze it
			local Phys = ent:GetPhysicsObject()
			if Phys:IsValid() then
				Phys:EnableMotion ( false ) 
			end
			
			--//Take ammo and set cooldown
			self:TakeSecondaryAmmo(1)
			self:SetNextSecondaryFire ( CurTime() + 1 )
		end
	end
	
end
--end

function SWEP:OnDrop()
if self and self:IsValid() then
		self:Remove()
	end
end


