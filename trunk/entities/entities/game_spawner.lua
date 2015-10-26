AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "NECROSSIN"
ENT.Purpose			= ""
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

util.PrecacheSound("items/ammo_pickup.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Placer")
	self:NetworkVar("Bool", 0, "Claimed")
end

util.PrecacheModel("models/props_c17/gravestone002a.mdl")
function ENT:Initialize()
	if SERVER then	
		self:DrawShadow(false)
		self.Entity:SetPos(self.Entity:GetPos() + Vector(0,0,22))
		--self:SetModelScale(0.3,0)
		self.Entity:SetMaterial("models/flesh")
		self.Entity:SetModel("models/props_c17/gravestone002a.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		local phys = self.Entity:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:EnableMotion(false) 
		end
	
		self.CrateHealth = 60
	end

	--Unclaimed by default
	self:SetClaimed(false)

	if CLIENT then
		hook.Add("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self), function()
			if not util.tobool(GetConVarNumber("zs_drawcrateoutline")) then
				return
			end
			
			if not IsValid(MySelf) or MySelf:Team() ~= TEAM_ZOMBIE then
				return
			end
			
			halo.Add({self}, self.LineColor, 2, 2, 2, true, false)
		end)
	end
end

function ENT:Think()
	if SERVER then
		if math.random(1,3) == 1 then 
			util.Blood(self.Entity:GetPos(), math.Rand(1, 2), (self.Entity:GetPos() - (self.Entity:GetPos() - Vector(0,0,32))):GetNormal() , math.Rand(1, 2), true)
		end
	end
	self:NextThink(CurTime() + 2)	
end

if SERVER then
	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsHuman() or dmginfo:GetAttacker() == self:GetPlacer() then
			self.CrateHealth = self.CrateHealth - dmginfo:GetDamage()
			util.Blood(self.Entity:GetPos(), math.Rand(2, 4), (self.Entity:GetPos() - (self.Entity:GetPos() - Vector(0,0,32))):GetNormal() , math.Rand(2, 4), true)			
			if self.CrateHealth <= 0 then
				self:Explode()	

				if dmginfo:GetAttacker():IsHuman() then			
					skillpoints.AddSkillPoints(dmginfo:GetAttacker(), 10)
					dmginfo:GetAttacker():AddXP(50)			
					self:FloatingTextEffect(10, dmginfo:GetAttacker())		
				end			
			end
		end
	end

	function ENT:Explode()
	
		self:GetPlacer().HasBloodSpawner = false
		
		for k,v in ipairs(team.GetPlayers(TEAM_UNDEAD)) do
			v:Message("A blood spawner has been destroyed!", 1)
		end	
	
		local trace = {}
		trace.start = self:GetPos() + Vector(0,0,5)
		trace.filter = self.Entity
		trace.endpos = trace.start - Vector(0,0,50)
		local traceground = util.TraceLine(trace)
		
		util.Decal("Scorch",traceground.HitPos - traceground.HitNormal,traceground.HitPos + traceground.HitNormal)
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
	ENT.LineColor = Color(210, 0, 0, 100)
	function ENT:Draw()
	    self:DrawModel()

		self:SetModelScale(math.Clamp((math.sin(CurTime() * 2) * 0.5) + 0.4,0.8,1.2),0)	
		
	    if not IsValid(MySelf) or MySelf:Team() ~= TEAM_ZOMBIE then
	        return
		end

	    self.LineColor = Color(math.abs(200 * math.sin(CurTime() * 3)), 0, 0, 100)

	    --Draw some stuff
	    local pos = self:GetPos() + Vector(0,0,30)

	    --Check for distance with local player
	    if pos:Distance(MySelf:GetPos()) > 128 then
	        return
	    end
	          
	    local angle = (MySelf:GetPos() - pos):Angle()
	    angle.p = 0
	    angle.y = angle.y + 90
	    angle.r = angle.r + 90

	    cam.Start3D2D(pos,angle,0.26)

		local owner = self:GetPlacer()
		local validOwner = (IsValid(owner) and owner:Team() == TEAM_UNDEAD)
	
		if validOwner then
			draw.SimpleTextOutlined( owner:Name() .."'s Blood Spawner", "ssNewAmmoFont4", 0, 0, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,200))
		end
				
	    cam.End3D2D()
	end

	function ENT:OnRemove()
	    hook.Remove("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self))
	end
end

--[[function ENT:ShouldCollide(Ent)
	if Ent:IsPlayer() then
		if Ent:GetPos():Distance(self:GetPos()) <= 30 then
			local dir = (Ent:GetPos() - self:GetPos()):GetNormal()

			--Push
			if Ent:GetVelocity():Length() > 0 then
				Ent:SetVelocity(dir * 66)  
			end
		end

		return false
	end
end]]