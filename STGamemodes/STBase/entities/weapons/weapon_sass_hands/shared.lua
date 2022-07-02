-------------------------
-- Sassilization Hands
-- Spacetech
-------------------------

if(SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= true
	SWEP.AutoSwitchFrom	= true
else
	SWEP.PrintName			= "Hands"
	SWEP.Slot				= 0
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.DrawWeaponInfoBox 	= false
end

SWEP.Base = "weapon_base"

SWEP.ViewModel		= ""
SWEP.WorldModel		= ""
SWEP.ViewModelFlip	= false

SWEP.HoldType = "normal"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if(self.SetWeaponHoldType) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end
