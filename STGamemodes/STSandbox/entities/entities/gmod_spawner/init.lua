
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then phys:Wake() end
	
	self.UndoList = {}
end

function ENT:SetCreationDelay( delay )	self.delay = delay	end
function ENT:SetDeletionDelay( delay )	self.undo_delay = delay	end

function ENT:GetCreationDelay()	return self.delay	end
function ENT:GetDeletionDelay()	return self.undo_delay	end

function ENT:OnTakeDamage( dmginfo )	self.Entity:TakePhysicsDamage( dmginfo ) end


function ENT:DoSpawn( pl, down )

	local ent	= self.Entity
	if (!ent:IsValid()) then return end

	local phys	= ent:GetPhysicsObject()
	if (!phys:IsValid()) then return end

	local Pos	= ent:GetPos()
	local Ang	= ent:GetAngles()
	local Model	= ent:GetModel()
	local Vel	= phys:GetVelocity()
	local aVel	= phys:GetAngleVelocity()
	local delay	= self:GetDeletionDelay()

	local prop = MakeProp( pl, Pos, Ang, Model, {}, {} )
	if (!prop || !prop:IsValid()) then return end

	local nocollide = constraint.NoCollide( prop, ent, 0, 0 )
	if (nocollide:IsValid()) then prop:DeleteOnRemove( nocollide ) end

	undo.Create("Prop")
		undo.AddEntity( prop )
		undo.AddEntity( nocollide )
		undo.SetPlayer( pl )
	undo.Finish()
	
	pl:AddCleanup( "props", prop )
	pl:AddCleanup( "props", nocollide )

	table.insert( self.UndoList, 1, prop )

	if (delay == 0) then return end

	timer.Simple( delay, function( ent ) if ent:IsValid() then ent:Remove() end end, prop )
	
end

function ENT:DoUndo( pl )

	if (!self.UndoList || #self.UndoList == 0) then return end

	local ent = self.UndoList[	#self.UndoList ]
	self.UndoList[	#self.UndoList ] = nil

	if (!ent || !ent:IsValid()) then
		return self:DoUndo(pl)
	end
	
	ent:Remove()
	umsg.Start( "UndoSpawnerProp", pl ) umsg.End()

end

local function Spawn( pl, ent )

	if (!ent:IsValid()) then return end

	local delay = ent:GetTable():GetCreationDelay()
	if (delay == 0) then ent:GetTable():DoSpawn( pl ) return end
	
	local TimedSpawn = 	function ( ent, pl ) 
						
							if (!ent) then return end
							if (!ent == NULL) then return end
	
							ent:GetTable():DoSpawn( pl ) 
							
						end
	
	timer.Simple( delay, TimedSpawn, ent, pl )

end

local function Undo( pl, ent )

	if (!ent:IsValid()) then return end
	ent:GetTable():DoUndo( pl )
	
end

numpad.Register( "SpawnerCreate",	Spawn )
numpad.Register( "SpawnerUndo",		Undo  )


