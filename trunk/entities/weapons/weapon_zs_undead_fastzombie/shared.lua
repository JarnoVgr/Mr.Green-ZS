-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_generic"

SWEP.Author = "Ywa"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Fast Zombie"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.ViewModel = Model("models/Weapons/v_fza.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.9

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.SwapAnims = false

SWEP.DistanceCheck = 42
SWEP.MeleeReach = 42
SWEP.MeleeSize = 1.5
SWEP.MeleeDelay = 0

SWEP.Damage = 4
SWEP.LeapDamage = 2

SWEP.LeapPounceVelocity = 500
SWEP.LeapPounceReach = 32
SWEP.LeapPounceSize = 16

SWEP.AttackSounds = {}
SWEP.IdleSounds = {}

if CLIENT then
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end

local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	lerp = math.Approach(lerp, 0, FrameTime() * ((lerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * lerp)
	if lerp > 0 then
		pos = pos + -8 * lerp * ang:Up() + -12 * lerp * ang:Forward()
	end
	return pos, ang
end

function SWEP:OnRemove()
	if CLIENT then
		self:RemoveArms()
	end
end

function SWEP:OnInitialize()
	if CLIENT then
		self:MakeArms()
	end

	--Attack sounds
	for i = 1, 11 do
		table.insert(self.AttackSounds,Sound("mrgreen/undead/fastzombie/attack"..i..".wav"))
	end

	--Idle sounds
	for i = 1, 12 do
		table.insert(self.IdleSounds,Sound("mrgreen/undead/fastzombie/idle"..i..".wav"))
	end
end


function SWEP:Think()
	self.BaseClass.Think(self)

	--Leaping
	if self.Leaping then
		self.Owner:LagCompensation(true)

		local traces = self.Owner:PenetratingMeleeTrace(self.LeapPounceReach, self.LeapPounceSize, nil, self.Owner:LocalToWorld(self.Owner:OBBCenter()))

		local hit = false
		for _, trace in ipairs(traces) do
			if not trace.Hit then
				continue
			end

			hit = true

			if not trace.HitWorld then
				local ent = trace.Entity
				if not ent or not ent:IsValid() then
					continue
				end

				--Break glass
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire( "break", "", 0 )
					hit = true
				end

				--Check for valid phys object
				local phys = ent:GetPhysicsObject()
				if not phys:IsValid() or not phys:IsMoveable() or ent.Nails then
					continue
				end

				if ent:IsPlayer() or ent:IsNPC() then
					ent:SetVelocity(self.Owner:GetForward() * self.LeapPounceVelocity)
				else
					--Calculate velocity to push
					local Velocity = self.Owner:EyeAngles():Forward() * (self.LeapPounceVelocity * 3)
					Velocity.z = math.min(Velocity.z,1600)

					--Apply push
					phys:ApplyForceCenter(Velocity)
					ent:SetPhysicsAttacker(self.Owner)					
				end
				
				--Take damage
				ent:TakeDamage(self.LeapDamage, self.Owner, self)
			end
		end

		if hit then
			if self.Owner.ViewPunch then
				self.Owner:ViewPunch(Angle(math.random(0, 70), math.random(0, 70), math.random(0, 70)))
			end

			if SERVER then
				self.Owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				self.Owner:EmitSound("mrgreen/undead/fastzombie/pain1.wav")
			end
						
			--Stopped leaping
			self.Leaping = false
			
			--Stop, so we don't bounce around
			self.Owner:SetLocalVelocity(Vector(0, 0, 0))
			
			--Leap Cooldown
			self.NextLeap = CurTime() + 3
		end
		
		--Always update leap status
		if (self.Owner:OnGround() or self.Owner:WaterLevel() >= 2) then
			self.Leaping = false
		end

		self.Owner:LagCompensation(false)
	end

	--Stop attacking when not holding button anymore
	if not self.Owner:KeyDown(IN_ATTACK) and self.Swinging == true then
		self.Swinging = false
	end

	--Prevent overriding from baseclass
	self:NextThink(CurTime())
	return true
end

function SWEP:CheckRoar()
	local rend = self:GetRoarEndTime()
	if rend == 0 or CurTime() < rend then return end
	self:SetRoarEndTime(0)
	
	if SERVER then
		local pl = self.Owner
		GAMEMODE:SetPlayerSpeed ( pl, ZombieClasses[ pl:GetZombieClass() ].Speed )
		pl:SetJumpPower( ZombieClasses[ pl:GetZombieClass() ].JumpPower ) 
	end
	
end

function SWEP:Move(mv)
	if self and self.Owner and self.Owner:KeyDown(IN_ATTACK) then
		mv:SetMaxSpeed(self.Owner:GetMaxSpeed()*0.35)
		return true
	end
end

function SWEP:SetRoarEndTime(time)
	self:SetDTFloat(0,time)
end

function SWEP:GetRoarEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsRoar()
	return self:GetRoarEndTime() > 0
end

function SWEP:SetRoar(count)
	self:SetDTInt(0,count)
end

function SWEP:AddRoar(am)
	self:SetRoar(self:GetRoar()+am)
end

function SWEP:GetRoar()
	return self:GetDTInt(0)
end

SWEP.NextAttack = 0
function SWEP:PrimaryAttack()
	if self.Leaping then
		return
	end

	self.BaseClass.PrimaryAttack(self)
end

SWEP.NextLeap = 0
SWEP.NextClimb = 0
function SWEP:SecondaryAttack()
	if self.Swinging then
		return
	end

	local Owner = self.Owner
	
	-- See where the player is ( on ground or flying )
	local bOnGround, bCrouching = Owner:OnGround(), Owner:Crouching()
	
	-- Trace filtering climb factors
	local vStart, vAimVector = Owner:GetShootPos() - Vector ( 0,0,20 ), Owner:GetAimVector()
	local trClimb = util.TraceLine( { start = vStart, endpos = vStart + ( vAimVector * 35 ), filter = Owner } )
		
	if trClimb.HitWorld then
		return
	end
	
	--Leap cooldown / player flying
	if CurTime() < self.NextLeap or not bOnGround or self.Leaping then
		return
	end
	
	--Set flying velocity
	local Velocity = self.Owner:GetAngles():Forward() * 800
	if Velocity.z < 200 then
		Velocity.z = 200
	end
	
	--Apply velocity and set leap status to true
	Owner:SetGroundEntity(NULL)
	Owner:SetLocalVelocity(Velocity)
	
	--Start leap
	self.Leaping = true
	
	--Leap cooldown
	self.NextLeap = CurTime() + 1.5
	
	--Fast zombie scream
	if SERVER then
		Owner:EmitSound("mrgreen/undead/fastzombie/leap".. math.random(1,5) ..".wav")
	end
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

-- Shutup.
function SWEP:Precache()
	util.PrecacheSound("mrgreen/undead/fastzombie/leap1.wav")
	util.PrecacheSound("mrgreen/undead/fastzombie/leap2.wav")
	util.PrecacheSound("mrgreen/undead/fastzombie/leap3.wav")
	util.PrecacheSound("mrgreen/undead/fastzombie/leap4.wav")
	util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet1.wav")

	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[2].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[2].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
end


if CLIENT then
	function SWEP:OnViewModelDrawn()
		local vm = self.Owner:GetViewModel();
		if IsValid(self.Arms) and IsValid(vm) then
			
			if self.Arms:GetModel() ~= self.Owner:GetModel() then
				self.Arms:SetModel(self.Owner:GetModel())
			end
			
			if not self.Arms.GetPlayerColor then
				self.Arms.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end
			end
		
			render.SetBlend(1) 
				self.Arms:SetParent(vm)
				
				self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
				
				for b, tbl in pairs(PlayerModelBones) do
					if tbl.ScaleDown then
						local bone = self.Arms:LookupBone(b)
						if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
							self.Arms:ManipulateBoneScale( bone, Vector(0.00001, 0.00001, 0.00001) )
						end
					else
						if not tbl.Arm then
							local bone = self.Arms:LookupBone(b)
							if bone and self.Arms:GetManipulateBoneScale(bone) == Vector(1,1,1) then
								self.Arms:ManipulateBoneScale( bone, Vector(1.5, 1.5, 1.5) )
							end
						end
					end
				end
				
				self.Arms:SetRenderOrigin( vm:GetPos()-vm:GetAngles():Forward()*20-vm:GetAngles():Up()*60 )-- self.Arms[1]:SetRenderOrigin( EyePos() )
				self.Arms:SetRenderAngles( vm:GetAngles() )
				
				self.Arms:SetupBones()	
				self.Arms:DrawModel()
				
				self.Arms:SetRenderOrigin()
				self.Arms:SetRenderAngles()
				
			render.SetBlend(1)
		end	
	end

	function SWEP:MakeArms()
		self.Arms = ClientsideModel("models/player/group01/male_04.mdl", RENDER_GROUP_VIEW_MODEL_OPAQUE) 
		
		if (ValidEntity(self.Arms)) and (ValidEntity(self)) then 
			self.Arms:SetPos(self:GetPos())
			self.Arms:SetAngles(self:GetAngles())
			self.Arms:SetParent(self) 
			self.Arms:SetupBones()
			-- self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
			self.Arms:SetNoDraw(true) 
		else
			self.Arms = nil
		end	
	end

	function SWEP:RemoveArms()
		if (ValidEntity(self.Arms)) then
			self.Arms:Remove()
		end
		
		self.Arms = nil
	end
end

if CLIENT then
	function SWEP:DrawHUD()
		GAMEMODE:DrawZombieCrosshair(self.Owner, self.DistanceCheck)
	end
end