--------------------
-- STBase
-- By Spacetech
--------------------

surface.CreateFont("JukeboxRefreshing", {font="Agency FB",size=72, weight=300})

Jukebox.Music = {}
Jukebox.IDs = {}
Jukebox.Playlist = {}
Jukebox.RefreshQueue = {}

Jukebox.Width = 0
Jukebox.UID = false
Jukebox.Panel = false
Jukebox.Radio = false
Jukebox.SteamID = false
Jukebox.Refreshing = false

Jukebox.Volume = CreateClientConVar( "st_volume", "100", true, false )

local col = Color(54, 77, 106, 230)

function Jukebox.HUDPaint()
	Jukebox.Width = 0
	
	local Table = Jukebox.Current
	if(!Table or !Table.ID) then
		return
	end
	
	local ScreenWidth = ScrW()
	local ScreenHeight = ScrH()
	
	local Name = Table.Name
	local Time = Table.Time
	local TimeStart = Table.TimeStart
	local TimeEnd = Table.TimeEnd
	
	if(TimeEnd and TimeEnd <= CurTime()) then
		Jukebox.Current = false
		return
	end
	
	if(TimeStart and TimeEnd) then
		Time = math.Round(CurTime() - TimeStart)
	end
	
	local Value = CurTime() - TimeStart
	local MaxValue = TimeEnd - TimeStart
	
	Time = STGamemodes:SecondsToFormat(Time).." / "..STGamemodes:SecondsToFormat(MaxValue)
	
	surface.SetFont("MenuLarge")
	
	local TWidthName, THeightName = surface.GetTextSize(Name)
	local TWidthTime, THeightTime = surface.GetTextSize(Time)
	
	local Width = math.Max(200, TWidthName + 20)
	
	local Height = 44
	local X = (ScrW() / 2) - (Width / 2)

	local BoxX = X + 5
	local BoxY = ScreenHeight - 20
	local BoxWidth = Width - 10
	local BoxHeight = 15
	
	draw.RoundedBoxEx(16, X, ScreenHeight - Height, Width, Height, col, true, true, false, false)
	
	surface.SetDrawColor(54, 77, 106, 255)
	surface.DrawRect(BoxX, BoxY, BoxWidth, BoxHeight)
	
	surface.SetDrawColor(154, 177, 206, 255)
	surface.DrawOutlinedRect(BoxX, BoxY, BoxWidth, BoxHeight)
	
	local DotX = BoxX + (BoxWidth / MaxValue) * Value
	
	surface.SetTextColor(255, 255, 255, 255)
	
    surface.SetTextPos(X + (Width / 2) - (TWidthName / 2), ScreenHeight - 40)
	surface.DrawText(Name)
	
	surface.SetDrawColor(154, 177, 206, 255)
	surface.DrawRect(DotX, BoxY, 2, BoxHeight)
	
    surface.SetTextPos(X + (Width / 2) - (TWidthTime / 2), BoxY + 0.5)
	surface.DrawText(Time)
	
	Jukebox.Width = X + Width
end
hook.Add("HUDPaint", "Jukebox.HUDPaint", Jukebox.HUDPaint)

function Jukebox.GetSteamID()
	if(IsValid(LocalPlayer())) then
		Jukebox.SteamID = string.gsub(LocalPlayer():SteamID(), ":", "_")
	else
		timer.Simple(0.1, function() Jukebox.GetSteamID() end)
	end
end

function Jukebox.UserMessageUID(um)
	Jukebox.UID = um:ReadShort()
	Jukebox.GetSteamID()
	RunConsoleCommand("jukebox_confirmuid")
end
usermessage.Hook("Jukebox.UID", Jukebox.UserMessageUID)

function Jukebox.UserMessagePlaySong(um)
	local ID = um:ReadShort()
	local Name = um:ReadString()
	local Genre = um:ReadString()
	local Time = um:ReadShort()
	if(!ValidPanel(Jukebox.Panel)) then
		Jukebox.CreatePanel()
	end
	RunConsoleCommand("jukebox_playconfirm")
	Jukebox.Panel:AddSong(ID, Name, Genre, Time, true)
