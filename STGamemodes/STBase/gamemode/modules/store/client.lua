--------------------
-- STBase
-- By Spacetech
--------------------

surface.CreateFont("cStoreFont", {font="Verdana",size=17, weight=500, antialias=true})
surface.CreateFont("ServerListHead", {font="Arial",size=24, weight=500, antialias=true, shadow=true})
surface.CreateFont("ServerListDesc", {font="Arial",size=16, weight=500, antialias=true})
surface.CreateFont("ServerListConn", {font="Arial",size=18, weight=700, antialias=true})
surface.CreateFont("DefaultBold", {font="Arial", size=18, weight=800, antialias=true}) 
surface.CreateFont("Trebuchet22", {font="Arial", size=18, weight=600, antialias=true})

COLOR_GREY = Color(229, 153, 164, 255)
COLOR_GREEN = Color(113, 164, 122, 255)
COLOR_OWNED = Color(181, 182, 194, 255)
COLOR_BLUE = Color(0, 0, 255, 255)
COLOR_RED = Color(86, 86, 86, 255)
COLOR_CATLABEL = Color(243, 237, 222, 255)
COLOR_GREY = Color(86, 86, 86, 255)
COLOR_SELECTED = Color(255, 0, 0, 255)
COLOR_GOLD = Color(255, 190, 0, 255)

STGamemodes.Store.Panel = false
STGamemodes.Store.Loading = true
STGamemodes.Store.Fonts = {}
STGamemodes.Store.LocalItems = {}
STGamemodes.Store.RefreshSettings = true

STGamemodes.Store.ButtonClick = Sound("buttons/button1.wav")
STGamemodes.Store.ButtonRelease = Sound("UI/buttonclickrelease.wav")
STGamemodes.Store.ButtonRollover = Sound("UI/buttonrollover.wav")


function STGamemodes.Store:SelectFont(Text, Wide)
	surface.SetFont("cStoreFont")
	local Width, Height = surface.GetTextSize(Text)
	if(Width >= Wide) then
		local Calc = Width / Wide
		local Size = math.floor(17 / Calc)
		local Font = "cStoreFont."..Size
		if(!self.Fonts[Size]) then
			self.Fonts[Size] = true
			-- print("Cached Font", Size)
			surface.CreateFont(Font, {font="Verdana",size=Size, weight=((500 /*/ Calc*/) / 2), antialias=true})
		end
		return Font
	end
	return "cStoreFont"
end

local PANEL = {}
PANEL.Tabs = {}
PANEL.Width = math.max(520, ScrW() / 1.5)
PANEL.Height = math.max(465, ScrH() / 1.5)

function PANEL:Init()
	self:SetTitleEx("Main Menu")
	
	self:SetDraggable(true)
	self:ShowCloseButton(true)
	self:SetDeleteOnClose(false)
	
	self:SetMouseInputEnabled(true)
	self:SetKeyBoardInputEnabled(true)
	
	self:SetSize(self.Width, self.Height)
	self:Center()
	
	local X = 5
	local Y = 28
	local Width = self:GetWide() - 10
	local Height = self:GetTall() - 30
	
	self.PropertySheet = vgui.Create("DPropertySheet", self)
	self.PropertySheet:SetPos(X, Y)
	self.PropertySheet:Dock(FILL)
	
	Height = Height - 20
	Y = Y - 25
	
	self.Help = vgui.Create("STGamemodes.VGUI.Help", self)
	self.Help.Mother = self
	self.PropertySheet:AddSheet("Help", self.Help, "icon16/star.png")
	self.Tabs["HELP"] = self.PropertySheet.Items[1]
	
	self.Achievements = vgui.Create("STGamemodes.VGUI.Achievements", self)
	self.Achievements.Mother = self
	self.PropertySheet:AddSheet("Achievements", self.Achievements, "icon16/world.png")
	self.Tabs["ACHIEVEMENTS"] = self.PropertySheet.Items[2]
	
	self.Store = vgui.Create("STGamemodes.VGUI.Store", self)
	self.Store.Mother = self
	self.PropertySheet:AddSheet("Store", self.Store, "icon16/brick_add.png")
	self.Tabs["STORE"] = self.PropertySheet.Items[3]
	
	self.Settings = vgui.Create("STGamemodes.VGUI.Settings", self)
	self.Settings.Mother = self
	self.Tabs["SETTINGS"] = self.PropertySheet:AddSheet("Settings", self.Settings, "icon16/plugin.png")
	
	--[[ THIS IS NOT DONE YET
	self.Customize = vgui.Create("STGamemodes.VGUI.Customize", self)
	self.Settings.Mother = self
	self.Tabs["CUSTOMIZE"] = self.PropertySheet:AddSheet("Customize", self.Customize, "gui/silkicons/palette")
	--]]

	self.Servers = vgui.Create("STGamemodes.VGUI.Servers", self)
	self.Servers.Mother = self
	self.PropertySheet:AddSheet("Servers", self.Servers, "icon16/car.png")
	self.Tabs["SERVERS"] = self.PropertySheet.Items[5]
	
	self.VIPBenefits = vgui.Create("STGamemodes.VGUI.VIPBenefits", self)
	self.VIPBenefits.Mother = self
	self.VIPBenefits.Paint = nil
	self.PropertySheet:AddSheet("VIP Benefits", self.VIPBenefits, "icon16/emoticon_smile.png")
	self.Tabs["VIPBenefits"] = self.PropertySheet.Items[6]
	
	self.Account = vgui.Create("STGamemodes.VGUI.Account", self)
	self.Account.Mother = self
	self.PropertySheet:AddSheet("Account", self.Account, "icon16/user.png")
	self.Tabs["Account"] = self.PropertySheet.Items[7]
	
	
	self.PropertySheet.Paint = nil
	self.Help.Paint = nil
	self.Achievements.Paint = nil
	self.Store.Paint = nil
	--self.Customize.Paint = nil
	self.Settings.Paint = nil
	self.Servers.Paint = nil
	self.Account.Paint = nil
end

function PANEL:Think()
	local activeTab = self.PropertySheet:GetActiveTab()
	if !self.lastTab then self.lastTab = activeTab end
	if (self.lastTab != activeTab) then
		self.lastTab = activeTab
		-- refresh the settings tab everytime it's pressed
		-- to ensure that recent changes have been added
		if (activeTab == self.Tabs["SETTINGS"].Tab) then
			if !activeTab.bInitialLoad then
				activeTab.bInitialLoad = true
			else
				self.Tabs["SETTINGS"].Panel:Update()
			end
		end

		--[[if (activeTab == self.Tabs["CUSTOMIZE"].Tab) then
			if !activeTab.bInitialLoad then
				activeTab.bInitialLoad = true
			else
				self.Tabs["CUSTOMIZE"].Panel:Update()
			end
		end--]]
	end
end

vgui.Register("STGamemodes.VGUI.Main", PANEL, "STGamemodes.VGUI.Base")

-------------------------------------------------------------------------------------------------------------------------

local LoadingLabelColor = Color(0, 0, 0, 255)
local ProgressLabelColor = Color(255, 255, 255, 255)
local ProgressPanelBackgroundColor = Color(70, 70, 70, 230)

local PANEL = {}
PANEL.Loading = -1

