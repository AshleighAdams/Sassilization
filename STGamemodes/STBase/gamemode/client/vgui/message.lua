--------------------
-- STBase
-- By Spacetech
--------------------

local PANEL = {}

function PANEL:Init()
	self:SetTitleEx("Login")
	self:SetDraggable(false)
	self:SetDeleteOnClose(true)
	self:ShowCloseButton(false)
	
	-- self:SetBackgroundBlur(true)
	
	self:SetMouseInputEnabled(true)
	self:SetKeyBoardInputEnabled(true)
	
	self.InnerPanel = vgui.Create("DPanel", self)
	self.InnerPanel:SetDrawBackground(false) 
	
	self.Text = vgui.Create("DLabel", self.InnerPanel)
	self.Text:SetText("Place Holder")
	self.Text:SetTextColor(color_white)
	
	self.ButtonPanel = vgui.Create("DPanel", self)
	self.ButtonPanel:SetTall(30)
	self.ButtonPanel:SetDrawBackground(false)

	self.Ok = vgui.Create("DButton", self.ButtonPanel)
	self.Ok:SetText("OK")
	self.Ok:SizeToContents()
	self.Ok:SetTall(20)
	self.Ok:SetWide(self.Ok:GetWide() + 20)
	self.Ok:SetPos(5, 5)
	self.Ok.DoClick = function()
		self:Close()
	end
	
	self.ButtonPanel:SetWide(self.Ok:GetWide() + 10)
	
	self:FixLayout()
end

function PANEL:Think()
	if(!self:HasFocus()) then
		self:MouseCapture(true)
		self:MouseCapture(false)
		self:SetDrawOnTop(true)
		self:RequestFocus()
	end
end

function PANEL:FixLayout()
	self.Text:SizeToContents()
	self.Text:SetContentAlignment(5)
	
	local TWidth, THeight = self.Text:GetSize()
	TWidth = math.max(TWidth, 65)
	
	self:SetSize(TWidth + 50, THeight + 25 + 45 + 10)
	self:Center()
	
	self.InnerPanel:StretchToParent(5, 25, 5, 45)
	
	self.Text:StretchToParent(5, 5, 5, 5)	
	
	self.ButtonPanel:CenterHorizontal()
	self.ButtonPanel:AlignBottom(8)
end

function PANEL:SetInfo(Title, Message)
	self:SetTitleEx(Title)
	self.Text:SetText(Message)
	self:FixLayout()
end
vgui.Register("STGamemodes.VGUI.Message", PANEL, "STGamemodes.VGUI.Base")
