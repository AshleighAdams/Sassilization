AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( 0 )
	self:SetNotSolid( true )
	self:DrawShadow( false )
	
end