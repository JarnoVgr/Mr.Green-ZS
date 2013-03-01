AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	local owner = self:GetOwner()
	if IsValid(owner) then
		owner.status_human_holding = self
		//owner:SetNetworkedBool("IsHolding", true)
		local wep = owner:GetActiveWeapon()
		if IsValid(wep) then
			wep:SendWeaponAnim(ACT_VM_HOLSTER)
			if wep.SetIronsights then
				wep:SetIronsights(false)
			end
		end

		owner:DrawWorldModel(false)
		owner:DrawViewModel(false)
	end

	local object = self:GetObject()
	if IsValid(object) then
		//for _, ent in pairs(ents.FindByClass("logic_pickupdrop")) do
		//	if ent.EntityToWatch == object:GetName() and IsValid(ent) then
		//		ent:Input("onpickedup", owner, object, "")
		//	end
		//end
		object:SetRenderMode(RENDERMODE_TRANSALPHA) 
		local c = object:GetColor()
		object.r,object.g,object.b,object.a = c.r,c.g,c.b,c.a
		object:SetColor(Color(object.r,object.g,object.b,190))
		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:AddGameFlag(FVPHYSICS_PLAYER_HELD)
			objectphys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:AddGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)

			if objectphys:GetMass() < CARRY_DRAG_MASS and object:OBBMins():Length() + object:OBBMaxs():Length() < CARRY_DRAG_VOLUME then
				object._OriginalMass = objectphys:GetMass()

				objectphys:EnableGravity(false)
				objectphys:SetMass(2)

				--[[if not object.OldCollisionGroup then
					local r, g, b, a = object:GetColor()
					object.OldColor = Color(r, g, b, a)
					object.OldCollisionGroup = object:GetCollisionGroup()
					object:SetColor(r, g, b, a / 2)
					object:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
				end]]
			else
				self:SetIsHeavy(true)
			--[[else --if not object._OriginalLinearDamping then
				--object._OriginalLinearDamping, object._OriginalAngularDamping = objectphys:GetDamping()
				--objectphys:SetDamping(object._OriginalLinearDamping, object._OriginalAngularDamping + 100)
				self.HingePosition = object:WorldToLocal(object:NearestPoint(owner:EyePos()))]]
				self:SetHingePos(object:NearestPoint(self:GetPullPos()))
			end

			if IsValid(owner) then
				owner:CheckSpeedChange()
				//GAMEMODE:SetPlayerSpeed(owner, math.max(CARRY_SPEEDLOSS_MINSPEED, CalculatePlayerSpeed(owner) - object:GetPhysicsObject():GetMass() * CARRY_SPEEDLOSS_PERKG))
				//owner:SetSpeed(math.max(CARRY_SPEEDLOSS_MINSPEED, 190 - objectphys:GetMass() * CARRY_SPEEDLOSS_PERKG))
			end
		end
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if IsValid(owner) then
		owner.status_human_holding = nil
		//owner:SetNetworkedBool("IsHolding", false)
		if owner:Alive() and owner:Team() ~= TEAM_UNDEAD then
			//GAMEMODE:SetPlayerSpeed(owner, owner:GetActiveWeapon().WalkSpeed or 200)
			owner:CheckSpeedChange()
			local wep = owner:GetActiveWeapon()
			if IsValid(wep) then
				wep:SendWeaponAnim(ACT_VM_DRAW)
			end
		end

		owner:DrawWorldModel(true)
		owner:DrawViewModel(true)
	end

	local object = self:GetObject()
	if IsValid(object) then
		--[[local timnam = "ENABLECOLLISIONS"..tostring(object)
		timer.Create(timnam, 0, 0, EnableCollisions, object, 16, nil, timnam)]]
		object:SetColor(Color(object.r,object.g,object.b,object.a))
		local objectphys = object:GetPhysicsObject()
		if objectphys:IsValid() then
			objectphys:ClearGameFlag(FVPHYSICS_PLAYER_HELD)
			objectphys:ClearGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			objectphys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			objectphys:EnableGravity(true)
			if object._OriginalMass then
				objectphys:SetMass(object._OriginalMass)
				object._OriginalMass = nil
			end
			--[[if object._OriginalLinearDamping then
				objectphys:SetDamping(object._OriginalLinearDamping, object._OriginalAngularDamping)
				object._OriginalLinearDamping = nil
				object._OriginalAngularDamping = nil
			end]]
		end

		//for _, ent in pairs(ents.FindByClass("logic_pickupdrop")) do
		//	if ent.EntityToWatch == object:GetName() and ent:IsValid() then
		//		ent:Input("ondropped", owner, object, "")
		//	end
		//end
	end
end

local ShadowParams = {secondstoarrive = 0.01, maxangular = 1000, maxangulardamp = 10000, maxspeed = 500, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 0}
function ENT:Think()
	local ct = CurTime()

	local frametime = ct - (self.LastThink or ct)
	self.LastThink = ct

	local object = self:GetObject()
	local owner = self:GetOwner()
	if not IsValid(object) or object:IsNailed() or not owner:IsValid() or not owner:Alive() or owner:KeyDown(IN_ATTACK) then
		self:Remove()
		return
	end

	local shootpos = owner:GetShootPos()
	local nearestpoint = object:NearestPoint(shootpos)

	local objectphys = object:GetPhysicsObject()
	if object:GetMoveType() ~= MOVETYPE_VPHYSICS or not objectphys:IsValid() or owner:GetGroundEntity() == object then
		self:Remove()
		return
	end

	if self:GetIsHeavy() then
		if 64 < self:GetHingePos():Distance(self:GetPullPos()) then
			self:Remove()
			return
		end
	elseif 64 < nearestpoint:Distance(shootpos) then
		self:Remove()
		return
	end

	objectphys:Wake()

	if self:GetIsHeavy() then
		local pullpos = self:GetPullPos()
		local hingepos = self:GetHingePos()
		objectphys:ApplyForceOffset(objectphys:GetMass() * frametime * 450 * (pullpos - hingepos):GetNormal(), hingepos)
		--[[local targetpos = shootpos + owner:GetAimVector() * 16
		local vel = (targetpos - object:NearestPoint(targetpos)):Normalize()
		--vel.z = 0
		objectphys:ApplyForceCenter(objectphys:GetMass() * frametime * 500 * vel:Normalize())]]
	else
		if not self.ObjectPosition or not owner:KeyDown(IN_SPEED) then
			local obbcenter = object:OBBCenter()
			local objectpos = shootpos + owner:GetAimVector() * 48
			objectpos = objectpos - obbcenter.z * object:GetUp()
			objectpos = objectpos - obbcenter.y * object:GetRight()
			objectpos = objectpos - obbcenter.x * object:GetForward()
			self.ObjectPosition = objectpos
			self.ObjectAngles = object:GetAngles()
		end

		ShadowParams.pos = self.ObjectPosition
		ShadowParams.angle = self.ObjectAngles
		ShadowParams.deltatime = frametime
		objectphys:ComputeShadowControl(ShadowParams)
	end

	object:SetPhysicsAttacker(owner)

	self:NextThink(ct)
	return true
end
