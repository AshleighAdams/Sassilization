
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
TOOL.Category		= "Constraints"
TOOL.Name			= "#Motor"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "torque" ] = "500"
TOOL.ClientConVar[ "friction" ] = "1"
TOOL.ClientConVar[ "nocollide" ] = "1"
TOOL.ClientConVar[ "forcetime" ] = "0"
TOOL.ClientConVar[ "fwd" ] = "1"
TOOL.ClientConVar[ "bwd" ] = "2"
TOOL.ClientConVar[ "toggle" ] = "0"
TOOL.ClientConVar[ "forcelimit" ] = "0"

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end

	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local iNum = self:NumObjects()

	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	
	// Don't allow us to choose the world as the first object
	if (iNum == 0 && !trace.Entity:IsValid()) then return end
	
	// Don't allow us to choose the same object
	if (iNum == 1 && trace.Entity == self:GetEnt(1) ) then return end
	
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		if ( CLIENT ) then
		
			self:ClearObjects()
			self:ReleaseGhostEntity()
			
			return true
			
		end
		
		// Get client's CVars
		local torque		= self:GetClientNumber( "torque" )
		local friction 		= self:GetClientNumber( "friction" )
		local nocollide		= self:GetClientNumber( "nocollide" )
		local time			= self:GetClientNumber( "forcetime" )
		local forekey		= self:GetClientNumber( "fwd" )
		local backkey		= self:GetClientNumber( "bwd" )
		local toggle		= self:GetClientNumber( "toggle" )
		local limit			= self:GetClientNumber( "forcelimit" )
		
		local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
		local WPos1, WPos2 = self:GetPos(1),	 self:GetPos(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
		local Norm1, Norm2 = self:GetNormal(1),	 self:GetNormal(2)
		local Phys1, Phys2 = self:GetPhys(1), self:GetPhys(2)
		
		// Note: To keep stuff ragdoll friendly try to treat things as physics objects rather than entities
		local Ang1, Ang2 = Norm1:Angle(), (Norm2 * -1):Angle()
		local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )
		
		Phys1:SetAngle( TargetAngle )
		
		// Move the object so that the hitpos on our object is at the second hitpos
		local TargetPos = WPos2 + (Phys1:GetPos() - self:GetPos(1))

		// Offset slightly so it can rotate
		TargetPos = TargetPos + (2*Norm2)

		// Set the position
		Phys1:SetPos( TargetPos )

		// Wake up the physics object so that the entity updates
		Phys1:Wake()

		// Set the hinge Axis perpendicular to the trace hit surface
		LPos1 = Phys1:WorldToLocal( WPos2 + Norm2 * 64 )

		local constraint, axis = constraint.Motor( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, friction, torque, time, nocollide, toggle, self:GetOwner(), limit, forekey, backkey, 1 )

		undo.Create("Motor")
		undo.AddEntity( axis )
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
		self:GetOwner():AddCleanup( "constraints", axis )
		self:GetOwner():AddCleanup( "constraints", constraint )

		// Clear the objects so we're ready to go again
		self:ClearObjects()
		self:ReleaseGhostEntity()

	else
	
		self:StartGhostEntity( trace.Entity )
		self:SetStage( iNum+1 )
		
	end
	
	return true
	
end

function TOOL:RightClick( trace )
	
	return false
	
end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Motor" )
	return bool
	
end

function TOOL:Think()

	if (self:NumObjects() != 1) then return end
	
	self:UpdateGhostEntity()

end
