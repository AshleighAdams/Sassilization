
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
TOOL.Category		= "Constraints"
TOOL.Name			= "#Ball Socket"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "forcelimit" ] = "0"
TOOL.ClientConVar[ "torquelimit" ] = "0"
TOOL.ClientConVar[ "nocollide" ] = "0"

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		if ( CLIENT ) then
		
			self:ClearObjects()
			return true
			
		end
		
		// Get client's CVars
		local forcelimit 	= self:GetClientNumber( "forcelimit", 0 )
		local torquelimit 	= self:GetClientNumber( "torquelimit", 0 )
		local nocollide 	= self:GetClientNumber( "nocollide", 0 )

		// Get information we're about to use
		local Ent1,  Ent2  = self:GetEnt(1),  self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1), self:GetBone(2)
		local LPos	   = self:GetLocalPos(2)

		local constraint = constraint.Ballsocket( Ent1, Ent2, Bone1, Bone2, LPos, forcelimit, torquelimit, nocollide )

		undo.Create("BallSocket")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "constraints", constraint )
		
		// Clear the objects so we're ready to go again
		self:ClearObjects()

	else
	
		self:SetStage( iNum+1 )
		
	end

	return true
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Ballsocket" )
	return bool
	
end
