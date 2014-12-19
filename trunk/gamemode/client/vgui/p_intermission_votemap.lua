--Colors
local COLOR_SUBTITLE = Color ( 146,146,146,255 )
local COLOR_TITLE = Color ( 255,245,245,255 )
local COLOR_GREY_ONE = Color ( 99,99,99,255 )
local COLOR_DARK_GREY = Color ( 35,35,35,255 )
local COLOR_BLUE = Color ( 139,183,220,255 )
local COLOR_LIGHT_GREY = Color ( 62,62,62,255 )
local COLOR_LIGHT_RED = Color ( 116,26,26,255 )
local COLOR_DARK_GREY_BUTTON = Color ( 12,72,122,255 )
local COLOR_DARK_RED = Color ( 123,24,24,255 )

local VoteMapPanel

hook.Add( "StartChat", "VoteMapStartChat", function()
	if not ENDROUND or not MySelf or not IsValid(MySelf) then
		return
	end

	MySelf.HideVoteMapFlash = true

	VoteMapPanel:Hide()
end)


hook.Add( "FinishChat", "VoteMapFinishChat", function()
	if not ENDROUND or not MySelf or not IsValid(MySelf) then
		return
	end

	MySelf.HideVoteMapFlash = false

	VoteMapPanel:Show()
end)

--[[---------------------------------------------------------
			  -- Votemap Panel
---------------------------------------------------------]]
local VOTEMAP_PANEL = {}

function VOTEMAP_PANEL:Init()
	VoteMapPanel = self
end
 