end
usermessage.Hook("Jukebox.PlaySong", Jukebox.UserMessagePlaySong)

function Jukebox.UserMessageDJPlaySong(um)
	local ID = um:ReadShort()
	local Name = um:ReadString()
	local Genre = um:ReadString()
	local Time = um:ReadShort()
	if(!ValidPanel(Jukebox.Panel)) then
		Jukebox.CreatePanel()
	end
	if(!Jukebox.DJMode) then
		Jukebox.DJMode = true
		Jukebox.OnDJModeOn()
	end
	Jukebox.Panel:AddSong(ID, Name, Genre, Time, true)
end
usermessage.Hook("Jukebox.DJPlaySong", Jukebox.UserMessageDJPlaySong)

function Jukebox:AddMusic(ID, Name, Time, Genre)
	if(tonumber(ID) != nil) then
		local ID = tonumber(ID)

		if (!table.HasValue(self.IDs, ID)) then
			table.insert(self.IDs, ID)
		end

		self.Music[ID] = {
			Name = Name,
			Genre = Genre,
			Time = tonumber(Time)
		}
	end
end

local Line
local Limit = 1
local LimitTimer = 0
local LimitPerMS = 50

function Jukebox.OnDJModeOn()
	Jukebox.SongEndTime = false
	Jukebox.Panel:ResetPlaylist()
	Jukebox.Panel:StopSong(false, true)
end

function Jukebox.Think()
	if(LimitTimer >= CurTime()) then
		return
	end
	LimitTimer = CurTime() + 0.025
	
	if(!ValidPanel(Jukebox.Panel)) then
		return
	end
	
	local DJMode = Jukebox:IsDJMode()
	if(Jukebox.DJMode != DJMode) then
		Jukebox.DJMode = DJMode
		if(Jukebox.DJMode) then
			Jukebox.OnDJModeOn()
		end
	end
	
	if(Jukebox.SongEndTime and Jukebox.SongEndTime <= CurTime()) then
		Jukebox.SongEndTime = false
		Jukebox.Panel:NextSong()
	end
	
	if(table.Count(Jukebox.RefreshQueue) == 0) then
		if(Jukebox.Refreshing and Jukebox.RefreshQueueFunc) then
			Jukebox.RefreshQueueFunc()
		end
		return
	end
	
	Limit = 1
	
	for k,v in pairs(Jukebox.RefreshQueue) do
		if(Limit >= LimitPerMS) then
			return
		end
		if(v.Name and v.Genre and v.Time) then
			Line = Jukebox.Panel.Music:AddLine(base64:dec(v.Name), base64:dec(v.Genre), STGamemodes:SecondsToFormat(v.Time))
			Line.ID = k
			Line.Name = v.Name
			Line.Genre= v.Genre
			Line.Time = v.Time
			Line.Hidden = true
		end
		Jukebox.RefreshQueue[k] = nil
		Limit = Limit + 1
	end
	
	if(Jukebox.RefreshQueueFunc) then
		Jukebox.RefreshQueueFunc()
	end
end
hook.Add("Think", "Jukebox.Think", Jukebox.Think)

function Jukebox:RefreshLists(Table, Func)
	Jukebox.RefreshQueue = table.Copy(Table)
	Jukebox.RefreshQueueFunc = Func or false
end

function Jukebox:RefreshMusic(OnRefresh)
	self.Music = {}
	self.Refreshing = true
	http.Fetch("http://server2.sassilization.com/jukebox/?p=List", function(Content)
		self.Refreshing = false
		for k,v in pairs(string.Explode("\n", Content)) do
			local Explode = string.Explode("\t", v)
			if(Explode and table.Count(Explode) >= 3) then
				local ID = string.Trim(Explode[1])
				local Name = string.Trim(Explode[2])
				local Time = string.Trim(Explode[3])
				local Genre = string.Trim(Explode[4] or "Ti9B")
				if(ID != "" and Name != "" and Time != "" and Genre != "") then
					Jukebox:AddMusic(ID, Name, Time, Genre)
				end
			end
		end
		if(OnRefresh) then
			OnRefresh()
		end
	end)
