AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "NECROSSIN"
ENT.Purpose			= ""
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

util.PrecacheSound("items/ammo_pickup.wav")
util.PrecacheSound("mrgreen/supplycrates/mobile_use.mp3")

function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Placer" );
end

util.PrecacheModel("models/Items/item_item_crate.mdl")
function ENT:Initialize()
	if SERVER then	
		self.Entity:SetModel("models/Items/item_item_crate.mdl")
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)	
		self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			phys:EnableMotion(false) 
		end
	
		self.CrateHealth = 300
	end
	--self.CrateOwner = self:GetDTEntity(0)
	--self.CrateOwner = self:GetPlacer()
	self.AmmoDelay = 150

	if CLIENT then
		hook.Add("PreDrawHalos", "CustDrawHalosAmmo".. tostring(self), function()
			if util.tobool(GetConVarNumber("_zs_drawcrateoutline")) then
				if (IsValid(MySelf) and MySelf:Team() == TEAM_HUMAN and MySelf:Alive()) then
					halo.Add({self}, self.LineColor, 1, 1, 1, true, false)
				end
			end
		end)
	end
end	

function ENT:Think()
	local ct = CurTime()
	
	--local humans = player.GetAll()
	local humans = team.GetPlayers(TEAM_HUMAN)
	--if SERVER then self:CheckOwner() end
	
	--Loop though all players
	for _, pl in ipairs(humans) do
		-- check if player got ammo
		if pl.GotMobileSupplies == nil then -- whatever
			pl.GotMobileSupplies = false
			pl.MobileSupplyTime = ct + self.AmmoDelay -- make a timer for him
			pl.MobileSupplyTimerActive = true
		end

		if pl.MobileSupplyTimerActive == true then
			if pl.MobileSupplyTime <= ct then
				pl.MobileSupplyTimerActive = false
				pl.GotMobileSupplies = false
			end
		end		
	end

	self:NextThink(ct+1)
	return true
end

if SERVER then
	function ENT:OnTakeDamage( dmginfo )
		if dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsZombie() then
			self.CrateHealth = self.CrateHealth - dmginfo:GetDamage()
		
			if self.CrateHealth <= 0 then
				self:Explode()
			end
		end
	end

	function ENT:CheckOwner()
		local Owner = self:GetPlacer()
		if not ValidEntity(Owner) or not Owner:Alive() or Owner:Team() == TEAM_UNDEAD then 
			self:Explode()
		end
	end

	function ENT:Explode()
		local trace = {}
		trace.start = self:GetPos() + Vector(0,0,5)
		trace.filter = self.Entity
		trace.endpos = trace.start - Vector(0,0,50)
		local traceground = util.TraceLine(trace)
		
		util.Decal("Scorch",traceground.HitPos - traceground.HitNormal,traceground.HitPos + traceground.HitNormal)

		local Effect = EffectData()
		Effect:SetOrigin(self:GetPos())
		Effect:SetStart(self:GetPos())
		Effect:SetMagnitude(300)
		util.Effect("Explosion", Effect)

		self.Entity:Remove()
	end


	function ENT:Use(activator, caller)
		if not IsValid(activator) then
			return
		end
		
		if not activator:IsPlayer() or not activator:IsHuman() then
			return
		end
		
		activator.NextPop = activator.NextPop or 0
			
		if activator.NextPop > CurTime() then
			return
		end
		activator.NextPop = CurTime() + 1.5

		local gotSupplies = false
			
		if activator.MobileSupplyTimerActive == false then
			if activator.GotMobileSupplies == false then
				activator.GotMobileSupplies = true
				activator.MobileSupplyTimerActive = true	
				activator:SendLua("MySelf.MobileSupplyTimerActive = true")
				activator:SendLua("MySelf.GotMobileSupplies = true")
				activator.MobileSupplyTime = CurTime() + self.AmmoDelay
				activator:SendLua("MySelf.MobileSupplyTime = CurTime() + "..self.AmmoDelay.."")
				
				--Give ammo
				local Automatic, Pistol = activator:GetAutomatic(), activator:GetPistol()
				if Automatic or Pistol then
					local WeaponToFill = activator:GetActiveWeapon()		
					local AmmoType
							
					if IsValid(WeaponToFill) and (GetWeaponCategory ( WeaponToFill:GetClass() ) == "Pistol" or GetWeaponCategory ( WeaponToFill:GetClass() ) == "Automatic") then
						AmmoType = WeaponToFill:GetPrimaryAmmoTypeString() or "pistol"
					else
						AmmoType = "pistol"
					end
								
					-- How much ammo to give
					local HowMuch = GAMEMODE.AmmoRegeneration[AmmoType] or 50
									
					--Multiplier for infliction
					HowMuch = math.Round(HowMuch * (INFLICTION + 0.5))

					--Finally give it
					activator:GiveAmmo(HowMuch, AmmoType)
				end

				--Heal
				if activator:Health() < activator:GetMaximumHealth() then
					local healthDifference = math.Clamp(activator:GetMaximumHealth() - activator:Health(), 0, 35)
					local actualHealAmount = math.random(15, healthDifference)
					actualHealAmount = math.min(activator:Health() + actualHealAmount, activator:GetMaximumHealth())
					activator:SetHealth(actualHealAmount)
				end

				--Give SP to crate owner		
				local Owner = self:GetPlacer()
				if activator ~= Owner and (ValidEntity(Owner) and Owner:Alive() and Owner:Team() == TEAM_HUMAN) then
					skillpoints.AddSkillPoints(Owner,3)
					self:FloatingTextEffect(3, Owner)
					Owner:AddXP(3)
				end

				--Play sound
				activator:EmitSound(Sound("mrgreen/supplycrates/mobile_use.mp3"))

				--
				gotSupplies = true
			end
		end

		--Show notice when not being able to use it
		if not gotSupplies then
			activator:Message("You can't get Supplies at this moment",1,"white")
		end
	end
