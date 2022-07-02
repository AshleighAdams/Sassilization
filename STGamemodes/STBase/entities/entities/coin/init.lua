AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.coin = true

function ENT:Initialize()
	self.ctime = CurTime() + 0.05
	self.spawn = CurTime() + 1
	self.lifetime = CurTime() + math.random( 25, 50 )
	self.layer = 0
end

function ENT:GroundTrace( s, e, filt, msk, recurse )
	recurse = recurse or 0
	if recurse > 20 then msk = MASK_SOLID_BRUSHONLY end
	local tr = util.TraceLine( { start = s, endpos = e, filter = filt, mask = msk } )
	if ValidEntity(tr.Entity) and tr.Entity:GetClass() == "coin" then
		table.insert( filt, tr.Entity )
		return self:GroundTrace( s, e, filt, msk, recurse + 1 )
	else
		return tr
	end
end

function ENT:Ground()
	local tr = self:GroundTrace( self:GetPos() + Vector( 0, 0, 5 ), self:GetPos() + Vector( 0, 0, -96 ), {self} )
	if tr.Hit then
		self:SetPos( tr.HitPos + tr.HitNormal + Vector( math.Rand( -6, 6 ), math.Rand( -6, 6 ), 0 ) )
		self:SetAngles( tr.HitNormal )
		self:GetPhysicsObject():EnableMotion( false )
	else
		self:SetModel( "models/props_c17/BriefCase001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:GetPhysicsObject():EnableMotion( !self.frozen )
	end
end

function ENT:Freeze()
	if self.frozen then return end
	self:Froze()
	self:GetPhysicsObject():EnableMotion( false )
	for _, ent in pairs( ents.FindInBox( self:LocalToWorld( self:OBBMins() ), self:LocalToWorld( self:OBBMaxs() ) ) ) do
		if ValidEntity( ent ) and ent != self and ent.coin then
			ent:Freeze()
		end
	end
	if (self.clayer and self.clayer > 1) and ValidEntity(self.collide) and self.collide:GetPos():Distance(self:GetPos()) < 15 then
		local ent = self.collide
		ent.value = ent.value + self.value
		ent.lifetime = CurTime() + math.random( 25, 50 )
		ent:SetColor( Color(255, 255, 255, 255 ))
		if ent.svalue and ent.value - ent.svalue >= 5 and !self.stacked then
			ent:Stack()
		elseif ent.value >= 5 and !ent.pile then
			ent:MakePile()
		end
		self.value = 0
		self:Remove()
	elseif self.clayer then
		self.layer = self.clayer + 1
	end
end

function ENT:Stack()
	if self.stacked then return end
	self.stacked = true
	self.value = math.floor( self.value * 0.5 )
	local coin = ents.Create( "coin" )
	coin:SetPos( self:GetPos() + self:GetUp() * 3 )
	coin:SetAngles( self:GetAngles() )
	coin.owner = self.owner
	coin:Spawn()
	coin:Activate()
	coin.pile = true
	coin.svalue = self.value
	coin.value = self.value
	coin.lifetime = CurTime() + math.random( 50, 75 )
	coin:SetModel( "models/jaanus/lounge/coinstack.mdl" )
	coin:PhysicsInit( SOLID_VPHYSICS )
	coin:GetPhysicsObject():EnableMotion( false )
	coin.stack = self
	coin.OnRemove = function()
		if ValidEntity( coin.stack ) then
			coin.stack.stacked = false
		end
	end
end

function ENT:MakePile()
	if self.pile then return end
	self.pile = true
	self.svalue = self.value
	self:SetAngles( Angle( 0, 0, 0 ) )
	self:SetModel( "models/jaanus/lounge/coinstack.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self.lifetime = CurTime() + math.random( 50, 75 )
	self:SetColor(Color( 255, 255, 255, 255 ))
	self:Ground()
end

function ENT:SetAmount( amount )
	self.value =  math.Round( tonumber( amount ) )
	if self.value < 25 then
		self:SetModel( "models/jaanus/lounge/coin.mdl" )
		self:PhysicsInitBox( self:OBBMins(), self:OBBMaxs() )
		local phys = self:GetPhysicsObject()
		if !ValidEntity( phys ) then return end
		phys:SetMaterial( "sass_coin" )
		phys:SetDragCoefficient( 1 )
		phys:SetDamping( 3 )
	else
		local aim = (self.owner or NULL):GetAimVector()
		aim = Vector( aim.x, aim.y, 0 ):Normalize()
		local tr = util.TraceLine( { start = self:GetPos(), endpos = self:GetPos() + aim * 56, mask = MASK_SOLID_BRUSHONLY } )
		self:SetPos( tr.HitPos + aim * (math.Rand(0,5)+6) * -1 )
		self:MakePile()
	end
end

function ENT:Cleanup()
	local owner = self.owner
	if ValidEntity( owner ) and owner:IsPlayer() then
		owner:GiveMoney( self.value )
	end 
	self:Remove()
end

function ENT:CheckLife()
	if self.pickedup then
		self:Remove()
		return
	end
	if !self.lifetime then return end
	self.lifecheck = self.lifecheck or CurTime()
	if self.lifecheck and CurTime() > self.lifecheck then
		local col = Color( self:GetColor() )
		if self.lifetime - CurTime() <= 5 and col.a == 255 then
			self.lifecheck = CurTime()
			self:SetColor( Color(col.r, col.g, col.b, 10 ))
		elseif CurTime() > self.lifetime then
			self:Cleanup()
		else
			self.lifecheck = CurTime() + 2
		end
	end
end

function ENT:Froze()
	self.frozen = true
	self.spawn = nil
	self.Think = self.CheckLife
end

function ENT:Think()
	if self.spawn then
		if CurTime() > self.spawn then
			self.spawn = nil
		end
	elseif !self.frozen and (self:OnGround() || self:GetVelocity():Length() < 1) then
		self:Freeze()
	end
	self:CheckLife()
end

function ENT:PhysicsCollide( data )
	self:EmitSound( "sassilization/ting"..math.random(1,4)..".wav", 65, 85 )
	local ent = data.HitEntity
	if ValidEntity( ent ) and ent.coin then
		self.clayer = ent.layer
		self.collide = ent
	end
end

function ENT:Touch( pl )
	if self.spawn then return end
	if self.pickedup then return end
	if ValidEntity( pl ) and pl:IsPlayer() then
		pl.lastPickup = CurTime() + 3
		pl.pickupAmount = (pl.pickupAmount or 0) + self.value
		pl:GiveMoney( self.value )
		self.pickedup = true
	end
end