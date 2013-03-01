-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
SWEP.PrintName = "barricade"
SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	if SERVER then
		if self.Owner:FlashlightIsOn() then
			self.Owner:Flashlight( false )
		end
		GAMEMODE:WeaponDeployed( self.Owner, self )
	end
	return true
end



function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		local yaw = math.Clamp(tonumber(self.Owner:GetInfo("zs_barricadekityaw")), -180, 180)
		local create = false
		local aimvec = self.Owner:GetAimVector()
		local shootpos = self.Owner:GetShootPos()
		local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 65, filter = self.Owner})
		
		local norm = tr.HitNormal*-1
		local ang = norm:Angle()
		
		if tr.HitSky then
			create = false
		else
	
		local right = ang:Right():Angle()
		right:RotateAroundAxis(ang:Forward(), yaw)
		local forw = right:Right()*-1
		right = right:Forward()
		
		local tr1 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * 61, filter = MySelf})
		local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * -61, filter = MySelf})
		local tr3 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + forw * 1, filter = MySelf})
		--local tr1r = util.TraceLine({start = tr.HitPos + right * 42, endpos = tr.HitPos + right * 40, filter = MySelf})
		--local tr2l = util.TraceLine({start = tr.HitPos + right * -42, endpos = tr.HitPos + right * -40, filter = MySelf})
	local case1 = ((tr1.HitWorld or tr2.HitWorld ) and tr3.HitWorld)
	local case2 = ((tr1.HitWorld and tr2.HitWorld ) and not tr3.HitWorld)
	local case3 = ((not tr1.HitWorld and tr2.HitWorld ) and tr3.HitWorld)
	local case4 = ((tr1.HitWorld and not tr2.HitWorld ) and tr3.HitWorld)
	
	--local tr1r = util.TraceLine({start = tr.HitPos + right * 42, endpos = tr.HitPos + right * 40, filter = MySelf})
	--local tr2l = util.TraceLine({start = tr.HitPos + right * -42, endpos = tr.HitPos + right * -40, filter = MySelf})
	--if ((tr1.HitWorld or tr2.HitWorld ) and tr3.HitWorld or (tr1.HitWorld or tr2.HitWorld ) and not tr3.HitWorld or (not tr1.HitWorld or not tr2.HitWorld ) and tr3.HitWorld) and not tr1.HitSky and not tr2.HitSky then
	if (case1 or case2 or case3 or case4) and not tr1.HitSky and not tr2.HitSky then
			if not (tr1.HitEntity and tr1.HitEntity:IsValid() and tr1.HitEntity:IsPlayer() and tr2.HitEntity and tr2.HitEntity:IsValid() and tr2.HitEntity:IsPlayer()) then
				create = true
			end
			end
		end
		--local traceground = util.TraceLine({start = self.Owner:GetPos(), endpos = self.Owner:GetPos() + Vector(0,0,-7), filter = self.Owner}) -- Exploiting cade kit is bad
		if create then
		--if not traceground.HitWorld then self.Owner:Message ("You should stand on solid ground! (Anti-Exploit protection)",1,"white") self.Weapon:SetNextPrimaryFire(CurTime() + 1) return end
		local phealth = 250 + (250 * ((HumanClasses[4].Coef[1]*(self.Owner:GetTableScore ("engineer","level")+1)) / 100))
			local ent = ents.Create("prop_physics")
			if ent:IsValid() then
				ent:SetPos(tr.HitPos)
				ang.roll = math.NormalizeAngle(90 + yaw)
				ent:SetAngles(ang)
				ent:SetModel("models/props_debris/wood_board03a.mdl")
				ent:SetKeyValue("spawnflags", "1672")
				ent:Spawn()
				ent:Fire("sethealth", ""..phealth.."", 0)
				ent:EmitSound("npc/dog/dog_servo12.wav")
				ent.IsBarricade = true
				ent:GetPhysicsObject():EnableMotion(false)
				self:TakePrimaryAmmo(1)
							
			end
			-- Engineer's requirements
			if self.Owner:GetHumanClass() == 4 then
				if self.Owner:GetTableScore("engineer","level") == 0 and self.Owner:GetTableScore("engineer","achlevel0_1") < 60 then
					self.Owner:AddTableScore("engineer","achlevel0_1",1)
				elseif self.Owner:GetTableScore("engineer","level") == 1 and self.Owner:GetTableScore("engineer","achlevel0_1") < 120 then
					self.Owner:AddTableScore("engineer","achlevel0_1",1)
				end				
			self.Owner:CheckLevelUp()
			--print(phealth)
			end
			
			
			self:DefaultReload(ACT_VM_RELOAD)
		end
	end
end
