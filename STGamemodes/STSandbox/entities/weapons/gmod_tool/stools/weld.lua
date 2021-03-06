
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
TOOL.Category		= "Constraints"
TOOL.Name			= "#Weld"
TOOL.Command		= nil
TOOL.ConfigName		= nil

/*

	To see the constraints do :

		ent_bbox phys_constraint

*/

TOOL.ClientConVar[ "forcelimit" ]		= "0"
TOOL.ClientConVar[ "nocollide" ]		= "0"

function TOOL:LeftClick( trace )

	if (trace.Entity:IsValid() && trace.Entity:IsPlayer()) then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end

	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( CLIENT ) then
	
		if ( iNum > 0 ) then self:ClearObjects() end
		
		return true
		
	end

	if ( iNum > 0 ) then
	
		// Get client's CVars
		local forcelimit = self:GetClientNumber( "forcelimit" )
		local nocollide  = ( self:GetClientNumber( "nocollide" ) == 1 )

		// Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),  self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)

		local constraint = constraint.Weld( Ent1, Ent2, Bone1, Bone2, forcelimit, nocollide )
		if (constraint) then 
		
			undo.Create("Weld")
			undo.AddEntity( constraint )
			undo.SetPlayer( self:GetOwner() )
			undo.Finish()
			
			self:GetOwner():AddCleanup( "constraints", constraint )
		
		end

		// Clear the objects so we're ready to go again
		self:ClearObjects()

	else
	
		self:SetStage( iNum+1 )
	
	end
	
	return true

end

function TOOL:RightClick( trace )

	// This was doing stuff that was totally overcomplicated
	// And I'm guessing no-one ever used it - because it didn't work

	return false
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Weld" )
	return bool
	
end
