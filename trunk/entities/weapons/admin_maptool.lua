if SERVER then
	AddCSLuaFile()
	SWEP.HoldType = "pistol"	
end

SWEP.Category = "ZS Map Tools"

SWEP.ViewModel	= Model("models/weapons/v_toolgun.mdl")
SWEP.WorldModel	= Model("models/weapons/w_toolgun.mdl")

SWEP.Spawnable = true
SWEP.AdminOnly	= true

SWEP.HumanSpawns = {
	"info_player_combine", 
	"info_player_terrorist",
	"info_player_human",
	"info_player_start",
	"info_player_deathmatch",
	"gmod_player_start"
}

SWEP.ZombieSpawns = {
	"info_player_undead",
	"info_player_zombie",
	"info_player_rebel",
	"info_player_counterterrorist",
	"info_zombiespawn",
	"info_player_start",
	"gmod_player_start"
}

if CLIENT then

	SWEP.PrintName = "Map Tool"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
	SWEP.Author	= ""
	SWEP.Slot = 4
	SWEP.SlotPos = 4
	SWEP.Contact = ""
    SWEP.Purpose = ""
    SWEP.Instructions = ""
end

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 0
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.01
SWEP.NextReload = 3

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"
SWEP.Secondary.Delay = 0.01

SWEP.Primary.Sound = Sound("buttons/button15.wav")

--Don't touch this
local EntsToDelete = {}
local PointsTable = {}

SWEP.AmmoBoxTable = {}
SWEP.AmmoBoxTable2 = {}


SWEP.SpawnsTable = {}

