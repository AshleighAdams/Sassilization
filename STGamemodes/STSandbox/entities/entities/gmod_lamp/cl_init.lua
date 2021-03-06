
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
include('shared.lua')

local matLight 		= Material( "sprites/light_ignorez" )
local matBeam		= Material( "effects/lamp_beam" )

ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Initialize()

	self.PixVis = util.GetPixelVisibleHandle()
	
end

/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()

	self.BaseClass.Draw( self )
	
end

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()
	
	self.BaseClass.DrawTranslucent( self )
	
	// No glow if we're not switched on!
	if ( !self:GetOn() ) then return end
	
	local LightNrm = self.Entity:GetAngles():Up()
	local ViewNormal = self.Entity:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm )
	local r, g, b, a = self:GetColor()
	local LightPos = self.Entity:GetPos() + LightNrm * -6
	
	// glow sprite
	/*
	render.SetMaterial( matBeam )
	
	local BeamDot = BeamDot = 0.25
	
	render.StartBeam( 3 )
		render.AddBeam( LightPos + LightNrm * 1, 128, 0.0, Color( r, g, b, 255 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 100, 128, 0.5, Color( r, g, b, 64 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 200, 128, 1, Color( r, g, b, 0) )
	render.EndBeam()
	*/

	if ( ViewDot >= 0 ) then
	
		render.SetMaterial( matLight )
		local Visibile	= util.PixelVisible( LightPos, 16, self.PixVis )	
		
		if (!Visibile) then return end
		
		local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 64, 512 )
		
		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( (1000 - Distance) * Visibile * ViewDot, 0, 100 )
		local Col = Color( r, g, b, Alpha )
		
		render.DrawSprite( LightPos, Size, Size, Col, Visibile * ViewDot )
		render.DrawSprite( LightPos, Size*0.4, Size*0.4, Color(255, 255, 255, Alpha), Visibile * ViewDot )
		
	end
	
end

/*---------------------------------------------------------
   Overridden because I want to show the name of the 
   player that spawned it..
---------------------------------------------------------*/
function ENT:GetOverlayText()

	return self:GetPlayerName()	
	
end
