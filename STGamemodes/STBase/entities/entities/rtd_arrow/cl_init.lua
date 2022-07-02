include('shared.lua')

function ENT:Draw()
	self:SetModelScale(2, 0)
	self:DrawModel()
end