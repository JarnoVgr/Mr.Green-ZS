-- � Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

if SERVER then AddCSLuaFile ( "shared.lua" ) end

SWEP.Author = "Deluvas"
SWEP.ViewModel = Model ( "models/weapons/v_hammer/v_hammer.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_hammer.mdl" )

SWEP.Base = "weapon_zs_melee_base"

-- Name, fov, etc
SWEP.PrintName = "Nailing Hammer"
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false



if CLIENT then

SWEP.ShowViewModel = true
SWEP.IgnoreBonemerge = true
SWEP.RotateFingers = Angle(12,-35,0)


SWEP.DummyModel = true
end

function SWEP:InitializeClientsideModels()
	
	self.VElements = {
		["hammer"] = { type = "Model", model = "models/weapons/w_hammer.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.318, 1.506, 0.449), angle = Angle(14.951, -5.289, 175.268), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	self.ViewModelBoneMods = {
		["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1, 1, 1), pos = Vector(-2.813, 0, -330), angle = Angle(0, 0, 0) }
	} 
	self.WElements = {} 
	
end

SWEP.DamageType = DMG_CLUB

-- Slot pos.
SWEP.Slot = 3
SWEP.SlotPos = 3

SWEP.Primary.ClipSize = 100
SWEP.Primary.Damage = 18
SWEP.Primary.DefaultClip = 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "gravity"
SWEP.Primary.Delay = 0.8

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 205
SWEP.HoldType = "melee"

SWEP.MeleeDamage = 35
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

if CLIENT then killicon.AddFont( "weapon_zs_tools_hammer", "ZSKillicons", "c", Color(255, 255, 255, 255 ) ) end

function SWEP:Reload()
	return false
end

for i=1,4 do
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-"..i..".wav")
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1, 4)..".wav", 75, math.random(110, 115))
end


function SWEP:OnInitialize()
	self:SetDeploySpeed( 1.1 )
	if SERVER then
		--self.Weapon:SetNWInt("Nails/Boards",1)	
		self.Weapon.FirstSpawn = true
	end
	self.NextNail = 0
	
end
-- LastInfoScroll = LastInfoScroll or 0
SWEP.NextSwitch = 0
function SWEP:Reload()
	--[=[if self.NextSwitch > CurTime() then return end
	
	if self:GetNWInt("Nails/Boards") == 1 then
		self.Info = "Right click to drop a plank.\n Reload - switch to nails."
		if CLIENT then 
			LastInfoScroll = CurTime() + 10 

		end
		self.Weapon:SetNetworkedInt ( "Nails/Boards", 2 )
		self.Weapon:EmitSound("weapons/smg1/switch_burst.wav")

	elseif self:GetNWInt ("Nails/Boards") == 2 then
		self.Info = "Right click to nail a prop.\n Reload - switch to planks."
		if CLIENT then 
			LastInfoScroll = CurTime() + 10 	

		end
		self.Weapon:SetNetworkedInt ( "Nails/Boards", 1 )
		self.Weapon:EmitSound("weapons/smg1/switch_burst.wav")
		
	end

	self.NextSwitch = CurTime() + 1.5]=]
	return false
end


local NONAILS = {}
NONAILS[MAT_GRATE] = "Impossible."
NONAILS[MAT_CLIP] = "Impossible."
NONAILS[MAT_GLASS] = "Trying to put nails in glass is a silly thing to do."

