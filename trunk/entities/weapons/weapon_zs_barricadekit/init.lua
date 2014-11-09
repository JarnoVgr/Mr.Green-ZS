AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false
SWEP.PrintName = "barricade kit"
SWEP.ViewModel = Model ( "models/weapons/c_rpg.mdl" )
SWEP.WorldModel = Model ( "models/weapons/w_rocket_launcher.mdl" )
SWEP.UseHands = true
SWEP.WalkSpeed = 190
SWEP.Models = { "models/props_interiors/radiator01a.mdl", "models/props_junk/trashbin01a.mdl" }
SWEP.ModelOBB = { [1] = { Min = Vector( -5.2500, -25.2500, -18.4771 ) , Max = Vector ( 5.2500 ,25.0245 ,18.2500 )  }, [2] = { Min = Vector( -13.2614 ,-12.0523 ,-20.2876 ) , Max = Vector ( 13.2614, 12.0523 ,20.3897 )  } }
SWEP.DrawCrosshair = true

function SWEP:Deploy()
	self.Owner:DrawViewModel( true )
	self.Owner:DrawWorldModel( true )

	GAMEMODE:WeaponDeployed ( self.Owner, self )

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
		
end

function SWEP:ViewModelDrawn()
		local viewmodel = LocalPlayer():GetViewModel()
		local attachmentIndex = viewmodel:LookupAttachment("muzzle")
        render.SetModel( "models/props_debris/wood_board07a.mdl" )
		--render.DrawBeam(viewmodel:GetAttachment(attachmentIndex).Pos, self.Owner:GetEyeTrace().HitPos, 2, 0, 12.5, Color(255, 0, 0, 255))
end

function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")
	self:SetModelToSpawn ( 1 )
end

function SWEP:SetModelToSpawn ( int ) 
	self.Weapon:SetNetworkedInt ( "ModelToSpawn", int )
end

function SWEP:GetModelToSpawn()
	return self.Models [self.Weapon:GetNetworkedInt ( "ModelToSpawn" )]
end


function SWEP:GetPlankSpawnPos( )
	local _p = self.Owner;
	if ( !IsValid( _p ) ) then return false; end

	-- Initialize Variables and grab essential data
	local _bCanSpawn = false;
	local _shootpos = _p:GetShootPos( );
	local _aimvec = _p:GetAimVector( );

	-- EndPos is up to 60 units or 3.75 FEET away as 4/3 = 1 inch in source-units, and 16 source units = 1 foot.
	local _endpos = _shootpos + _aimvec * 100

	--Set up our Trace Structure...
	local _trdata = {
		start	= _shootpos;
		endpos	= _endpos;
		filter	= self.Owner; -- Can also use player.GetAll( );
		mask	= MASK_NPCWORLDSTATIC;
		mins	= WALL_MINS_VECTOR;
		maxs	= WALL_MAXS_VECTOR;
	};
	local _tr = util.TraceHull( _trdata );

	-- If our trace hit something, and the thing it his is the world
	if ( _tr.Hit && _tr.HitWorld ) then
		-- Allow the spawn!
		_bCanSpawn = true;
	end

	-- Ternary operation. If _bCanSpawn is true, it'll return the position to spawn the object at, otherwise false.
	return _bCanSpawn && _tr.HitPos || false;	
	
end



-- Primary Attack - this function is used to ensure the prop gets spawned... Or not..

function SWEP:PrimaryAttack( )

	local cades = 0
	local planks = 0
	
	for k,v in pairs(ents.FindByClass("aegis")) do --Lets limit the amount of planks they can spawn.
		if v and v:GetOwner() == self.Owner then
			planks = planks + 1
		end
	end
	
	if planks > 5 then --More than five will just be spam! 
		if SERVER then
			self.Owner:Message("You can't place more than 5 planks on the ground!",1,"white")
		end
		return
	end

	local _p = self.Owner;

	-- Make sure the Owner is valid, and the owner is on the ground, and the CLIENT doesn't spam ( its how SWEPs work... )
	if ( !IsValid( _p ) || !self:CanPrimaryAttack( ) || !_p:OnGround( ) || !IsFirstTimePredicted( ) ) then return; end


