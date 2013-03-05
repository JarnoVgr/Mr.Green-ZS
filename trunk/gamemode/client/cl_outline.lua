-- © Limetric Studios ( www.limetricstudios.com ) -- All rights reserved.
-- See LICENSE.txt for license information

--[=[ -- -- L4D style player and items outlining

-- local Colors = {}
-- Colors.Green = { r =  0, b = 255, g = 0 }
-- Colors.Zombies = { r =  154, b = 143, g = 47 }

-- local MaterialBlurX = Material( "pp/blurx" );  
-- local MaterialBlurY = Material( "pp/blury" );  
-- local MaterialWhite = CreateMaterial( "WhiteMaterial", "VertexLitGeneric", {  
    -- ["$basetexture"] = "color/white",  
    -- ["$vertexalpha"] = "1",  
    -- ["$model"] = "1",  
-- } );  
-- local MaterialComposite = CreateMaterial( "CompositeMaterial", "UnlitGeneric", {  
    -- ["$basetexture"] = "_rt_FullFrameFB",  
    -- ["$additive"] = "1",  
-- } );  
  
-- --  we need two render targets, if you don't want to create them yourself, you can  
-- --  use the bloom textures, they are quite low resolution though.  
-- --  render.GetBloomTex0() and render.GetBloomTex1();  
local RT1 = GetRenderTarget( "L4D1" );  
local RT2 = GetRenderTarget( "L4D2" );  
  
-- --[==[------------------------------------  
    -- RenderToStencil()  
----------------------------------]==]  
-- local function RenderToStencil( entity )  
  
    -- --  tell the stencil buffer we're going to write a value of one wherever the model  
    -- --  is rendered  
    -- render.SetStencilEnable( true );  
    -- render.SetStencilFailOperation( STENCILOPERATION_KEEP );  
    -- render.SetStencilZFailOperation( STENCILOPERATION_KEEP );  
    -- render.SetStencilPassOperation( STENCILOPERATION_REPLACE );  
    -- render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS );  
    -- render.SetStencilWriteMask( 1 );  
    -- render.SetStencilReferenceValue( 1 );  
      
    -- --  this uses a small hack to render ignoring depth while not drawing color  
    -- --  i couldn't find a function in the engine to disable writing to the color channels  
    -- --  i did find one for shaders though, but I don't feel like writing a shader for this.  
    -- cam.IgnoreZ( true );  
        -- render.SetBlend( 0 );  
			
			-- entity:SetModelScale ( Vector ( 1.2, 1.2, 1.2 ) )
		  
            -- SetMaterialOverride( MaterialWhite );  
                -- entity:DrawModel();  
            -- SetMaterialOverride(); 

			-- entity:SetModelScale ( Vector ( 1, 1, 1 ) )			
              
        -- render.SetBlend( 1 );  
    -- cam.IgnoreZ( false );  
      
    -- --  don't need this for the next pass  
    -- render.SetStencilEnable( false );  
  
-- end  
  
-- --[==[------------------------------------  
    -- RenderToGlowTexture()  
----------------------------------]==]  
-- local function RenderToGlowTexture( entity )  
  
    -- local w, h = ScrW(), ScrH();
	-- local Color = { r = 255, g = 0, b = 0 } 
	
	-- if entity:IsPlayer() then
		-- if MySelf:Team() == TEAM_UNDEAD then
			-- if entity:Team() == TEAM_UNDEAD then
				-- Color = Colors.Zombies
			-- elseif entity:Team() == TEAM_HUMAN then
				-- local health = entity:Health()
				-- Color = { r = ( 255 - health * 2 ), g = ( health * 2.1 ), b = 30 }
			-- end
		-- elseif MySelf:Team() == TEAM_HUMAN then
			-- if entity:Team() == TEAM_HUMAN then
				-- local health = entity:Health()
				-- Color = { r = ( 255 - health * 2 ), g = ( health * 2.1 ), b = 30 }
			-- else return end
		-- end
	-- end
		
	-- --  draw into the white texture  
   local oldRT = render.GetRenderTarget();  
   render.SetRenderTarget( RT1 );  
       render.SetViewPort( 0, 0, w, h );  
          
        -- cam.IgnoreZ( true );  
          
            -- render.SuppressEngineLighting( true );  
            -- render.SetColorModulation( Color.r / 255, Color.g / 255, Color.b / 255 );           --  Set color of glow here  
              
                -- SetMaterialOverride( MaterialWhite );  
                    -- entity:DrawModel();  
                -- SetMaterialOverride();  
				
				
                  
            -- render.SetColorModulation( 1, 1, 1 );  
            -- render.SuppressEngineLighting( false );  
              
        -- cam.IgnoreZ( false );  
          
		render.SetViewPort( 0, 0, w, h );  
    render.SetRenderTarget( oldRT );  
  
-- end  
  
-- --[==[------------------------------------  
    -- RenderScene()  
----------------------------------]==]  
local function RenderScene( Origin, Angles )  
  
    local oldRT = render.GetRenderTarget();  
	render.SetRenderTarget( RT1 );  
	render.Clear( 0, 0, 0, 255, true );  
	render.SetRenderTarget( oldRT );   
  
end  
hook.Add( "RenderScene", "ResetGlow", RenderScene );  
  
-- --[==[------------------------------------  
    -- RenderScreenspaceEffects()  
----------------------------------]==]  
-- local function RenderScreenspaceEffects( )  
  
    MaterialBlurX:SetMaterialTexture( "$basetexture", RT1 );  
    MaterialBlurY:SetMaterialTexture( "$basetexture", RT2 );  
    MaterialBlurX:SetMaterialFloat( "$size", 2 );  
    MaterialBlurY:SetMaterialFloat( "$size", 2 );  
          
    local oldRT = render.GetRenderTarget();  
      
    --  blur horizontally  
    render.SetRenderTarget( RT2 );  
    render.SetMaterial( MaterialBlurX );  
    render.DrawScreenQuad();  
  
    --  blur vertically  
    render.SetRenderTarget( RT1 );  
    render.SetMaterial( MaterialBlurY );  
    render.DrawScreenQuad();  
  
   render.SetRenderTarget( oldRT );  
      
    -- --  tell the stencil buffer we're only going to draw  
    -- --  where the player models are not.  
    -- render.SetStencilEnable( true );  
    -- render.SetStencilReferenceValue( 0 );  
    -- render.SetStencilTestMask( 1 );  
    -- render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL );  
    -- render.SetStencilPassOperation( STENCILOPERATION_ZERO );  
      
    -- --  composite the scene  
    -- MaterialComposite:SetMaterialTexture( "$basetexture", RT1 );  
    -- render.SetMaterial( MaterialComposite );  
    -- render.DrawScreenQuad();  
  
    -- --  don't need this anymore  
    -- render.SetStencilEnable( false );  
  
-- end  
-- hook.Add( "RenderScreenspaceEffects", "CompositeGlow", RenderScreenspaceEffects );  
  
-- --[==[------------------------------------  
    -- PrePlayerDraw()  
----------------------------------]==]  
-- local function PostPlayerDraw( pl )  
  
	-- if ( ScrW() == ScrH() ) then return; end  
  
    -- --  prevent recursion  
    -- if( OUTLINING_PLAYER ) then return; end  
    -- OUTLINING_PLAYER = true;  
      
    -- RenderToStencil( pl );  
	-- RenderToGlowTexture( pl );  
      
    -- --  prevents recursion time  
    -- OUTLINING_PLAYER = false;  
      
-- end  
-- hook.Add( "PrePlayerDraw", "RenderGlow", PostPlayerDraw );  

 ]=]