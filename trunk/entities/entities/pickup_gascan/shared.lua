ENT.Type = "anim"
ENT.Base = "pickup__base"

util.PrecacheModel("models/props_junk/metalgascan.mdl")

if SERVER then
AddCSLuaFile("shared.lua")

function ENT:Initialize()
	
	self.Entity:SetModel("models/props_junk/metalgascan.mdl")//
	self.Entity:SetColor(Color(255,0,0,255))
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS )
	self.Entity:SetSolid(SOLID_VPHYSICS)
	--self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	--self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
	local phys = self.Entity:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:Wake()
		--phys:SetMass(30)
		--phys:EnableMotion( true ) 
	end


	
	self.Entity:_SetHealth(90)
	
	self.AllowDamage = true
	
end

function ENT:OnZeroHealth(dmginfo)
	
	if self.Exploded then return end
	self.Exploded = true
	
	local attacker = dmginfo:GetAttacker()
	local tm = nil
	
	if attacker and attacker.Team then
		tm = attacker:Team()
	end
	
	local Ent = ents.Create("env_explosion")
	Ent:EmitSound( "explode_4" )		
	Ent:SetPos( self.Entity:GetPos() + Vector(0,0,3) )
	Ent:Spawn()
	if tm then
		Ent.Team = function()
			return tm
		end
	end
	Ent:SetOwner( self:GetOwner() )
	Ent:Activate()
	Ent:SetKeyValue( "iMagnitude", 200 )
	Ent:SetKeyValue( "iRadiusOverride", 140 )
	Ent:Fire("explode", "", 0)
	
	local shake = ents.Create( "env_shake" )
	shake:SetPos( self.Entity:GetPos() )
	shake:SetKeyValue( "amplitude", "800" )
	shake:SetKeyValue( "radius", "300" )
	shake:SetKeyValue( "duration", "3" )
	shake:SetKeyValue( "frequency", "128" )
	shake:SetKeyValue( "spawnflags", "4" )
	shake:Spawn()
	shake:SetOwner( self:GetOwner() )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	//timer.Simple(0,function ()
		//if not ValidEntity(self.Entity) then return end
		self.Entity:Remove() //end)

	
end

function ENT:SetUse()
	if self.Activator.CurrentWeapons["Misc"] < 1 then
		self.Activator:Give("weapon_zs_pickup_gascan2")
		self:Remove()
	end
end



end

