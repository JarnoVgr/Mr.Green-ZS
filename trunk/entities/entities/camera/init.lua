-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

include ("shared.lua")
AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")


function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_FLY)-- MOVETYPE_FLY
	self.Entity:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	-- self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Entity:SetModel("models/items/ar2_grenade.mdl")
	self.Entity:SetBloodColor(BLOOD_COLOR_YELLOW)
	self:GetOwner().Crow = self.Entity
	self.Position = self.Entity:GetPos()
	--self.Entity:GetPhysicsObject():SetMass(50)
	local w = 20
	local l = 20
	local h = 15
--	self.Entity:PhysicsInitBox ( Vector (0 - (w/2), 0 - (l/2), 0 ), Vector (w/2,l/2,h) )
	self.Entity:SetCollisionBounds( Vector (0 - (w/2), 0 - (l/2), 0 ), Vector (w/2,l/2,h) ) 
	self.Entity:SetPos(GAMEMODE:PlayerSelectSpawn(self:GetOwner()):GetPos()+ Vector (0,0,50))
	-- self.Entity:SetPos(self:GetOwner():GetPos() + Vector (0,0,50))
	self.LastTick = 0
	self.CrowHealth = 50
	print("Spawned!")
end

function ENT:OnTakeDamage( dmginfo )
	if not IsValid (self.Entity) or not IsValid (self:GetOwner()) then return end
	--[=[local attacker = dmginfo:GetAttacker()
	local inflictor
	local ent = self:GetOwner()
	
	if IsValid (dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() then
		attacker = dmginfo:GetAttacker()
		inflictor = attacker:GetActiveWeapon()
		if attacker:Team() == TEAM_UNDEAD then
			return 
		end
	else
		inflictor = attacker
	end]=]
	if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsHuman() then
	print("Health: "..self.CrowHealth)
	self.CrowHealth = self.CrowHealth - dmginfo:GetDamage()
	print("Health "..self.CrowHealth.." after: "..dmginfo:GetDamage().." dmg")
	self:EmitSound("npc/crow/pain"..math.random(1,2)..".wav")
	
		if self.CrowHealth <= 0 then
			self.Entity:Remove()
		end
	end
	-- Assist for crows, are you joking :o ?
	-- AssistAdd (ent, attacker, inflictor, dmginfo:GetDamage() , dmginfo)
	
	-- self.Owner:SetHealth(self.Owner:Health() - dmginfo:GetDamage())
	-- if self.Owner:Health() <= 0 then
	-- 	gamemode.Call ("DoPlayerDeath", self.Owner, attacker, dmginfo)
	-- 	ent:KillSilent()
	-- end
end

function ENT:Think()
	if not IsValid(self:GetOwner()) or self:GetOwner():Alive() then 		
		-- Unspectate him first then remove the crow.
		if self:GetOwner() and self:GetOwner():IsValid() then
			self:GetOwner():UnSpectate()
		end
		
		self.Entity:Remove() return 
	end
	
	-- Shoudn't OBS CHASE MOD do this?
	self:GetOwner():SetPos( self.Entity:GetPos() )
	self:Tick()
end

function ENT:OnRemove()
self:GetOwner().Crow = nil
self:EmitSound("npc/crow/die"..math.random(1,2)..".wav")
print("Ded!")
end

ENT.SecondaryAttackDelay = 0
function ENT:SecondaryAttack()
	if not IsValid (self:GetOwner()) then return end

	local pl = self:GetOwner()
	if self.SecondaryAttackDelay <= CurTime() then
		local ent = ents.Create("crow_spit")
		self.Entity:EmitSound (self.SecondaryAttackSounds [math.random(1,#self.SecondaryAttackSounds)])
		if ent:IsValid() then
			ent:SetOwner(pl)
			ent:SetPos(pl:GetPos())-- + pl:GetAimVector() * 40)
			ent:Spawn()
		end
		self.SecondaryAttackDelay = CurTime() + 1.9
	end
end

function ENT:SpawnMechanism()
	if ENDROUND then return end
	
	local owner = self.Entity:GetOwner()
	if owner.DeathClass then
		owner:SetZombieClass(owner.DeathClass)
		-- owner.DeathClass = nil
	else
		owner:SetZombieClass (1)
	end
	
	local pos = owner:GetPos()
	local ang = owner:EyeAngles()
	-- owner:StripWeapon("weapon_zs_crow")
	--owner:DropWeapon (owner:GetWeapon("weapon_zs_crow"))
	-- owner.MutatedSpawn = true
	-- owner:Spawn()
	-- owner:UnSpectate()
	-- owner:SetPos(pos)
	-- owner:SetEyeAngles (ang)
	-- function self:Think() end
	-- self:Remove()
end
	 
function ENT:Tick()
	if not IsValid (self:GetOwner()) then return end
	
	self.Entity:NextThink(CurTime())
	-- self:FrameAdvance( CurTime() - self.LastTick )+0.001
	-- self.LastTick = CurTime()
	
	local owner = self:GetOwner()
	if owner and owner:IsValid() and owner:IsPlayer() then
		local pl = owner
		
		--pl:SetPos(self.Entity:GetPos())
		local speed = {SideSpeed = 150,ForwardSpeed = 350,BackSpeed = -150,UpSpeed = 250,DownSpeed = - 150}
		local walkspeed = 12
		local runspeed = 100
		local eyeangles = pl:EyeAngles()	
		self.Entity:SetAngles(Angle (0,eyeangles.y,0))
		local vel = Vector(0,0,0)
		local nokey = true
		
		local dist = 16
		local tr = util.TraceLine{start = self.Entity:GetPos(),endpos = self.Entity:GetPos() - Vector(0,0,dist),filter = self.Entity}
		tr.dist = tr.Fraction*dist
		
		if pl:KeyDown(IN_JUMP) then
			nokey = false
			vel = vel + Vector(0,0,1)*speed.UpSpeed
			self.lastjump = true
			if self.Entity:GetVelocity() == Vector (0,0,0) and tr.Hit then
				self:UnStuck()
			end
		else
			self.lastjump = false
		end
		
		if pl:KeyDown(IN_DUCK) then
			nokey = false
			vel = vel + Vector(0,0,1)*speed.DownSpeed
			self.lastjump = true
			-- if self.Entity:GetVelocity() == Vector (0,0,0) then
				-- pl:Message ("If you are stuck, type !crowstuck",1,"white")
			-- end
		else
			self.lastjump = false
		end
							   
		if pl:KeyDown(IN_FORWARD) then
			nokey = false
			self.Entity:SetAngles(Angle (eyeangles.p,eyeangles.y,eyeangles.r))
		end
		
		-- if pl:KeyDown(IN_BACK) then
			-- move = true
			-- neg = -1
			-- yaw = pl:EyeAngles().y+180
		-- end
		-- if move then
			-- local dir = tr.HitNormal:Angle()
			-- local avel = dir:Right():Angle()
			-- local rot = yaw-avel.y
			-- avel:RotateAroundAxis(dir:Forward(),rot)
			-- vel = vel + avel:Forward() * (pl:KeyDown(IN_SPEED) and walkspeed or runspeed)
		-- end
		if not tr.Hit then
			if pl:KeyDown(IN_ATTACK2) then
				self:SecondaryAttack()
			end
		end
							   
		if (nokey or tr.Hit) and not pl:KeyDown(IN_JUMP) then 
			vel = -1*self.Entity:GetVelocity()
			if tr.Hit then -- ON THE GROUND
				self.Entity:GetOwner().CanTransform = true
				local move = false
				local yaw = nil
				local neg = 1
				if pl:KeyDown(IN_FORWARD) then
				
					move = true
					yaw = pl:EyeAngles().y
				elseif pl:KeyDown(IN_BACK) then
					move = true
					neg = -1
					yaw = pl:EyeAngles().y+180
				end
				if pl:KeyDown(IN_MOVERIGHT) then
					move = true
					if yaw then
						yaw = yaw-45*neg
					else
						yaw = pl:EyeAngles().y-90
					end
				end
				if pl:KeyDown(IN_MOVELEFT) then
					move = true
					if yaw then
						yaw = yaw+45*neg
					else
						yaw = pl:EyeAngles().y+90
					end
				end
			
				if dist > 12 or dist < 4 then
					self.Entity:SetPos(tr.HitPos+Vector(0,0,8))
				end
												   
				if move then
					local dir = tr.HitNormal:Angle()
					local avel = dir:Right():Angle()
					local rot = yaw-avel.y
					avel:RotateAroundAxis(dir:Forward(),rot)
					vel = vel + avel:Forward() * (pl:KeyDown(IN_SPEED) and walkspeed or runspeed)
				end
			end
		else 
			self.Entity:GetOwner().CanTransform = false
			if pl:KeyDown(IN_FORWARD) then
				vel = vel + pl:EyeAngles():Forward() * speed.ForwardSpeed
			end
			--self.Entity:SetAngles(pl:EyeAngles())
			vel = vel - self.Entity:GetVelocity()
		end
		self.Entity:SetVelocity(vel)
	end
	self.Position = self.Entity:GetPos()
end

function ENT:UnStuck ()
	local pl = self:GetOwner()
	if self.Entity:GetVelocity() == Vector (0,0,0) and self.Position == self.Entity:GetPos() then
		local newpos = playerSend( self:GetOwner(),self:GetOwner(),self:GetOwner():GetMoveType() == MOVETYPE_NOCLIP )
		local newcrowpos = self.Entity:GetPos() + Vector (0,50,0)
				
		if not NewPositionTable then
			NewPositionTable = { Vector (0,0,20),Vector (20,0,0), Vector (0,20,0), Vector (40,0,0), Vector (0,40,0),Vector (0,-20,0),Vector (-20,0,0),Vector (0,0,-20) }
		end
				
		for i=1,#NewPositionTable do
			if not newpos then
				if pl:IsStuck ( self.Entity:GetPos() + NewPositionTable[i], true ) == false then
					newpos = self.Entity:GetPos() + NewPositionTable[i]
					break
				end
			end
		end
				
		if not newpos then
			newpos = self.Entity:GetPos()
		end
				
		local newang = (pl:GetPos() - newpos):Angle()
		self.Entity:SetPos( newpos )
		pl:SetEyeAngles( newang )
		pl:SetLocalVelocity( Vector( 0, 0, 0 ) ) -- Stop!
	end
end

--[=[ function ENT:UpdateTransmitState ()
	return TRANSMIT_ALWAYS
end ]=]