function PANEL:Init()
	self.LoadingLabel = vgui.Create("DLabel", self)
	self.LoadingLabel:SetFont("Trebuchet24")
	self.LoadingLabel:SetColor(LoadingLabelColor)
	self.LoadingLabel:SetText("Loading...")
	self.LoadingLabel:SizeToContents()
	
	self.PanelList = vgui.Create("DPanelList", self)
	self.PanelList:SetSpacing(5)
	self.PanelList:SetPadding(5)
	self.PanelList:EnableVerticalScrollbar()
	
	for k,v in pairs(STAchievements.Order) do
		local Panel = vgui.Create("STAchievements.Panel")
		Panel:SetAchievement(STAchievements:Get(v))
		
		self.PanelList:AddItem(Panel)
	end
	
	self.ProgressPanel = vgui.Create("DPanel", self)
	
	self.TotalProgress = vgui.Create("DProgressBar", self.ProgressPanel)
	self.TotalProgress:SetSize(200, 100)
	self.TotalProgress:LabelAsPecentage()
	self.TotalProgress:SetMin(0)
	self.TotalProgress:SetMax(table.Count(STAchievements.Achievements))
	self.TotalProgress:SetValue(0)
	
	self.ProgressLabel = vgui.Create("DLabel", self.ProgressPanel)
	self.ProgressLabel:SetFont("Trebuchet18")
	self.ProgressLabel:SetColor(ProgressLabelColor)
end

function PANEL:Think()
	if(!self.LastThink) then
		self.LastThink = CurTime() - 2
	end
	if(!STAchievements.RefreshPanel and self.LastThink >= CurTime() - 1) then
		return
	end
	self.LastThink = CurTime()
	self:Update()
	STAchievements.RefreshPanel = false
end

function PANEL:Update()
	local Completed = 0
	
	for k,v in pairs(self.PanelList:GetItems()) do
		if(v:Update(STAchievements:IsAchieved(LocalPlayer(), v:GetName()), STAchievements:GetCount(LocalPlayer(), v:GetName()))) then
			Completed = Completed + 1
		else
			Completed = Completed + (STAchievements:GetCount(LocalPlayer(), v:GetName()) / v:GetGoal())
		end
	end
	
	self.TotalProgress:SetValue(Completed)
	self.ProgressLabel:SetText(Format("You have unlocked %i out of %i achievements!", Completed, table.Count(self.PanelList:GetItems())))
	
	if(self.Loading == STAchievements.Loading) then
		return
	end
	self.Loading = STAchievements.Loading
	
	if(STAchievements.Loading) then
		self.LoadingLabel:SetVisible(true)
		self.PanelList:SetVisible(false)
		self.ProgressPanel:SetVisible(false)
	else
		self.LoadingLabel:SetVisible(false)
		self.PanelList:SetVisible(true)
		self.ProgressPanel:SetVisible(true)
	end
end

function PANEL:PerformLayout()
	self.LoadingLabel:Center()
	
	self.ProgressPanel:SetTall(55)
	self.ProgressPanel:StretchToParent(10, 10, 10, nil)
	self.ProgressPanel:SetBackgroundColor(ProgressPanelBackgroundColor)

	self.ProgressLabel:SizeToContents()	
	self.ProgressLabel:SetPos(5, 5)
	self.ProgressLabel:CenterHorizontal()
	
	self.TotalProgress:SetTall(22)
	self.TotalProgress:StretchToParent(6, nil, 6, nil)
	self.TotalProgress:AlignBottom(6)
	
	self.PanelList:MoveBelow(self.ProgressPanel, 5)
	self.PanelList:StretchToParent(10, nil, 10, 10)
end

