--------------------
-- STBase
-- By Spacetech
--------------------

SWEP.Author			= "Spacetech"
SWEP.Contact		= "Spacetech326@gmail.com"
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Spawnable		= false
SWEP.AdminSpawnable	= true

SWEP.ViewModel	= ""
SWEP.WorldModel	= "models/weapons/w_bugbait.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

function SWEP:Equip()
	self.CanReload = true
end

function SWEP:Deploy()
end

function SWEP:DrawWorldModel()
end

function SWEP:Think()
	if !self.Owner or !self.Owner.Winner then
		return
	end
	
	local Velocity = vector_origin
	local AngVelocity = Angle(0, self.Owner:EyeAngles().y, 0)
	
	if self.Hover then
		Velocity = Vector(0, 0, -self.Owner:GetVelocity().z + 4.5)
	else
		if self.Owner:KeyDown(IN_ATTACK) then
			Velocity = (vector_up * 16)
		elseif self.Owner:KeyDown(IN_ATTACK2) then
			Velocity = (vector_up * -16)
		end
	end
	
	if self.Owner:KeyDown(IN_FORWARD) then
		Velocity = Velocity + (AngVelocity:Forward() * 12)
	elseif self.Owner:KeyDown(IN_BACK) then
		Velocity = Velocity + (AngVelocity:Forward() * -12)
	end
	
	if self.Owner:KeyDown(IN_MOVERIGHT) then
		Velocity = Velocity + (AngVelocity:Right() * 12)
	elseif self.Owner:KeyDown(IN_MOVELEFT) then
		Velocity = Velocity + (AngVelocity:Right() * -12)
	end
	
	if Velocity.x != 0 or Velocity.y != 0 or Velocity.z != 0 then
		self.Owner:SetVelocity(Velocity)
	end
end

function SWEP:Reload()
	if !self.CanReload then
		return
	end
	
	self.Hover = !self.Hover
	self.Owner:ChatPrint("Jetpack Hover Mode: " .. (self.Hover and "Enabled" or "Disabled"))
	
	self.CanReload = false
	timer.Create("JetpackReload_" .. self:EntIndex(), 1, 1, function()
		self.CanReload = true
	end)
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:ShouldDropOnDie()
	return false
end
