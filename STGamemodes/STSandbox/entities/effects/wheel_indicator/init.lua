
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/

EFFECT.Mat = Material( "effects/wheel_ring" )

local WheelEffects = {}

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	local size = 64
	self.Entity:SetCollisionBounds( Vector( -size,-size,-size ), Vector( size,size,size ) )
	
	self.Wheel 	= data:GetEntity()
	
	if (!self.Wheel:IsValid()) then return end
	
	local oldeffect = WheelEffects[ self.Wheel:EntIndex() ]
	if ( oldeffect && oldeffect:IsValid() ) then
	
		oldeffect:Remove()
	
	end
	
	// This 0.01 is a hack.. to prevent the angle being weird and messing up when we change it back to a normal
	self.Entity:SetAngles( data:GetNormal():Angle() + Angle( 0.01, 0.01, 0.01 ) )
	
	self.Entity:SetParent( self.Wheel )

	self.Pos = data:GetOrigin()
	self.Normal = self.Wheel:GetPos() - self.Pos
	self.Alpha = 1
	
	self.Direction = data:GetScale()
	self.Size = self.Wheel:BoundingRadius() + 8
	self.Axis = data:GetOrigin()
	self.Axis = self.Axis
	
	self.Entity:SetPos( self.Wheel:LocalToWorld( self.Axis ) )
	self.Entity:SetParent( self.Wheel )
	
	WheelEffects[ self.Wheel:EntIndex() ] = self.Entity
	
end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if (!self.Wheel:IsValid()) then return end

	local speed = FrameTime()
	
	self.Alpha = self.Alpha - speed * 0.5
	
	if (self.Alpha < 0 ) then return false end
	return true
	
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	if (!self.Wheel:IsValid()) then return end

	if (self.Alpha < 0 ) then return end

	render.SetMaterial( self.Mat )
	
	local Normal = self.Wheel:LocalToWorld( self.Axis ) - self.Wheel:GetPos()

	render.DrawQuadEasy( self.Wheel:GetPos() + Normal,
						 Normal:GetNormalized() * self.Direction,
						 self.Size, self.Size,
						 Color( 255, 255, 255, (self.Alpha ^ 1.1) * 255 ),
						 self.Alpha * 200 )
				

end
