--------------------
-- STBase
-- By Spacetech
--------------------

include("shared.lua")

SWEP.PrintName		= "Jetpack"			
SWEP.Slot			= 2
SWEP.SlotPos		= 3
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false

function SWEP:GetPrintName()
	return self.PrintName
end
