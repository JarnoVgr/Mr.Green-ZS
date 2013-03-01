-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

//Global table
graph = {}

//On entities initiailize
function OnEntitiesInit()

	//Create a graph talbe
	graph = CreateNodeSystem()
	
	//Now add spawns as seed
	for k,v in pairs ( ents.FindByClass( "info_player_*" ) ) do
		graph:AddSeed( v:GetPos() )
	end
	
	//Create it
	graph:ComputeNodes()	
end
//hook.Add( "InitPostEntity", "GraphCreate", OnEntitiesInit )
