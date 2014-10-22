game.AddParticles("particles/cig_smoke.pcf" )

PrecacheParticleSystem( "cig_burn" )
PrecacheParticleSystem( "cig_smoke" )
PrecacheParticleSystem( "drg_pipe_smoke" )

local USE_PARTICLES = file.Exists ("models/player/items/soldier/cigar.mdl","GAME")-- IsMounted("tf2")

ENT.Type = "anim"
ENT.Base = "suit_new"

if SERVER then
	AddCSLuaFile("shared.lua")
end 

function ENT:Think()
	if SERVER then
		local pl = self:GetOwner():GetRagdollEntity() or self:GetOwner()
		-- self:SetColor(pl:GetColor())
		if not IsValid(pl) then self:Remove() end
		if (pl:IsPlayer() and not pl:IsHuman()) then self:Remove() end
		if IsValid(self:GetOwner()) and not self:GetOwner():Alive() and not IsValid(self:GetOwner():GetRagdollEntity()) then self:Remove() end
		-- self.Entity:SetPos(pl:GetPos())
	end
	if CLIENT then
		if IsValid(self:GetOwner()) then
			local owner = self:GetOwner()
			if MySelf and owner == MySelf and not IsValid(MySelf.Hat) then
				MySelf.Hat = self.Entity
			end
		end
	end
end


if SERVER then
	function ENT:SetHatType( hat )
		self.HatType = hat
		-- self:SetNWString("HatType", hat)
		self:SetDTString(0,hat)
		--self.Entity:SetColor(255,255,255,255)
		local r,g,b = 255,255,255
		if self:GetOwner():HasBought("hatpainter") then
			r,g,b = self:GetOwner():GetInfoNum("_zs_hatpcolR",255) or 255 ,self:GetOwner():GetInfoNum("_zs_hatpcolG",255) or 255 ,self:GetOwner():GetInfoNum("_zs_hatpcolB",255) or 255
			-- self:GetOwner():PrintMessage (HUD_PRINTTALK, "You got the hat painter! Color is: "..tostring(r).." "..tostring(g).." "..tostring(b))
			self.Entity:SetDTBool(0,true)
		end
		self.Entity:SetColor(Color(r,g,b,255))
	end
end

function ENT:CreateModelElements()
	local temp = {}
	
	local tocheck = string.Explode("$",self:GetHatType())
	
	local hashat = false
	
	-- PrintTable(tocheck)
	local c = 0
	for k,v in pairs(tocheck) do
		if hats[v] and not (hashat and PureHats[v]) then
			if not hashat and PureHats[v] then
				hashat = true
			end
			for _,minitable in pairs(hats[v]) do
				local t = table.Copy(minitable)
				if minitable.rel and minitable.rel ~= "" then
					t.rel = v.."_"..minitable.rel
				end
				if PureHats[v] then
					t.UsePainter = true
				end
				temp[v.."_".._] = t
			end
			c = c + 1
			if c == 4 then break end
		end
	end
	
	-- PrintTable(temp)
	
	if temp then
		self:InitializeClientsideModels(temp)
		self:CreateModels(self.Elements)
		-- self.Elements = {}
	end
	
end

-- Build a table with our models
function ENT:InitializeClientsideModels(tbl)
	
	self.Elements = {}
	if tbl then
		self.Elements = table.Copy(tbl) 
	end
	
end

if SERVER then
function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
end

-- Small function to check if suit models dissapeared
function ENT:CheckModelElements()
	if not self.Elements then
		timer.Simple(0,function()
			if self.CreateModelElements then
				self:CreateModelElements()
			end
		end)
	end
end

if CLIENT then

	local render = render
	local table = table
	local pairs = pairs
	local cam = cam
	
	ENT.RenderOrder = nil

	function ENT:Draw()
		
		if IsValid(self:GetOwner()) then
			self.Entity:SetRenderBounds( self:GetOwner():OBBMaxs()*1.5, self:GetOwner():OBBMins()*1.5) 
		end
	
		local owner = self:GetOwner()
		if MySelf and owner == MySelf and not IsValid(MySelf.Hat) then
			MySelf.Hat = self.Entity
		end
		if not owner:IsValid() or not owner:Alive() or owner == MySelf or not util.tobool(GetConVarNumber("_zs_enablehats")) then return end
		if not owner:IsHuman() then return end
		
		-- if self:GetOwner() == LocalPlayer() and LocalPlayer():Alive() then return end
		
		if self.CheckModelElements then
			self:CheckModelElements()
		end
		
		if (not self.Elements) then return end
		
		if (not self.RenderOrder) then

			self.RenderOrder = {}

			for k, v in pairs( self.Elements ) do
				if (v.type == "Model") then
					table.insert(self.RenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.RenderOrder, k)
				end
			end

		end
		
		if (IsValid(self:GetOwner())) then
			if IsValid(self:GetOwner():GetRagdollEntity()) then
				bone_ent = self:GetOwner():GetRagdollEntity()
			else
				bone_ent = self:GetOwner()
			end
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.RenderOrder ) do
		
			local v = self.Elements[name]
			if (not v) then self.RenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.Elements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.Elements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (not pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				local size = (v.size.x + v.size.y + v.size.z)/3
				
				model:SetAngles(ang)
				model:SetModelScale(size,0)
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				local r,g,b = v.color.r,v.color.g,v.color.b
				
				local c = self.Entity:GetColor()
				local er,eg,eb,ea = c.r,c.g,c.b,c.a
				
				-- if er ~= 255 and eg ~= 255 and eb ~= 255 then
				if self.Entity:GetDTBool(0) and model.UsePainter then
					r,g,b = er,eg,eb
				end
				-- end
				
				render.SetColorModulation(r/255, g/255, b/255)
				render.SetBlend(v.color.a/255)
				model:SetupBones()
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end

	end
	
	function ENT:DrawTranslucent()
		self:Draw()
	end
	
	
	function ENT:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel ~= "") then
			
			local v = basetab[tab.rel]
			
			if (not v) then return end
			
			--  Technically, if there exists an element with the same name as a bone
			--  you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (not pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (not bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
		end
		
		return pos, ang
	end

	function ENT:CreateModels( tab )

		if (not tab) then return end

		--  Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model ~= "" and (not IsValid(v.modelEnt) or v.createdModel ~= v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
					v.modelEnt.SuitProp = true
					if v.UsePainter then
						v.modelEnt.UsePainter = true
					end
					
					-- Particles!
					if USE_PARTICLES and v.particle and v.particleatt and self:GetOwner() ~= MySelf then
						for _,part in pairs(v.particle) do
							ParticleEffectAttach(part,PATTACH_POINT_FOLLOW,v.modelEnt,v.modelEnt:LookupAttachment(v.particleatt))
						end
					end
									
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite ~= "" and (not v.spriteMaterial or v.createdSprite ~= v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				--  make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	function ENT:RemoveModels()
		if (self.Elements) then
			for k, v in pairs( self.Elements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.Elements = nil
	end


end