function SWEP:SecondaryAttack()
	if self.Owner.KnockedDown or self.Owner.IsHolding and self.Owner:IsHolding() or ARENA_MODE then return end
	--local Mode = self:GetNWInt ("Nails/Boards")
	
	--if Mode == 1 then
	--Nails!
		if 0 < self:Clip1() and self.NextNail < CurTime() then
			local tr = self.Owner:TraceLine( 64, MASK_SHOT, player.GetAll() )

			local trent = tr.Entity
			if not IsEntityValid ( trent ) then return end
			
			-- Get phys object
			local PhysEnt = trent:GetPhysicsObject()
			
			if not trent:IsValid() and --[=[trent:GetMoveType() == MOVETYPE_VPHYSICS]=] string.find(trent:GetClass(), "prop_physics") and IsEntityValid ( PhysEnt ) then return end
			if SERVER then 
			if not IsValid(PhysEnt) then return end
				if not PhysEnt:IsMoveable() and not trent.Nails then 
					return 
				end 
			end

			if SERVER then
			if trent.IsObjEntity then return end
				if NONAILS[tr.MatType or 0] then
					self.Owner:PrintMessage(HUD_PRINTCENTER, NONAILS[tr.MatType])
					return
				end
			end

			local trtwo = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + self.Owner:GetAimVector() * 16, filter = {self.Owner, trent}})

			local ent = trtwo.Entity
			if trtwo.HitWorld or IsValid(ent) and string.find(ent:GetClass(), "prop_physics") and ent:GetPhysicsObject():IsValid() and (ent:GetPhysicsObject():IsMoveable() or not ent:GetPhysicsObject():IsMoveable() and ent.Nails ) or ent:IsValid() and ent:GetClass() == "func_physbox" and ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:GetPhysicsObject():IsValid() and (ent:GetPhysicsObject():IsMoveable() or not ent:GetPhysicsObject():IsMoveable() and ent.Nails ) then
				if SERVER then
				if ent.IsObjEntity then return end
					if NONAILS[trtwo.MatType or 0] then
						self.Owner:PrintMessage(HUD_PRINTCENTER, NONAILS[trtwo.MatType])
						return
					end
				end
				
				if SERVER then
					if string.find(trent:GetClass(), "door") then return end
					local cons = constraint.Weld(trent, ent, tr.PhysicsBone, trtwo.PhysicsBone, 0, true)
					if cons then -- New constraint
						self:SendWeaponAnim(ACT_VM_HITCENTER)
						self.Alternate = not self.Alternate
						self.Owner:SetAnimation(PLAYER_ATTACK1)

						self.NextNail = CurTime() + 1
						self:TakePrimaryAmmo(1)
						
						skillpoints.AddSkillPoints(self.Owner,10)
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
						-- trent.Nailed = true
						-- if trent:Health() < trent:GetMaxHealth() then -- we cant overheal props
							-- trent:SetHealth(trent:Health() + (trent:GetMaxHealth() - trent:Health())/3) -- and we cant repair them at 100%
							-- trent:TakeDamage(0.1, self.Owner) -- fix the ent color bug
						-- end
						
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
					if string.find(trent:GetClass(), "door") then return end
						for _, oldcons in pairs(constraint.FindConstraints(trent, "Weld")) do
							if oldcons.Ent1 == ent or oldcons.Ent2 == ent then
								trent.Nails = trent.Nails or {}
								if #trent.Nails < 3 then
									self:SendWeaponAnim(ACT_VM_HITCENTER)
									self.Alternate = not self.Alternate
									self.Owner:SetAnimation(PLAYER_ATTACK1)

									self.NextNail = CurTime() + 1
									self:TakePrimaryAmmo(1)
									
									skillpoints.AddSkillPoints(self.Owner,10)
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
											phys:EnableMotion( false )
											nail.toworld = true
										end
									end
										nail.constraint = oldcons.Constraint
										oldcons.Constraint:DeleteOnRemove(nail)
									


								--else
									--self.Owner:PrintMessage(HUD_PRINTCENTER, "Too many nails.")
								end
							end
						end
					end
				end
				-- Animations
				--[=[
				if SERVER then self:SendWeaponAnim(ACT_VM_HITCENTER) end
				self.Alternate = not self.Alternate
				self.Owner:SetAnimation(PLAYER_ATTACK1)
				
				self.NextNail = CurTime() + 1
				if SERVER then self:TakePrimaryAmmo(1) end
				
				-- Creating the nail
				if SERVER then
					local nail = ents.Create( "nail" )
					local aimvec = self.Owner:GetAimVector()
					nail:SetPos(tr.HitPos - aimvec * 8)
					nail:SetAngles(aimvec:Angle())
					nail:SetParent(trent)
					nail:Spawn()
					trent:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1,4)..".wav")
					trent.Nailed = true
					if trent:Health() < trent:GetMaxHealth() then -- we cant overheal props
					trent:SetHealth(trent:Health() + (trent:GetMaxHealth() - trent:Health())/3) -- and we cant repair them at 100%
					trent:TakeDamage(0.1, self.Owner) -- fix the ent color bug
					end
				end
				
				if SERVER then
					if trent:GetPhysicsObject():IsValid() and ent:IsWorld() then
						local phys = trent:GetPhysicsObject()
						phys:EnableMotion( false )
					end
				end
				]=]	
				-- Support Prop Nailing Achievments
				if SERVER then
					if self.Owner:GetHumanClass() == 5 then
						if self.Owner:GetTableScore("support","level") == 0 then
							if self.Owner:GetTableScore("support","achlevel0_2") < 150 then
							-- 	self.Owner:AddTableScore ("support","achlevel0_2",1)
							end
						elseif self.Owner:GetTableScore("support","level") == 1 then
							if self.Owner:GetTableScore("support","achlevel0_2") < 400 then
							-- 	self.Owner:AddTableScore ("support","achlevel0_2",1)
							end
						end
						
						-- self.Owner:CheckLevelUp()
					end
				end
			end
		end
	--Planks
	--[=[else	
		if 0 < self:Clip2() and self.NextNail < CurTime() then
			self.NextNail = CurTime() + 1
			if SERVER then
			local Plank = ents.Create("prop_physics")
			local Force = 10
	
			local v = self.Owner:GetShootPos()
			v = v + self.Owner:GetForward() * 17
			-- v = v + self.Owner:GetRight() * 4
			v = v + self.Owner:GetUp() * -7
			Plank:SetModel("models/props_debris/wood_board06a.mdl")
			Plank:SetPos(v)
			Plank:SetAngles( Angle(self.Owner:GetAimVector():Angle().p,self.Owner:GetAimVector():Angle().y,0) )
			Plank:Fire("sethealth", "150", 0)
			-- Plank:SetOwner(self.Owner)
			Plank:Spawn()
			Plank.IsBarricade = true
			local Phys = Plank:GetPhysicsObject()
			Phys:SetVelocity(self.Owner:GetAimVector()* Force)
			self:TakeSecondaryAmmo(1)
			
				if self.Owner:IsPlayer() then
					--  logging
					log.PlayerAction( self.Owner, "build_barricade")
				end
			
			end
			
		end
	end]=]
end


function SWEP:Equip ( NewOwner )
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
	gamemode.Call ( "OnWeaponEquip", NewOwner, self )
end

function SWEP:Precache()
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-1.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-2.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-3.wav")
	util.PrecacheSound("weapons/melee/crowbar/crowbar_hit-4.wav")
end

if CLIENT then

function SWEP:DrawHUD()
	if not self.Owner:Alive() then return end
	if ENDROUND then return end
	MeleeWeaponDrawHUD()

	draw.SimpleTextOutlined("Right click to nail an object", "ArialBoldFive", w-ScaleW(150), h-ScaleH(63), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
	draw.SimpleTextOutlined("Hammer can NOT heal the nails", "ArialBoldFive", w-ScaleW(150), h-ScaleH(40), Color(255,255,255,255), TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
end
end

 