--	 Update next-fire time
	self:SetNextPrimaryFire( CurTime( ) + 1 );

	-- Take ammo ( Without IsFirstTimePredicted, this would desync on the client... )
	--self:TakePrimaryAmmo( 1 );

	-- Server only code... This is where the entity gets spawned, client doesn't need this...
	if ( SERVER ) then
		-- Perform the test to see if we can spawn or not
		local _pos = self:GetPlankSpawnPos( _p );

		-- Because of how we set up the return statement, If it is set then it is a position, otherwise it is false and won't do anything
		if ( _pos ) then
			self:TakePrimaryAmmo( 1 );
			local _ent = ents.Create( "aegis" );
			if ( !IsValid( _ent ) ) then
				error( "Error Spawning aegis; invalid entity name!" );
			end
			_ent:SetPos( _pos );
			_ent:SetAngles( angle_zero );
			_ent:EmitSound( "npc/dog/dog_servo12.wav" );
			_ent:Spawn( );
			_ent:Activate( );

			--//Freeze it
			local Phys = _ent:GetPhysicsObject( );
			if ( Phys:IsValid( ) ) then
				Phys:EnableMotion( false );
			end
		else
			self.Owner:Message("You can't spawn planks there!",1,"white")
			print( "Error spawning aegis... INVALID POSITION!" )
			return
		end
	end
end 
  
  
  
local sIndex = 1
function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	
	--Cycle through the models
--	if sIndex <= #self.Models then
	--	sIndex = sIndex + 1
	--end
				
	--if sIndex > #self.Models then
	--	sIndex = 1
--	end
	
	--Set the model to spawn
	--self:SetModelToSpawn ( sIndex )
	
	local cades = 0
	local planks = 0
	
	for k,v in pairs(ents.FindByClass("aegis2")) do --Lets limit the amount of planks they can spawn.
		if v and v:GetOwner() == self.Owner then
			planks = planks + 1
		end
	end
	
	if planks > 5 then --More than five will just be spam! 
		if SERVER then
			self.Owner:Message("You can't place more than 5 planks on the ground!",1,"white")
		end
		return
	end

	local _p = self.Owner;

	-- Make sure the Owner is valid, and the owner is on the ground, and the CLIENT doesn't spam ( its how SWEPs work... )
	if ( !IsValid( _p ) || !self:CanPrimaryAttack( ) || !_p:OnGround( ) || !IsFirstTimePredicted( ) ) then return; end


--	 Update next-fire time
	self:SetNextPrimaryFire( CurTime( ) + 1 );

	-- Take ammo ( Without IsFirstTimePredicted, this would desync on the client... )
	--self:TakePrimaryAmmo( 1 );

	-- Server only code... This is where the entity gets spawned, client doesn't need this...
	if ( SERVER ) then
		-- Perform the test to see if we can spawn or not
		local _pos = self:GetPlankSpawnPos( _p );

		-- Because of how we set up the return statement, If it is set then it is a position, otherwise it is false and won't do anything
		if ( _pos ) then
			self:TakePrimaryAmmo( 1 );
			local _ent = ents.Create( "aegis2" );
			if ( !IsValid( _ent ) ) then
				error( "Error Spawning aegis; invalid entity name!" );
			end

			_ent:SetPos( _pos );
			_ent:SetAngles( angle_zero );
			_ent:Spawn( );
			_ent:EmitSound( "npc/dog/dog_servo12.wav" );
			_ent:Activate( );

			--//Freeze it
			local Phys = _ent:GetPhysicsObject( );
			if ( Phys:IsValid( ) ) then
				Phys:EnableMotion( false );
			end
		else
			self.Owner:Message("You can't spawn planks there!",1,"white")
			print( "Error spawning aegis... INVALID POSITION!" )
			return
		end
	end
	
end

function SWEP:OnDrop()
	if self and self:IsValid() then
		self:Remove()
	end
end
