
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local Thruster_Sound 	= Sound( "PhysicsCannister.ThrusterLoop" )


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	local max = self.Entity:OBBMaxs()
	local min = self.Entity:OBBMins()
	
	self.ThrustOffset 	= Vector( 0, 0, max.z )
	self.ThrustOffsetR 	= Vector( 0, 0, min.z )
	self.ForceAngle		= self.ThrustOffset:GetNormalized() * -1
	
	self:SetForce( 2000 )
	
	self:SetEffect( "Fire" )

	self:SetOffset( self.ThrustOffset )
	self.Entity:StartMotionController()
	
	self:Switch( false )
	self.ActivateOnDamage = true
	
end


/*---------------------------------------------------------
   Name: OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()

	if (self.Sound) then
		self.Sound:Stop()
	end

end


/*---------------------------------------------------------
   Name: SetForce
---------------------------------------------------------*/
function ENT:SetForce( force, mul )

	if (force) then	self.force = force end
	mul = mul or 1
	
	local phys = self.Entity:GetPhysicsObject()
	if (!phys:IsValid()) then 
		Msg("Warning: [gmod_thruster] Physics object isn't valid!\n")
		return 
	end
	
	// Get the data in worldspace
	local ThrusterWorldPos = phys:LocalToWorld( self.ThrustOffset )
	local ThrusterWorldForce = phys:LocalToWorldVector( self.ThrustOffset * -1 )
	
	// Calculate the velocity
	ThrusterWorldForce = ThrusterWorldForce * self.force * mul * 50
	self.ForceLinear, self.ForceAngle = phys:CalculateVelocityOffset( ThrusterWorldForce, ThrusterWorldPos );
	self.ForceLinear = phys:WorldToLocalVector( self.ForceLinear )
	
	if ( mul > 0 ) then
		self:SetOffset( self.ThrustOffset )
	else
		self:SetOffset( self.ThrustOffsetR )
	end
	
	self.Entity:SetNetworkedVector( 1, self.ForceAngle )
	self.Entity:SetNetworkedVector( 2, self.ForceLinear )
	
	self:SetOverlayText( "Force: " .. math.floor( self.force ) )
	
end


/*---------------------------------------------------------
   Called when keypad key is pressed
---------------------------------------------------------*/
function ENT:AddMul( mul, bDown )

	if ( self:GetToggle() ) then 
	
		if ( !bDown ) then return end
		
		if ( self.Multiply == mul ) then 
			self.Multiply = 0
		else 
			self.Multiply = mul 
		end
		
	else
	
		self.Multiply = self.Multiply or 0
		self.Multiply = self.Multiply + mul	
	
	end

	
	self:SetForce( nil, self.Multiply )
	self:Switch( self.Multiply != 0 )
	
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

	self.Entity:TakePhysicsDamage( dmginfo )

	if (!self.ActivateOnDamage) then return end

	self:Switch( true )
	timer.Create( self, 5, 1, function() self.Switch(false) end )

end


/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use( activator, caller )
end

/*---------------------------------------------------------
   Name: Simulate
---------------------------------------------------------*/
function ENT:PhysicsSimulate( phys, deltatime )

	if (!self:IsOn()) then return SIM_NOTHING end
	
	local ForceAngle, ForceLinear = self.ForceAngle, self.ForceLinear

	return ForceAngle, ForceLinear, SIM_LOCAL_ACCELERATION
	
end

/*---------------------------------------------------------
   Switch thruster on or off
---------------------------------------------------------*/
function ENT:Switch( on )
	
	if (!self.Entity:IsValid()) then return false end
	
	self:SetOn( on )
	
	if (on) then 
	
		self:StartThrustSound()
		
	else
		
		self:StopThrustSound()
		
	end
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	return true
	
end

/*---------------------------------------------------------
   Sets whether this is a toggle thruster or not
---------------------------------------------------------*/
function ENT:StartThrustSound()

	if (!self:GetSound()) then return end

	if (!self.Sound) then
		self.Sound = CreateSound( self.Entity, Thruster_Sound )
	end
	
	self.Sound:Play()

end

/*---------------------------------------------------------
   Sets whether this is a toggle thruster or not
---------------------------------------------------------*/
function ENT:StopThrustSound()

	if (!self:GetSound()) then return end

	if (self.Sound) then
		self.Sound:Stop()
	end

end

/*---------------------------------------------------------
   Sets whether this is a toggle thruster or not
---------------------------------------------------------*/
function ENT:SetToggle(tog)
	self.Toggle = tog
end

/*---------------------------------------------------------
   Returns true if this is a toggle thruster
---------------------------------------------------------*/
function ENT:GetToggle()
	return self.Toggle
end


/*---------------------------------------------------------
   Numpad control functions
   These are layed out like this so it'll all get saved properly
---------------------------------------------------------*/
local function On( pl, ent, mul )
	if (!ent:IsValid()) then return false end
	ent:AddMul( mul, true )
	return true
end

local function Off( pl, ent, mul )
	if (!ent:IsValid()) then return false end
	ent:AddMul( mul * -1, false )
	return true
end

// register numpad functions
numpad.Register( "Thruster_On", On )
numpad.Register( "Thruster_Off", Off )

