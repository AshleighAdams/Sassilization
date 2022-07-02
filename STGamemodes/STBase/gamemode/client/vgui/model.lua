--------------------
-- STBase
-- By Spacetech
--------------------

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(false)
	self:UpdateCam(Vector(0, 0, 0), Vector(25, 25, 25))
end

function PANEL:SetItem(Item)
	self.Item = STGamemodes:UpperCaseFirst(string.gsub(Item, "weapon_", ""))
	self.ItemTable = STGamemodes.WeaponsMenu[Item]
	
	self:UpdateInfo(self.ItemTable.Model, self.ItemTable.Angles)
	
	local LookAt = self.ItemTable.LookAt
	local CamPos = self.ItemTable.CamPos
	self.FakeEntity = ents.Create("prop_physics")
	if(self.FakeEntity and self.FakeEntity:IsValid()) then
		self.FakeEntity:SetModel(self.ItemTable.Model)
		local Center = self.FakeEntity:OBBCenter()
		LookAt = Vector(Center.x, Center.y, Center.z)
		CamPos = Vector(Center.x, self.FakeEntity:OBBMins():Distance(self.FakeEntity:OBBMaxs()), Center.z * 1.25)
		self.FakeEntity:Remove()
	end
	
	self:UpdateCam(LookAt, CamPos)
end

function PANEL:UpdateInfo(Model, Angles)
	self:SetModel(Model)
	self.Angles = Angles
end

function PANEL:UpdateCam(LookAt, CamPos)
	if(LookAt and CamPos) then
		self:SetLookAt(LookAt)
		self:SetCamPos(CamPos)
	end
end

function PANEL:LayoutEntity(Entity)
	self:RunAnimation()
	
	if(!self.Angles) then
		return
	end
	
	local Angles = self.Angles

	local Ang1 = Angles.p
	local Ang2 = Angles.y
	local Ang3 = Angles.r
	
	Entity:SetAngles(Angle(Ang1, RealTime() * 50, Ang3))
	Entity:ClearPoseParameters()
end
vgui.Register("STGamemodes.VGUI.Model", PANEL, "DModelPanel")
