--------------------
-- STBase
-- By Spacetech
--------------------

STAchievements.Loading = true
STAchievements.RefreshPanel = false

usermessage.Hook("STAchievements.UserMessage.Start", function(um)
	STAchievements.Loading = true
end)

function STAchievements:UserMessageLoad(um)
	local Name = um:ReadString()
	local Count = um:ReadLong()
	
	self:SetCount(LocalPlayer(), Name, Count)
	self.RefreshPanel = true
	
	if(STAchievements.Loading) then
		RunConsoleCommand("st_achievement_loaded", Name)
	end
end
usermessage.Hook("STAchievements.UserMessage.Load", function(um) STAchievements:UserMessageLoad(um) end)

usermessage.Hook("STAchievements.UserMessage.End", function(um)
	STAchievements.Loading = false
	STAchievements.RefreshPanel = true
end)

----------------------------------------------------------------------------------
-- I wanted to make it look similar to the main garrysmod one so most of this code is from that

local NameColor = Color(170, 240, 90)
local ShadowColor = Color(0, 0, 0, 100)
local DescriptionColor = Color(255, 255, 255, 200)
local NotAchievedColor = Color(100, 100, 100, 200)
local BackgroundColor = Color(100, 100, 100, 200)

local PANEL = {}

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(false)
	
	self.Name = vgui.Create("DLabel", self)
	self.Name:SetFont("Trebuchet22")
	self.Name:SetColor(NameColor)
	self.Name:SetText("")
	self.Name:SetExpensiveShadow(2, ShadowColor)
	
	self.Description = vgui.Create("DLabel", self)
	self.Description:SetFont("DefaultBold")
	self.Description:SetColor(DescriptionColor)
	self.Description:SetText("")
	
	self.Icon = vgui.Create("TGAImage", self)
	
	self.ProgressBar = vgui.Create("DProgressBar", self)
	
	self:SetBackgroundColor(BackgroundColor)
end

function PANEL:GetName()
	return self.AchievementName
end

function PANEL:GetGoal()
	return self.AchievementGoal
end

function PANEL:SetAchievement(Achievement)
	self.AchievementName = Achievement:GetName()
	
	self.Name:SetText(self.AchievementName)
	self.Description:SetText(Achievement:GetDescription())
	
	self:SetSize(74, 74)
	
	self.ProgressBar:SetVisible(false)
	
	local Count = STAchievements:GetCount(LocalPlayer(), self.AchievementName)
	
	self.AchievementGoal = Achievement:GetGoal()
	
	if Achievement:HasTGA() then 
		self.Icon:LoadTGAImage("materials/sassilization/achievements/"..Achievement:GetTGA()..".tga", "MOD")
	end 
	
	if(self.AchievementGoal > 1) then
		self.ProgressBar:SetVisible(true)
		self.ProgressBar:SetMin(0)
		self.ProgressBar:SetMax(self.AchievementGoal)
		self.ProgressBar:SetValue(Count)
		self.ProgressBar:InvalidateLayout(true)
	end
end

function PANEL:Update(Achieved, Count)
	self.Achieved = Achieved
	self.ProgressBar:SetValue(Count)
	self.ProgressBar:InvalidateLayout(true)
	return Achieved
end

function PANEL:PerformLayout()
	self.Icon:SetPos(5, 5)
	self.Icon:SetSize(64, 64)
	
	self.Name:SizeToContents()
	self.Name:AlignTop(5)
	self.Name:MoveRightOf(self.Icon, 10)
	self.Name:SetZPos(100)
	
	self.Description:SizeToContents()
	self.Description:CopyPos(self.Name)
	self.Description:MoveBelow(self.Name, 0)
	
	self.ProgressBar:SetPos(10, 10)
	self.ProgressBar:SetSize(20, 20)
	self.ProgressBar:AlignBottom(5)
	self.ProgressBar:MoveRightOf(self.Icon, 10)
	self.ProgressBar:StretchToParent(nil, nil, 10, nil)	
end

function PANEL:PaintOver()
	if(!self.Achieved) then
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), NotAchievedColor)
	end
end

vgui.Register("STAchievements.Panel", PANEL, "DPanel")
