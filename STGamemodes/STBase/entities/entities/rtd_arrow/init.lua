AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()

	self:SetModel( "models/mrgiggles/sassilization/arrow.mdl" )
	
	self:PhysicsInitSphere( 1 )
	self:SetCollisionBounds( Vector(-2,-2,-0.1), Vector(2,2,0.1) )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetMoveCollide( MOVECOLLIDE_FLY_SLIDE )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor( Color(255, 255, 255, 255 ))
	self:SetTrigger( true )
	
	self.trail = util.SpriteTrail(	self,
					0,
					Color( 180, 180, 180, 80 ),
					false,
					1,
					0.01,
					0.5,
					0.5,
					"trails/laser.vmt"
				)
	
	timer.Simple( 2, function() self:Raze() end )
	
	self:SetAngles( self.AngStart )
	self.DirAngle = (self.PosTarget - self.PosStart):Angle()
	self:SetPos( self.PosStart + (Vector(self.DirAngle:Forward().x,self.DirAngle:Forward().y,0) * 8) )
	
	local power = self.PosStart:Distance( self.PosTarget ) * 1.5
	
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass( 1 )
		phys:EnableMotion(true)
		phys:EnableGravity( false )
		phys:SetVelocity( self.DirAngle:Forward() * power * 2 )
	end
	
end

function ENT:Think()
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		if phys:GetVelocity().z > 0 then
			phys:EnableMotion( true )
			phys:EnableGravity( true )
		end
	end
	
end

function ENT:Raze()
	if self.Dead then return end
	self.Dead = true
	if self:IsValid() then
		local function RemoveEntity( ent )
 				ent:Remove()
 		end
 		timer.Simple( 1, function() RemoveEntity(self) end  )
	 	self:SetNotSolid( true )
 		self:SetMoveType( MOVETYPE_NONE )
	 	self:SetNoDraw( true )
	end
end

function ENT:PhysicsCollide( data, phys )
	local ent = data.HitEntity
	if ent:IsWorld() and data.HitNormal:Dot(Vector(0,0,1)) < 0.1 then
		phys:EnableMotion( false )
	end
end
