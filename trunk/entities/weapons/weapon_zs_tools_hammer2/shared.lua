-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information
 
AddCSLuaFile()
 
SWEP.Author = "Duby"
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.UseHands = true
SWEP.WorldModel = Model("models/weapons/w_hammer.mdl")
 
SWEP.Base = "weapon_zs_melee_base"
 
-- Name, fov, etc
SWEP.PrintName = "Nailing Hammer"
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false
 
if CLIENT then
        SWEP.ShowViewModel = false
        SWEP.ShowWorldModel = true
        killicon.AddFont("weapon_zs_tools_hammer", "ZSKillicons", "c", Color(255, 255, 255, 255))
 
        SWEP.VElements = {
                ["hammer"] = { type = "Model", model = "models/weapons/w_hammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.023, 1.764, -1.575), angle = Angle(0, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
                ["nail"] = { type = "Model", model = "models/crossbow_bolt.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(0.989, 2.296, -3.958), angle = Angle(62.951, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
        }
 
        SWEP.ViewModelBoneMods = {
                ["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(2.296, 1.378, -13.011), angle = Angle(0, -98.265, 8.265) },
                ["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 22.958, 0) },
                ["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -0.918, 0) },
                ["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-32.144, -52.348, 0) }
        }
end
 
SWEP.DamageType = DMG_CLUB
 
-- Slot pos.
SWEP.Slot = 3
SWEP.SlotPos = 3
 
SWEP.Primary.ClipSize = 10
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "gravity"
SWEP.Primary.Delay = 1
 
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
 
SWEP.WalkSpeed = 225
SWEP.HoldType = "melee"
 
SWEP.MeleeDamage = 0
SWEP.MeleeRange = 50
SWEP.MeleeSize = 0.875
 
SWEP.UseMelee1 = true
 
SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture
 
SWEP.SwingTime = 0.25
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingOffset = Vector(0, -30, 0)
SWEP.SwingHoldType = "grenade"
 
SWEP.Mode = 1
 
for i=1,4 do
    util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-"..i..".wav")
end
 
function SWEP:PlayHitSound()
    self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1, 4)..".wav", 75, math.random(110, 115))
end
 
function SWEP:Initialize()
	self.BaseClass.Initialize(self)

	self:SetDeploySpeed(1.1)
	if SERVER then
			self.Weapon.FirstSpawn = true
	end
	self.NextNail = 0
end
 
 
SWEP.NextSwitch = 0
function SWEP:Reload()
    return false
end
 
function SWEP:PrimaryAttack()
 
	if not self:CanPrimaryAttack() then
        return	
		print("Can't Primary Attack!")
	end
 
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() then
		return
		print("Knocked Down!")
	end
		   
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Alternate = not self.Alternate
	self.Owner:SetAnimation(PLAYER_ATTACK1)
   
	if SERVER then
		local tr = self.Owner:TraceLine(54, MASK_SHOT, team.GetPlayers(TEAM_HUMAN))

		local trent = tr.Entity
		if not IsEntityValid(trent) then
				return
		end

		if tr.Hit and not tr.HitWorld then
			if trent.Nails and #trent.Nails > 0 then
				local griefedprop = false
			   
				if trent._LastAttackerIsHuman then
						griefedprop = true
				end
			   
				for i=1, #trent.Nails do
					local nail = trent.Nails[i]
					   
					if nail and nail:IsValid() then
							print("Repairing!")
					
						if nail:GetNailHealth() < nail:GetDTInt(1) then -- nail:GetNWInt("MaxNailHealth")
							if self.Owner:GetPerk("_trchregen") then      
								--nail:SetMaxNailHealth(math.Clamp(nail:GetMaxNailHealth()-2,1))                                                        
								nail:SetNailHealth(math.Clamp(nail:GetNailHealth()+7,1,nail:GetDTInt(1)))
							else
								--nail:SetMaxNailHealth(math.Clamp(nail:GetMaxNailHealth()-3,1))                                                        
								nail:SetNailHealth(math.Clamp(nail:GetNailHealth()+5,1,nail:GetDTInt(1)))
							end  					

							if not griefedprop then
								self.Owner._RepairScore = self.Owner._RepairScore + 1
							   
								if self.Owner._RepairScore == 5 then
									skillpoints.AddSkillPoints(self.Owner, 10)
									nail:FloatingTextEffect( 10, self.Owner )
									self.Owner:AddXP(5)
									self.Owner._RepairScore = 0
								end
							end

							local pos = tr.HitPos
							local norm = tr.HitNormal-- (tr.HitPos - self.Owner:GetShootPos()):Normalize():Angle()
						   
							local eff = EffectData()
							eff:SetOrigin( pos )
							eff:SetNormal( norm )
							eff:SetScale( math.Rand(0.5,0.75) )
							eff:SetMagnitude( math.random(5,10) )
							util.Effect( "StunstickImpact", eff, true, true )
						   
							self.Owner:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
							break
						end
					end
				end
			end
		   
			--turret
			if trent:GetClass() == "zs_turret" then
				if trent:GetDTInt(1) < trent.MaxHealth then
   
					self.Owner._RepairScore = self.Owner._RepairScore + 1
										   
					if self.Owner._RepairScore == 5 then
						skillpoints.AddSkillPoints(self.Owner, 10)
						trent:FloatingTextEffect( 10, self.Owner )
						self.Owner:AddXP(5)
						self.Owner._RepairScore = 0
					end
		   
					trent:SetDTInt(1,trent:GetDTInt(1)+1)
				   
					local pos = tr.HitPos
					local norm = tr.HitNormal-- (tr.HitPos - self.Owner:GetShootPos()):Normalize():Angle()
								   
					local eff = EffectData()
					eff:SetOrigin(pos)
					eff:SetNormal(norm)
					eff:SetScale( math.Rand(0.5,0.75) )
					eff:SetMagnitude( math.random(5,10) )
					util.Effect("StunstickImpact", eff, true, true)
								   
					self.Owner:EmitSound("npc/dog/dog_servo"..math.random(7, 8)..".wav", 70, math.random(100, 105))
				end
			end
	   
			if trent:IsPlayer() and trent:IsZombie() and trent:Alive()then
		   
				trent:TakeDamage(30,self.Owner,self)
		   
				if math.random(3) == 3 then
				trent:EmitSound("player/pl_burnpain"..math.random(1,3)..".wav")
				end
			end
		end
	end
end
 
local NONAILS = {}
NONAILS[0] = "It's impossible to put nails here."
NONAILS[0] = "Computer says no. Btw check you're nail count."
NONAILS[MAT_GRATE] = "It's impossible to put nails here."
NONAILS[MAT_GRATE] = "You're doing a Duby aren't you?"
NONAILS[MAT_CLIP] = "It's impossible to put nails here."
NONAILS[MAT_GLASS] = "Trying to put nails in glass is a silly thing to do."
 
function SWEP:SecondaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() or ARENA_MODE or CurTime() < self.NextNail then
		return
	end

	if self:Clip1() <= 0 then
		--Remove nail in hand
		if CLIENT then
			self:ResetBonePositions()
		end

		--Notice, cuz we're nice folks explaining how this game works
		if SERVER then
			self.Owner:Message("No nails left. Wait for the crate timer!", 2)
		end

		return
	end

	local tr = self.Owner:TraceLine(64, MASK_SHOT, player.GetAll())

	local trent = tr.Entity
	if not IsEntityValid(trent) then
		return
	end
		   
	--Get phys object
	local PhysEnt = trent:GetPhysicsObject()
		   
	if not trent:IsValid() and string.find(trent:GetClass(), "prop_physics") and IsEntityValid(PhysEnt) then
		return
	end

	if SERVER then
		if not IsValid(PhysEnt) or (not PhysEnt:IsMoveable() and not trent.Nails) or trent.IsObjEntity then
				return
		end

		if NONAILS[tr.MatType or 0] then
			if SERVER then
				self.Owner:Message(NONAILS[tr.MatType], 2)
			end
			return
		end
	end

	local trtwo = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + self.Owner:GetAimVector() * 16, filter = {self.Owner, trent}})

	local ent = trtwo.Entity
	
	if trtwo.HitWorld or IsValid(ent) and string.find(ent:GetClass(), "prop_physics") and ent:GetPhysicsObject():IsValid() and (ent:GetPhysicsObject():IsMoveable() or not ent:GetPhysicsObject():IsMoveable() and ent.Nails ) or ent:IsValid() and ent:GetClass() == "func_physbox" and ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:GetPhysicsObject():IsValid() and (ent:GetPhysicsObject():IsMoveable() or not ent:GetPhysicsObject():IsMoveable() and ent.Nails ) then
		if SERVER then
			if ent.IsObjEntity then
					return
			end
		   
			if NONAILS[trtwo.MatType or 0] then
					self.Owner:PrintMessage(HUD_PRINTCENTER, NONAILS[trtwo.MatType])
					return
			end    

			--Ignore doors
			if string.find(trent:GetClass(), "door") then
					return
			end

			local cons = constraint.Weld(trent, ent, tr.PhysicsBone, trtwo.PhysicsBone, 0, true)

			-- New constraint
			if cons then
				self:SendWeaponAnim(ACT_VM_HITCENTER)
				self.Alternate = not self.Alternate
				self.Owner:SetAnimation(PLAYER_ATTACK1)

				self.NextNail = CurTime() + 1
				self:TakePrimaryAmmo(1)
			   
				--Give XP for nailing
				self.Owner:AddXP(5)
					   
				local nail = ents.Create("nail")
				local aimvec = self.Owner:GetAimVector()
				nail:SetPos(tr.HitPos - aimvec * 8)
				nail:SetAngles(aimvec:Angle())
				nail:SetParentPhysNum(tr.PhysicsBone)
				nail:SetParent(trent)
				nail:SetOwner(self.Owner)
				nail:Spawn()
				trent:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1,4)..".wav")
													   
				--??
				trent:CollisionRulesChanged()
					   
				-- store entities
				nail.Ents = {}
				-- store 1st ent
				table.insert(nail.Ents, trent)
					   
				trent.Nails = trent.Nails or {}
				table.insert(trent.Nails, nail)
					   
				if not ent:IsWorld() then
					-- store second one
					table.insert(nail.Ents, ent)
				   
					ent.Nails = ent.Nails or {}
					table.insert(ent.Nails, nail)
				end
			   
				if trtwo.HitWorld then
					if trent:GetPhysicsObject():IsValid() and ent:IsWorld() then
						local phys = trent:GetPhysicsObject()
						phys:EnableMotion( false )
						nail.toworld = true
					end
				end

				nail.constraint = cons
				cons:DeleteOnRemove(nail)
			else -- Already constrained.
				if string.find(trent:GetClass(), "door") then
					return
				end

				for _, oldcons in pairs(constraint.FindConstraints(trent, "Weld")) do
					if oldcons.Ent1 == ent or oldcons.Ent2 == ent then
						trent.Nails = trent.Nails or {}
						if #trent.Nails < 3 then
							self:SendWeaponAnim(ACT_VM_HITCENTER)
							self.Alternate = not self.Alternate
							self.Owner:SetAnimation(PLAYER_ATTACK1)

							self.NextNail = CurTime() + 1
							self:TakePrimaryAmmo(1)
						   
							self.Owner:AddXP(5)
								   
							local nail = ents.Create("nail")
							local aimvec = self.Owner:GetAimVector()
							nail:SetPos(tr.HitPos - aimvec * 8)
							nail:SetAngles(aimvec:Angle())
							nail:SetParentPhysNum(tr.PhysicsBone)
							nail:SetParent(trent)
							nail:SetOwner(self.Owner)
							nail:Spawn()
							trent:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1,4)..".wav")
							trent:CollisionRulesChanged()
							-- store entities
							nail.Ents = {}
							-- store 1st ent
							table.insert(nail.Ents, trent)
						   
							table.insert(trent.Nails, nail)
							--ent.Nails = ent.Nails or {}
							--table.insert(ent.Nails, nail)
								   
							if not ent:IsWorld() then
								-- store second one
								table.insert(nail.Ents, ent)
					   
								ent.Nails = ent.Nails or {}
								table.insert(ent.Nails, nail)
								ent:CollisionRulesChanged()
							end
								   
							if trtwo.HitWorld then
								if trent:GetPhysicsObject():IsValid() and ent:IsWorld() then
									local phys = trent:GetPhysicsObject()
									phys:EnableMotion(false)
									nail.toworld = true
								end
							end

							nail.constraint = oldcons.Constraint
							oldcons.Constraint:DeleteOnRemove(nail)
						else
							if SERVER then
								self.Owner:Message("Only 3 nails can be placed here", 2)
							end
						end
					end
				end
			end
		end
	end
