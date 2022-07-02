local PANEL = {}
local MapsPanel
local MapList;

function PANEL:Init()
	
	self:SetWide( 600 );
	
	MapsPanel = self;
	
	self.NoStretchX = true;
	self.NoStretchY = true;
	
	self.VoteMap = vgui.Create("DButton", self)
	self.VoteMap:SetText("VoteMap")
	self.VoteMap.DoClick = function()
		RunConsoleCommand( "st_startvotemap" )
	end
	
	self.ChangeMap = vgui.Create("DButton", self)
	self.ChangeMap:SetText("ChangeMap...")
	self.ChangeMap.DoClick = function(btn)
		local Menu = DermaMenu()
		if( #self.MapRotationPanelList:GetItems() == 0 ) then
			Menu:AddOption( "(no maps in rotation)", function() end )
		else
			for _, mapPanel in pairs( self.MapRotationPanelList:GetItems() ) do
				local mapname = mapPanel.mapName;
				Menu:AddOption( mapname, function()
					RunConsoleCommand( "st_changemap", mapname )
				end)
			end
		end
		Menu:Open()
	end
	
	self.AddButton = vgui.Create("DButton", self)
	self.AddButton:SetText("<")
	self.AddButton.DoClick = function()
		for _, mapPanel in pairs( self.MapListPanelList:GetItems() ) do
			if( mapPanel:GetSelected() ) then
				RunConsoleCommand( "st_maplist_add", mapPanel.mapName )
			end
		end
	end
	
	self.RemoveButton = vgui.Create("DButton", self)
	self.RemoveButton:SetText(">")
	self.RemoveButton.DoClick = function()
		for _, mapPanel in pairs( self.MapRotationPanelList:GetItems() ) do
			if( mapPanel:GetSelected() ) then
				RunConsoleCommand( "st_maplist_remove", mapPanel.mapName )
			end
		end
	end
	
	self.MapRotationPanelList = vgui.Create("DPanelList", self)
	self.MapRotationPanelList:SetSpacing(0)
	self.MapRotationPanelList:EnableVerticalScrollbar(true)
	
	self.MapListPanelList = vgui.Create("DPanelList", self)
	self.MapListPanelList:SetSpacing(0)
	self.MapListPanelList:EnableVerticalScrollbar(true)
	
	if( MapList ) then
		for k, v in ipairs( MapList ) do
			local mapname, bEnabled, bSelected = v[1], v[2], v[3]
			if( bEnabled ) then
				
				self:AddMapPanel( self.MapRotationPanelList, mapname, selected )
				
			else
				
				self:AddMapPanel( self.MapListPanelList, mapname, selected )
				
			end
		end
	end
	
	self:PerformLayout()
	
end

function PANEL:PerformLayout()

	local SizeX = self:GetWide()
	local SizeY = self:GetTall()
	
	local Spacing = 5
	
	local PositionX = 5
	local PositionY = 3
	
	local ButtonSizeX = 80
	local ButtonSizeY = 20
	
	SizeY = SizeY - 50
	
	self.VoteMap:SetPos(PositionX, PositionY)
	self.VoteMap:SetSize(ButtonSizeX, ButtonSizeY)
	
	PositionX = PositionX + self.VoteMap:GetWide() + Spacing
	
	self.ChangeMap:SetPos(PositionX, PositionY)
	self.ChangeMap:SetSize(ButtonSizeX, ButtonSizeY)
	
	PositionX = PositionX + self.ChangeMap:GetWide() + Spacing
	
	PositionX = 5
	PositionY = PositionY + ButtonSizeY + 20
	SizeX = SizeX - 10
	SizeY = SizeY + 10
	
	self.MapRotationPanelList:SetPos( 5, PositionY)
	self.MapRotationPanelList:SetSize( SizeX*0.5 - 35, SizeY - 5)
	
	self.MapListPanelList:SetPos( SizeX*0.5 + 30, PositionY)
	self.MapListPanelList:SetSize( SizeX*0.5 - 25, SizeY - 5)
	
	self.AddButton:SetWide( 50 )
	self.AddButton:SetPos( SizeX*0.5 - 25, SizeY*0.5 - self.AddButton:GetTall()*0.5 - 5 )
	
	self.RemoveButton:SetWide( 50 )
	self.RemoveButton:SetPos( SizeX*0.5 - 25, SizeY*0.5 + self.RemoveButton:GetTall()*0.5 + 5 )
	
end

local selectedPanel
local queue = 0

function PANEL:AddMapPanel( list, mapname, selected )
	
	
	for _, panel in pairs( list:GetItems() ) do
		
		if( panel.mapName == mapname ) then
			return
		end
		
	end
	
	local otherList = self.MapRotationPanelList;
	if( list == self.MapRotationPanelList ) then
		otherList = self.MapListPanelList
	end
	
	for _, panel in pairs( otherList:GetItems() ) do
		
		if( panel.mapName == mapname ) then
			otherList:RemoveItem( panel, true )
			otherList:Rebuild()
			otherList:PerformLayout()
			otherList.VBar:AddScroll( 0 )
			list:AddItem( panel )
			list:Rebuild()
			list:PerformLayout()
			return
		end
		
	end
	
	local DPanel = vgui.Create("DPanel")
	DPanel.Paint = function()
		if(DPanel:GetSelected()) then
			surface.SetDrawColor(0, 100, 255, 255)
			surface.DrawRect(0, 0, DPanel:GetWide(), DPanel:GetTall())
		end
	end

	function DPanel:GetSelected()
		return DPanel.Selected
	end

	function DPanel:SetSelected(Bool)
		DPanel.Selected = Bool
	end

	function DPanel:OnMousePressed(MouseCode)
		if(DPanel:GetSelected()) then
			DPanel.Selected = false
		else
			if( selectedPanel and selectedPanel:IsValid() ) then
				selectedPanel:SetSelected( false )
			end
			DPanel.Selected = true
			selectedPanel = DPanel
		end
	end
	
	DPanel.Icon = vgui.Create("HTML", DPanel)
    DPanel.Icon:SetMouseInputEnabled(false)
	DPanel.Icon:SetPos(5, 5)
	DPanel.Icon:SetHTML( "<html><style type=\"text/css\">body{overflow: hidden;background-color:rgb(50,50,50)}</style><body></body></html>" )
	
	local function getImage( panelIcon )
		http.Get( "http://sassilization.com/secretmaplisteditor/icon.php?mapname="..tostring(mapname), "", function( args, contents, size )
			args[1]:SetHTML( " <html><style type=\"text/css\">body{overflow:hidden;padding:0;margin:0}</style><body><img src=\"http://sassilization.com/secretmaplisteditor/map_icons/"..tostring(contents)..".png\"/></body></html>" )
			args[1]:Refresh()
			queue = queue - 1
		end, panelIcon )
	end
	timer.Simple(queue, function() getImage(DPanel.Icon) end)
	queue = queue + 1
	
	DPanel.Icon:SetSize(48,48)
	DPanel.Icon:SetVerticalScrollbarEnabled( false )
	
	DPanel.Label = vgui.Create("DLabel", DPanel)
	DPanel.Label:SetText( mapname )
	DPanel.Label:SizeToContents()
	DPanel.Label:SetPos(DPanel.Icon:GetWide() + 10, DPanel.Icon:GetTall() * 0.5 - DPanel.Label:GetTall()*0.5 + 5)
	
	if( selected ) then
		if( selectedPanel ) then
			selectedPanel:SetSelected( false )
		end
		selectedPanel = DPanel
	end
	
	DPanel.DoClick = DPanel.OnMousePressed
	DPanel.mapName = mapname
	DPanel:SetSelected( selected )
	DPanel:SetTall( 58 )
	
	list:AddItem( DPanel )
	list:Rebuild()
	list:PerformLayout()
	
end

usermessage.Hook( "STGamemodes.VGUI.Admin.Maps.Add", function( um )
	
	local mapname = um:ReadString()
	local bEnabled = um:ReadBool()
	local bSelected = um:ReadBool()
	
	if( !MapsPanel ) then
		MapList = MapList or {}
		table.insert( MapList, {mapname, bEnabled, bSelected} )
		return
	else
	
		if( bEnabled ) then
			
			MapsPanel:AddMapPanel( MapsPanel.MapRotationPanelList, mapname, selected )
			
		else
			
			MapsPanel:AddMapPanel( MapsPanel.MapListPanelList, mapname, selected )
			
		end
	
	end
	
end )

local tSize
function PANEL:Paint()
	
	surface.SetTextColor( 250, 250, 250, 255 )
	surface.SetFont( "BudgetLabel" )
	
	surface.SetTextPos( 15, 25 )
	surface.DrawText( "Maps in Rotation" )
	
	tSize = tSize or surface.GetTextSize( "Maps Available" )
	surface.SetTextPos( self:GetWide() - 25 - tSize, 25 )
	surface.DrawText( "Maps Available" )
	
end

vgui.Register("STGamemodes.VGUI.Admin.Maps", PANEL, "DPanel")