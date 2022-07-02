--------------------
-- STBase
-- By Spacetech
--------------------

include( "tabs/main.lua" )
-- include( "tabs/maps.lua" )

function STGamemodes.FindByPartial(Info)
	local Count = 0
	local FoundPlayer = false
	local Search = STGamemodes:ParseString(Info)
	for k,v in pairs(player.GetAll()) do
		if(v:EntIndex() == tonumber(Search) or tostring(v:EntIndex()) == Search) then
			return v
		end
		-- v:GetName(), 
		for k2,v2 in pairs({v:CName(), v:SteamID()}) do
			if(FoundPlayer != v) then
				local UniqueInfo = STGamemodes:ParseString(v2)
				if(string.find(UniqueInfo, Search, 1, true)) then
					if(UniqueInfo == Search) then
						return v
					end
					Count = Count + 1
					FoundPlayer = v
				end
			end
		end
	end
	if(FoundPlayer) then
		if(Count > 1) then
			return "Too many people's name contain that!"
		end
		return FoundPlayer 
	end
	return "No ones name contains that!"
end

local PANEL = {}

function PANEL:Init()
	if(!LocalPlayer():IsAdmin()) then
		self:Close()
	end
	
    self:SetTitle("Admin Panel")
	self:SetSizable(false)
    self:SetDraggable(true)
    self:ShowCloseButton(true)
	self:SetDeleteOnClose(true)
	
	self:SetSize(310, ScrH()/1.75)
	self.desiredWidth = self:GetWide();
	
    self:Center()
	
	local SizeX = self:GetWide() - 10
	local SizeY = self:GetTall() - 30
	
	local PositionX = 5
	local PositionY = 28
	
	self.PropertySheet = vgui.Create("DPropertySheet", self)
	self.PropertySheet:SetPos(PositionX, PositionY)
	self.PropertySheet:SetSize(SizeX, SizeY)
	self.PropertySheet.Paint = function()
		--surface.SetDrawColor(255,255,255,40)
		--surface.DrawRect(0,0,self.PropertySheet:GetWide(),self.PropertySheet:GetTall())
	end
	-----------------------------------------
	-- Start Tab: Main
	-----------------------------------------
	
	self.Main = vgui.Create("STGamemodes.VGUI.Admin.Main", self)
	self.Main:SetTall( SizeY )
	
	local DTab = self.PropertySheet:AddSheet("Main", self.Main, "icon16/user.png")
	DTab.Tab.OnMousePressed = function( tab, mcode )
		
		-- self.desiredWidth = tab:GetPanel():GetWide() + 20;
		tab:GetPropertySheet():SetActiveTab( tab )
		
	end
	
	-----------------------------------------
	-- End Tab: Main
	-----------------------------------------
	
	if( !LocalPlayer():IsAdmin() ) then return end
	
	-----------------------------------------
	-- Start Tab: Maps
	-----------------------------------------
	
	-- self.Maps = vgui.Create("STGamemodes.VGUI.Admin.Maps", self)
	-- self.Maps:SetTall( SizeY)
	
	-- local DTab = self.PropertySheet:AddSheet("Maps", self.Maps, "gui/silkicons/world")
	-- DTab.Tab.OnMousePressed = function( tab, mcode )
		
		-- self.desiredWidth = tab:GetPanel():GetWide() + 20;
		-- tab:GetPropertySheet():SetActiveTab( tab )
		
	-- end
	
	-----------------------------------------
	-- End Tab: Maps
	-----------------------------------------
end

function PANEL:Think()
	if(self.Dragging) then
		local x = gui.MouseX() - self.Dragging[1]
		local y = gui.MouseY() - self.Dragging[2]
		if(self:GetScreenLock()) then
			x = math.Clamp(x, 0, ScrW() - self:GetWide())
			y = math.Clamp(y, 0, ScrH() - self:GetTall())
		end
		self:SetPos(x, y)
	end
	
	local wide = self:GetWide()
	if( math.abs( wide - self.desiredWidth ) > 5 ) then
		
		local oldWide = wide
		wide = Lerp( 0.2, self:GetWide(), self.desiredWidth )
		
		self:SetWide( wide )
		self.PropertySheet:SetWide( wide - 10 )
		
		local x, y = self:GetPos()
		self:SetPos( x - (wide - oldWide)*0.5, y )
		
	elseif( wide != self.desiredWidth ) then
		
		wide = self.desiredWidth
		self:SetWide( wide )
		self.PropertySheet:SetWide( wide - 10 )
		
	end
	
end

vgui.Register("STGamemodes.VGUI.Admin", PANEL, "STGamemodes.VGUI.Base")

STGamemodes.Mod = false
STGamemodes.Admin = false

local Panel = false
concommand.Add("st_admin", function()
	if(!LocalPlayer():IsMod() and !STGamemodes.Mod) then
		return
	end
	if(!Panel or !Panel:IsValid()) then
		Panel = vgui.Create("STGamemodes.VGUI.Admin")
	end
	Panel:SetVisible(true)
	Panel:MakePopup()
end)

usermessage.Hook("activate_admin", function(um)
	STGamemodes.Admin = true
	STGamemodes.Mod = true
end)

usermessage.Hook("activate_mod", function(um)
	STGamemodes.Mod = true
end)
