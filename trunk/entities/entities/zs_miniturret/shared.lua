AddCSLuaFile()

if SERVER then	
	util.AddNetworkString( "SendMiniTurret" )
end

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.AutomaticFrameAdvance = true

ENT.MaxHealth = 60
ENT.MaxBullets = 150
ENT.RechargeDelay = 0.5
ENT.SpotDistance = 190
ENT.Damage = 4

local model = Model("models/Combine_Scanner.mdl")

local scaredsound = Sound("npc/scanner/cbot_servoscared.wav")
local readysound = Sound("npc/scanner/combat_scan5.wav")

local function TrueVisible(posa, posb, filter)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, player.GetAll())
	if filter then
		filt[#filt + 1] = filter
	end

	return not util.TraceLine({start = posa, endpos = posb, filter = filt, mask = MASK_SHOT}).Hit
end

if SERVER then

function ENT:Initialize()
	self:SetModel(model)
	
	self:PhysicsInit(SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	self:SetModelScale(0.3,0)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(2)
		phys:EnableGravity(false)
	end
	
	
	self.Loaded = true
	self.Emptied = false
	
	self.LastShootTime = 0
	
	
	if self:GetOwner():GetPerk("_turret") then --Combined the turret perks into one perk as requested by the community.
		self.MaxBullets = math.Round(self.MaxBullets*1.5)
		self.MaxHealth = math.Round(self.MaxHealth*1.5)
		self.Damage = math.Round(self.Damage*1.5)
	end
	
	--[[if self:GetOwner():GetPerk("_turretammo") then
		self.MaxBullets = math.Round(self.MaxBullets*1.5)
	end
	
	if self:GetOwner():GetPerk("_turrethp") then
		self.MaxHealth = math.Round(self.MaxHealth*1.5)
	end
	
	if self:GetOwner():GetPerk("_turretdmg") then
		self.Damage = math.Round(self.Damage*1.5)
	end]]--
	
	self:SetAmmo(self.MaxBullets)
	self:SetHealth(self.MaxHealth)
	self:SetMaxAmmo(self.MaxBullets)
	self:SetAttacking(false)
	
	self:EmitSound(readysound)
	
	timer.Simple(1,function()
		if self and IsValid(self:GetOwner()) then
			net.Start("SendMiniTurret")
				net.WriteEntity(self)
			net.Send(self:GetOwner())
		end
	end)
end


function ENT:Think()
	local ct = CurTime()
	local alert
	
	self:CheckOwner()
	
	self:CalculateMovement()

	self:SetPoseParameter("dynamo_wheel",math.NormalizeAngle(math.Approach(self:GetPoseParameter("dynamo_wheel"),RealTime(),2)))
	
	local target = self:GetTarget()
	if target:IsValid() then
		if self:IsValidTarget(target) then
			if ct > (self.NextAttackAction or 0) then
				if self:CanAttack() then
					self.NextShoot = self.NextShoot or ct + 0.18	
					if ct > self.NextShoot then
						self:Shoot()
						self.NextShoot = ct + 0.18	
					end
				else
					self:ClearTarget()
					self:SetAttacking(false)
					-- todo: add little sound there
				end
			end
		else
			self:ClearTarget()
			
			self:SetAttacking(false)
			
		end
	else
		local target = self:SearchForTarget()
		if target and self.Loaded then
			self:SetTarget(target)
			
			self.NextAttackSound = self.NextAttackSound or ct + 1
			self.NextAttackAction = ct + 0.35
			if ct > self.NextAttackSound then	
				self:EmitSound("NPC_FloorTurret.Activate")
				self.NextAttackSound = ct + 1
			end
			
			self:SetAttacking(true)
			
		else
			self:RechargeAmmo(1,self.RechargeDelay)	
		end
	end
	
	if self:IsAttacking() then
		alert = 1
	else
		if self.Emptied then
			alert = -1
		else
			alert = math.Clamp(math.sin( RealTime()*1.3)*0.1,-0.4,0.4)
		end
	end
	
	self:SetPoseParameter("alert_control",math.Approach(self:GetPoseParameter("alert_control"),alert,FrameTime()))
	
	self:NextThink(CurTime())
	return true
	
end

local ShadowParams = {secondstoarrive = 0.001, maxangular = 1000, maxangulardamp = 10000, maxspeed = 800, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 300}

function ENT:CalculateMovement()
	local ct = CurTime()
	
	local frametime = ct - (self.LastThink or ct)
	self.LastThink = ct
		
	local owner = self:GetOwner()
	
	if not IsValid(owner) then return end
	
	local pos = owner:GetPos()+(owner:Crouching() and vector_up*45 or vector_up*65)+(owner:GetAimVector():Angle()):Right()*7+(owner:GetAimVector():Angle()):Forward()*4
		
	local phys = self:GetPhysicsObject()		
	phys:Wake()
		
	-- if not self.ObjectPosition or not self.EntOwner:KeyDown(IN_SPEED) then
		local obbcenter = self:OBBCenter()
		local objectpos = pos-- shootpos + owner:GetAimVector() * 70
		objectpos = objectpos - obbcenter.z * self:GetUp()
		objectpos = objectpos - obbcenter.y * self:GetRight()
		objectpos = objectpos - obbcenter.x * self:GetForward()
		self.ObjectPosition = objectpos
		
		local target = self:GetTarget()
		if target:IsValid() and self:IsValidTarget(target) then
			self.ObjectAngles = (self:GetTargetPos(target) - self:GetPos()):GetNormalized():Angle()
		else
			local check = owner:GetEyeTrace().Entity and owner:GetEyeTrace().Entity:IsPlayer() and owner:GetEyeTrace().Entity:IsZombie()
			self.ObjectAngles = check and (owner:GetEyeTrace().HitPos - self:GetPos()):GetNormalized():Angle() or owner:GetAimVector():Angle()
		end
	-- end

	ShadowParams.pos = self.ObjectPosition
	ShadowParams.angle = self.ObjectAngles
	ShadowParams.deltatime = frametime
	phys:ComputeShadowControl(ShadowParams)
	
end

function ENT:CheckOwner()
	local Owner = self:GetOwner()
	if not IsValid ( Owner ) or not Owner:Alive() or Owner:Team() == TEAM_UNDEAD then 
		self:Explode()
		return
	end
end

function ENT:IsValidTarget(target)
	return target:IsPlayer() and target:Team() == TEAM_UNDEAD and target:Alive() and not target:IsWraith() and TrueVisible(self:GetPos(), self:GetTargetPos(target), self)
end

local tabSearch = {mask = MASK_SHOT}
function ENT:SearchForTarget()
	local shootpos = self:GetPos()

	tabSearch.start = shootpos
	tabSearch.endpos = shootpos + self:GetAngles():Forward() * self.SpotDistance
	tabSearch.filter = {self,self:GetOwner()}
	local tr = util.TraceLine(tabSearch)
	local ent = tr.Entity
	if ent and ent:IsValid() and self:IsValidTarget(ent) then
		return ent
	end
end

local TURRETOWNER
local TURRET

local damageisfalse = {damage = false, effect = true}

local tempknockback
function ENT:StartBulletKnockback()
	tempknockback = {}
end

function ENT:EndBulletKnockback()
	tempknockback = nil
end

function ENT:DoBulletKnockback()
	for ent, prevvel in pairs(tempknockback) do
		local curvel = ent:GetVelocity()
		ent:SetVelocity(curvel * -1 + (curvel - prevvel) * 0.005 + prevvel)
	end
end

function GenericBulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		if ent:IsPlayer() then
			if ent:Team() == TEAM_UNDEAD and tempknockback then
				tempknockback[ent] = ent:GetVelocity()
			end
		else
			local phys = ent:GetPhysicsObject()
			if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
				ent:SetPhysicsAttacker(attacker)
			end
		end
	end
end

local function BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() then
		ent:TakeSpecialDamage(dmginfo:GetDamage(), dmginfo:GetDamageType(), TURRETOWNER, TURRET, tr.HitPos)

		local phys = ent:GetPhysicsObject()
		if ent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
			ent:SetPhysicsAttacker(attacker)
		end
	end

	return damageisfalse
end

function ENT:Shoot()
	local owner = self:GetOwner()
	
	TURRETOWNER = owner
	TURRET = self
	
	TURRET.IsTurretDmg = true
	
	local bullet = {}
	bullet.Num = 1
	bullet.Src = self:GetPos()
	bullet.Dir = self:GetAngles():Forward()
	bullet.Spread = Vector(0.1, 0.1, 0.1)  
	bullet.Tracer = 6
	bullet.Force = 1
	bullet.Damage = 4
	bullet.TracerName = "Tracer"
	bullet.Callback = BulletCallback
	
	self:FireBullets(bullet)
	
	self:TakeAmmo(1)
	
	self.LastShootTime = CurTime() + 3
	
	self:EmitSound("NPC_FloorTurret.ShotSounds")
	
	if self:GetAmmo() < 1 and not self.Emptied then
		self.Emptied = true
		self.Loaded = false
		self:EmitSound(scaredsound)
	end
	
	local ed = EffectData()
	ed:SetOrigin(self:GetAttachment(1).Pos)
	ed:SetAngles(self:GetAngles())
	ed:SetScale(0.3)
	util.Effect("MuzzleEffect", ed)
end

function ENT:TakeAmmo(amount)
	self:SetAmmo(math.Clamp(self:GetAmmo() - amount,0,self.MaxBullets))
end

function ENT:AddAmmo(amount)
	self:SetAmmo(math.Clamp(self:GetAmmo() + amount,0,self.MaxBullets))
end

function ENT:RechargeAmmo(amount,delay)
	local ct = CurTime()

	if self:GetAmmo() == self.MaxBullets then
		return
	end
	
	--Only allow reload when clip is empty
	--[[if not self.Emptied then
		return
	end]]

	if self.LastShootTime > ct then
		return
	end

	self.NextRegenTime = self.NextRegenTime or ct + delay
	
	if ct < self.NextRegenTime then
		return
	end

	self:AddAmmo(amount)
	self.NextRegenTime = ct + delay

	if self:GetAmmo() == self.MaxBullets and not self.Loaded then
		self.Loaded = true
		self.Emptied = false
		self:EmitSound(readysound)
	end
end

function ENT:CanAttack()
	return self:GetAmmo() > 0 and self.Loaded
end

function ENT:OnTakeDamage( dmginfo )
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsZombie() then
	--if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsUNDEAD() then
		
		local dmg = dmginfo:GetDamage()
		
		if IsValid(self:GetOwner()) and self:GetOwner():GetSuit() == "techsuit" then
			dmg = dmg*1.5
		end
		
		self:SetHealth(self:GetHealth() - dmg)
		self:EmitSound(Sound("npc/scanner/scanner_pain"..math.random(1,2)..".wav"))
	
		if self:GetHealth() <=0 then
			self:Explode()
		end
	end
end

function ENT:Explode()
	local trace = {}
	trace.start = self:GetPos() + Vector(0,0,5)
	trace.filter = self.Entity
	trace.endpos = trace.start - Vector(0,0,50)
	local traceground = util.TraceLine(trace)
	
	util.Decal("Scorch",traceground.HitPos - traceground.HitNormal,traceground.HitPos + traceground.HitNormal)

	local Effect = EffectData()
	Effect:SetOrigin( self:GetPos() )
	Effect:SetStart( self:GetPos() )
	Effect:SetMagnitude( 300 )
	util.Effect("Explosion", Effect)

	self.Entity:Remove()
end

end

function ENT:SetTarget(ent)
	self:SetDTEntity(0,ent)
end

function ENT:ClearTarget()
	self:SetDTEntity(0,nil)
end

function ENT:GetTarget()
	return self:GetDTEntity(0)
end

function ENT:SetAttacking(bl)
	self:SetDTBool(0,bl)
end

function ENT:IsAttacking()
	return self:GetDTBool(0)
end

function ENT:SetAmmo(am)
	self:SetDTInt(0,am)
end

function ENT:SetHealth(am)
	self:SetDTInt(1,am)
end

function ENT:SetMaxAmmo(am)
	self:SetDTInt(2,am)
end

function ENT:GetAmmo()
	return self:GetDTInt(0)
end

function ENT:GetMaxAmmo()
	return self:GetDTInt(2)
end

function ENT:GetHealth()
	return self:GetDTInt(1)
end

function ENT:GetTargetPos(target)
	local boneid = target:GetHitBoxBone(HITGROUP_HEAD, 0)
	if boneid and boneid > 0 then
		local p, a = target:GetBonePosition(boneid)
		if p then
			return p
		end
	end

	return target:LocalToWorld(target:OBBCenter())
end

if CLIENT then
	local matLight = Material( "models/roller/rollermine_glow" )
	function ENT:Draw()
		self.Entity:SetRenderBounds( self:OBBMaxs()*2, self:OBBMins()*2) 
		
		self:DrawModel()
		
		--[[local att = self:GetAttachment(self:LookupAttachment("eyes"))
		
		local Normal = ((att.Pos + att.Ang:Forward()*10)-att.Pos):GetNormal() * 0.1
		local size = math.Rand( 2, 4 )
		
		render.SetMaterial( matLight )
		render.DrawQuadEasy( att.Pos, Normal, size, size, Color( 255, 55, 55, 255 ), 0 )]]
	end

	net.Receive("SendMiniTurret", function( len )
		if not IsValid(MySelf) then
			return
		end
		
		local t = net.ReadEntity()	
		MySelf.MiniTurret = t or nil
	end)
end