vgui.Register("STGamemodes.VGUI.Achievements", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self.HTML = vgui.Create("HTML", self)
	self.HTML:OpenURL("http://www.sassilization.com/servers/"..string.lower(GAMEMODE:GetGameDescription())..".html")
	self.HTML:Dock(FILL)
end

/*function PANEL:PerformLayout()
	self.HTML:StretchToParent(5, 5, 5, 5)
end*/

vgui.Register("STGamemodes.VGUI.Help", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}
PANEL.Selected = false
PANEL.SelectedCat = false
PANEL.SelectedCatContainer = false
PANEL.Categories = {}
PANEL.CategoryContainers = {}
local CurCategory = false 

function PANEL:Init()
	self.PanelList = vgui.Create("DPanelList", self)
	self.PanelList:SetPadding(5)
	self.PanelList:SetSpacing(5)
	self.PanelList:EnableHorizontal(true)
	self.PanelList:SetDrawBackground(false)
	self.PanelList:EnableVerticalScrollbar()
	
	for k,v in pairs(STGamemodes.Store:GetCategories()) do
		local Container = vgui.Create("STGamemodes.VGUI.StoreCategoryContainer", self)
		Container:SetInfo(self, k)
		Container:SetVisible(false)
		self.CategoryContainers[k] = Container
		Container.Paint = nil
		
		local Cat = vgui.Create("STGamemodes.VGUI.StoreCategoryButton", self)
		Cat:SetSize(96, 96)
		Cat:SetText(k)
		Cat:SetInfo(self, v.Mat)
		Cat.Container = Container or false
		--Cat.Paint = nil
		
		self.Categories[k] = Cat
		
		self.PanelList:AddItem(Cat)
	end
	
	self.BackButton = vgui.Create("DButton", self)
	self.BackButton:SetText("Back")
	self.BackButton:SetDisabled(true)
	function self.BackButton.DoClick()
		self:Select()
	end
	
	self.BuyButton = vgui.Create("DButton", self)
	self.BuyButton:SetText("Buy")
	self.BuyButton:SetDisabled(true)
	function self.BuyButton.DoClick()
		self:BuyClick()
	end
	
	self.SellButton = vgui.Create("DButton", self)
	self.SellButton:SetText("Sell")
	self.SellButton:SetDisabled(true)
	function self.SellButton.DoClick()
		self:SellClick()
	end
end

function PANEL:GetSelected()
	return self.Selected
end

function PANEL:SetSelected(Panel)
	if(self.Selected != Panel) then
		if(self.Selected != false) then
			self.Selected.Selected = false
		end
		self.Selected = Panel
		self.Selected.Selected = true
		surface.PlaySound(STGamemodes.Store.ButtonRelease)
	end
	self.BuyButton:SetDisabled(Panel.HasItem)
	self.SellButton:SetDisabled(!Panel.HasItem)
end

function PANEL:SetSelectedCat(Panel)
	if(self.SelectedCat != Panel) then
		if(self.SelectedCat != false) then
			self.SelectedCat:SetVisible(false)
		end
		self.SelectedCat = Panel
		self:Select(self.SelectedCat.Container)
		surface.PlaySound(STGamemodes.Store.ButtonRelease)
	end
end

function PANEL:Select(Container)
	if(self.Selected != false) then
		self.Selected.Selected = false
	end
	CurCategory = false 
	self.Selected = false
	self.BuyButton:SetDisabled(true)
	self.SellButton:SetDisabled(true)
	
	if(Container) then
		self.BackButton:SetDisabled(false)
	else
		self.SelectedCat = false
		self.BackButton:SetDisabled(true)
	end
	
	for k,v in pairs(self.Categories) do
		if(Container) then
			v:SetVisible(false)
		else
			v:SetVisible(true)
		end
	end
	for k,v in pairs(self.CategoryContainers) do
		if(Container) then
			if(Container == v) then
				CurCategory = k
				v:SetVisible(true)
			else
				v:SetVisible(false)
			end
		else
			v:SetVisible(false)
		end
	end
end

local ValidTable = {"Hats", "Trails", "Player Models", "Misc"}
function PANEL:BuyClick()
	if(!self.Selected) then
		return
	end
	surface.PlaySound(STGamemodes.Store.ButtonClick)
	RunConsoleCommand("st_store_buy", self.Selected.Text)

	if table.HasValue( ValidTable, CurCategory ) then
		if (STGamemodes.Store:CanBuyItem(LocalPlayer(), self.Selected.Text)) then
			Derma_Query( "Do you want to equip this (May not appear until you next spawn)?\nYou can alternatively equip it in the settings menu.", "Wear This?",
				"Yes", function()
				if CurCategory then 
					if CurCategory == "Hats" then 
						RunConsoleCommand( "st_store_hat", self.Selected.Text )
					elseif CurCategory == "Trails" then 
						RunConsoleCommand( "st_store_trail", self.Selected.Text, "255", "255", "255" )
					elseif CurCategory == "Player Models" then 
						RunConsoleCommand( "st_store_playermodel", self.Selected.Text )
					elseif CurCategory == "Misc" then 
						if self.Selected.Text == "Ghost Mode" then 
							RunConsoleCommand("st_store_ghost", 1)
						elseif self.Selected.Text == "Third Person Mode" then 
							RunConsoleCommand("st_store_thirdperson", 1)
						end 
					end 
				end 
			end, "No" )
		end
	elseif CurCategory == "Acts" then 
		Derma_Message( "You can use this act by typing \"/".. string.Explode( " ", self.Selected.Text )[2] .."\" into chat!" )
	end 
end

function PANEL:SellClick()
	if(!self.Selected) then
		return
	end
	surface.PlaySound(STGamemodes.Store.ButtonClick)
	RunConsoleCommand("st_store_sell", self.Selected.Text)
end

function PANEL:PerformLayout()
	self.PanelList:StretchToParent(5, 5, 5, 25)
	
	for k,v in pairs(self.CategoryContainers) do
		v:StretchToParent(5, 5, 5, 5)
	end
	
	self.BackButton:SetWide(40)
	self.BackButton:AlignLeft(5)
	self.BackButton:AlignBottom(5)
	
	local Left = self:GetWide() - self.BackButton:GetWide() - 20
	
	self.BuyButton:SetWide(Left / 2)
	self.BuyButton:MoveRightOf(self.BackButton, 5)
	self.BuyButton:AlignBottom(5)
	
	self.SellButton:SetWide(Left / 2)
	self.SellButton:MoveRightOf(self.BuyButton, 5)
	self.SellButton:AlignBottom(5)
end

function PANEL:Paint()

end

vgui.Register("STGamemodes.VGUI.Store", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}
PANEL.Items = {}
PANEL.Loading = true

function PANEL:Init()
	self.LoadingLabel = vgui.Create("DLabel", self)
	self.LoadingLabel:SetFont("Trebuchet24")
	self.LoadingLabel:SetColor(LoadingLabelColor)
	self.LoadingLabel:SetText("Loading...")
	self.LoadingLabel:SizeToContents()
	
	self.PanelList = vgui.Create("DPanelList", self)
	self.PanelList:NoClipping(false)
	self.PanelList:SetPadding(5)
	self.PanelList:SetSpacing(5)
	self.PanelList:EnableHorizontal(true)
	self.PanelList:SetDrawBackground(false)
	self.PanelList:EnableVerticalScrollbar()
	self.PanelList.Paint = nil
end

function PANEL:OnThink()
	if(STGamemodes.Store:CanBuyCategoryItem(LocalPlayer(), self.Text)) then
		self.CanBuy = true
	else
		self.CanBuy = false
	end
end

function PANEL:UpdateHover(Panel)
	if(!self.HoverPanel) then
		return
	end
	local x, y = gui.MousePos()
	self.HoverPanel:SetPos(x + 5, y + 5)
end

function PANEL:OnHover(Panel, Bool)
	if(!self.HoverPanel) then
		return
	end
	
	if(Bool) then
		if(!Panel.MatModel) then
			return
		end
		
		self.HoverModelPanel:SetModel(Panel.MatModel)
		self:UpdateHover(Panel)
		self.HoverPanel:SetVisible(true)
		self.HoverPanel:SetDrawOnTop(true)
		self.HoverPanel:MakePopup()
	else
		if(self.HoverPanel:IsVisible()) then
			self.HoverPanel:SetVisible(false)
		end
	end
end

function PANEL:SetInfo(Mother, Cat)
	self.Loading = true
	
	self.Items = {}
	self.Mother = Mother
	self.Cat = Cat
	
	self.LoadingLabel:SetVisible(true)
	self.PanelList:SetVisible(false)
	
	local Timer = 0.02
	for k,v in pairs(STGamemodes.Store:GetCategoryItems(Cat)) do
		local ItemTable = STGamemodes.Store:GetItem(v)
		if(ItemTable.Price > -1) then
			timer.Simple(Timer, function()
				if(!ValidPanel(self)) then
					return
				end
				local Item = vgui.Create("STGamemodes.VGUI.StoreItemButton", self.PanelList)
				//Item:NoClipping(false)
				Item:SetSize(96, 96)
				Item:SetText(v)
				if (ItemTable.VIP) then
					Item:SetTopText("VIP Only!")
				end

				Item.Container = self
				
				local ItemTable = STGamemodes.Store:GetItem(v)
				local Mat = ItemTable.Mat
				--PrintTable(ItemTable)
				if(Cat == "Player Models" or string.find(string.lower(Mat), "models/player")) then
					Item.MatModel = Mat
					//Mat = "store/PModels/PModels_Generic"
					if(!self.HoverPanel) then
						self.HoverPanel = vgui.Create("STGamemodes.VGUI.BasePaint")
						self.HoverPanel:SetSize(250, 250)
						self.HoverPanel:SetZPos(101)
						
						self.HoverModelPanel = vgui.Create("DModelPanel", self.HoverPanel)
						self.HoverModelPanel:StretchToParent(5, 5, 5, 5)
						self.HoverModelPanel:SetAnimSpeed(1)
						self.HoverModelPanel:SetAnimated(true)
						function self.HoverModelPanel:LayoutEntity(Entity)
							Entity:ClearPoseParameters()
							if(self.bAnimated) then
								self:RunAnimation()
							end
							Entity:SetAngles(Angle(0, RealTime() * 100, 0))
						end
						
						self.HoverPanel:SetVisible(false)
					end
				end

				if(Cat == "Hats" or Cat == "Player Models") then
					Item:SetInfo(self.Mother, Mat, true)
				else
					Item:SetInfo(self.Mother, Mat)
				end

				Item["Price"] = STGamemodes.Store:GetPrice(v, LocalPlayer())
				Item["Description"] = ItemTable.Description
				
				Item:UpdateTooltip()
				
				self.Items[v] = Item
				
				self.PanelList:AddItem(Item)
			end)
			Timer = Timer + 0.02
		end
	end
	timer.Simple(Timer, function()
		if(!ValidPanel(self)) then
			return
		end
		self.Loading = false
		self.LoadingLabel:SetVisible(false)
		self.PanelList:SetVisible(true)
		self.PanelList:SortByMember("Price", true)
	end)
end

function PANEL:PerformLayout()
	self.LoadingLabel:Center()
	self.PanelList:StretchToParent(5, 5, 5, 25)
end

vgui.Register("STGamemodes.VGUI.StoreCategoryContainer", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}
PANEL.Col = COLOR_GREEN
PANEL.BorderCol = COLOR_GREY

function PANEL:Init()
	self.TopText = ""
end

function PANEL:SetText(Text)
	self.Text = Text
end

function PANEL:SetTopText(Text)
	self.TopText = Text
end

function PANEL:SetInfo(Mother, Mat, bModel)
	self.Mother = Mother
	if(Mat) then
		if (bModel) then
			self.Image = vgui.Create("DSassilizationModelPanel", self)
			self.Image.Mat = Mat
			self.Image.List = self:GetParent()
			//self.Image:SetAnimated(true)
			function self.Image:PostSetModel()
				local entity = ents.CreateClientProp("prop_physics")
					entity:SetAngles(Angle(0, 0, 0))
					entity:SetPos(Vector(0, 0, 0))
					entity:SetModel(self.Mat)
					entity:Spawn()
					entity:Activate()
				entity:PhysicsInit(SOLID_VPHYSICS);
				
				local obbCenter = entity:OBBCenter()
					obbCenter.z = obbCenter.z * 1.09
				local distance = entity:BoundingRadius() * 1.2
			
				self:SetLookAt(obbCenter)

				if (string.find(self.Mat, "models/player") or string.find(self.Mat, "models/mrgiggles/sassmodels")) then
					self:SetCamPos(obbCenter + Vector(13, 13, 26))
					self:SetLookAt(obbCenter + Vector(0, 0, 26))
				else
					self:SetCamPos(obbCenter + Vector(distance * 0.8, distance * 0.8, distance * 0.8))
				end
				
				entity:Remove()
			end

			-- Cheating... I can't get the models to clip right. so this will have to do D:
			function self.Image:PrePaint()
				local x, y = self:GetParent():GetPos()
				local w, h = self:GetParent():GetSize()
				local maxXs, maxYs = self.List:GetSize()
				local eW, eH = self.List.pnlCanvas:GetPos()
				local maxX = maxXs + eW*-1
				local maxY = maxYs + eH*-1

				if (y < maxY - maxYs or y + h > maxY) then
					self.scissor = true
				end
				return true
			end

			function self.Image:StartCam()
				if (self.scissor) then
					local maxXs, maxYs = self.List:GetSize()
					local sX, sY = self.List:LocalToScreen()
					local eW, eH = self.List.pnlCanvas:GetPos()
					local maxX = maxXs + eW*-1
					local maxY = maxYs + eH*-1
					render.SetScissorRect(sX, sY, sX + maxX, sY + maxY, true)
					surface.SetDrawColor(Color(255, 0,0))
					surface.DrawRect(0, 0, 100, 100)
				end
			end

			function self.Image:EndCam()
				if (self.scissor) then
					render.SetScissorRect(0, 0, 0, 0, false)
					self.scissor = nil
				end
			end

			self.Image:SetModel(Mat)
			
		else
			self.Image = vgui.Create("DImage", self)
			self.Image:SetImage(Mat)
		end
	end

end


function PANEL:Think()
	if(!self.LastThink) then
		self.LastThink = CurTime() - 2
	end
	if(self.LastThink >= CurTime() - 1) then
		return
	end
	self.LastThink = CurTime()
	self:OnThink()
end

function PANEL:OnCursorEntered()
	self.Hovered = true
	if(self.Container.OnHover) then
		self.Container:OnHover(self, self.Hovered)
	end
	surface.PlaySound(STGamemodes.Store.ButtonRollover)
end

function PANEL:OnCursorMoved()
	if(self.Container.UpdateHover) then
		self.Container:UpdateHover(self)
	end
end

function PANEL:OnCursorExited()
	self.Hovered = false
	if(self.Container.OnHover) then
		self.Container:OnHover(self, self.Hovered)
	end
end

function PANEL:OnMousePressed(MouseCode)
	if(MouseCode == MOUSE_LEFT) then
		self:Clicked()
	end
end

function PANEL:UpdateTooltip()
	local Tooltip = self.Text
	if(self["Price"]) then
		if(self.HasItem) then
			self:SetTooltip("You own this item\nYou can sell this item for $"..tostring(self["Price"] * 0.8))
		else
			local ToolTip = "$"..tostring(self["Price"])
			if(self["Description"] and self["Description"] != "") then
				ToolTip = ToolTip.."\n"..self["Description"]
			end
			self:SetToolTip(ToolTip)
		end
	else
		if(self.HasItem) then
			self:SetTooltip("You own everything in this category!")
		elseif(!self.CanBuy) then
			self:SetTooltip("You don't have enough dough to buy anything in this category!")
		end
	end
end

function PANEL:Paint()
	if(self.HasItem) then
		self.Col = Color(0,140,255,20)
		self.ColAlpha = self.Col.a
	elseif(self.CanBuy) then
		self.Col = Color(94,255,0,20)
		self.ColAlpha = self.Col.a
	else
		self.Col = Color(255,0,0,20)
		self.ColAlpha = self.Col.a
	end

	if(self.Selected) then
		self.BorderCol = self.Col
		--self.BorderColA = 90
	elseif(self.Hovered) then
		self.BorderCol = self.Col
		self.BorderColA = 50
	else
		self.BorderCol = self.Col
		self.BorderColA = 30
	end
	
	local Wide, Tall = self:GetSize()

	surface.SetDrawColor(self.Col.r, self.Col.g, self.Col.b, self.Col.a)
	surface.DrawRect(0, 0, Wide, Tall)

	surface.SetDrawColor(self.BorderCol.r, self.BorderCol.g, self.BorderCol.b, self.BorderColA)
	surface.DrawOutlinedRect(0, 0, Wide, Tall)

	draw.SimpleText(self.TopText, STGamemodes.Store:SelectFont(self.TopText, Wide - 10), Wide / 2+1, 10+1, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.TopText, STGamemodes.Store:SelectFont(self.TopText, Wide - 10), Wide / 2, 10, COLOR_GOLD, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText(self.Text, STGamemodes.Store:SelectFont(self.Text, Wide - 10), Wide / 2+1, Tall - 10+1, Color(0,0,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.Text, STGamemodes.Store:SelectFont(self.Text, Wide - 10), Wide / 2, Tall - 10, COLOR_CATLABEL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if (self.Hovered) then
		surface.SetDrawColor(255, 255, 255, 30)
		surface.DrawRect(0, 0, Wide, Tall)
	elseif (self.Selected) then
		surface.SetDrawColor(255, 255, 255, 40)
		surface.DrawRect(0, 0, Wide, Tall)
	end
end

function PANEL:PerformLayout()
	if(!self.Image) then
		return
	end
	self.Image:SetZPos(20)
	self.Image:SetSize(60, 60)
	self.Image:AlignTop(6)
	self.Image:CenterHorizontal()
	self.Image:CenterVertical()
end
vgui.Register("STGamemodes.VGUI.StoreButton", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:OnThink()
	local Count, MaxCount = STGamemodes.Store:HasItemInCategory(LocalPlayer(), self.Text)
	if(Count >= MaxCount) then
		if(!self.HasItem) then
			self.HasItem = true
			self:UpdateTooltip()
		end
	else
		self.HasItem = false
		if(STGamemodes.Store:CanBuyCategoryItem(LocalPlayer(), self.Text)) then
			self.CanBuy = true
		else
			if(self.CanBuy) then
				self.CanBuy = false
				self:UpdateTooltip()
			end
		end
	end
end

function PANEL:Clicked()
	self.Mother:SetSelectedCat(self)
end

vgui.Register("STGamemodes.VGUI.StoreCategoryButton", PANEL, "STGamemodes.VGUI.StoreButton")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:OnThink()
	if(STGamemodes.Store:HasItem(LocalPlayer(), self.Text)) then
		if(!self.HasItem) then
			self.HasItem = true
			if(self.Mother:GetSelected() == self) then
				self.Mother:SetSelected(self)
			end
			self:UpdateTooltip()
		end
	else
		self.CanBuy = STGamemodes.Store:CanBuyItem(LocalPlayer(), self.Text)
		if(self.HasItem) then
			self.HasItem = false
			if(self.Mother:GetSelected() == self) then
				self.Mother:SetSelected(self)
			end
			self:UpdateTooltip()
		end
	end
end

function PANEL:Clicked()
	self.Mother:SetSelected(self)
end

vgui.Register("STGamemodes.VGUI.StoreItemButton", PANEL, "STGamemodes.VGUI.StoreButton")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()

	self.SidebarPanel = vgui.Create("DPanelList", self)
	self.SidebarPanel:EnableVerticalScrollbar( true )
	self.SidebarPanel:EnableHorizontal( false )
	self.SidebarPanel:Dock(RIGHT)
	self.SidebarPanel:SetWide(320)
	self.SidebarPanel.Paint = function()
		local w, h = self.SidebarPanel:GetSize()
		surface.SetDrawColor(0,0,0,100)
		surface.DrawRect(0, 0, w, h)
	end
	
	self.PlayerModelPanel = vgui.Create("DSassilizationModelPanel", self)
	self.PlayerModelPanel:Dock(FILL)
	self.PlayerModelPanel:SetAnimated(true)
	
	local BH = 25
	local BW = 100
	local Spacing = 5

	self.UpdateButton = vgui.Create("DButton", self)
	self.UpdateButton:SetText("Update Settings")
	self.UpdateButton:SetSize(BW,BH)
	
	local x, y = self.PlayerModelPanel:GetPos()
	self.UpdateButton:SetPos(x+Spacing,y+Spacing)
	
	self.UpdateButton.Updates = {}
	self.UpdateButton.DoClick = function()
		for _, update in ipairs(self.UpdateButton.Updates) do
			update()
		end
		LocalPlayer():ChatPrint("Your settings have been updated!")
		self.UpdateButton:SetVisible(false)
	end

	local x, y = self.UpdateButton:GetPos()
	self.RemoveTrail = vgui.Create("DButton", self)
	self.RemoveTrail:SetText("Remove Trail")
	self.RemoveTrail:SetSize(BW,BH)
	self.RemoveTrail:SetPos(x,y+BH+Spacing)
	self.RemoveTrail.DoClick = function()
		LocalPlayer():ConCommand("st_store_trail")
		TrailsClearList()
	end

	local x, y = self.RemoveTrail:GetPos()
	self.RemoveHat = vgui.Create("DButton", self)
	self.RemoveHat:SetText("Remove Hat")
	self.RemoveHat:SetSize(BW,BH)
	self.RemoveHat:SetPos(x,y+BH+Spacing)
	self.RemoveHat.DoClick = function()
		LocalPlayer():ConCommand("st_store_hat")
		self.PlayerModelPanel:RemoveHat()
		HatsClearList()
	end

	self:Update()
	
end

function PANEL:Update()

	self.SidebarPanel:Clear()

	local LocalItems = STGamemodes.Store.LocalItems
	--local Updates = {}
	
	local MainModelPanel = self.PlayerModelPanel

	local UpdateButton = self.UpdateButton
	UpdateButton.Updates = {}
	
	if(LocalItems["Player Models"]) then
		
		local ModelCategory = vgui.Create("DCollapsibleCategory")
		ModelCategory:SetLabel("Player Models")
		//ModelCategory:SetExpanded(1)
		
		local CategoryList = vgui.Create( "DPanelList" )
		CategoryList:SetAutoSize( true )
		CategoryList:SetPadding(5)
		CategoryList:SetSpacing(5)
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		CategoryList.Paint = function()
			local w, h = CategoryList:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0, 0, w, h)
		end
		
		ModelCategory:SetContents(CategoryList)
		
		self.SidebarPanel:AddItem(ModelCategory)
		
		-- List of player models
		local ModelList = vgui.Create("DComboBox")
		-- ModelList:SetTall(100)
		-- ModelList:SetMultiple(false)
		
		-- local ChooseOptionID = ModelList.ChooseOptionID
		-- function ModelList:ChooseOptionID(item, onlyme)
		-- 	if !item then return end
		-- 	print(item)
		-- 	local Name = ModelList.Choices[item]
		-- 	if(MainModelPanel.SelectedModel != Name) then
		-- 		MainModelPanel.SelectedModel = Name
		-- 		MainModelPanel:SetModel(STGamemodes.PlayerModels[Name])
		-- 	end
		-- 	UpdateButton:SetVisible(true)
		-- 	return ChooseOptionID(item)
		-- end

		function ModelList:OnSelect(index, value, data) 
			if MainModelPanel.SelectedModel != value then 
				MainModelPanel.SelectedModel = value 
				MainModelPanel:SetModel(STGamemodes.PlayerModels[value]) 
			end 
			UpdateButton:SetVisible(true) 
		end 
		
		for k,v in pairs(LocalItems["Player Models"]) do
			local Name = string.Trim(k)
			if(Name != "" and STGamemodes.PlayerModels[Name]) then
				local Item = ModelList:AddChoice(Name)
				if(LocalItems["Player Models"].Selected == Name) then
					ModelList:ChooseOptionID(Item)
				end
			end
		end
		
		if(!LocalItems["Player Models"].Selected) then
			if ModelList.Choices[1] then 
				ModelList:ChooseOptionID(1)
			end 
		end
		
		table.sort(ModelList.Choices, function(a, b)
			return a < b
		end)
		
		-- Function to update player model
		table.insert( self.UpdateButton.Updates, function()
			local Table = ModelList:GetText()
			if(Table and Table != "") then
				RunConsoleCommand("st_store_playermodel", Table)
			end
		end )
		
		CategoryList:AddItem( ModelList )
		
	end

	if STGamemodes.Store:HasItem(ply, "Tron") then 
		local TronCategory = vgui.Create("DCollapsibleCategory")
		TronCategory:SetLabel("Tron Skin")
	
		local CategoryList = vgui.Create( "DPanelList" )
		CategoryList:SetAutoSize( true )
		CategoryList:SetPadding(5)
		CategoryList:SetSpacing(5)
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		CategoryList.Paint = function()
			local w, h = CategoryList:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0, 0, w, h)
		end
		
		TronCategory:SetContents(CategoryList)

		local SkinSlider = vgui.Create("DComboBox")
		local Skin = STGamemodes.Store:GetItemInfo(ply, "Player Models", "TronSkin")
		for k, v in pairs(STGamemodes.Store.TronSkins) do 
			local Choice = SkinSlider:AddChoice(k) 
			if Skin and v == Skin then 
				SkinSlider:ChooseOptionID(Choice) 
			end 
		end 

		function SkinSlider:OnSelect( index, value, data )
			RunConsoleCommand("st_tronskin", value)
		end 

		CategoryList:AddItem( SkinSlider )
		self.SidebarPanel:AddItem(TronCategory)
	end 

	if STGamemodes.Store:HasItem(ply, "Lilith") then 
		local TronCategory = vgui.Create("DCollapsibleCategory")
		TronCategory:SetLabel("Lilith Skin")
	
		local CategoryList = vgui.Create( "DPanelList" )
		CategoryList:SetAutoSize( true )
		CategoryList:SetPadding(5)
		CategoryList:SetSpacing(5)
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		CategoryList.Paint = function()
			local w, h = CategoryList:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0, 0, w, h)
		end
		
		TronCategory:SetContents(CategoryList)

		local SkinSlider = vgui.Create("DComboBox")
		local Skin = STGamemodes.Store:GetItemInfo(ply, "Player Models", "LilithSkin")
		for k, v in pairs(STGamemodes.Store.LilithSkins) do 
			local Choice = SkinSlider:AddChoice(k) 
			if Skin and v == Skin then 
				SkinSlider:ChooseOptionID(Choice) 
			end 
		end 

		function SkinSlider:OnSelect( index, value, data )
			RunConsoleCommand("st_lilithskin", value)
		end 

		CategoryList:AddItem( SkinSlider )
		self.SidebarPanel:AddItem(TronCategory)
	end 

	
	if(LocalItems["Trails"]) then
		
		local TrailsCategory = vgui.Create("DCollapsibleCategory")
		TrailsCategory:SetLabel("Trails")
		//TrailsCategory:SetExpanded(0)
		
		local CategoryList = vgui.Create( "DPanelList" )
		CategoryList:SetAutoSize(true)
		CategoryList:SetPadding(5)
		CategoryList:SetSpacing(5)
		CategoryList:EnableHorizontal(true)
		CategoryList:EnableVerticalScrollbar(true)
		CategoryList.Paint = function()
			local w, h = CategoryList:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0, 0, w, h)
		end
		
		TrailsCategory:SetContents(CategoryList)
		
		self.SidebarPanel:AddItem(TrailsCategory)
		
		-- Trail Preview Image
		local TrailPreview = vgui.Create("DImage", self)
		TrailPreview:SetTall(100)
		TrailPreview:SetWide(100)
		
		-- Trail color mixer
		local ColorMixer = vgui.Create("DColorMixer", self)
		ColorMixer:SetTall(100)
		ColorMixer:SetWide(194)
		ColorMixer:SetAlphaBar(false)
		-- ColorMixer:SetColor(Color(255,255,255,255))
		ColorMixer:SetColor( LocalItems["Trails"].Col or Color(255, 255, 255, 255) )
		ColorMixer.Think = function()
			local MColor = ColorMixer:GetColor()
			if(self.MCOlor != MColor) then
				UpdateButton:SetVisible(true)
				
				self.MCOlor = MColor
				TrailPreview:SetImageColor(self.MCOlor)
				if !ColorMixer.bInitialColor then
					ColorMixer:SetColor(self.MCOlor)
					ColorMixer.bInitialColor = true
				end
			end
			--return ColorMixerThink(self)
		end
		ColorMixer.HSV:SetRGB(LocalItems["Trails"].Col or Color(255, 255, 255, 255))
		ColorMixer.HSV:SetColor(LocalItems["Trails"].Col or Color(255, 255, 255, 255))

		CategoryList:AddItem( ColorMixer )
		CategoryList:AddItem( TrailPreview )
		
		-- List of trails
		local TrailsList = vgui.Create("DComboBox", self)
		TrailsList:SetTall(100)
		TrailsList:SetWide(294)
		
		-- local ChooseOptionID = TrailsList.ChooseOptionID
		-- function TrailsList:ChooseOptionID(item, onlyme)
		-- 	if !item then return end
		-- 	local Name = TrailsList.Choices[item]
		-- 	TrailPreview:SetImage(STGamemodes.Trails[Name][1])
		-- 	UpdateButton:SetVisible(true)
		-- 	return ChooseOptionID(item)
		-- end

		function TrailsList:OnSelect(item, value, data) 
			TrailPreview:SetImage(STGamemodes.Trails[value][1]) 
			UpdateButton:SetVisible(true)
		end 

		function TrailsClearList()
			TrailsList:SetText("")
		end 
		
		for k,v in pairs(LocalItems["Trails"]) do
			local Name = string.Trim(k)
			if(Name != "" and STGamemodes.Trails[Name]) then
				local Item = TrailsList:AddChoice(Name)
				if(LocalItems["Trails"].Selected == Name) then
					TrailsList:ChooseOptionID(Item)
				end
			end
		end
		
		-- if(!LocalItems["Trails"].Selected) then
		-- 	-- TrailsList:SelectItem(TrailsList:GetItems()[1], true)
		-- 	-- self.RemoveTrail:SetVisible(false)
		-- 	self:Update()
		-- end
		
		table.sort(TrailsList.Choices, function(a, b)
			return a < b
		end)
		
		-- Function to update trail
		table.insert( self.UpdateButton.Updates, function()
			local Table = TrailsList:GetText()
			if Table and Table != "" then
				local Col = ColorMixer:GetColor()
				RunConsoleCommand("st_store_trail", Table, Col.r, Col.g, Col.b, Col.a)
			end
		end )
		
		CategoryList:AddItem( TrailsList )
		
	end
	
	
	if(LocalItems["Hats"]) then
		
		local HatsCategory = vgui.Create("DCollapsibleCategory")
		HatsCategory:SetLabel("Hats")
		//HatsCategory:SetExpanded(0)
		
		local CategoryList = vgui.Create( "DPanelList" )
		CategoryList:SetAutoSize( true )
		CategoryList:SetPadding(5)
		CategoryList:SetSpacing(5)
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		CategoryList.Paint = function()
			local w, h = CategoryList:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0, 0, w, h)
		end
		
		HatsCategory:SetContents(CategoryList)
		
		self.SidebarPanel:AddItem(HatsCategory)
		
		-- List of hats
		local HatsList = vgui.Create("DComboBox", self)
		-- HatsList:SetTall(100)
		-- HatsList:SetMultiple(false)
		
		function HatsList:OnSelect(item, value, data)
			MainModelPanel:SetHatModel(STGamemodes.Hats[value][1], STGamemodes.Hats[value])
			UpdateButton:SetVisible(true)
		end
		
		for k,v in pairs(LocalItems["Hats"]) do
			local Name = string.Trim(k)
			if(Name != "" and STGamemodes.Hats[Name]) then
				local Item = HatsList:AddChoice(Name)
				if(LocalItems["Hats"].Selected == Name) then
					HatsList:ChooseOptionID(Item)
				end
			end
		end

		function HatsClearList()
			HatsList:SetText("")
		end
		
		-- if(!LocalItems["Hats"].Selected) then
		-- 	HatsList:SelectItem(HatsList:GetItems()[1], true)
		-- end
		
		table.sort(HatsList.Choices, function(a, b)
			return a < b
		end)
		
		-- Function to update trail
		table.insert( self.UpdateButton.Updates, function()
			local Table = HatsList:GetText()
			if(Table and Table != "") then
				RunConsoleCommand("st_store_hat", Table)
			end
		end )
		
		CategoryList:AddItem( HatsList )
		
	end
	
	
	if(LocalItems["Misc"]) then
		
		local MiscCategory = vgui.Create("DCollapsibleCategory", self.SidebarPanel)
		MiscCategory:SetLabel("Misc")
		//MiscCategory:SetExpanded(0)
		
		local CategoryList = vgui.Create( "DPanelList" )
		CategoryList:SetAutoSize( true )
		CategoryList:SetPadding(5)
		CategoryList:SetSpacing(5)
		CategoryList:EnableHorizontal( false )
		CategoryList:EnableVerticalScrollbar( true )
		CategoryList.Paint = function()
			local w, h = CategoryList:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0, 0, w, h)
		end
		
		MiscCategory:SetContents(CategoryList)
		
		local function AddCheckbox( Text, Tooltip, bValue, Checked, Unchecked )
			local checkbox = vgui.Create("DCheckBoxLabel")
			checkbox:SetText(tostring(Text))
			checkbox:SetValue(bValue)
			if Tooltip then checkbox:SetTooltip(tostring(Tooltip)) end
			checkbox:SizeToContents()
			function checkbox.OnChange()
				if(checkbox:GetChecked()) then
					Checked()
				else
					Unchecked()
				end
			end
			
			CategoryList:AddItem( checkbox )
		end
		
		AddCheckbox("Enable Trails",
			"You can also type '/trails' in chat or bind a key to 'st_enabletrails' to toggle trails",
			!file.Exists("DisableTrails.txt", "DATA"),
			function()
				RunConsoleCommand( "st_enabletrails" )
			end,
			function()
				RunConsoleCommand( "st_enabletrails" )
			end
		)
		
		if(STGamemodes.Store:HasItem(LocalPlayer(), "Ghost Mode")) then
			AddCheckbox("Ghost Mode",
				"You can also type '/ghostmode' in chat or bind a key to 'st_ghostmode' to toggle Ghost Mode",
				LocalPlayer():CanGhost(),
				function() RunConsoleCommand("st_store_ghost", 1) end,
				function() RunConsoleCommand("st_store_ghost", 0) end
			)
		end
		
		if(STGamemodes.Store:HasItem(LocalPlayer(), "Third Person Mode")) then
			AddCheckbox("Third Person Mode",
				"You can also type '/thirdperson' in chat or bind a key to 'st_thirdperson' to toggle third person mode",
				LocalPlayer():CanThirdPerson(),
				function() RunConsoleCommand("st_store_thirdperson", 1) end,
				function() RunConsoleCommand("st_store_thirdperson", 0) end
			)
		end
		
		AddCheckbox("Enable Forum Online List",
			"Toggles the Forum Online List located on your scoreboard.",
			(UserCPOnlineListCVar:GetInt()==1),
			function() RunConsoleCommand("st_forumonline") end,
			function() RunConsoleCommand("st_forumonline") end
		)
		if GAMEMODE and (GAMEMODE.Name == "Bunny Hop" or GAMEMODE.Name == "Climb") then 
			AddCheckbox("Draw Players",
				"Toggles the drawing of players.",
				(GetDrawingPlayers()),
				function() RunConsoleCommand("st_hideplayers") end,
				function() RunConsoleCommand("st_hideplayers") end
			)
		end 
		
		if GAMEMODE and (GAMEMODE.Name == 'STBunnyHop') then
			AddCheckbox("Telehopping",
				"Toggles the ability to telehop on maps.",
				(GetTelehopStatus()),
				function() RunConsoleCommand("st_toggletelehop") end,
				function() RunConsoleCommand("st_toggletelehop") end
			)
		end

		AddCheckbox("Mute Voice Chat",
			"Mutes voice chat client side.  You can also type /voice in chat.",
			STGamemodes.Voice.ClientDisabled,
			STGamemodes.Voice.ToggleVoice,
			STGamemodes.Voice.ToggleVoice
		)

		if(IsDecember()) then
			AddCheckbox("Snow Mode",
				"Enable/Disable snow and frosty vignette effect. You can also type '/snow'.",
				!file.Exists("DisableSnow.txt", "DATA"),
				function() RunConsoleCommand("st_disablesnow") end,
				function() RunConsoleCommand("st_disablesnow") end
			)
		end

		AddCheckbox("Background Blur",
			"You can also use 'st_cl_blur_amount integer' to set the blur amount.",
			GetConVar("st_cl_blur"):GetBool(),
			function() RunConsoleCommand("st_cl_blur", 1) end,
			function() RunConsoleCommand("st_cl_blur", 0) end
		)
		

		self.SidebarPanel:AddItem(MiscCategory)
		
	end