end

Jukebox:RefreshMusic()

function Jukebox:IsDJMode()
	local Bool = GetGlobalBool("DJMode")
	if(Bool and type(Bool) == "boolean") then
		return Bool
	end
	return false
end

local PANEL = {}
PANEL.Children = {}
PANEL.LastThink = CurTime()
PANEL.DisableJukebox = false //file.Exists("Jukebox.txt")

function PANEL:Init()
	self:ResetTitle()
	
	local X = 7.5
	local Y = 25
	local Spacing = 5
	local ButtonWidth = 65
	local ButtonHeight = 35
	local MainWide = 440
	
	self.Browser = vgui.Create("HTML", self)
	self.Browser:SetVisible(false)
	self.Browser:SetPos(X, Y)
	self.Browser:SetSize(0, 0)
	-- PrintTable(self.Browser:GetTable())
	-- function self.Browser:OpeningURL(id1, id2, id3)
		-- print("OPENING URL", id1, id2, id3)
	-- end

	function self.Browser.FinishedURL()
		self:UpdateVolume()
	end
	
	self.Playlist = vgui.Create("DListView", self)
	self.Playlist:SetPos(X, Y)
	self.Playlist:SetSize(MainWide, 102)
	self.Playlist:SetMultiSelect(false)
	self.Playlist:OnRequestResize(self.Playlist:AddColumn("Name"), 300)
	self.Playlist:OnRequestResize(self.Playlist:AddColumn("Genre"), MainWide - 300 - 38)
	self.Playlist:OnRequestResize(self.Playlist:AddColumn("Time"), 38)
	self.Playlist.SortByColumn = function() end
	self.Playlist.OnRequestResize = function() end
	self.Playlist.DoDoubleClick = function(Panel, ID, Line)
	end
	self.Playlist.DoDoubleRightClick = function(Panel, ID, Line)
	end
	table.insert(self.Children, self.Playlist)
	
	Y = Y + self.Playlist:GetTall() + Spacing
	
	self.Music = vgui.Create("DListView", self)
	self.Music:SetPos(X, Y)
	self.Music:SetSize(MainWide, 391)
	self.Music:SetDataHeight(12)
	self.Music:SetMultiSelect(false)
	self.Music:OnRequestResize(self.Music:AddColumn("Name"), 300)
	self.Music:OnRequestResize(self.Music:AddColumn("Genre"), MainWide - 300 - 38)
	self.Music:OnRequestResize(self.Music:AddColumn("Time"), 38)
	self.Music.OnRequestResize = function() end
	self.Music.DoDoubleClick = function(Panel, ID, Line)
		if(Line.Search) then
			return
		end
		if(Jukebox.DJMode) then
			if(LocalPlayer():IsDev() or LocalPlayer():IsRadio()) then
				RunConsoleCommand("jukebox_djplay", Line.ID, Line.Name, Line.Genre, Line.Time)
			else
				RunConsoleCommand("jukebox_reqplay", base64:dec(Line.Name))
			end
		elseif(LocalPlayer():IsVIP()) then -- I'm trusting script enforcer on this one
			self:AddSong(Line.ID, Line.Name, Line.Genre, Line.Time)
		else
			RunConsoleCommand("jukebox_play", Line.ID, Line.Name, Line.Genre, Line.Time)
		end
	end
	
	self.Music.OnRowRightClick = function(Panel, ID, Line)
		if(Panel.NextClickTime and Panel.NextClickTime >= CurTime()) then
			return
		end
		if(Line:GetSelected() and Line.m_fClickTime) then 
			local fTimeDistance = SysTime() - Line.m_fClickTime
			if(fTimeDistance < 0.3) then
				Panel.NextClickTime = CurTime() + 5
				Panel:DoDoubleRightClick(Line:GetID(), Line)
			end
		end
	end
	
	self.Music.DoDoubleRightClick = function(Panel, ID, Line)
		if(Line.Search) then
			return
		end
		if(!Jukebox.DJMode) then
			return
		end
		if(!LocalPlayer():IsDev() and !LocalPlayer():IsRadio()) then
			return
		end
		RunConsoleCommand("jukebox_djvoteplay", Line.ID, Line.Name, Line.Genre, Line.Time)
	end
	
	function self.Music:DataLayout()
		local Y = 0
		local Height = self.m_iDataHeight
		for k, Line in pairs(self.Sorted) do
			Line:SetPos(0, Y)
			Line:SetWide(self:GetWide())
			if(Line.Hidden) then
				Line:SetTall(0)
			else
				Line:SetTall(Height)
			end
			Line:DataLayout(self) 
			Line:SetAltLine(k % 2 == 1)
			Y = Y + Line:GetTall()
		end
		return Y
	end
	table.insert(self.Children, self.Music)
	
	Y = Y + self.Music:GetTall() + Spacing
	
	self.Search = vgui.Create("DTextEntry", self)
	self.Search:SetPos(X, Y)
	self.Search:SetWide(MainWide)
	self.Search:SetFocusTopLevel(true)
	self.Search:RequestFocus()
	function self.Search.Think()
		local Value = self.Search:GetValue()
		if(self.Search.Value != Value or self.Search.Fix) then
			self.Search.Value = Value
			if(self.Search.Fix) then
				self.Search.Fix = false
			end
			if(string.Trim(Value) == "") then
				for k,v in pairs(self.Music.Lines) do
					if(v.Search) then
						v.Hidden = false
					else
						v.Hidden = true
					end
				end
			else
				for k,v in pairs(self.Music.Lines) do
					local Hide = true
					if(!v.Search and (string.find(STGamemodes:ParseString(v:GetColumnText(1)), STGamemodes:ParseString(Value), 1, true) or string.find(STGamemodes:ParseString(v:GetColumnText(2)), STGamemodes:ParseString(Value), 1, true))) then
						Hide = false
					end
					if(v.Hidden != Hide) then
						v.Hidden = Hide
					end
				end
			end
			self.Music.VBar:SetScroll(0)
			self.Music:SetDirty(true)
			self.Music:InvalidateLayout(true)
		end
	end
	table.insert(self.Children, self.Search)
	
	Y = Y + self.Search:GetTall() + Spacing
	
	self.StopButton = vgui.Create("DButton", self)
	self.StopButton:SetPos(X, Y)
	self.StopButton:SetSize(50, ButtonHeight)
	self.StopButton:SetText("Stop")
	function self.StopButton.DoClick()
		self:StopSong()
	end
	table.insert(self.Children, self.StopButton)
	X = X + self.StopButton:GetWide() + Spacing
	
	self.RefreshMusic = vgui.Create("DButton", self)
	self.RefreshMusic:SetText("Refresh")
	self.RefreshMusic:SetPos(X, Y)
	self.RefreshMusic:SetSize(ButtonWidth, ButtonHeight)
	function self.RefreshMusic.DoClick()
		if(!Jukebox.Refreshing and !Jukebox.Recaching) then
			self.Refreshing = true
			self:MassVisible(false)
			Jukebox:RefreshMusic(function()
				self:DoJukeboxRefresh()
			end)
		end
	end
	table.insert(self.Children, self.RefreshMusic)
	X = X + self.RefreshMusic:GetWide() + Spacing

	self.RandomButton = vgui.Create("DButton", self)
	self.RandomButton:SetText("Random")
	self.RandomButton:SetPos(X, Y)
	self.RandomButton:SetSize(ButtonWidth, ButtonHeight)
	function self.RandomButton.DoClick()
		if !Jukebox.IDs[1] or Jukebox.IDs[1] == "" then return end 
		local ID = table.Random(Jukebox.IDs)
		if !Jukebox.Music[ID] then return end 
		local Line = Jukebox.Music[ID]

		if(Jukebox.DJMode) then
			if(LocalPlayer():IsDev() or LocalPlayer():IsRadio()) then
				RunConsoleCommand("jukebox_djplay", ID, Line.Name, Line.Genre, Line.Time)
			else
				RunConsoleCommand("jukebox_reqplay", base64:dec(Line.Name))
			end
		elseif(LocalPlayer():IsVIP()) then -- I'm trusting script enforcer on this one
			self:AddSong(ID, Line.Name, Line.Genre, Line.Time)
		else
			RunConsoleCommand("jukebox_play", ID, Line.Name, Line.Genre, Line.Time)
		end
	end

	table.insert(self.Children, self.RandomButton)
	X = X + self.RandomButton:GetWide() + Spacing
	
	if(LocalPlayer():IsDev() or LocalPlayer():IsRadio()) then
		self.DJModeButton = vgui.Create("DButton", self)
		self.DJModeButton:SetText("DJ Mode")
		self.DJModeButton:SetPos(X, Y)
		self.DJModeButton:SetSize(ButtonWidth, ButtonHeight)
		function self.DJModeButton.DoClick()
			Derma_QueryFixed("Are you sure you want to turn DJ Mode "..tostring(Jukebox.DJMode and "off" or "on"), "Confirmation",
				"Yes", function()
					RunConsoleCommand("jukebox_djmode")
				end, 
				"No", function()
				end
			)
		end
		table.insert(self.Children, self.DJModeButton)
		X = X + self.DJModeButton:GetWide() + Spacing
	end
	
	self.Volume = vgui.Create("DNumSlider", self)
	self.Volume:SetPos(X, Y)
	self.Volume:SetWide(MainWide - X + 7)
	self.Volume:SetDecimals(0)
	self.Volume:SetText("Volume")
	self.Volume:SetMin(0) 
	self.Volume:SetMax(100)
	self.Volume:SetValue(Jukebox.Volume:GetInt())
	function self.Volume.OnValueChanged()
		RunConsoleCommand("st_volume", self.Volume:GetValue())
		self:UpdateVolume()
	end

	table.insert(self.Children, self.Volume)
	
	Y = Y + self.Volume:GetTall() + Spacing
	
	self:SetSize(MainWide + 15, Y)
	self:Center()
	
	self:DoJukeboxRefresh()