function VOTEMAP_PANEL:Paint()
	local Wide = self:GetWide()
	local Tall = self:GetTall()
	   
	draw.RoundedBox(8, 0, 0, Wide, Tall, COLOR_DARK_GREY)
	surface.SetDrawColor(COLOR_BLUE)

	--Voted map name (the one voted by you)
	local VotedMap = "nothing"
	if MySelf.HasVotedMap == true and MySelf.VotedMapSlot ~= nil then
		if not MySelf.strMapVote then
			for k,v in ipairs(VoteMaps) do
				if k == MySelf.VotedMapSlot then
					MySelf.strMapVote = v.OriginalTitle
					break
				end
			end

			MySelf.strMapVote = MySelf.strMapVote or "a map"
		end
		VotedMap = MySelf.strMapVote
	end
	   
	local nextsign,prevsign = ">","<"
	local VoteHeader = "Vote for next destination"
	if MySelf.HasVotedMap == true then
		VoteHeader = "You have voted for ".. tostring(VotedMap)
	end
	if IsVotingOver == true then
		VoteHeader = "Voting ended"
	end

	if SCREEN then
		surface.DrawRect ( 7,7, Wide - 14, ScaleH(93) )
		draw.SimpleText("VOTEMAP","ArialBoldEighteen", ScaleW(25),ScaleH(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(tostring(VoteHeader),"ArialBoldNine", ScaleW(28),ScaleH(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	elseif WIDESCREEN then  
		surface.DrawRect( 7,7, Wide - 14 , ScalePanel(93) )
		draw.SimpleText("VOTEMAP","ArialBoldEighteen", ScalePanel(25),ScalePanel(39), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(tostring(VoteHeader),"ArialBoldNine", ScalePanel(28),ScalePanel(77), COLOR_DARK_GREY, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end

	--Skip when maps table isn't filled yet
	if not VoteMaps or #VoteMaps ~= 3 then
		return
	end

	--Set scale function depending on ratio
	if SCREEN then
		self.SmartScale = ScaleH
	elseif WIDESCREEN then
		self.SmartScale = ScalePanel
	end

	self.Height = self.SmartScale(122)

	for i = 1,3 do
		--Draw the selection area on every slot, but keep the color invisible
		surface.SetDrawColor(IntermissionColorLabels[i+8])
		surface.DrawRect(7, self.Height - self.SmartScale(15), Wide - 14, self.SmartScale(30))
					   
		if i == MySelf.VotedMapSlot then
			if not string.find(VoteMaps[i].Title, "(voted)") then
				VoteMaps[i].Title = VoteMaps[i].Title .." (voted)"
			end
			IntermissionColorLabels[i+8] = COLOR_LIGHT_GREY
		end
				   
		--Write (winner) if the map is the voted one
		if IsVotingOver == true and VoteMaps[i].MapName == tostring(WinnerMap) then
			if not string.find(VoteMaps[i].Title, "(winner)") then
				VoteMaps[i].Title = VoteMaps[i].Title .." (winner)"
			end
		end
					   
		--Select the win map and make it red
		if MapName == WinnerMap then      
			IntermissionColorLabels[i+8] = COLOR_LIGHT_RED
		end
				   
		local howmanyvotes = "votes"
		if VoteMaps[i].Votes == 1 then
			howmanyvotes = "vote"
		end
											   
		draw.SimpleText(tostring(VoteMaps[i].Title),"ArialNine", self.SmartScale(18),self.Height, COLOR_BLUE, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(tostring(VoteMaps[i].Votes).." ".. howmanyvotes,"ArialNine", Wide - 17,self.Height, COLOR_BLUE, TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		self.Height = self.Height + self.SmartScale(34)
	end
	   
	return true
end
 
function VOTEMAP_PANEL:Think()
	self:PerformLayout()
end
 
function VOTEMAP_PANEL:PerformLayout()
	if SCREEN then
		local h = ScaleH(485)
	
		self:SetSize(ScaleW(440), ScaleH(214))
		self:SetPos(ScaleW(269), h)
	elseif WIDESCREEN then
		local h = ScaleH(476)
	
		self:SetSize(ScalePanel(440), ScalePanel(214))
		self:SetPos(ScaleW(260), h)
	end
	   
	--Align the panel to the center.
	self:AlignCenter()
end
vgui.Register("Votemap", VOTEMAP_PANEL, "Panel")

--[[---------------------------------------------------------
				Manage Votemap Panel
---------------------------------------------------------]]
function ManageVoteMap(panel)	   
	--Wide,tall
	if SCREEN then
		panel:SetSize(ScaleW(440),ScaleH(214))
	else
		panel:SetSize(ScalePanel(440),ScalePanel(214))
	end
	   
	panel:SetPos(ScaleW(269), h * 0.5)
	   
	local Wide, Tall = panel:GetWide(), panel:GetTall()
	   
	--Initialize the votemap bool ( see if the map is already set)
	MySelf.HasVotedMap = false
 	   
	--Create the labels
	local h, posy, tall = 0, 0, 0
	if SCREEN then
		h = ScaleH(122)
		posy = ScaleH(16)
		tall = ScaleH(30)
	elseif WIDESCREEN then
		h = ScalePanel(122)
		posy = ScalePanel(16)
		tall = ScalePanel(30)
	end
 
	--Pagestuff
	panel.Page = 1
	panel.MaxPages = 1
	   
	for i = 1, 3 do
		DoLabel(i+8, panel, font, text, 7, h - posy, COLOR_LIGHT_GREY, "label", Color(0,0,0,0), Wide - 14, tall)

		local increment
		if WIDESCREEN then
			increment = ScalePanel(34)
		else
			increment = ScaleH(34)
		end
		h = h + increment
	end
end

--[==[---------------------------------------------------------
	   Receive voting maps (3 maps)
---------------------------------------------------------]==]
net.Receive("ReceiveVoteMaps", function(len)
	for i = 1, 3 do
	    local MapName = net.ReadString()
	    local Title = net.ReadString()

	    VoteMaps = VoteMaps or {}

		--Voted map names
		table.insert(VoteMaps,{
			MapName = MapName,
			Title = Title,
			OriginalTitle = Title,
			Votes = 0
		})
	end
end)

--[==[---------------------------------------------------------
	   Receive vote points update
---------------------------------------------------------]==]
net.Receive("ReceiveVotePoints", function(len)
	for i = 1, 3 do
		local MapName = net.ReadString()

		for k,v in pairs(VoteMaps) do
			if v.MapName == MapName then
				v.Votes = net.ReadDouble()
				break
			end
		end
	end
end)


--[[---------------------------------------------------------
	   Receive nextmap ( Vote Result )
---------------------------------------------------------]]
function SetWinnerMap(MapName)
	WinnerMap = MapName
	IsVotingOver = true
end