end

vgui.Register("STGamemodes.VGUI.Settings", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------------------------------

local iconprefix = "sassilization/servers/"
STGamemodes.Servers = {}
STGamemodes.Servers["Deathrun"] = {
	IP = "192.31.185.138:27015",
	Description = [[Dodging traps to kill the deaths is your only concern.]],
	Icon = Material(iconprefix.."deathrun_server"),
}

STGamemodes.Servers["Climb"] = {
	IP = "192.31.185.138:27017",
	Description = [[Climb to the top of the world to save trapped hostages.]],
	Icon = Material(iconprefix.."climb_server"),
}

STGamemodes.Servers["Bunny Hop"] = {
	IP = "192.31.185.138:27016",
	Description = [[Hop like a madman until you reach the end.]],
	Icon = Material(iconprefix.."bhop_server"),
}

-- STGamemodes.Servers["Surf"] = {
-- 	IP = "37.59.184.231:27015",
-- 	Description = [[Kill people deathmatch-style while surfing on concrete.]],
-- 	Icon = "surf_server",
-- }


-- STGamemodes.Servers["Zombie Escape"] = {
-- 	IP = "192.30.136.8:27015",
-- 	Description = [[Escape from the infection by completing the map.]],
-- 	Icon = "ze_servertest",
-- }

local PANEL = {}

function PANEL:Init()
	self.ServerList = vgui.Create("DPanelList", self)
	self.ServerList:SetSpacing(5)
	self.ServerList:EnableHorizontal(false)
	self.ServerList:EnableVerticalScrollbar(true)
	self.ServerList:NoClipping(false)
	self.ServerList:SetDrawBackground(false)

	for k, v in pairs(STGamemodes.Servers) do
		self.ServerPanel = vgui.Create("DPanel")
		self.ServerPanel:SetTall(74)
		self.ServerPanel.Paint = function()
			local w, h = self.ServerPanel:GetSize()
			surface.SetDrawColor(255,255,255,20)
			surface.DrawRect(0,0,w,h)

			surface.SetDrawColor(255,255,255,40)
			surface.DrawOutlinedRect(0,0,w,h)
		end

		self.IconB = vgui.Create("DPanel", self.ServerPanel) 
		self.IconB:SetPos(5, 5) 
		self.IconB:SetSize(64, 64) 
		self.IconB.Paint = function() 
			surface.SetDrawColor(255, 255, 255, 30) 
			surface.DrawRect(0, 0, self.IconB:GetWide(), self.IconB:GetTall()) 
		end 

		self.Icon = vgui.Create("DImage", self.ServerPanel)
		self.Icon:SetMaterial(v.Icon)
		self.Icon:SetPos(5, 5)
		self.Icon:SetSize(64, 64)

		self.Name = vgui.Create("DLabel", self.ServerPanel)
		self.Name:SetFont("ServerListHead")
		self.Name:SetTextColor(Color(255,255,255,255))
		self.Name:SetPos(74, 5)
		--self.Name:MoveRightOf(self.Icon, 10)
		self.Name:SetText(k)
		self.Name:SizeToContents()

		self.Description = vgui.Create("DLabel", self.ServerPanel)
		self.Description:SetFont("ServerListDesc")
		self.Description:SetTextColor(Color(230,230,230,255))
		self.Description:SetPos(74, 45)
		--self.Description:MoveRightOf(self.Icon, 10)
		--self.Description:MoveBelow(self.Name, 10)
		self.Description:SetText(v.Description)
		self.Description:SizeToContents()

		self.Connect = vgui.Create("ServerConnect", self.ServerPanel)
		self.Connect:SetText("CONNECT")
		self.Connect:SetSize(120, 20)
		self.Connect:Dock(RIGHT)
		self.Connect:MoveBelow(self.Description, 5)
		self.Connect:SetFont("ServerListConn")
		function self.Connect.DoClick()
			LocalPlayer():ConCommand("connect "..v.IP.."\n")
		end

		self.ServerList:AddItem(self.ServerPanel)
	end
end



function PANEL:PerformLayout()
	self.ServerList:StretchToParent(5, 5, 5, 25)
end

vgui.Register("STGamemodes.VGUI.Servers", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self.Header = vgui.Create("DLabel", self)
	self.Header:SetColor(color_white)
	self.Header:SetFont("DefaultBold")
	self.Header:SetText("VIP's recieve the following benefits")
	self.Header:SizeToContents()
	
	self.Benefits = vgui.Create("DLabel", self)
	self.Benefits:SetColor(color_white)
	self.Benefits:SetText([[
		1. Everything in the store is 30% off.
		2. If you're a runner and you kill a death, you receive 240 dough.
		3. If you're a death and you kill a runner, you receive 300 dough.
		4. If you win a round as a runner, you receive 200 dough.
		5. If you win a round as a death, you receive 100 dough.	
		6. In Deathrun you get double health and a speed increase.
		7. Higher playlist limit in the jukebox.
		8. Free songs from the jukebox.
		9. You get double voting power.
		10. In Bunny Hop you win 25% more dough.
		11. In Deathrun you get access to voteslay.
		12. Many benefits in the main Sassilization Lobby Server! (Currently Down)
		13. Possibly more unlisted benefits!
		Reminder: These benefits are subject to change.
	]])
	self.Benefits:SizeToContents()
	
	self.Footer = vgui.Create("DLabel", self)
	self.Footer:SetColor(color_white)
	self.Footer:SetFont("DefaultBold")
	self.Footer:SetText("Donate over at www.sassilization.com/usercp by logging into your Sassilization account.")
	self.Footer:SizeToContents()
end

function PANEL:PerformLayout()
	self.Header:AlignTop(self:GetTall()/2 - self.Benefits:GetTall()/2 - self.Footer:GetTall()/2 - self.Header:GetTall()/2 - 10)
	self.Header:CenterHorizontal()
	
	self.Benefits:MoveBelow(self.Header, 5)
	self.Benefits:CenterHorizontal()
	
	self.Footer:MoveBelow(self.Benefits, 5)
	self.Footer:CenterHorizontal()
end

vgui.Register("STGamemodes.VGUI.VIPBenefits", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

local PANEL = {}

function PANEL:Init()
	self.Header = vgui.Create("DLabel", self)
	self.Header:SetColor(color_white)
	self.Header:SetText("Your Sassilization account is used to login to the usercp and forums.\nOur forums are located at www.sassilization.com/forums\nOur usercp is located at www.sassilization.com/usercp")
	self.Header:SizeToContents()
	
	self.LookupUsername = vgui.Create("DButton", self)
	self.LookupUsername:SetText("Lookup Username")
	function self.LookupUsername.DoClick()
		RunConsoleCommand("st_lookupusername")
	end
	
	self.ResetPassword = vgui.Create("DButton", self)
	self.ResetPassword:SetText("Reset Password")
	function self.ResetPassword.DoClick()
		Derma_QueryFixed("Are you sure you want to reset your account password?\nDoing so will cause you to rejoin the server", "Confirmation",
			"Yes", function()
				RunConsoleCommand("st_resetpassword")
			end,
			"No", function()
			end
		)
	end
end

function PANEL:PerformLayout()
	self.Header:AlignTop((self:GetTall() / 2) - 100)
	self.Header:CenterHorizontal()
	
	self.LookupUsername:SetWide(100)
	self.LookupUsername:MoveBelow(self.Header, 5)
	self.LookupUsername:CenterHorizontal()
	
	self.ResetPassword:SetWide(100)
	self.ResetPassword:MoveBelow(self.LookupUsername, 5)
	self.ResetPassword:CenterHorizontal()
end

vgui.Register("STGamemodes.VGUI.Account", PANEL, "DPanel")

-------------------------------------------------------------------------------------------------------------------------

concommand.Add("st_store", function(ply, cmd, args)
	-- if(STGamemodes.Store.Loading) then
	-- 	LocalPlayer():ChatPrint("Your profile is currently loading. Please wait...")
	-- 	return
	-- end
	if(!STGamemodes.Store.Panel or !STGamemodes.Store.Panel:IsValid()) then
		STGamemodes.Store.Panel = vgui.Create("STGamemodes.VGUI.Main")
		STGamemodes.Store.Panel:MakePopup()
	end
	if(!STGamemodes.Store.Panel:IsVisible()) then
		STGamemodes.Store.Panel:SetVisible(true)
		STGamemodes.Store.Panel:MakePopup()
	end

	if(STGamemodes.LevelSelect and ValidPanel(STGamemodes.LevelSelect)) then
		STGamemodes.LevelSelect:SetVisible(false)
	end 

	local Tab = args[1]
	if(!Tab) then
		return
	end
	local Panel = STGamemodes.Store.Panel.Tabs[string.upper(Tab)]
	if(Panel and Panel.Tab and Panel.Tab:IsValid()) then
		STGamemodes.Store.Panel.PropertySheet:SetActiveTab(Panel.Tab)
	end
end)

usermessage.Hook("STGamemodes.Store.UserMessageReqLoad", function(um)
	if(STValidEntity(LocalPlayer())) then
		RunConsoleCommand("st_store_requestload")
	end
end)

usermessage.Hook("STGamemodes.Store.UserMessageItemStart", function(um)
	STGamemodes.Store.Loading = true
	STGamemodes.Store.StartUMsg = true
end)

function STGamemodes.Store:UserMessageMultiItemID(um)
--[[ 	for k,v in pairs(self.LoadList) do
		local Char = tonumber(um:ReadChar())
		local Cat = self:GetCat(v)
		if(Cat) then
			self.LocalItems[Cat] = self.LocalItems[Cat] or {}
			if(Char > 0) then
				self.LocalItems[Cat][v] = true
			end
		end
	end
	RunConsoleCommand("st_store_loaded", "MultiItemID") ]]
	local Cat = um:ReadString()
	local item = um:ReadString()
	local Char = um:ReadBool()
	if Char then
		self.LocalItems[Cat] = self.LocalItems[Cat] or {}
		self.LocalItems[Cat][item] =  true
	end
end
usermessage.Hook("STGamemodes.Store.UserMessageMultiItemID", function(um) STGamemodes.Store:UserMessageMultiItemID(um) end)

usermessage.Hook("STGamemodes.Store.UserMessageMultiItemIDLoaded", function()
	RunConsoleCommand("st_store_loaded", "MultiItemID")
end)

function STGamemodes.Store:UserMessageItem(um)
	local Name = um:ReadString()
	local Data = um:ReadString()
	self.LocalItems[Name] = Json.Decode(Data)
	RunConsoleCommand("st_store_loaded", Name)
end
usermessage.Hook("STGamemodes.Store.UserMessageItem", function(um) STGamemodes.Store:UserMessageItem(um) end)

function STGamemodes.Store:UserMessageCatItem(um)
	local Cat = um:ReadString()
	local Name = um:ReadString()
	local Data = um:ReadString()
	self.LocalItems[Cat] = self.LocalItems[Cat] or {}
	self.LocalItems[Cat][Name] = Json.Decode(Data)
	RunConsoleCommand("st_store_loaded", Cat, Name)
	self.RefreshSettings = true
end
usermessage.Hook("STGamemodes.Store.UserMessageCatItem", function(um) STGamemodes.Store:UserMessageCatItem(um) end)

usermessage.Hook("STGamemodes.Store.UserMessageItemEnd", function(um)
	STGamemodes.Store.Loading = false
	STGamemodes.Store.LoadList = nil
	if(STGamemodes.VIP) then
		if(STGamemodes.Store:CatItemIsFree(LocalPlayer(), "Trails")) then
			STGamemodes.FreeTrail = true
			STGamemodes.Message("Free Trail", "Since you are a VIP you get to buy 1 free trail with a value equal to or less than 30k!")
		end
	end
end)

usermessage.Hook("STGamemodes.Store.UserMessageItemFree", function(um)
	STGamemodes.Message("Free Item", "Since you are a VIP you have received a free "..um:ReadString().."!")
end)