function SWEP:Initialize()
	--Ammo box switch
	self:SetDTBool(0, false)

	--(Re)Create all crates
	gamemode.Call("SpawnCratesFromTable", AllCrateSpawns, true)
	

	if SERVER then
		--Parse existing ammo boxes
		for _, tbl in pairs(AllCrateSpawns) do
			local ent = tbl.ent
			if not ent then
				Debug("[MAPTOOL] Failed to parse a Supply Crates.")
				continue
			end

			table.insert(self.AmmoBoxTable2, ent)
			table.insert(self.AmmoBoxTable, {
				Pos = {
					ent:GetPos().x,
					ent:GetPos().y,
					ent:GetPos().z
				},
				Angles = {
					ent:GetAngles().p,
					ent:GetAngles().y,
					ent:GetAngles().r
				}
			})
		end

		Debug("[MAPTOOL] Parsed ".. #self.AmmoBoxTable .." Supply Crates.")
	end
end

function SWEP:SpawnAmmoBox()
	local trace = self.Owner:GetEyeTrace()
	
	local pos = trace.HitPos
	
	--[[local ent = ents.Create ( "prop_physics_multiplayer" )
	ent:SetPos ( pos )// + vector_up*25
	ent:SetAngles(Angle(0,0,0))//Angle(0,(Switched and 90 or 0),90)
	ent:SetModel ( "models/Items/item_item_crate.mdl" )//"models/props_interiors/VendingMachineSoda01a.mdl"
	ent:SetColor (Color(0,255,0,200))
	ent:SetMaterial("models/debug/debugwhite")
	--ent:SetCollisionGroup ( COLLISION_GROUP_DEBRIS )
	ent.CrateDummy = true
	--ent.CrateIndex = #self.AmmoBoxTable+1
	ent:Spawn()]]
	
	
	
	--print("Spawning Crate index: "..ent.CrateIndex)

	--[[local Phys = ent:GetPhysicsObject()
	if IsValid ( Phys ) then
		Phys:EnableMotion ( false )
	end]]

	--Get proper angles
	local angles = self.Owner:GetAimVector():Angle()
	
	local ent = ents.Create("game_supplycrate")
	ent:SetPos(pos)
	ent:SetAngles(Angle(0,angles.y,angles.r))
	ent:Spawn()

	

	local PosTableSupply = { Pos = {trace.HitPos.x,trace.HitPos.y,trace.HitPos.z}, Angles = {0,angles.y,angles.r} }
	--self.AmmoBoxTable2[#self.AmmoBoxTable+1] = ent
	--self.AmmoBoxTable[ent.CrateIndex] = PosTableSupply
	table.insert(self.AmmoBoxTable2, ent)
	table.insert(self.AmmoBoxTable, PosTableSupply)
	
	Debug("[MAPTOOL] Added Crate")
end

function SWEP:RemoveAmmoBox(ent)
	local ind = 0
	
	for i,crate in pairs(self.AmmoBoxTable2) do
		if crate == ent then
			ind = i
		end
	end
	
	ent:Remove()
	
	self.AmmoBoxTable2[ind] = nil
	self.AmmoBoxTable[ind] = nil
	
	table.Resequence(self.AmmoBoxTable)
	table.Resequence(self.AmmoBoxTable2)
	
	Debug("[MAPTOOL] Removed Crate #".. ind)
end

function SWEP:Think()
end

--[[---------------------------------------------------------------------------------
       Saves Ammo Box Locations from the developer tool - don't touch!
----------------------------------------------------------------------------------]]
if SERVER then
	local function SaveAmmoPoints ( pl, cmd, args )
		if not pl:IsAdmin() then return end
		
		local filename = "zombiesurvival/crates/".. game.GetMap() ..".txt"
		
		local Tool = pl:GetWeapon ( "admin_maptool" )
		if Tool == nil then return end
		
		if !file.Exists ("zombiesurvival/crates","DATA") then
			Debug("[MAPTOOL] 'zombiesurvival/crates' folder didn't exist. Created it for you.")
			file.CreateDir("zombiesurvival/crates")
		end
			
		file.Write(filename,util.TableToJSON(Tool.AmmoBoxTable or {}))
		Debug("[MAPTOOL] Saved crates to 'data/zombiesurvival/crates/".. game.GetMap() ..".txt'")
	end

	concommand.Add("zs_maptool_save", SaveAmmoPoints)
end

function SWEP:Reload()
	if self.NextReload > CurTime() then
		return
	end
	
	if CLIENT then		
		gui.EnableScreenClicker(true)
		Derma_Query("Are you sure you want to save current Supply Crates positions to file?", "Warning!","Yes", function()
			RunConsoleCommand("zs_maptool_save")
			timer.Simple(0.2, function ()
				Derma_Query("You've saved the Supply Crates positions to 'data/zombiesurvival/crates/".. game.GetMap() ..".txt'", "Way to go!","Continue", function()
					gui.EnableScreenClicker(false)
				end)
			end)
		end, "No", function()
			gui.EnableScreenClicker(false)
		end)
	end
	
	self.NextReload = CurTime() + 3
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		local tr = self.Owner:GetEyeTrace()
		local HitPos, Ent = tr.HitPos + tr.HitNormal * 16, tr.Entity 
		
		if Ent and IsValid(Ent) then
			if Ent:GetClass() == "game_supplycrate" then
				self:RemoveAmmoBox(Ent)
				self.Owner:Message("Removed Supply Crate")
			else
				self.Owner:Message("Can't remove a non-Supply Crate entity")
			end
		elseif tr.HitWorld then
			self:SpawnAmmoBox(self:GetDTBool(0))
			self.Owner:Message("Spawned Supply Crate")
		else
			self.Owner:Message("Can't spawn Supply Crate here")
		end
		
		--Weapon animation
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	if SERVER then
		self:SetDTBool ( 0 , not self:GetDTBool ( 0 ) ) 
	end	
end

if SERVER then
	util.AddNetworkString( "map_tool_SendHumanSpawns" )
	util.AddNetworkString( "map_tool_SendZombieSpawns" )

	function SWEP:MakeSpawnTables()
		if not self.ActualHumanSpawns then
			self.ActualHumanSpawns = {}
			for _,class in pairs(self.HumanSpawns) do
				local points = ents.FindByClass(class)
				for k,v in pairs(points) do
					if class == "gmod_player_start" and not v.BlueTeam then continue end
					table.insert(self.ActualHumanSpawns,v:GetPos())
				end
			end

			net.Start("map_tool_SendHumanSpawns")
				net.WriteTable(self.ActualHumanSpawns)
			net.Send(self.Owner)
		end
		if not self.ActualZombieSpawns then
			self.ActualZombieSpawns = {}
			for _,class in pairs(self.ZombieSpawns) do
				local points = ents.FindByClass(class)
				for k,v in pairs(points) do
					if class == "gmod_player_start" and v.BlueTeam then continue end
					table.insert(self.ActualZombieSpawns,v:GetPos())
				end
			end
			net.Start("map_tool_SendZombieSpawns")
				net.WriteTable(self.ActualZombieSpawns)
			net.Send(self.Owner)
		end
	end
end

if CLIENT then
	net.Receive( "map_tool_SendHumanSpawns", function( len )

		local points = net.ReadTable()
		
		if not map_tool_HumanSpawns then
			map_tool_HumanSpawns = {}
		end
		
		map_tool_HumanSpawns = table.Copy(points)
	end)

	net.Receive( "map_tool_SendZombieSpawns", function( len )

		local points = net.ReadTable()
		
		if not map_tool_ZombieSpawns then
			map_tool_ZombieSpawns = {}
		end
		
		map_tool_ZombieSpawns = table.Copy(points)
	end)

	function SWEP:DrawHUD()
		local pos = nil
		if map_tool_HumanSpawns then
			for _,vec in pairs(map_tool_HumanSpawns) do
				pos = (vec+vector_up*15):ToScreen()
				draw.SimpleText( "H", "ScoreboardDefaultTitle", pos.x, pos.y,  Color(0, 160, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		
		if map_tool_ZombieSpawns then
			for _,vec in pairs(map_tool_ZombieSpawns) do
				pos = (vec+vector_up*15):ToScreen()
				draw.SimpleText( "Z", "ScoreboardDefaultTitle", pos.x, pos.y,  Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
	end
end

function SWEP:Holster(weapon)
	return true
end 

function SWEP:OwnerChanged(Owner)
end

function SWEP:Deploy()
	if SERVER then
		local owner = self.Owner
		local effectdata = EffectData()
		effectdata:SetEntity(owner)
		effectdata:SetOrigin(owner:GetShootPos() + owner:GetAimVector() * 32)
		util.Effect("map_crate_ghost", effectdata, true, true)
		self:MakeSpawnTables()
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
end 

function table.Resequence(oldtable)
	local newtable = table.Copy(oldtable)
	local id = 0
	
	--Clear old table
	table.Empty(oldtable)
	
	--Write the new one
	for k,v in pairs(newtable) do
		id = id + 1
		oldtable[id] = newtable[k]
	end
end
