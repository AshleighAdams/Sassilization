--------------------
-- STBase
-- By Spacetech
--------------------

include("shared.lua")

function ENT:Draw()
	if !GetDrawingPlayers() and !GetDrawingPlayers(true) and self:GetOwner() != LocalPlayer() then return end 
	if(self:GetOwner() != LocalPlayer() or STGamemodes.ThirdPerson.GoodToGo(LocalPlayer(), true)) then
		if(LocalPlayer():GetObserverMode() != OBS_MODE_IN_EYE or LocalPlayer():GetObserverTarget() != self:GetOwner()) then
			self:DrawModel()
		end
	end
end

function ENT:Think()
	if(self:GetOwner() != LocalPlayer()) then
		if(STValidEntity(self:GetOwner())) then
			self:SetColor(self:GetOwner():GetColor())
		end
	end
end