end

function PANEL:UpdateVolume()
	self.Browser:RunJavascript("if (document.getElementById('player')) { document.getElementById('player').setVolume("..tostring(Jukebox.Volume:GetInt())..") }")
end

function PANEL:PaintOver()
	self.PanelOverText = false
    if(self.Refreshing) then
		self.PanelOverText = "Refreshing"
	elseif(Jukebox.Radio) then
		self.PanelOverText = "Radio"
	end
	if(!self.PanelOverText) then
		return
	end
	surface.SetFont("JukeboxRefreshing")
	local TWidth, THeight = surface.GetTextSize(self.PanelOverText)
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos((self:GetWide() / 2) - (TWidth / 2), (self:GetTall() / 2) - (THeight / 2))
	surface.DrawText(self.PanelOverText)
end

function PANEL:MassVisible(Bool)
	for k,v in pairs(self.Children) do
		if(ValidPanel(v)) then
			v:SetVisible(Bool)
		end
	end
end

function PANEL:DoJukeboxRefresh()
	self.Refreshing = true
	self:MassVisible(false)
	self.Music:Clear()
	self.Music:AddLine("Search for something to get started").Search = true
	Jukebox:RefreshLists(Jukebox.Music, function()
		self.Refreshing = false
		self:ResetTitle()
		self.Music:SortByColumn(1)
		self:MassVisible(true)
		self.Search:SetText("")
		self.Search.Fix = true
		self.Music:SetDirty(true)
		self.Music:InvalidateLayout(true)
	end)
