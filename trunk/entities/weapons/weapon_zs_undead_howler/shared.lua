-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile()

SWEP.Base = "weapon_zs_undead_generic"
SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.PrintName = "Howler"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false
end


SWEP.ViewModel = Model("models/Weapons/v_zombiearms.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.DistanceCheck = 400

SWEP.SwapAnims = false
SWEP.AttackAnimations = { "attackD", "attackE", "attackF" }

function SWEP:Precache()
	self.BaseClass.Precache(self)

	util.PrecacheSound("ambient/energy/zap6.wav")
	util.PrecacheSound("npc/barnacle/barnacle_bark1.wav")

	-- Quick way to precache all sounds
	for _, snd in pairs(ZombieClasses[5].PainSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].DeathSounds) do
		util.PrecacheSound(snd)
	end
	
	for _, snd in pairs(ZombieClasses[5].AttackSounds) do
		util.PrecacheSound(snd)
	end
end	

SWEP.NextSwing = 0
function SWEP:DoAttack( bPull ) 
	if CurTime() < self.NextSwing then
		return
	end
	
	-- Get owner
	local mOwner = self.Owner
	if not ValidEntity(mOwner) then
		return
	end
	
	-- Cannot scream while in air
	if not mOwner:OnGround() then
		return
	end
	
	-- Cooldown
	self.NextSwing = CurTime() + self.Primary.Delay
	
	--Thirdperson animation and sound
	mOwner:DoAnimationEvent(CUSTOM_PRIMARY)
	
	--Set scream end time
	self:SetScreamEndTime(CurTime() + 1.3)
		
	--Just server from here
	if CLIENT then
		return
	end

	--Emit Sound
	mOwner:EmitSound(table.Random(ZombieClasses[mOwner:GetZombieClass()].AttackSounds), 100, math.random(95, 135))

	--Find in sphere
	for k,v in ipairs(team.GetPlayers(TEAM_HUMAN)) do
		local fDistance = v:GetPos():Distance( self.Owner:GetPos() )

		--Check for conditions
		if not v:IsPlayer() or not v:IsHuman() or not v:Alive() or fDistance > self.DistanceCheck then
			continue
		end

		local vPos, vEnd = mOwner:GetShootPos(), mOwner:GetShootPos() + ( mOwner:GetAimVector() * self.DistanceCheck )
		local Trace = util.TraceLine ( { start = vPos, endpos = v:LocalToWorld( v:OBBCenter() ), filter = mOwner, mask = MASK_SOLID } )
			
		-- Exploit trace
		if not Trace.Hit or not ValidEntity(Trace.Entity) or Trace.Entity ~= v then
			continue
		end
		
		--Calculate percentage of being hit
		local fHitPercentage = math.Clamp(1 - (fDistance / self.DistanceCheck), 0, 1)
		
		--We want something between 1 and 2
		local fFuckIntensity = fHitPercentage + 1
		
		--Shakey shakey
		GAMEMODE:OnPlayerHowlered(v, fFuckIntensity)
											
		--Inflict damage
		local fDamage = math.Round(10 * fHitPercentage, 0, 10)
		if fDamage > 0 then
			v:TakeDamage(fDamage, self.Owner, self)
		end

		-- Calculate velocity
		local Velocity = -1 * mOwner:GetForward() * 145
		if not bPull then
			Velocity = -1 * Velocity * 2
		end
		
		--Calculate velocity
		Velocity.x, Velocity.y, Velocity.z = Velocity.x * 0.5, Velocity.y * 0.5, math.random(250, 270)
		if not bPull then
			Velocity = Vector(Velocity.x * 0.4, Velocity.y * 0.4, Velocity.z)
		end

		--Apply velocity		
		v:SetVelocity(Velocity)
				
		-- Play sound
		timer.Simple(0.2, function()
			if IsValid(v) then
				WorldSound("npc/barnacle/barnacle_bark1.wav", v:GetPos() + Vector(0, 0, 20), 120, math.random(60, 75))
			end
		end)
	end
	
	--On trigger play sound
	local iRandom = math.Rand(1, 2.5)
	if iRandom <= 1.5 then
		self.Owner:EmitSound("ambient/energy/zap6.wav")
	end
	
	--Scream effect for myself
	self.Owner:SendLua("WraithScream()")
end

function SWEP:Think()
	self:CheckScream()

	return self.BaseClass.Think(self)
end

function SWEP:CheckScream()
	local rend = self:GetScreamEndTime()
	if rend == 0 or CurTime() < rend then
		return
	end

	self:SetScreamEndTime(0)
end

function SWEP:SetScreamEndTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:GetScreamEndTime()
	return self:GetDTFloat(0)
end

function SWEP:IsScreaming()
	return self:GetScreamEndTime() > 0
end

function SWEP:PrimaryAttack()
	self:DoAttack(true)
end

function SWEP:SecondaryAttack()
	self:DoAttack(false)
end

function SWEP:Move(mv)
	if self:IsScreaming() then
		mv:SetMaxSpeed(0)
		return true
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

if CLIENT then
	function SWEP:DrawHUD()
		GAMEMODE:DrawZombieCrosshair(self.Owner, self.DistanceCheck)
	end
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
end


if CLIENT then
	function SWEP:OnViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if IsValid(self.Arms) and IsValid(vm) then
			
			if self.Arms:GetModel() ~= self.Owner:GetModel() then
				self.Arms:SetModel(self.Owner:GetModel())
			end
			
			if not self.Arms.GetPlayerColor then
				self.Arms.GetPlayerColor = function() return Vector(GetConVarString("cl_playercolor")) end
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