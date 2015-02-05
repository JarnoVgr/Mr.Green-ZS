-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

function ScaleW(sizew)
	return ScrW() * ( sizew / 1280 )
end

function RevertScaleW(AbsoluteWidth)
	return (AbsoluteWidth / ScrW()) * 1280
end

function ScaleH(sizeh)
	return ScrH() * (sizeh / 1024) 
end

function RevertScaleH(AbsoluteHeight)
	return (AbsoluteHeight / ScrH()) * 1024
end



--[==[-----------------------------------------------------------------------------------------------------------------------------------------------------------
	Draws a rounded text box with self sizeable text in it : ( text, font, posx, posy, added dist, box color, text color, aligny, alignx )
-------------------------------------------------------------------------------------------------------------------------------------------------------------]==]
function draw.RoundedTextBox ( strText, strFont, xPos, yPos, fDistance, tbColorBox, tbColorText, xAlign, yAlign )

	-- Get text size
	surface.SetFont ( strFont )
	local fWidth, fHeight = surface.GetTextSize ( strText )
	
	-- Default distance
	local fxDist, fyDist
	if fDistance == nil then fyDist = fHeight * 0.35 fxDist = fHeight * 0.45 else fyDist = fHeight * fDistance fxDist = fHeight * ( fDistance + 0.12 ) end
	
	-- Draw box
	local fBoxWidth, fBoxHeight = fWidth + ( fxDist * 3 ), fHeight + ( fyDist * 2 )

	-- Align on width center
	if ( xAlign == TEXT_ALIGN_CENTER ) then	xPos = xPos - fBoxWidth / 2 end
		
	-- Align on width right
	if ( xAlign == TEXT_ALIGN_RIGHT ) then xPos = xPos - fBoxWidth end
		
	-- Align on height center
	if ( yAlign == TEXT_ALIGN_CENTER ) then yPos = yPos - fBoxHeight / 2 end
	
	-- Align on height top
	if ( yAlign == TEXT_ALIGN_TOP ) then yPos = yPos - fBoxHeight end	
	
	-- Align on width left
	if ( xAlign == TEXT_ALIGN_LEFT ) then xPos = xPos + fBoxWidth end

	draw.RoundedBox( 4, xPos, yPos , fBoxWidth, fBoxHeight, tbColorBox )
	draw.SimpleText( strText, strFont, xPos + ( fBoxWidth / 2 ) ,yPos + ( fBoxHeight / 2 ),tbColorText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function draw.SimpleColoredText (text, font, x, y, colour, xalign, yalign, _return)
	font 	= font 		or "Default"
	x 		= x 		or 0
	y 		= y 		or 0
	xalign 	= xalign 	or TEXT_ALIGN_LEFT
	yalign 	= yalign 	or TEXT_ALIGN_TOP
				
	local lines = {}
	local fulltext = ""
		
	local clStarts,clEnds,clParts = 0,0,0
	local w, h = 0, 0
	surface.SetFont(font)
		
	if (xalign == TEXT_ALIGN_CENTER) then
		w, h = surface.GetTextSize( text )
		x = x - w/2
	end
		
	if (xalign == TEXT_ALIGN_RIGHT) then
		w, h = surface.GetTextSize( text )
		x = x - w
	end
		
	if (yalign == TEXT_ALIGN_CENTER) then
		w, h = surface.GetTextSize( text )
		y = y - h/2
	end
		
	-- Search for starting pattern
	for k,v in string.gmatch(text, "(%[(%d+),(%d+),(%d+),(%d+)%])") do
		clStarts = clStarts + 1
	end
		
	--Search for ending pattern
	for k,v in string.gmatch(text, "(%[/c%])" ) do
		clEnds = clEnds + 1
		-- If there are 'perechi' then a part exists
		if clStarts == clEnds then
			clParts = clParts + 1
		end
	end
		
	local ptext = text
	for i=1,clStarts do
		if string.find ( ptext, "(%[(%d+),(%d+),(%d+),(%d+)%])" ) then
			-- Get the positions
			local clStart, clEnd, clTag, clR, clG, clB, clA = string.find ( ptext, "(%[(%d+),(%d+),(%d+),(%d+)%])" )
			local clEndStart, clEndEnd, colEnd
			local clText,behindText,frontText = "","",""
			-- Some bools
			local HasBehind,HasPair,HasFront = false,false,false
			
			-- See if there are sufficient pairs
			if i <= clEnds then
				clEndStart, clEndEnd, colEnd = string.find( ptext, "(%[/c%])" )
				HasPair = true
			end
				
			if HasPair then
				clText = string.sub ( ptext, clEnd + 1, clEndStart - 1 )
			else
				clText = string.sub ( ptext, clEnd + 1 )
			end
				
			--If there is normal text behind this
			if clStart > 1 then
				if i == 1 then
					behindText = string.sub ( ptext, 1, clStart - 1)
				else
					behindText = string.sub ( ptext, 2, clStart - 1)
				end
				HasBehind = true
			end
			
			if i == clStarts and HasPair then
				frontText = string.sub ( ptext, clEndEnd + 1)
			end
			
			-- Add the information to the table
				lines[i] = {
				id = i,
				whitetextbehind = behindText,
				whitetextafter = frontText,
				text = clText,
				startpos = clEnd,
				startposbox = clEndEnd,
				endpos = clEndStart,
				endposbox = clStart,
				color = Color (clR,clG,clB,clA),
				length = surface.GetTextSize ( clText ),
			}
		
			-- Cut the text
			if HasPair then
				ptext = string.sub ( ptext, clEndEnd ) 
			end
		end
	end
	
	-- First coloured text position
	local clStart, clEnd = string.find ( text, "(%[(%d+),(%d+),(%d+),(%d+)%])" )
	local nocolText,nocollength = "",0
	if clStart then
		nocolText = string.sub ( text, 0, clStart - 1 )
		nocollength = surface.GetTextSize ( nocolText )
	else
		nocolText = string.sub ( text, 0 )	
		nocollength = surface.GetTextSize ( nocolText )
	end
	
	surface.SetTextPos(x,y)
	if (colour~=nil) then
		local alpha = 255
		if (colour.a) then alpha = colour.a end
		surface.SetTextColor( colour.r, colour.g, colour.b, alpha )
	else
		surface.SetTextColor(255, 255, 255, 255)
	end
	
	if nocolText ~= nil and not lines[1] then
		if not _return then
			surface.DrawText( nocolText )
		end
		x = x + nocollength
		fulltext = nocolText
	end
	
	for k, v in pairs (lines) do
		if lines[k].whitetextbehind ~= "" then
			local length = surface.GetTextSize ( lines[k].whitetextbehind )
			surface.SetTextPos (x,y)
			surface.SetTextColor ( colour )
			if not _return then
				surface.DrawText( lines[k].whitetextbehind )
			end
			x = x + length
			fulltext = fulltext..""..lines[k].whitetextbehind 
		end
		
		surface.SetTextPos (x,y)
		surface.SetTextColor (lines[k].color)
		if not _return then
			surface.DrawText(lines[k].text)
		end
		x = x + lines[k].length
		fulltext = fulltext..""..lines[k].text 
		
		if lines[k].whitetextafter ~= "" then
			local length = surface.GetTextSize ( lines[k].whitetextafter )
			surface.SetTextPos (x,y)
			surface.SetTextColor ( colour )
			if not _return then
				surface.DrawText( lines[k].whitetextafter )
			end
			x = x + length
			fulltext = fulltext..""..lines[k].whitetextafter
		end
	end
	
	return w, h, fulltext
end

-- Limits a string based on size given
function string.Limit ( sString, sFont, wSize )

	-- Get text size
	surface.SetFont ( sFont )
	local wText, hText = surface.GetTextSize ( sString )
	
	-- No need to clamp it
	if wText <= wSize then return sString, false end
	
	local tbString, sNew = string.Explode ( "", sString ), ""
	for k,v in pairs ( tbString ) do
		local iSize = surface.GetTextSize ( sNew )
		if iSize < wSize * 0.85 then sNew = sNew..v end
	end
	
	return sNew, true
end

-- Draws a rectangle inside another rectangle
function draw.OutlineRect ( xPos, yPos, xSize, ySize, xDif, yDif, colOuter, colInner, xAlign, yAlign )

	-- Align on width center
	if ( xAlign == TEXT_ALIGN_CENTER ) then	xPos = xPos - xSize / 2 end
		
	-- Align on width right
	if ( xAlign == TEXT_ALIGN_RIGHT ) then xPos = xPos - xSize end
		
	-- Align on height center
	if ( yAlign == TEXT_ALIGN_CENTER ) then yPos = yPos - ySize / 2 end
	
	-- Align on height top
	if ( yAlign == TEXT_ALIGN_TOP ) then yPos = yPos - ySize end	
	
	-- Align on width left
	if ( xAlign == TEXT_ALIGN_LEFT ) then xPos = xPos + xSize end

	-- Draw the outer box
	surface.SetDrawColor ( colOuter )
	surface.DrawRect ( xPos, yPos, xSize, ySize )
	
	-- Draw inner box
	surface.SetDrawColor ( colInner )
	surface.DrawRect ( xPos + xDif, yPos + yDif, xSize - ( 2 * xDif ), ySize - ( 2 * yDif ) )
	
	return xPos + xDif, yPos + yDif, xSize - ( 2 * xDif ), ySize - ( 2 * yDif )
end

-- New draw metatable
drawX, DRAW = {}, {}
drawX.__index = DRAW 

-- Globals
ALIGN_LEFT, ALIGN_RIGHT, ALIGN_CENTER, ALIGN_TOP, ALIGN_BOTTOM = 10, 20, 30, 40, 50
 
--[==[---------------------------------------------------------------------------------------------------------
	                     Creates a text metatable : Variable are obvious
-----------------------------------------------------------------------------------------------------------]==]
function CreateText ( sText, sFont, xPos, yPos, Color, wAlign, hAlign )
	
	-- Our table
	local Table = { IsText = true, sText = sText or "", sFont = sFont or "Default", xPos = xPos or 0, yPos = yPos or 0, Color = Color or Color ( 255,255,255,255 ), wAlign = wAlign, hAlign = hAlign }
	
	-- Set font
	surface.SetFont( sFont )
	Table.wSize, Table.hSize = surface.GetTextSize( sText or "" )
	
	-- Set meta table
	setmetatable( Table, drawX ) 
	
	-- Align
	Table:Align ( wAlign, hAlign )
	
	return Table
end

--[==[---------------------------------------------------------------------------------------------------------
	                     Creates a box metatable - Variables are obvious
---------------------------------------------------------------------------------------------------------]==]
function CreateBox ( xPos, yPos, wSize, hSize, Color, wAlign, hAlign )
	
	-- Our table
	local Table = { IsBox = true, xPos = xPos or 0, wSize = wSize or 0, hSize = hSize or 0, yPos = yPos or 0, Color = Color or Color ( 255,255,255,255 ), wAlign = wAlign, hAlign = hAlign }
	
	-- Set meta table
	setmetatable( Table, drawX ) 
	
	-- Align
	Table:Align ( wAlign, hAlign )
	
	return Table
end

--[==[---------------------------------------------------------------------------------------------------------
	                     Creates a rounded box metatable - Variables are obvious
---------------------------------------------------------------------------------------------------------]==]
function CreateBoxRounded ( iRound, xPos, yPos, wSize, hSize, Color, wAlign, hAlign )
	
	-- Our table
	local Table = { IsRoundedBox = true, iRound = iRound or 4, xPos = xPos or 0, wSize = wSize or 0, hSize = hSize or 0, yPos = yPos or 0, Color = Color or Color ( 255,255,255,255 ), wAlign = wAlign, hAlign = hAlign }
	
	-- Set meta table
	setmetatable( Table, drawX ) 
	
	-- Align
	Table:Align ( wAlign, hAlign )
	
	return Table
end

--[==[---------------------------------------------------------------------------------------------------------
	                 Creates a textured box metatable - Variables are obvious
---------------------------------------------------------------------------------------------------------]==]
function CreateBoxTextured ( matTexture, xPos, yPos, wSize, hSize, Color, wAlign, hAlign )
	
	-- Our table
	local Table = { IsTextureRect = true, matTexture = matTexture, xPos = xPos or 0, wSize = wSize or 0, hSize = hSize or 0, yPos = yPos or 0, Color = Color or Color ( 255,255,255,255 ), wAlign = wAlign, hAlign = hAlign }
	
	-- Set meta table
	setmetatable( Table, drawX ) 
	
	-- Align
	Table:Align ( wAlign, hAlign )
	
	return Table
end

--[==[---------------------------------------------------------------------------------------------------
	                 Creates a line metatable - Variables are obvious
----------------------------------------------------------------------------------------------------]==]
function CreateLine ( x1Pos, y1Pos, x2Pos, y2Pos, Color )
	
	-- Our table
	local Table = { IsLine = true, x1Pos = x1Pos or 0, x2Pos = x2Pos or 0, y2Pos = y2Pos or 0, y1Pos = y1Pos or 0, Color = Color or Color ( 255,255,255,255 ) }
	
	-- Set meta table
	setmetatable( Table, drawX ) 
	
	return Table
end

--[==[---------------------------------------------------------------------------------------------------
	         Creates a rotated textur'd box metatable - Variables are obvious
----------------------------------------------------------------------------------------------------]==]
function CreateBoxTexturedRotated ( matTexture, xPos, yPos, wSize, hSize, Color, iRotation, wAlign, hAlign )

	-- Starts off centered
	xPos = xPos + math.Round( wSize / 2 )
	yPos = yPos + math.Round( hSize / 2 )
	
	-- Our table
	local Table = { IsTextureRectRotated = true, iRotation = iRotation or 0, matTexture = matTexture, xPos = xPos or 0, wSize = wSize or 0, hSize = hSize or 0, yPos = yPos or 0, Color = Color or Color ( 255,255,255,255 ), wAlign = wAlign, hAlign = hAlign }
	
	-- Set meta table
	setmetatable( Table, drawX ) 
	
	-- Align
	Table:Align ( wAlign, hAlign )
	
	return Table
end

--[==[---------------------------------------------------------------------------------------------------
	         Creates a rounded box with boolean corners (rounded)
----------------------------------------------------------------------------------------------------]==]
function CreateBoxRoundedEx ( iRound, xPos, yPos, wSize, hSize, Color, bUpperLeft, bUpperRight, bBottomLeft, bBottomRight, wAlign, hAlign )

	-- Our table
	local Table = { IsRoundedBoxEx = true, bUpperLeft = bUpperLeft, bUpperRight = bUpperRight, bBottomLeft = bBottomLeft, bBottomRight = bBottomRight, iRound = iRound or 0, xPos = xPos or 0, wSize = wSize or 0, hSize = hSize or 0, yPos = yPos or 0, Color = Color or Color ( 255,255,255,255 ), wAlign = wAlign, hAlign = hAlign }

	-- Set meta table
	setmetatable( Table, drawX ) 
	
	return Table
end

--[==[-----------------------------------------
	    Get draw width size
-----------------------------------------]==]
function DRAW:GetWidth()
	return self.wSize
end

--[==[-----------------------------------------
	    Get draw height size
-----------------------------------------]==]
function DRAW:GetHeight()
	return self.hSize
end

--[==[-------------------------------------------------------
	      Set module width position
--------------------------------------------------------]==]
function DRAW:SetWidthPos( xPos )
	self.xPos = xPos
end

--[==[----------------------------------------------
	Get module width position
----------------------------------------------]==]
function DRAW:GetWidthPos()
	return self.xPos
end

--[==[-----------------------------------------------------------
	         Set module height position
------------------------------------------------------------]==]
function DRAW:SetHeightPos ( yPos )
	self.yPos = yPos
end

--[==[-----------------------------------------------
	Return module height position
------------------------------------------------]==]
function DRAW:GetHeightPos()
	return self.yPos
end

--[==[---------------------------------------------------------------
	               Sets the module size
----------------------------------------------------------------]==]
function DRAW:SetSize( wSize, hSize )
	self.wSize, self.hSize = wSize, hSize
	
	-- Update alignment
	self:Align ( self.wAlign, self.hAlign )
end

--[==[----------------------------------------------------
	     Set the module width size
-----------------------------------------------------]==]
function DRAW:SetWidth( wSize )
	self.wSize = wSize
	
	-- Update alignment
	self:Align ( self.wAlign )
end

--[==[-----------------------------------------------------
	      Set the module height size
------------------------------------------------------]==]
function DRAW:SetHeight( hSize )
	self.hSize = hSize
	
	-- Update alignment
	self:Align ( nil, self.hAlign )
end

--[==[-------------------------------------
         Returns module position
-------------------------------------]==]
function DRAW:GetPos()
	return self:GetWidthPos(), self:GetHeightPos()
end

--[==[---------------------------------------
         Returns round coeficient
----------------------------------------]==]
function DRAW:GetRound()
	return self.iRound or 0
end

--[==[---------------------------------------------------------
	     Set module position ( xPos, yPos )
----------------------------------------------------------]==]
function DRAW:SetPos( xPos, yPos )
	self.xPos, self.yPos = xPos, yPos
	
	-- Update align
	self:Align( self.wAlign, self.hAlign )
end

--[==[---------------------------------------------------
	              Set module font 
---------------------------------------------------]==]
function DRAW:SetFont( sFont )
	self.sFont = sFont or "Default"
	
	-- Update size and font
	surface.SetFont ( sFont )
	self.wSize, self.hSize = surface.GetTextSize( self.sText )
end

--[==[------------------------------------------------------
	              Set module color
-------------------------------------------------------]==]
function DRAW:SetColor ( Color )
	self.Color = Color
end

function DRAW:GetHeightPercentPos( fPercent )
	return self:GetHeightPos() + math.Round ( self:GetHeight() * fPercent )
end

function DRAW:GetWidthPercentPos( fPercent )
	return self:GetWidthPos() + math.Round ( self:GetWidth() * fPercent )
end

function DRAW:GetCenter()
	return ( self:GetWidthPos() + math.Round ( self:GetWidth() * 0.5 ) ), ( self:GetHeightPos() + math.Round ( self:GetHeight() * 0.5 ) )
end

function DRAW:GetCenterRight()
	return self:GetWidthPos() + ( self:GetWidth() ), self:GetHeightPos() + math.Round ( self:GetHeight() / 2 )
end

function DRAW:GetCenterLeft()
	return self:GetWidthPos(), self:GetHeightPos() + math.Round ( self:GetHeight() / 2 )
end

function DRAW:GetCenterBottom()
	return self:GetWidthPos() + math.Round ( self:GetWidth() / 2 ), self:GetHeightPos() + self:GetHeight()
end

function DRAW:GetCenterTop()
	return self:GetWidthPos() + math.Round ( self:GetWidth() / 2 ), self:GetHeightPos()
end

function DRAW:GetTopRight()
	return self:GetWidthPos() + self:GetWidth(), self:GetHeightPos()
end

function DRAW:GetTopLeft()
	return self:GetWidthPos(), self:GetHeightPos()
end

function DRAW:GetBottomRight()
	return self:GetWidthPos() + self:GetWidth(), self:GetHeightPos() - self:GetHeight()
end

function DRAW:GetBottomLeft()
	return self:GetWidthPos(), self:GetHeightPos() - self:GetHeight()
end

function DRAW:AlignOnCenter( Module )
	self:SetPos( Module:GetCenter() )
end

function DRAW:GetDistanceInBetween( Module )

	-- Starting from first end to second start
	local xDistance, yDistance
	
	-- First module is in front of the other
	if self:GetWidthPos() > Module:GetWidthPos() then
		xDistance = self:GetCenterLeft() - Module:GetCenterRight()
	end
	
	-- First module is behind the other
	if self:GetWidthPos() < Module:GetWidthPos() then
		xDistance = Module:GetCenterLeft() - self:GetCenterRight()
	end
	
	-- First module is in front of the other
	if self:GetHeightPos() > Module:GetHeightPos() then
		xDistance = self:GetCenterBottom() - Module:GetCenterTop()
	end
	
	-- First module is behind the other
	if self:GetHeightPos() < Module:GetHeightPos() then
		xDistance = Module:GetCenterTop() - self:GetCenterBottom()
	end

	return xDistance, yDistance
end

-- Used for rounded box
local matCorner8, matCorner16 = surface.GetTextureID( "gui/corner8" ), surface.GetTextureID( "gui/corner16" )
	
--[==[---------------------------------
	    Draw module
----------------------------------]==]
function DRAW:Draw()

	-- Draw rotated texture
	if self.IsTextureRectRotated then
		surface.SetDrawColor ( self.Color )
		surface.SetTexture ( self.matTexture )
		surface.DrawTexturedRectRotated ( self:GetWidthPos(), self:GetHeightPos(), self:GetWidth(), self:GetHeight(), self.iRotation )
		
		return
	end

	-- Draw text
	if self.IsText then
		if ( string.len( self.sText ) > 0 ) then
			draw.SimpleText( self.sText, self.sFont, self.xPos, self.yPos, self.Color )
		end
		
		return
	end
	
	-- Draw boxes
	if self.IsBox then
		surface.SetDrawColor ( self.Color )
		surface.DrawRect ( self:GetWidthPos(), self:GetHeightPos(), self:GetWidth(), self:GetHeight() )
		
		return
	end
	
	-- Draw rounded boxes
	if self.IsRoundedBox then
		draw.RoundedBox ( self:GetRound(), self:GetWidthPos(), self:GetHeightPos(), self:GetWidth(), self:GetHeight(), self.Color )
		
		return
	end
	
	-- Draw textured rects
	if self.IsTextureRect then
		surface.SetDrawColor ( self.Color )
		surface.SetTexture ( self.matTexture )
		surface.DrawTexturedRect ( self:GetWidthPos(), self:GetHeightPos(), self:GetWidth(), self:GetHeight() )
		
		return
	end
	
	-- Drawline
	if self.IsLine then
		surface.SetDrawColor ( self.Color )
		surface.DrawLine ( self.x1Pos, self.y1Pos, self.x2Pos, self.y2Pos )
		
		return
	end
	
	-- Roundedbox ex.
	if self.IsRoundedBoxEx then
		surface.SetDrawColor( self.Color )
		
		-- Round'em up
		self.xPos, self.yPos, self.wSize, self.hSize = math.Round ( self.xPos ), math.Round ( self.yPos ), math.Round ( self.wSize ), math.Round ( self.hSize )
		
		--  Draw as much of the rect as we can without textures
		surface.DrawRect( self.xPos + self.iRound, self.yPos, self.wSize - self.iRound * 2, self.hSize )
		surface.DrawRect( self.xPos, self.yPos + self.iRound, self.iRound, self.hSize - self.iRound * 2 )
		surface.DrawRect( self.xPos + self.wSize - self.iRound, self.yPos + self.iRound, self.iRound, self.hSize - self.iRound * 2 )
		
		local matTex = matCorner8
		if ( self.iRound > 8 ) then matTex = matCorner16 end
		
		-- Set correct text. for corner
		surface.SetTexture( matTex )
		
		if ( self.bUpperLeft ) then
			surface.DrawTexturedRectRotated( self.xPos + self.iRound / 2 , self.yPos + self.iRound / 2, self.iRound, self.iRound, 0 ) 
		else
			surface.DrawRect( self.xPos, self.yPos, self.iRound, self.iRound )
		end
		
		if ( self.bUpperRight ) then
			surface.DrawTexturedRectRotated( self.xPos + self.wSize - self.iRound / 2 , self.yPos + self.iRound / 2, self.iRound, self.iRound, 270 ) 
		else
			surface.DrawRect( self.xPos + self.wSize - self.iRound, self.yPos, self.iRound, self.iRound )
		end
		
		if ( self.bBottomLeft ) then
			surface.DrawTexturedRectRotated( self.xPos + self.iRound / 2 , self.yPos + self.hSize - self.iRound / 2, self.iRound, self.iRound, 90 ) 
		else
			surface.DrawRect( self.xPos, self.yPos + self.hSize - self.iRound, self.iRound, self.iRound )
		end
		
		if ( self.bBottomRight ) then
			surface.DrawTexturedRectRotated( self.xPos + self.wSize - self.iRound / 2 , self.yPos + self.hSize - self.iRound / 2, self.iRound, self.iRound, 180 ) 		
		else
			surface.DrawRect( self.xPos + self.wSize - self.iRound, self.yPos + self.hSize - self.iRound, self.iRound, self.iRound )
		end
	end
end

--[==[--------------------------------------------------------------
         Align a draw module in place ( horiz, vertical )
---------------------------------------------------------------]==]
function DRAW:Align( wAlign, hAlign )
	
	-- Align horizontal right
	if wAlign == ALIGN_RIGHT then self:SetWidthPos( self:GetWidthPos() - self:GetWidth() ) end
		
	-- Align horizontal center
	if wAlign == ALIGN_CENTER then self:SetWidthPos( self:GetWidthPos() - math.Round ( self:GetWidth() / 2 ) ) end
	
	-- Align vertical bottom
	if hAlign == ALIGN_BOTTOM then self:SetHeightPos( self:GetHeightPos() + self:GetHeight() ) end
	
	-- Align vertical top
	if hAlign == ALIGN_TOP then self:SetHeightPos( self:GetHeightPos() - self:GetHeight() ) end
	
	-- Align central vertical
	if hAlign == ALIGN_CENTER then self:SetHeightPos( self:GetHeightPos() - math.Round ( self:GetHeight() / 2 ) ) end
end