end

function PANEL:AddSong(ID, Name, Genre, Time, Force)
	if(!Force) then
		if(Jukebox.DJMode) then
			return
		end
		if(LocalPlayer():IsVIP()) then
			if(table.Count(self.Playlist.Sorted) >= 7) then
				LocalPlayer():ChatPrint("Jukebox: You can't have more than 7 songs in the playlist!")
				return
			end
		else
			if(table.Count(self.Playlist.Sorted) >= 2) then
				LocalPlayer():ChatPrint("Jukebox: You must be a VIP to have more than 2 songs in the playlist!")
				return
			end
		end
	end
	
	local Line = self.Playlist:AddLine(base64:dec(Name), base64:dec(Genre), STGamemodes:SecondsToFormat(Time))
	Line.Name = Name
	Line.Genre = Genre
	Line.Time = Time
	Line.ID = ID
	Line.OnMousePressed = function(Panel, MouseCode)
		if(Line.LastClickTime) then
			if((SysTime() - Line.LastClickTime) < 0.3) then
				if(MouseCode == MOUSE_LEFT) then
					self.Playlist.DoDoubleClick(Panel, Line:GetID(), Line)
				elseif(MouseCode == MOUSE_RIGHT) then
					self.Playlist.DoDoubleRightClick(Panel, Line:GetID(), Line)
				end
				return
			end
		end
		Line.LastClickTime = SysTime()
	end
	if(table.Count(self.Playlist.Sorted) == 1) then
		self:NextSong()
	end
