// Thanks to Kogitsune for the code
// http://www.facepunch.com/showthread.php?p=24290611
// Basically allows calling HookOutput on any created entity

ENT.Base = "base_point"
ENT.Type = "point"

ENT.Hooks = { }

local catch = NULL
local metaEntity = FindMetaTable( "Entity" )
function metaEntity:HookOutput( name, unique, func )
	if not ValidEntity( catch ) then
		catch = ents.Create( "outputhook" )
		catch:Spawn( )
		catch:SetName( "outputhook" )
	end
	
	self:Fire( "addoutput", name .. " outputhook," .. name )
	
	if not catch.Hooks[ self ] then
		catch.Hooks[ self ] = { }
	end
	
	if not catch.Hooks[ self ][ name ] then
		catch.Hooks[ self ][ name ] = { }
	end
	
	catch.Hooks[ self ][ name ][ unique ] = func
end

function metaEntity:UnhookOutput( name, unique )
	if not ValidEntity( catch ) then
		catch = ents.Create( "outputhook" )
		catch:Spawn( )
		catch:SetName( "outputhook" )
	end
	
	if not catch.Hooks[ self ] then
		catch.Hooks[ self ] = { }
	end
	
	if not catch.Hooks[ self ][ name ] then
		catch.Hooks[ self ][ name ] = { }
	end
	
	catch.Hooks[ self ][ name ][ unique ] = nil
end

function ENT:AcceptInput( name, activator, caller, data )
	local k, v, ok, err
	
	if not self.Hooks[ caller ] then
		return false
	end
	
	if not self.Hooks[ caller ][ name ] then
		return false
	end
	
	for k, v in pairs( self.Hooks[ caller ][ name ] ) do
		ok, err = pcall( v, activator, data )
		
		if not ok then
			ErrorNoHalt( string.format( "OutputHook %q failed: %q\n", name .. k, err ) )
		end
	end
	
	return false
end

--ClavusElite: entity:HookOutput(<output name from SDK wiki>, <unique name>, callback function)
