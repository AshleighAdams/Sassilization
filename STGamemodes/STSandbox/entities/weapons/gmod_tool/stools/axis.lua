
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
TOOL.Category		= "Constraints"
TOOL.Name			= "#Axis"
TOOL.Command		= nil
TOOL.ConfigName		= nil


TOOL.ClientConVar[ "forcelimit" ] = 0
TOOL.ClientConVar[ "torquelimit" ] = 0
TOOL.ClientConVar[ "hingefriction" ] = 0
TOOL.ClientConVar[ "nocollide" ] = 0

function TOOL:LeftClick( trace )

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end
	
	// todo: Don't attempt to constrain the first object if it's already constrained to a static object
	
	local iNum = self:NumObjects()
	
	// Don't allow us to choose the world as the first object
	if (iNum == 0 && !trace.Entity:IsValid()) then return false end
	
	// Don't do jeeps (crash protection until we get it fixed)
	if (iNum == 0 && trace.Entity:GetClass() == "prop_vehicle_jeep") then return false end
	
	// If there's no physics object then we can't constraint it!
	if ( SERVER && !util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) ) then return false end
	
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		// Clientside can bail out now
		if ( CLIENT ) then
		
			self:ClearObjects()
			self:ReleaseGhostEntity()
			
			return true
		
		end
	
		// Get client's CVars
		local forcelimit	= self:GetClientNumber( "forcelimit", 0 )
		local torquelimit 	= self:GetClientNumber( "torquelimit", 0 )
		local friction		= self:GetClientNumber( "hingefriction", 0 )
		local nocollide		= self:GetClientNumber( "nocollide", 0 )
		
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
		local TargetPos = WPos2 + (Phys1:GetPos() - self:GetPos(1)) + (Norm2)

		// Offset slightly so it can rotate
		TargetPos = TargetPos + Norm2
		
		// Set the position
		Phys1:SetPos( TargetPos )
		
		// Wake up the physics object so that the entity updates
		Phys1:Wake()
				
		// Set the hinge Axis perpendicular to the trace hit surface
		LPos1 = Phys1:WorldToLocal( WPos2 + Norm2 )

		// Create a constraint axis
		local constraint = constraint.Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide )

		undo.Create("Axis")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()
		
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

	if ( trace.Entity:IsValid() && trace.Entity:IsPlayer() ) then return end
	
	local iNum = self:NumObjects()
	
	// Don't allow us to choose the world as the first object
	if (iNum == 0 && !trace.Entity:IsValid()) then return false end
	
	local Phys = trace.Entity:GetPhysicsObjectNum( trace.PhysicsBone )
	self:SetObject( iNum + 1, trace.Entity, trace.HitPos, Phys, trace.PhysicsBone, trace.HitNormal )
	
	if ( iNum > 0 ) then
	
		// Clientside can bail out now
		if ( CLIENT ) then
		
			self:ClearObjects()
			self:ReleaseGhostEntity()
			
			return true
		
		end
		
		// Get client's CVars
		local forcelimit	= self:GetClientNumber( "forcelimit", 0 ) 
		local torquelimit 	= self:GetClientNumber( "torquelimit", 0 ) 
		local friction		= self:GetClientNumber( "hingefriction", 0 ) 
		local nocollide		= self:GetClientNumber( "nocollide", 0 ) 
		
		local Ent1,  Ent2  = self:GetEnt(1),	 self:GetEnt(2)
		local Bone1, Bone2 = self:GetBone(1),	 self:GetBone(2)
		local WPos1, WPos2 = self:GetPos(1),	 self:GetPos(2)
		local LPos1, LPos2 = self:GetLocalPos(1),self:GetLocalPos(2)
		local Norm1, Norm2 = self:GetNormal(1),	 self:GetNormal(2)
		local Phys1, Phys2 = self:GetPhys(1), self:GetPhys(2)
		
		// Note: To keep stuff ragdoll friendly try to treat things as physics objects rather than entities
		local Ang1, Ang2 = Norm1:Angle(), (Norm2 * -1):Angle()
		local TargetAngle = Phys1:AlignAngles( Ang1, Ang2 )
		
		//Phys1:SetAngle( TargetAngle )
		
		local TargetPos = WPos2 + (Phys1:GetPos() - self:GetPos(1)) + (Norm2)


		Phys1:Wake()

		// Set the hinge Axis perpendicular to the trace hit surface
		LPos1 = Phys1:WorldToLocal( WPos2 + Norm2 )

		local constraint = constraint.Axis( Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, forcelimit, torquelimit, friction, nocollide )

		undo.Create("Axis")
		undo.AddEntity( constraint )
		undo.SetPlayer( self:GetOwner() )
		undo.Finish()

		self:GetOwner():AddCleanup( "constraints", constraint )

		// Clear the objects so we're ready to go again
		self:ClearObjects()
		self:ReleaseGhostEntity()


	else
	
		self:StartGhostEntity( trace.Entity )
		self:SetStage( iNum+1 )
	
	end

end

function TOOL:Reload( trace )

	if (!trace.Entity:IsValid() || trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local  bool = constraint.RemoveConstraints( trace.Entity, "Axis" )
	return bool
	
end

function TOOL:Think()

	if (self:NumObjects() != 1) then return end
	
	self:UpdateGhostEntity()

end