end
	
if CLIENT then
	ENT.LineColor = Color(210, 0, 0, 100)
	function ENT:Draw()
	    self:DrawModel()

	    if not ValidEntity(MySelf) or MySelf:Team() ~= TEAM_HUMAN then
	        return
	    end

		if MySelf.MobileSupplyTimerActive == false then
	    	self.LineColor = Color(0, math.abs(200 * math.sin(CurTime() * 3)), 0, 100)
	    elseif self.LineColor ~= Color(210, 0, 0, 100) then
	    	self.LineColor = Color(210, 0, 0, 100)
	    end

	    --Draw some stuff
	    local pos = self:GetPos() + Vector(0,0,45)

	    --Check for distance with local player
	    if pos:Distance(MySelf:GetPos()) > 400 then
	        return
	    end
	          
	    local angle = (MySelf:GetPos() - pos):Angle()
	    angle.p = 0
	    angle.y = angle.y + 90
	    angle.r = angle.r + 90

	    cam.Start3D2D(pos,angle,0.26)

				local Owner = self:GetPlacer()
				if ValidEntity(Owner) and Owner:Alive() and Owner:Team() == TEAM_HUMAN then
					draw.SimpleTextOutlined( Owner:Name() .."'s Mobile Supplies", "ArialBoldFive", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
				else
					draw.SimpleTextOutlined( "Mobile Supplies", "ArialBoldFive", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
				end
				
				if MySelf.MobileSupplyTimerActive == true then
					local time = math.Round(MySelf.MobileSupplyTime - CurTime())
					draw.SimpleTextOutlined("0"..ToMinutesSeconds(time + 1), "ArialBoldFour", 0, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
				elseif MySelf.MobileSupplyTimerActive == false then
					draw.SimpleTextOutlined("Press E for bandages and ammo", "ArialBoldFour", 0, 20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1, Color(0,0,0,255))
				end

	    cam.End3D2D()
	end

	function ENT:OnRemove()
	    hook.Remove( "PreDrawHalos", "CustDrawHalosAmmo".. tostring( self ) )
	end
end
