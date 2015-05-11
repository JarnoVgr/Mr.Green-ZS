local tbCratePos = {}
local function UpdateCompass(len)
	if not IsValid(MySelf) then
		return
	end

	--Reste positions table
	tbCratePos = {}
	
	--Get number of crates first
	local numCrates = net.ReadInt(32)
	
	--Get positions
	if numCrates > 0 then
		for i = 1, numCrates do
			table.insert(tbCratePos, net.ReadVector())
		end
	end
	
	--Debug
	Debug("[COMPASS] Received ".. numCrates .." Supply Crates")
end
net.Receive("UpdateCompass", UpdateCompass)

--[[------------------------------------------
          Returns number of crates
------------------------------------------]]
local function GetCrateAmount()
	return #tbCratePos
end

--[[--------------------------------------------
          Returns crate positions
---------------------------------------------]]
local function GetCratePositions()
	return tbCratePos
end

--[[--------------------------------------------
          Returns if there are crates
---------------------------------------------]]
local function AreThereCrates()
	if GetCrateAmount() == 0 then
		return false
	else
		return true
	end
end

--[[------------------------------------------------------------------------------------------
     Returns if there are crates and the distance in meters between you and them
--------------------------------------------------------------------------------------------]]
--TODO: Cache AreThereSupplyCrates?
local function AreThereSupplyCrates()
	if not IsValid(MySelf) then
		return
	end
	
	--Check them all
	local AreThereCrates, DistanceCrate, CratePosition = AreThereCrates(), 32000, Vector(0, 0, 0)
	local MyPosition = MySelf:GetPos()

	local Positions = GetCratePositions()
	for i=1,#Positions do
		local crate = Positions[i]

		local DistanceCrateCurrent = math.Round((MyPosition:Distance(crate)) / 52.5)
		if DistanceCrateCurrent < DistanceCrate then
			DistanceCrate = DistanceCrateCurrent
			CratePosition = crate
		end
	end
	
	--Beware! Distance is in Meters
	return AreThereCrates, DistanceCrate, CratePosition
end

local SupplyArrowModelPanel = {}  
  
--[[---------------------------------------------------------  
   This function inits the arrow pointing to crates
---------------------------------------------------------]]
function SupplyArrowModelPanel:Init()  
    self:SetModel(Model("models/props_mrgreen/arrow.mdl"))
	self:SetVisible(false)
    self:PerformLayout()  
end  
  
--[[---------------------------------------------------------  
       Called each frame - updates arrow angles
---------------------------------------------------------]]
function SupplyArrowModelPanel:LayoutEntity(Arrow) 
	if not IsValid(MySelf) then
		return
	end
	--camera related stuff
    self:SetCamPos(Vector(0, 20, -6))  
	self:SetLookAt(Vector(0, 0, 0))  
    Arrow:SetModelScale(0.4, 0)
      
--	self:SetPos(w * 0.5 - (self:GetWide() / 2), h - self:GetTall())
	self:SetPos(w * 0.5 - (self:GetWide() / 2), h -20 - self:GetTall())

	--Color the arrow
	--self:SetColor(Color(200, 30, 30, 255))
	self:SetColor(Color(24, 140, 30, 255))

	--Original vector pointing to
	local AreThereCrates, Distance, CratePosition = AreThereSupplyCrates()
	
	
	--No crates
	if not AreThereCrates then
		return
	end
	
	--Don't mess with this shit
	local ang = MySelf:EyeAngles()
	ang.p = ang.p * -1
	local tang = (MySelf:EyePos() - CratePosition):Angle()
	
	local nAng = Angle(math.NormalizeAngle(tang.p), math.NormalizeAngle(tang.y), math.NormalizeAngle(tang.r))
	nAng = nAng - ang

	--Correct it for arrow model
	nAng = nAng - Angle(-50, 90, 0)

	--Smoothen
	local OldAngles, ApproachRate = Arrow:GetAngles(), 3
	nAng = Angle(math.ApproachAngle(OldAngles.p, nAng.p, ApproachRate), math.ApproachAngle(OldAngles.y, nAng.y, ApproachRate), math.ApproachAngle(OldAngles.r, nAng.r, ApproachRate))

	--Finally set the arrow angles
    Arrow:SetAngles(nAng)

end

--[[----------------------------------------------------------------------------  
   Update the model panel size ( not the model itself, just the panel )
------------------------------------------------------------------------------]]
function SupplyArrowModelPanel:PerformLayout()  
 	self:SetSize(ScrW() * 0.16, ScrW() * 0.16)
end  
  
--The model panel
local Compass = vgui.CreateFromTable(vgui.RegisterTable(SupplyArrowModelPanel, "DModelPanel"))

--[[---------------------------------------------------------  
         Manages the visibility of the arrow
---------------------------------------------------------]]
local ArrowVisible = false
local function ShouldDrawCompass()
--	timer.Simple(100, function() --Some Shitty work around because I cba..
	if CurTime() >= WARMUPTIME then --Actually, I could be assed. There done.
	ArrowVisible = false
	
	--Grab data
	local AreThereCrates, Distance = AreThereSupplyCrates()

	--if there are crates, turn the arrow on
	if AreThereCrates then 
		ArrowVisible = true

		--For humans only
		if not IsValid(MySelf) or MySelf:Team() ~= TEAM_HUMAN or not MySelf:Alive() then
			ArrowVisible = false
		--there is no crate or you are dead or you already got supplies, turn the arrow off
		elseif Distance >= 32000 then
			ArrowVisible = false
		--Already got supplies
		elseif CurTime() < (MySelf.NextSupplyTime or 0) then
			ArrowVisible = false
		--Endround
		elseif ENDROUND then
			ArrowVisible = false
		--Player decided to not have us
		elseif not util.tobool(GetConVarNumber("zs_drawarrow")) then
			ArrowVisible = false
		end
	end

	--Set when needed

	if Compass:IsVisible() ~= ArrowVisible then
		Compass:SetVisible(ArrowVisible)
	end
--end)
	end
end
hook.Add("Think", "ShouldDrawCompass", ShouldDrawCompass)

--[[---------------------------------------------------------  
         Draws the text under the arrow
---------------------------------------------------------]]
local function DrawArrowText()
	if not IsValid(MySelf) or not ArrowVisible or Compass == nil then
		return
	end

	--Grab data
	local AreThereCrates, DistanceCrate = AreThereSupplyCrates()
	local CrateW, CrateH = Compass:GetPos()
	local ArrowWide, ArrowTall = Compass:GetWide(), Compass:GetTall()
	
	--There are no crates
	if not AreThereCrates then
		return
	end
	
	--Draw the shit
--	draw.SimpleTextOutlined("Supplies: "..DistanceCrate.." m", "ArialBoldTen", CrateW + (ArrowWide * 0.5), (CrateH + ArrowTall) - 20, Color(24, 140, 30, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
	draw.SimpleTextOutlined("Supplies: "..DistanceCrate.." m", "ArialBoldTen", CrateW + (ArrowWide * 0.5), (CrateH + ArrowTall) - 40, Color(24, 140, 30, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 200))
end
hook.Add("HUDPaint", "DrawArrowText", DrawArrowText)