end
 
if SERVER then
	function SWEP:Think()
		self.BaseClass.Think(self)

		--Set secondary ammo in clip
		local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
		if 0 < ammocount then
			self:SetClip1(ammocount + self:Clip1())
			self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
		end
	end
end
 
 
function SWEP:Equip( NewOwner )
	if CLIENT then return end
   
	if self.Weapon.FirstSpawn then
		self.Weapon.FirstSpawn = false
	   
		if self.Owner:GetPerk("_nailamount") then
			self.Weapon:SetClip1( math.Round(self.Primary.DefaultClip*1.5) )
		else
			self.Weapon:SetClip1( self.Primary.DefaultClip )
		end
	else
		if self.Weapon.Ammunition then
			self.Weapon:SetClip1(self.Weapon.Ammunition)
		end
	end
   
	-- Update it just in case
	self.MaximumNails = self:Clip1()               
   
	-- Call this function to update weapon slot and others
	gamemode.Call("OnWeaponEquip", NewOwner, self)
end
 
function SWEP:Precache()
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-1.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-2.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-3.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-4.wav")
end
 
if CLIENT then
	function SWEP:DrawHUD()
		if ENDROUND or not self.Owner:Alive() then
			return
		end

		MeleeWeaponDrawHUD()
		surface.SetFont("ArialBoldTen")

		for _,nail in pairs (ents.FindByClass("nail")) do
			if not nail or not nail:IsValid() then
				continue
			end

			if nail:GetPos():Distance(EyePos()) > 105 then
				continue
			end

			draw.SimpleTextOutlined("+".. math.Round(nail:GetDTInt(0)) .."/".. math.Round(nail:GetDTInt(1)), "ArialBoldFive", nail:GetPos():ToScreen().x, nail:GetPos():ToScreen().y, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
		end
	end
end