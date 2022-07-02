--------------------
-- STBase
-- By Spacetech
--------------------

AddCSLuaFile( "shared.lua" )
AddCSLuaFile("cl_init.lua")
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
	timer.Simple( 30, function() self:End() end )
end

function ENT:End()
	self:Remove()
end 
