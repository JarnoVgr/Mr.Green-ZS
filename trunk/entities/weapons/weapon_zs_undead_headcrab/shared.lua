-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Author = "Deluvas"
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


function SWEP:Deploy()
	if SERVER then 
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:Think()
	if self.Leaping then
		local owner = self.Owner
		if owner:OnGround() or 0 < owner:WaterLevel() then
			self.Leaping = false
			self.Owner.Humping = false
			self.NextLeap = CurTime() + 0.75
		else
			local vStart = self.OwnerOffset + owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self.OwnerAngles
			tr.filter = owner
			local trace = util.TraceLine(tr)
			local ent = trace.Entity

			if IsValid(ent) then
				if SERVER then
					if ent:GetClass() == "func_breakable_surf" then
						ent:Fire("break", "", 0)
					else
						local damage = math.random(10,13)
						local phys = ent:GetPhysicsObject()

						if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
							local vel = damage * 600 * owner:GetAimVector()

							phys:ApplyForceOffset(vel, (ent:NearestPoint(owner:GetShootPos()) + ent:GetPos() * 2) / 3)
							ent:SetPhysicsAttacker(owner)
						end
						ent:TakeDamage( damage, owner, self )
					end
					owner:SetLocalVelocity( Vector(0,0,0) )
				end
					
				self.Leaping = false
				self.Owner.Humping = false
				self.NextLeap = CurTime() + 1
				if SERVER then owner:EmitSound("npc/headcrab/headbite.wav") owner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30))) end
			elseif trace.HitWorld then
				if SERVER then owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav") end
				self.Leaping = false
				self.Owner.Humping = false
				self.NextLeap = CurTime() + 1
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

SWEP.NextLeap = 0
function SWEP:PrimaryAttack()
	if self.Leaping or CurTime() < self.NextLeap or not self.Owner:OnGround() then return end

	local vel = self.Owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel = vel:GetNormal()

	local angles = self.Owner:GetAngles():Forward()
	angles.z = -0.1
	angles = angles:GetNormal()
	
	self.OwnerAngles = angles * 52
	self.OwnerOffset = Vector(0, 0, 6)
	self.Owner:SetGroundEntity(NULL)
	self.Owner:SetLocalVelocity(vel * 450)
	if SERVER then self.Owner:EmitSound("npc/headcrab/attack"..math.random(1,3)..".wav") end
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self.Leaping = true
	self.Owner.Humping = true
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end

	if SERVER then self.Owner:EmitSound("npc/headcrab/idle"..math.random(1,3)..".wav") end
	self.NextYell = CurTime() + 2
end

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