-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

SWEP.Author = "NECROSSIN"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.ViewModel = Model ( "models/weapons/v_knife_t.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.PrintName = "Headcrab"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.DistanceCheck = 250

function SWEP:Initialize()
	if SERVER then
		
	end
end

function SWEP:Deploy()
	if SERVER then 
		self.Owner:DrawViewModel( false )
		self.Owner:DrawWorldModel( false )
		self.FlySound = CreateSound( self.Owner, "NPC_Crow.Flap" )
		self.Owner:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
	self.Owner.SkipCrow = true
end
SWEP.NextIdle = 0

function SWEP:Think()
local ct = CurTime()
if SERVER then
	if not self.Owner:IsCrow() then
		self.Owner:Kill()
	end
	
	if self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.Owner:SetMoveType(MOVETYPE_WALK)
	end

	local vel = Vector(0,0,0)
	local push = false
	local flying = false
	-- prevent one glitch
	local passenger = false
	-- small traces
	--[==[local tr = {}
	tr.start = self.Owner:GetPos()
	tr.endpos = self.Owner:GetPos()+Vector(0,0,45)
	tr.filter = self.Owner
	local tr1 = {}
	tr1.start = self.Owner:GetPos()+self.Owner:GetForward()*5
	tr1.endpos = self.Owner:GetPos()+Vector(0,0,45)
	tr1.filter = self.Owner
	local tr2 = {}
	tr2.start = self.Owner:GetPos()+self.Owner:GetForward()*-5
	tr2.endpos = self.Owner:GetPos()+Vector(0,0,45)
	tr2.filter = self.Owner
	local tr3 = {}
	tr3.start = self.Owner:GetPos()+self.Owner:GetRight()*-5
	tr3.endpos = self.Owner:GetPos()+Vector(0,0,45)
	tr3.filter = self.Owner
	local tr4 = {}
	tr4.start = self.Owner:GetPos()+self.Owner:GetRight()*5
	tr4.endpos = self.Owner:GetPos()+Vector(0,0,45)
	tr4.filter = self.Owner
	local trace = util.TraceLine(tr)
	local trace1 = util.TraceLine(tr1)
	local trace2 = util.TraceLine(tr2)
	local trace3 = util.TraceLine(tr3)
	
	local case = trace.Hit and trace.Entity and trace.Entity:IsPlayer()
	local case1 = trace1.Hit and trace1.Entity and trace1.Entity:IsPlayer()
	local case2 = trace2.Hit and trace2.Entity and trace2.Entity:IsPlayer()
	local case3 = trace3.Hit and trace3.Entity and trace3.Entity:IsPlayer()
		
	if case or case1 or case2 or case3 then
		passenger = true
	end]==]
	
	if self.NextIdle < ct then
		self.NextIdle = ct + math. random(3,8)
		self.Owner:EmitSound("npc/crow/idle"..math.random(1,4)..".wav")
	end
	
	if self.Owner:KeyDown(IN_SPEED) then
		GAMEMODE:SetPlayerSpeed( self.Owner,ZombieClasses[9].RunSpeed )
	else
		GAMEMODE:SetPlayerSpeed( self.Owner, ZombieClasses[9].Speed)
	end
	
	if self.Owner:OnGround() then
		if self.Owner:KeyDown(IN_JUMP) then
			if not passenger then
				self.Owner:SetLocalVelocity(Vector(0,0,190))
			end
		end
		self.FlySound:Stop()
		if flying then
			flying = false
		end
	else
		if not passenger then
			if not flying then
				flying = true
				self.FlySound:Play();
			end
			
			if self.Owner:KeyDown(IN_FORWARD) then
				vel = self.Owner:GetAimVector()*250
				push = true
			end
			if self.Owner:KeyDown(IN_JUMP) then
				vel.z = vel.z + 110
				push = true
				-- self.Owner:SetLocalVelocity(Vector(0,0,130))
			end
			if push then
				self.Owner:SetLocalVelocity(vel)
			end
		end
	end
end
	self:NextThink(ct)
	return true
end

SWEP.NextSound = 0
SWEP.Crow1 = {
"npc/crow/alert1.wav",
"npc/crow/crow2.wav",
"npc/crow/crow3.wav",
}
function SWEP:PrimaryAttack()

	if self.NextSound > CurTime() then return end
	self.NextSound = CurTime() + 2.4
	if SERVER then
		self.Owner:EmitSound(table.Random(self.Crow1))
	end
end

SWEP.NextSpit = 0
function SWEP:SecondaryAttack()
	if self.Owner:OnGround() then return end
	if self.NextSpit > CurTime() then return end
	self.NextSpit = CurTime() + 2.4
	if SERVER then
	local pl = self.Owner
		local ent = ents.Create("crow_spit")
		self.Owner:EmitSound ("npc/crow/alert"..math.random(2,3)..".wav")
		if ent:IsValid() then
			ent:SetOwner(pl)
			ent:SetPos(pl:GetPos())
			ent:Spawn()
		end
	end
end

function SWEP:OnRemove()
	if SERVER then
		if self.FlySound then
			self.FlySound:Stop()
		end
		if self.Owner and IsValid(self.Owner) then
			self.Owner:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		end
	end
return true
end

SWEP.Holster = SWEP.OnRemove

function SWEP:Reload()
	return false
end

if SERVER then
	function SWEP:OnDrop()
		if self and self:IsValid() then
			self:Remove()
		end
	end
end

if CLIENT then
	function SWEP:DrawHUD() GAMEMODE:DrawZombieCrosshair ( self.Owner, self.DistanceCheck ) end
end

util.PrecacheSound("npc/headcrab/attack1.wav")
util.PrecacheSound("npc/headcrab/attack2.wav")
util.PrecacheSound("npc/headcrab/attack3.wav")
util.PrecacheSound("npc/headcrab/headbite.wav")
util.PrecacheSound("npc/headcrab/idle"..math.random(1,2)..".wav")