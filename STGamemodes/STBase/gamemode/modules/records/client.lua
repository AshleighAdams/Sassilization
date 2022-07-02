--------------------
-- STBase
-- By Spacetech
--------------------

usermessage.Hook( "STGamemodes.Records:CheckPersonal", function(um) 
	local Time = um:ReadShort() 

	STGamemodes.Records:LoadPersonalRecord( LocalPlayer(), false, LocalPlayer().Record )
end )

function STGamemodes.Records.PersonalCmd( ply, cmd, args )
	if !STGamemodes.Records:GetEnabled() then 
		return 
	end 
	
	STGamemodes.Records:LoadPersonalRecord( ply, true, nil, args[1] )
end
concommand.Add( "st_record", STGamemodes.Records.PersonalCmd )

function STGamemodes.Records.TopCmd( ply, cmd, args )
	if !STGamemodes.Records:GetEnabled() then 
		return 
	end 

	STGamemodes.Records:Load( true, args[1] )

end
concommand.Add( "st_top", STGamemodes.Records.TopCmd )

local Panel = false
function STGamemodes.Records:OpenTop(Map)
	if Panel or (Panel and Panel:IsValid()) then
		Panel:Close()
		Panel:Remove()
		Panel = false
	end
	if(!Panel or !Panel:IsValid()) then
		Panel = vgui.Create("STGamemodes.VGUI.Records")
	end
	Panel:SetVisible(true)
	Panel:MakePopup()
	Panel:SetTitle("Map Records - ".. (Map or game.GetMap()))
end

local PANEL = {}

function PANEL:Init()
	-- self:SetTitle("Map Records - ".. game.GetMap())
	self:SetSizable(false)
    self:SetDraggable(false)
    self:ShowCloseButton(true)
	self:SetDeleteOnClose(true)
	
	self:SetSize( 400, 454 )
	
	self:Center()

	if !STGamemodes.Records.Top or !STGamemodes.Records.Top[1] then
		self.Loading = vgui.Create("DLabel", self )
		self.Loading:SetFont("STHUD44NO")
		self.Loading:SetText("LOADING")
		self.Loading:SetExpensiveShadow(1, Color(0, 0, 0, 100))
		self.Loading:SetTextColor(Color(255,255,255,255))
		self.Loading:SizeToContents()
		self.Loading:Center()
		timer.Create( "Records.ERROR", 5, 1, function() 
			if self and self:IsValid() and self.Loading and self.Loading:IsValid() then 
				self.Loading:SetText("ERROR LOADING")
				self.Loading:SetTextColor(Color(255, 0, 0, 200)) 
				self.Loading:SizeToContents()
				self.Loading:Center() 
			end 
		end )
	else 
		timer.Destroy( "Records.ERROR" )
		self.List = vgui.Create("DPanelList", self )
		self.List:SetPadding(3)
		self.List:SetSpacing(2)
		self.List:EnableVerticalScrollbar()
		self.List:StretchToParent(5,25,5,5)
		self.List.Paint = nil
		self.List:Clear()
		for k, v in pairs(STGamemodes.Records.Top) do
			local id = k%2;
			local col = Color(255,255,255,50)
			if (id == 0) then
				col = Color(255,255,255,20)
			elseif(id == 1) then
				col = Color(255,255,255,50)
			end

			if (k == 1) then
				tcol = Color(150,255,150,255)
			else
				tcol = Color(255,255,255,255)
			end
			self.ListPanel = vgui.Create("DPanelList")
			self.ListPanel:SetTall(40)
			self.ListPanel.Paint = function()
				surface.SetDrawColor(col.r, col.g, col.g, 50)
				surface.DrawOutlinedRect(0,0,self.ListPanel:GetWide(), self.ListPanel:GetTall())

				surface.SetDrawColor(col.r, col.g, col.g, col.a)
				surface.DrawRect(0,0,self.ListPanel:GetWide(), self.ListPanel:GetTall())
			end

			self.RecordID = vgui.Create("DLabel", self.ListPanel)
			self.RecordID:SetFont("STHUD30NO")
			self.RecordID:SetText(k..STNDRD(k))
			self.RecordID:SetPos(10,4)
			self.RecordID:SetExpensiveShadow(1, Color(0, 0, 0, 100))
			self.RecordID:SetTextColor(tcol)
			self.RecordID:SizeToContents()

			self.Time = vgui.Create("DLabel", self.ListPanel)
			self.Time:SetFont("STHUD15NO")
			self.Time:SetText(STGamemodes:SecondsToFormat(v[3], true))
			self.Time:SetPos(325,13)
			self.Time:SetExpensiveShadow(1, Color(0, 0, 0, 100))
			self.Time:SetTextColor(tcol)
			self.Time:SizeToContents()
			self.Time:SetPos(350-self.Time:GetWide()/2, 13)

			self.Name = vgui.Create("DLabel", self.ListPanel)
			self.Name:SetFont("STHUD20NO")
			self.Name:SetText(v[2])
			self.Name:SetPos(76,10)
			self.Name:SetExpensiveShadow(1, Color(0, 0, 0, 100))
			self.Name:SetTextColor(tcol)
			self.Name:SizeToContents()
			self.Name:SetWide(self:GetWide()-76-self.Time:GetWide()/2-50-5)
					
			self.List:AddItem(self.ListPanel)
		end
	end 
end
vgui.Register("STGamemodes.VGUI.Records", PANEL, "STGamemodes.VGUI.Base")