end

function PANEL:RemoveSong(Panel)
	return self.Playlist:RemoveLine(Panel:GetID())
end

function PANEL:ResetPlaylist()
	self.Playlist:Clear()
end

function PANEL:GetCurrentSong(Sorted)
	if(ValidPanel(self.CurrentPanel)) then
		for k,v in pairs(Sorted) do
			if(v == self.CurrentPanel) then
				return k
			end
		end
	end
	return 0
end

function PANEL:StopSong(Delete, Complete)
	if(self.CurrentSong and self.Playing) then
		if(Complete or !Jukebox.DJMode) then
			-- http.Fetch(self:GenerateURL(self.CurrentSong, "end"), function() end)
			Jukebox.Panel.Browser:OpenURL(self:GenerateURL(self.CurrentSong, "end"))
		end
	end
	
	self:ResetTitle()
	self.Loading = false
	self.Playing = false
	self.Browser:Stop()
	self.Browser:SetHTML("")
	
	if(Complete) then
		Jukebox.Current = false
		self.CurrentSong = false
		self.CurrentPanel = false
	end
	
	if(Delete) then
		self.Browser:Remove()
	end
end

function PANEL:NextSong()
	local Sorted = self.Playlist.Sorted
	local Current = self:GetCurrentSong(Sorted)
	local NewSong = Current + 1
	if(NewSong > table.Count(Sorted)) then
		NewSong = 1
	end
	local Line = Sorted[NewSong]
	if(Line) then
		if(self.CurrentPanel == Line) then
			self:RemoveSong(self.CurrentPanel)
			self:NextSong()
		else
			self:PlaySong(Line)
		end
	else
		self:StopSong(false, true)
	end
end

function PANEL:GenerateURL(SongID, Last)
	-- print("http://server2.sassilization.com/jukebox/?p=Client&steamid="..Jukebox.SteamID.."&uid="..tostring(STGamemodes.Forums.ID)..tostring(Jukebox.UID).."&s="..tostring(SongID).."&djmode="..tostring(Jukebox.DJMode and STGamemodes.Forums.ID or 0).."&"..Last)
	return "http://server2.sassilization.com/jukebox/?p=Client&steamid="..Jukebox.SteamID.."&uid="..tostring(STGamemodes.Forums.ID)..tostring(Jukebox.UID).."&s="..tostring(SongID).."&djmode="..tostring(Jukebox.DJMode and STGamemodes.Forums.ID or 0).."&"..Last
end

function PANEL:ResetTitle()
	self:SetTitle("Jukebox - "..tostring(table.Count(Jukebox.Music)).." Songs")
end

