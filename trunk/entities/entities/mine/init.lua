-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ActualMines = {}

function ENT:Initialize()
	self.Entity:SetModel("models/weapons/w_c4_planted.mdl") 
	
	--self.Entity:SetColor( 255 255 255 255 )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid (SOLID_NONE)
	self.Entity:DrawShadow(false)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Entity:SetTrigger(true)
	self.Entity.Frozen = true
	
	if self:GetOwner():GetPerk("_nitrate") then
		self.scan = 2
	end

	if self:GetOwner():GetPerk("_trap") then
		self.range = 70
	end
	
	if self:GetOwner().DataTable["ShopItems"][50] then
		self.Damage = self.Damage + (self.Damage * 0.1)		
	end
	
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion( false )
	
	table.insert(ActualMines,self)
end
--[[
function ENT:AcceptInput(name, activator, caller, arg)
	if name == "detonate" then
		self.Entity:EmitSound(self.WarningSound)
		timer.Simple( 0.5, function()
			self:Explode()
		end)
		function self.Think() end
		
		return true
	end
end
--]]
function ENT:Think()
	
	if not IsValid(self) then
		return
	end
	
	--if CurTime() < 1.5 then return end
		
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

	if self.Detonating then
		self:Explode()
		return
	end	
	
	for k,v in ipairs(team.GetPlayers(TEAM_ZOMBIE)) do
		local fDistance = v:GetPos():Distance( self:GetPos() )

		--Check for conditions
		if v:IsPlayer() and not v:IsHuman() and v:Alive() and not table.HasValue(self.IgnoreClasses, v:GetZombieClass()) and fDistance < self.range then		
		local vPos, vEnd = self:GetPos(), self:GetPos() + ( self:GetPos() * self.range )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = self, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not IsValid(Trace.Entity) or Trace.Entity ~= v then
			continue
		end		
			self.Entity:EmitSound(self.WarningSound)
			self.Detonating = true
			return
		end	

	end	
	
	self:NextThink(CurTime() + self.scan)
end

function ENT:Explode()
	-- BOOM!
	if not IsValid(self.Entity) then
		return
	end
	
	local Ent = ents.Create("env_explosion")
	Ent:EmitSound( "explode_" .. math.random(1,4))
	Ent:SetPos( self.Entity:GetPos() )
	Ent:Spawn()
	Ent.Team = function() -- Correctly applies the whole 'no team damage' thing
		return TEAM_HUMAN
	end
	Ent.Inflictor = "weapon_zs_mine"
	Ent:SetOwner( self:GetOwner() )
	Ent:Activate()
	
	
	
	if self:GetOwner():GetPerk("_engineer") then
		self.damage = self.damage + (self.damage*(2*self:GetOwner():GetRank())/100)
		self.radius = self.radius + (self.radius*(2*self:GetOwner():GetRank())/100)		
	end
	
	if self:GetOwner():GetPerk("_nitrate") then
		self.radius = self.radius + (self.radius*0.4)		
	end
	
	if self:GetOwner():GetPerk("_trap") then
		self.damage = self.damage + (self.damage*0.3)		
	end	
	
	Ent:SetKeyValue( "iMagnitude", self.damage ) --180 -- math.Clamp ( math.Round ( 250 * GetInfliction() ), 100, 350 )
	Ent:SetKeyValue( "iRadiusOverride", self.radius )-- math.Clamp ( math.Round ( 250 * GetInfliction() ), 150, 350 )
	Ent:Fire("explode", "", 0)
	
	--Shaken, not stirred
	local shake = ents.Create( "env_shake" )
	shake:SetPos( self.Entity:GetPos() )
	shake:SetKeyValue( "amplitude", "500" ) -- Power of the shake effect
	shake:SetKeyValue( "radius", "512" )	-- Radius of the shake effect
	shake:SetKeyValue( "duration", "4" )	-- Duration of shake
	--shake:SetKeyValue( "frequency", "128" )	-- Screenshake frequency
	shake:SetKeyValue( "frequency", "170" )	-- Screenshake frequency
	shake:SetKeyValue( "spawnflags", "4" )	-- Spawnflags( In Air )
	shake:Spawn()
	shake:SetOwner( self:GetOwner() )
	shake:Activate()
	shake:Fire( "StartShake", "", 0 )
	
	self:Remove()
end

function ENT:WallPlant(hitpos, forward)
	if (hitpos) then
		self.Entity:SetPos( hitpos + Vector(0,0,3) )
	end
    self.Entity:SetAngles( forward:Angle() + Angle( -90, 0, 180 ) )
end

function ENT:PhysicsCollide( data, phys ) 
	if ( not data.HitEntity:IsWorld() ) then
		return
	end
	phys:EnableMotion(false)
	self:WallPlant(nil, data.HitNormal:GetNormal() * -1)
end