local math = math
local team = team
local util = util
local timer = timer

if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
	SWEP.PrintName = "weapon"
end

if CLIENT then
	SWEP.PrintName = "Infected"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.ViewModelBoneMods = {
		//["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-10.202, 19.533, 0) },
		["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(0, -7.493, -45.569) },
		["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(5.802, 1.06, 0.335), angle = Angle(0, 0, 0) },
		["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(52.678, 0, 0) },
		["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(45.873, -0.348, 0) },
		["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-59.774, -9.223, 18.572) },
		["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.2, 1.2, 1.2), pos = Vector(0, 0, 0), angle = Angle(10.701, -7.301, 42.666) },
		["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(0, 9.659, 6.218) },
		["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.4, 1.4, 1.4), pos = Vector(0, 0, 0), angle = Angle(-6.42, 28.499, 7.317) }
	}


	
end
SWEP.Base = "weapon_zs_zombie"
//Remade by Deluvas
SWEP.Author = "Deluvas"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = Model ( "models/Weapons/v_zombiearms.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_knife_t.mdl" )

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DistanceCheck = 88
SWEP.MeleeDelay = 0.6

SWEP.Damage = 20

SWEP.SwapAnims = false
SWEP.AttackAnimations = { "attackD", "attackE", "attackF" }

function SWEP:Reload()
	return false
end

function SWEP:OnDeploy()
	if SERVER then
		self.Owner.Moaning = false
	end
	self.Owner.IsMoaning = false 
	self.Owner.ZomAnim = math.random(1, 3)
end

function SWEP:PrimaryAttack()
	if self:IsClimbing() then return end

	self.BaseClass.PrimaryAttack(self)
end

SWEP.NextClimbSound = 0
function SWEP:Think()
	local curtime = CurTime()
	local owner = self.Owner

	if self:GetClimbing() then
		if self:GetClimbSurface() and owner:KeyDown(IN_ATTACK2) then
			if SERVER and (owner:KeyDown(IN_FORWARD) or owner:KeyDown(IN_BACK)) and CurTime() >= self.NextClimbSound then
				self.NextClimbSound = CurTime() + 1
				owner:EmitSound("player/footsteps/metalgrate"..math.random(4)..".wav", 75, math.Rand(85, 90))
			end
		else
			self:StopClimbing()
		end
	end

	return self.BaseClass.Think(self)
end



function SWEP:PrimaryAttack()
	if self:IsClimbing() then return end

	self.BaseClass.PrimaryAttack(self)
end

local climbtrace = {mask = MASK_SOLID_BRUSHONLY, mins = Vector(-5, -5, -5), maxs = Vector(5, 5, 5)}
function SWEP:GetClimbSurface()
	local owner = self.Owner

	local fwd = owner:SyncAngles():Forward()
	local up = owner:GetUp()
	local pos = owner:GetPos()
	local tr
	for i=-15, owner:OBBMaxs().z, 5 do
		if not tr or not tr.Hit then
			climbtrace.start = pos + up * i
			climbtrace.endpos = climbtrace.start + fwd * 28
			tr = util.TraceHull(climbtrace)
			if tr.Hit and not tr.HitSky then break end
		end
	end

	if tr.Hit and not tr.HitSky then
		climbtrace.start = tr.HitPos + tr.HitNormal
		climbtrace.endpos = climbtrace.start + owner:SyncAngles():Up() * 72
		local tr2 = util.TraceHull(climbtrace)
		if tr2.Hit and not tr2.HitSky then
			return tr2
		end

		return tr
	end
end

function SWEP:SecondaryAttack()
	if self:IsClimbing() then return end

	if not self.Owner:IsOnGround() and self.Owner:GetVelocity():Length() < 200 and self:GetClimbSurface() then
		self:StartClimbing()
	end
end

function SWEP:StartClimbing()
	if self:GetClimbing() then return end

	self:SetClimbing(true)

	self:SetNextPrimaryFire(math.huge)

	if SERVER and not IsValid(self.Owner.status_overridemodel) then
		local ov = self.Owner:GiveStatus("overridemodel")
		if ov and ov:IsValid() then
			ov:SetModel(self.Owner:GetModel())
			self.Owner:SetModel("models/zombie/fast.mdl")
		end
	end
end

function SWEP:StopClimbing()
	if not self:GetClimbing() then return end

	self:SetClimbing(false)

	self:SetNextPrimaryFire(CurTime() + 0.5)

	if SERVER then
		local ov = self.Owner.status_overridemodel
		if ov and ov:IsValid() then
			self.Owner:SetModel(ov:GetModel())
			ov:Remove()
		end
	end
end

function SWEP:Move(mv)
	if self:GetClimbing() then
		mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)

		local tr = self:GetClimbSurface()
		local dir = tr and tr.Hit and tr.HitNormal.z <= -0.5 and (self.Owner:SyncAngles():Forward() * -1) or self.Owner:GetUp()

		if self.Owner:KeyDown(IN_FORWARD) then
			mv:SetVelocity(dir * 60)
		elseif self.Owner:KeyDown(IN_BACK) then
			mv:SetVelocity(dir * -60)
		else
			mv:SetVelocity(Vector(0, 0, 4))
		end

		return true
	end
end

function SWEP:SetClimbing(climbing)
	self:SetDTBool(1, climbing)
end

function SWEP:GetClimbing()
	return self:GetDTBool(1)
end
SWEP.IsClimbing = SWEP.GetClimbing

local lerp = 0
function SWEP:GetViewModelPosition(pos, ang)
	lerp = math.Approach(lerp, self:IsClimbing() and 1 or 0, FrameTime() * ((lerp + 1) ^ 3))
	ang:RotateAroundAxis(ang:Right(), 64 * lerp)
	if lerp > 0 then
		pos = pos + -8 * lerp * ang:Up() + -12 * lerp * ang:Forward()
	end
	return pos, ang
	--return self.BaseClass.GetViewModelPosition(self, pos, ang)
end

function SWEP:_OnRemove()
	if CLIENT then
		self:RemoveArms()
	end
end

function SWEP:OnInitialize()
	if CLIENT then
		self:MakeArms()
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

function SWEP:OnViewModelDrawn()

	local vm = self.Owner:GetViewModel();
	if IsValid(self.Arms) and IsValid(vm) then
		
		if self.Arms:GetModel() ~= self.Owner:GetModel() and self.Owner:GetModel() ~= "models/zombie/fast.mdl" then
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
			
			self.Arms:SetRenderOrigin( vm:GetPos()-vm:GetAngles():Forward()*20-vm:GetAngles():Up()*60 )//self.Arms[1]:SetRenderOrigin( EyePos() )
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
		//self.Arms:AddEffects(bit.bor(EF_BONEMERGE , EF_BONEMERGE_FASTCULL , EF_PARENT_ANIMATES))
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