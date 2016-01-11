AddCSLuaFile()
ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Pufulet"
ENT.Purpose			= ""
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


util.PrecacheModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
util.PrecacheModel("models/props_wasteland/rockcliff_cluster02a.mdl")

function ENT:Initialize()
	if SERVER then	
		self:DrawShadow(false)
		self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,8))
		self:SetModelScale(0.75,0)
		self.Entity:SetMaterial("models/flesh")
		self.Entity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		local phys = self.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(false) 
		end
		self.SpawnerHealth = 50
	end	
	
	self.Dormant = true		
	self.Placed = CurTime()	
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Placer")
end

 

function ENT:Think()
	self:NextThink(CurTime() + 1)	
	if (self.Dormant and self.Placed + 12 < CurTime()) then
		self.Dormant = false
		self.Entity:SetModel("models/props_wasteland/rockcliff_cluster02a.mdl")	
		util.Blood(self.Entity:GetPos(), math.Rand(10, 20), (self.Entity:GetPos() - (self.Entity:GetPos() + Vector(0,0,16))):GetNormal() , math.Rand(20, 30), true)
		self:SetModelScale(0.2)
		self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,18))		
		self.Entity:SetMaterial("models/flesh")
		self.Entity:SetPos(self.Entity:GetPos())	
		self.SpawnerHealth = 120
		for k,v in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
			v:Message("A spawner has been created.", 2)
		end				
	end
end

if SERVER then
	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsHuman() or dmginfo:GetAttacker() == self:GetPlacer() then
			self.SpawnerHealth = self.SpawnerHealth - dmginfo:GetDamage()
			util.Blood(self.Entity:GetPos(), math.Rand(2, 4), (self.Entity:GetPos() - (self.Entity:GetPos() - Vector(0,0,32))):GetNormal() , math.Rand(1, 2), true)			
			if self.SpawnerHealth <= 0 then
				self:Explode()	

				for k,v in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
					v:Message("A spawner has been destroyed!", 1)
				end					
			end
		end
	end

	function ENT:Explode()
		self:GetPlacer().HasBloodSpawner = false
		local trace = {}
		trace.start = self:GetPos() + Vector(0,0,5)
		trace.filter = self.Entity
		trace.endpos = trace.start - Vector(0,0,50)
		local traceground = util.TraceLine(trace)
		
		util.Blood(self.Entity:GetPos(), math.Rand(10, 20), (self.Entity:GetPos() - (self.Entity:GetPos() - Vector(0,0,32))):GetNormal() , math.Rand(10, 20), true)
		
		local Effect = EffectData()
		Effect:SetOrigin(self:GetPos())
		Effect:SetStart(self:GetPos())
		Effect:SetMagnitude(300)
		util.Effect("Explosion", Effect)

		self.Entity:Remove()
	end
end
	
if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		if self.Dormant then
			self:SetModelScale(math.Clamp(math.abs( math.sin( CurTime() * 0.9 ) ),0.7,0.9),0)		
		else
			self:SetModelScale( math.Clamp(math.abs( math.sin( CurTime() * 0.5 ) ) * 0.1,0.10,0.11),0)		
		end
	end
end