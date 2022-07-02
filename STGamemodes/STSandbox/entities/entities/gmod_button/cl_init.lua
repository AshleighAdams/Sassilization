
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
include('shared.lua')

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()

	if ( LocalPlayer():GetEyeTrace().Entity == self.Entity && EyePos():Distance( self.Entity:GetPos() ) < 512 ) then
	
		if ( self:IsOn() ) then
			self:DrawEntityOutline( 1.05 + math.sin( CurTime() * 60 ) * 0.05 )
		else
			self:DrawEntityOutline( 1.0 )
		end
	
	end
	
	self:Draw()
	
end
