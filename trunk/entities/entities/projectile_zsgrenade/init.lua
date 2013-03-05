AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + 2.5

	self:SetModel("models/weapons/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(4)
		phys:SetMaterial("metal")
	end
end

util.PrecacheSound("physics/metal/metal_grenade_impact_hard1.wav")
util.PrecacheSound("physics/metal/metal_grenade_impact_hard2.wav")
util.PrecacheSound("physics/metal/metal_grenade_impact_hard3.wav")
function ENT:PhysicsCollide(data, phys)
	if 20 < data.Speed and 0.25 < data.DeltaTime then
		self:EmitSound("physics/metal/metal_grenade_impact_hard"..math.random(1,3)..".wav")
	end
end

function ENT:Think()

	if self.DieTime < CurTime() then
		self:Explode()
	end
	
		-- In case the owner dies
	local Owner = self:GetOwner()
	if not IsValid ( Owner ) or not Owner:Alive() or Owner:Team() == TEAM_UNDEAD then 
		local Effect = EffectData()
			Effect:SetOrigin( self:GetPos() )
			Effect:SetStart( self:GetPos() )
			Effect:SetMagnitude( 300 )
		util.Effect("Explosion", Effect)
		
		-- Remove it
		self.Entity:Remove()
	end
end

function ENT:Explode()
	if not ValidEntity(self.Entity) then return end
	
	local dmg, rad = 250,250
	
	if ValidEntity(self:GetOwner()) and self:GetOwner():GetSuit() == "assaultsuit" then
		dmg,rad = dmg*1.2, rad*1.2
	end
	
	local Ent = ents.Create("env_explosion")
	Ent:EmitSound( "explode_4" )		
	Ent:SetPos( self.Entity:GetPos() + Vector(0,0,3) )
	Ent:Spawn()
	Ent.Team = function() -- Correctly applies the whole 'no team damage' thing
		return TEAM_HUMAN
	end
	Ent.Inflictor = "weapon_zs_grenade"
	Ent.IsGrenadeDmg = true
	Ent:SetOwner( self:GetOwner() )
	Ent:Activate()
	Ent:SetKeyValue( "iMagnitude", dmg )
	Ent:SetKeyValue( "iRadiusOverride", rad )
	Ent:Fire("explode", "", 0)
	
	-- Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( self.Entity:GetPos() )
	shake:SetKeyValue( "amplitude", "800" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "300" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "3" )	-- Duration of shake
	shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:SetOwner( self:GetOwner() )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	-- timer.Simple(0,function ()
		-- if not ValidEntity(self.Entity) then return end
		self.Entity:Remove() -- end)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