function PANEL:PlaySong(Panel)
	if(!ValidPanel(Panel) or self.Loading or !Jukebox.UID or !STGamemodes.Forums.ID) then
		return
	end
	
	if(!self.DisableJukebox and self.CurrentSong and !Jukebox.DJMode) then
		-- http.Fetch(self:GenerateURL(self.CurrentSong, "end"), function() end)
		Jukebox.Panel.Browser:OpenURL(self:GenerateURL(self.CurrentSong, "end"))
	end
	
	if(ValidPanel(self.CurrentPanel)) then
		self:RemoveSong(self.CurrentPanel)
	end
	
	self.Playing = true
	self.Loading = true
	
	Panel:SetSelected(true)
	
	self.CurrentPanel = Panel
	self.CurrentSong = Panel.ID
	
	local Name = base64:dec(Panel.Name)
	
	self:SetTitle("Loading "..Name)
	
	self.Timeout = true
	
	if(Jukebox.DJMode) then
		self:PlaySongReal(Name, Panel)
	elseif(!self.DisableJukebox) then
		-- http.Fetch(self:GenerateURL(self.CurrentSong, "start"), function(Contents)
			Jukebox.Panel.Browser:OpenURL(self:GenerateURL(self.CurrentSong, "start"))
			timer.Simple(1, function() self:PlaySongReal(Name, Panel) end)
		-- end)
	end 
	timer.Simple(10, function()
		if(!ValidPanel(self) or !ValidPanel(Panel)) then
			return
		end
		if(self.Timeout) then
			self.Loading = false
			self:NextSong()
		end
	end)
end

function PANEL:PlaySongReal(Name, Panel)
	if(!ValidPanel(self) or !ValidPanel(Panel)) then
		return
	end
	
	self.Loading = false
	self.Timeout = false
	self:SetTitle(Name)
	
	Jukebox.Current = {
		ID = Panel.ID,
		Name = Name,
		Time = Panel.Time,
		TimeStart = CurTime(),
		TimeEnd = CurTime() + Panel.Time
	}
	
	Jukebox.SongEndTime = CurTime() + Panel.Time + 4
	
	LocalPlayer():ChatPrint("Jukebox: Now Playing: "..Name)
	if(!self.DisableJukebox and Jukebox.Volume:GetInt() > 0) then
		timer.Simple(1, function() 
			-- print("http://server2.sassilization.com/jukebox/?fol="..tostring(Jukebox.DJMode and string.gsub(STGamemodes.ServerDirectory, " ", "") or Jukebox.SteamID).."&s="..tostring(self.CurrentSong))
			self.Browser:OpenURL("http://server2.sassilization.com/jukebox/?fol="..tostring(Jukebox.DJMode and string.gsub(STGamemodes.ServerDirectory, " ", "") or Jukebox.SteamID).."&s="..tostring(self.CurrentSong))
		end )
	end
end

function PANEL:OnClose()
	self.Search:SetText("")
end

vgui.Register("STGamemodes.VGUI.Jukebox", PANEL, "STGamemodes.VGUI.Base")

function Jukebox.CreatePanel()
	Jukebox.Panel = vgui.Create("STGamemodes.VGUI.Jukebox")
	Jukebox.Panel:Close()
end

local EndWait = CurTime() + 10

concommand.Add("jukebox_show", function()
	if(EndWait >= CurTime()) then
		LocalPlayer():ChatPrint("Jukebox: Please wait "..tostring(math.Round(EndWait - CurTime())).." seconds before using the jukebox")
		return
	end
	if(!Jukebox.UID or !Jukebox.SteamID or STGamemodes.Store.Loading) then
		LocalPlayer():ChatPrint("Jukebox: Please wait until your profile is loaded")
		return
	end
	if(!ValidPanel(Jukebox.Panel)) then
		Jukebox.CreatePanel()
	end
	Jukebox.Panel:SetVisible(true)
	Jukebox.Panel:MakePopup()

	if(STGamemodes.LevelSelect and ValidPanel(STGamemodes.LevelSelect)) then
		print(STGamemodes.LevelSelect)
		STGamemodes.LevelSelect:Close()
		STGamemodes.LevelSelect:Remove()
		STGamemodes.LevelSelect = false
	end
end)
