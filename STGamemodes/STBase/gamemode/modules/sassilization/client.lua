--------------------
-- STBase
-- By Spacetech
--------------------

RepMat = {}

-- In order!

RepMat["epic"] = Material("sassilization/tags2/epictag")
RepMat["space"] = Material("sassilization/tags2/spacetag")
RepMat["owner"] = Material("sassilization/tags2/ownertag")
RepMat["super"] = Material("sassilization/tags2/supertag")
RepMat["superadmin"] = RepMat["super"]

RepMat["devmin"] = Material("sassilization/tags2/devtag")

RepMat["admin"] = Material("sassilization/tags2/admintag")
RepMat["goat"] = Material("sassilization/tags2/goattag")
RepMat["ftw"] = Material("sassilization/tags2/ftwtag")
RepMat["bhop"] = Material("sassilization/tags2/bhoptag3")

RepMat["mod"] = Material("sassilization/tags2/modtag2")

RepMat["radio"] = Material("sassilization/tags2/radiotag")
RepMat["dev"] = Material("sassilization/tags2/devtag")
RepMat["developer"] = RepMat["dev"]

RepMat["beta tester"] = Material("sassilization/tags2/viptag")
RepMat["girl"] = Material("sassilization/tags/gtag")
RepMat["vip"] = Material("sassilization/tags2/viptag")


MONEY = {}
MONEY.coins = {}
MONEY.coinage = surface.GetTextureID( "sassilization/coinage" )
MONEY.cps = 6 --Coins per Second
MONEY.timeleft = CurTime()
MONEY.tex = surface.GetTextureID("coded/dbox")
MONEY.w = 128
MONEY.h = 64
MONEY.velx = 0
MONEY.vely = 0
MONEY.x = 0-MONEY.w
MONEY.y = ScrH()*0.3-MONEY.h*0.5


surface.CreateFont("Default", {font="Tahoma", size=13, weight=500})

local HUDCoin_b = 0
local HUDCoin_c = 0
local HUDCoin_d = 0
local HUDCoin_i = 1
local HUDCoins = {}

usermessage.Hook( "MONEY.amount", function( um )
	MONEY.amount = um:ReadLong()
	RunConsoleCommand("st_moneyloaded")
	LocalPlayer():SetNWInt("Dough", MONEY.amount)
end )

local tink = 0
local function PlayTink()
	tink = tink + 1
	if tink > 4 then tink = 0 end
	surface.PlaySound( "sassilization/ting"..(tink > 0 and tink or "")..".wav" )
end

function GM:AddCoin()

	local coin = {}
	coin.recv 	= SysTime()
	coin.income	= true
	coin.velx	= math.random( -5, -2 )*0.01
	coin.vely	= 0
	coin.x		= ScrW() + 200
	coin.y		= MONEY.y + MONEY.h * 0.25 + math.random( -64, 64 )
	
	local diff	= LocalPlayer():GetMoney() - MONEY.amount + HUDCoin_b
	coin.value	= diff > 100 and math.min( math.Round( math.sqrt( diff ) * 0.5 ), diff ) or math.min( 1, diff )

	HUDCoin_b = HUDCoin_b + coin.value
	
	table.insert( HUDCoins, coin )
	
	HUDCoin_c = HUDCoin_c + 1
	HUDCoin_i = HUDCoin_i + 1
	
end

function GM:RemoveCoin()

	local coin = {}
	coin.recv 	= SysTime()
	coin.outcome	= true
	coin.velx	= math.random( -75, 75 )
	coin.vely	= math.random( 50, 100 ) - 500
	coin.x		= MONEY.x + MONEY.w * 0.5 - 16
	coin.y		= MONEY.y + MONEY.h * 0.1

	PlayTink()
	local diff	= MONEY.amount - LocalPlayer():GetMoney()
	MONEY.amount	= MONEY.amount - math.min( math.Round( math.sqrt( diff ) * 0.5 ), diff + HUDCoin_b )
	
	table.insert( HUDCoins, coin )
	
	HUDCoin_d = HUDCoin_d + 1
	HUDCoin_i = HUDCoin_i + 1
	
end

local function DrawCoin( self, k, v, i )

	local x = v.x
	local y = v.y
	
	v.w = v.w or math.random( 24, 32 )
	local w,h = v.w, v.w

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( MONEY.coinage )
	surface.DrawTexturedRect( x, y, w, h )

	local spd = RealFrameTime()
	
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd
	
	if v.income then
		
		local ideal_y = MONEY.y + h * 0.5
		local ideal_x = -v.w
		
		ideal_x = -v.w
		
		local dist = ideal_y - v.y
		v.vely = v.vely + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
		local dist = ideal_x - v.x
		v.velx = v.velx + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
		
	elseif v.outcome then
		
		v.vely = v.vely + spd * 500
		
	end

end

function GM:PaintCoins()
	
	if !MONEY.amount then return end
	
	local pl = LocalPlayer()
	if !STValidEntity(pl) then return end
	
	local ft = FrameTime()
	if (MONEY.amount + HUDCoin_b) < pl:GetMoney() then
		for i=1, math.min( 1, math.Round( MONEY.cps * ft * 64 ) ) do
			if (pl:GetMoney() - MONEY.amount + HUDCoin_b) > 0 then
				self:AddCoin()
			else break end
		end
	elseif MONEY.amount > pl:GetMoney() then
		if MONEY.x > MONEY.w*-0.5 then
			for i=1, math.min( 1, math.Round( MONEY.cps * ft * 64 ) ) do
				if (MONEY.amount - pl:GetMoney()) > 0 then
					self:RemoveCoin()
				else break end
			end
		else
			MONEY.timeleft = CurTime() + 2
		end
	end
	
	if ( !HUDCoins ) then return end
	
	local i = 0
	for k, v in pairs( HUDCoins ) do
	
		if ( v != 0 ) then
		
			i = i + 1
			DrawCoin( self, k, v, i)
		
		end
		
	end
	
	for k, v in pairs( HUDCoins ) do
	
		if ( v != 0 && (v.x < -v.w || v.y > ScrH() + v.w) ) then
			
			if v.income then
				PlayTink()
				local value = LocalPlayer():GetMoney() - MONEY.amount
				value = math.min( v.value, value )
				MONEY.amount = MONEY.amount + value
				HUDCoin_b = HUDCoin_b - value
				HUDCoin_c = HUDCoin_c - 1
			elseif v.outcome then
				HUDCoin_d = HUDCoin_d - 1
			end
			
			HUDCoins[ k ] = 0
			
			if (HUDCoin_c == 0 and HUDCoin_d == 0) then HUDCoins = {} HUDCoin_b = 0 end
		
		end

	end

end

function GM:DoughPaint()
	
	if !(STValidEntity( LocalPlayer() )) then return end
	
	local v = MONEY
	
	if LocalPlayer():KeyDown(IN_SCORE) then
		v.timeleft = CurTime() + 2
	elseif HUDCoin_c > 0 || HUDCoin_d > 0 then
		v.timeleft = CurTime() + 2
	end
	
	local x = v.x
	local y = v.y

	local w = v.w
	local h = v.h

	surface.SetDrawColor( 255, 255, 255, 120 )
	surface.SetTexture( v.tex )
	surface.DrawTexturedRect( x, y, w, h )
	
	if(v.amount and tonumber(v.amount) != nil) then
		draw.DrawText( math.Round(v.amount), "Default", x+w*0.8+1, y+h*0.5+1, Color(0,0,0,255),2)
		draw.DrawText( math.Round(v.amount), "Default", x+w*0.8, y+h*0.5, Color(255,255,255,255),2)
	end

	local ideal_y = MONEY.y
	local ideal_x = -v.w

	local timeleft = v.timeleft - CurTime()
	
	if timeleft <= 0 then
		ideal_x = -v.w
	else
		ideal_x = 0
	end

	local spd = FrameTime() * 8
	
	v.y = v.y + v.vely * spd
	v.x = v.x + v.velx * spd
	
	local dist = ideal_y - v.y
	v.vely = v.vely + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
	local dist = ideal_x - v.x
	v.velx = v.velx + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
	
	v.velx = v.velx * (0.95 - RealFrameTime() * 5 )
	v.vely = v.vely * (0.95 - RealFrameTime() * 5 )
	
	if v.x > 0 then
		v.x = 0
		v.velx = 0
	end

end

hook.Add( "PostRenderVGUI", "Dough.PostRenderVGUI", function()
	
	if(LocalPlayer() and IsValid(LocalPlayer()) and !LocalPlayer():IsFake()) then
		GAMEMODE:PaintCoins()
	end
	GAMEMODE:DoughPaint()
	
end )

Account = {}
Account.requesting = false

usermessage.Hook( "account.Close", function()
	if (Account.Window and Account.Window:IsValid()) then
		Account.Window:Close()
	end
end )

usermessage.Hook( "Account.request.full", function()
	RequestAccount()
end )

usermessage.Hook( "Account.request.password", function( um )
	local accountname = um:ReadString()
	RequestPassword( accountname )
end )

function ValidEntry( name, password, confirm )
	local messages = {}
	local length = string.len( name )
	if length < 4 then
		table.insert( messages, "Username is too short" )
	elseif length > 13 then
		table.insert( messages, "Username is too long" )
	end
	if string.len(string.gsub( name, "[%w_]", "" )) > 0 then
		table.insert( messages, "Username may only contain alphanumeric characters [a-z0-9] and '_'" )
	end
	length = string.len( password )
	if length < 4 then
		table.insert( messages, "Password is too short" )
	elseif length > 13 then
		table.insert( messages, "Password is too long" )
	end
	if string.len(string.gsub( password, "[%w_]", "" )) > 0 then
		table.insert( messages, "Password may only contain alphanumeric characters [a-z0-9] and '_'" )
	end
	if password != confirm then
		table.insert( messages, "The confirmation password does not match the password." )
	end
	if #messages > 0 then
		local error = ""
		for _, msg in pairs( messages ) do
			error = error .. msg .. "\n"
		end
		Derma_Message( error )
		return false
	else
		return true
	end
end

function RequestAccount()
	
	if (Account.Window and Account.Window:IsValid()) then return end
	
	gui.EnableScreenClicker(true)
	
	Window = vgui.Create( "STGamemodes.VGUI.Base" )
		Window:SetTitle( "Account Setup" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		-- Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window.Close = function()
			Window:SetVisible( false )
			gui.EnableScreenClicker(false)
			Window:Remove()
		end
		
	Account.Window = Window
	
	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetDrawBackground(false) 
	local yPosition = 5;
	
	local UsernameEntry = vgui.Create( "SassTextEntry", InnerPanel )
	local PasswordEntry = vgui.Create( "SassTextEntry", InnerPanel )
	local ConfirmEntry = vgui.Create( "SassTextEntry", InnerPanel )

	UsernameEntry:SetAlpha(200)
	PasswordEntry:SetAlpha(200)
	ConfirmEntry:SetAlpha(200)
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( "Please choose a username between 4 and 13 alphanumeric characters." )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetPos( 5, yPosition+5 )
		Text:SetTextColor( color_white )
		Text:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	yPosition = yPosition + Text:GetTall() + 10
	
		UsernameEntry:SetPos( 5, yPosition )
		UsernameEntry:SetText( "(username)" )
		UsernameEntry.OnEnter = function() PasswordEntry:RequestFocus() PasswordEntry:SelectAllText( true ) end	
	
	yPosition = yPosition + Text:GetTall() + 10
	
	local Text2 = vgui.Create( "DLabel", InnerPanel )
		Text2:SetText( "Please choose a password between 4 and 13 alphanumeric characters." )
		Text2:SizeToContents()
		Text2:SetContentAlignment( 5 )
		Text2:SetPos( 5, yPosition+5 )
		Text2:SetTextColor( color_white )
		Text2:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	yPosition = yPosition + Text:GetTall() + 10
	
		PasswordEntry:SetPos( 5, yPosition )
		PasswordEntry:SetText( "(password)" )
		PasswordEntry.OnEnter = function() ConfirmEntry:RequestFocus() ConfirmEntry:SelectAllText( true ) end
	
	yPosition = yPosition + Text:GetTall() + 10
	
	local Text3 = vgui.Create( "DLabel", InnerPanel )
		Text3:SetText( "Confirm your password." )
		Text3:SizeToContents()
		Text3:SetContentAlignment( 5 )
		Text3:SetPos( 5, yPosition+5 )
		Text3:SetTextColor( color_white )
		Text3:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	yPosition = yPosition + Text:GetTall() + 10
	
		ConfirmEntry:SetPos( 5, yPosition )
		ConfirmEntry:SetText( "(confirm password)" )
		ConfirmEntry.OnEnter = function()
			if ValidEntry( UsernameEntry:GetValue(), PasswordEntry:GetValue(), ConfirmEntry:GetValue() ) then
				RunConsoleCommand("linkaccount", UsernameEntry:GetValue(), PasswordEntry:GetValue(), ConfirmEntry:GetValue() )
			end
		end
	
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetDrawBackground(false)
	
	local Button = vgui.Create( "DButton", ButtonPanel )
		Button:SetText( "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function()
			if ValidEntry( UsernameEntry:GetValue(), PasswordEntry:GetValue(), ConfirmEntry:GetValue() ) then
				RunConsoleCommand("linkaccount", UsernameEntry:GetValue(), PasswordEntry:GetValue(), ConfirmEntry:GetValue() )
			end
		end
	
	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
		ButtonCancel:SetText( "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() end
		ButtonCancel:MoveRightOf( Button, 5 )
		
	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	w = math.max( w, 400 ) 
	
	Window:SetSize( w + 50, h + 75 + 10 + yPosition + 128 )
	Window:Center()
	
	yPosition = yPosition + Text:GetTall() + 45
	
	local LowerPanel = vgui.Create( "DPanel", Window )
		LowerPanel:SetPos( 5, yPosition )
		LowerPanel:SetSize( Window:GetWide() - 10, Window:GetTall() - yPosition - 45 )
		LowerPanel:SetDrawBackground(false)

		--LowerPanel.Paint = function()
		--	draw.RoundedBox( 6, 0, 0, LowerPanel:GetWide(), LowerPanel:GetTall(), Color( 100, 100, 100, 100 ) )
		--end
	
	local Notice = vgui.Create( "WaveyText", LowerPanel )
		Notice:SetFont( "TabLarge" )
		Notice:SetText( "ATTENTION!" )
		Notice:SetColor( Color( 255, 255, 255, 255 ) )
		Notice:SetOutlined( false )
		Notice:SetPos( LowerPanel:GetWide() * 0.5, Notice:GetTall() )
		--Notice:SetExpensiveShadow(1, Color(0, 0, 0, 100))

	local text = "Attention! It is very important that you remember these personal details as they will be used to access the User Control Panel as well as login to your forum account.  Without this account you will not be able to donate to the server or acquire access to other bonuses such as VIP or advertisements. Your password will be hashed and stored into our database for extra protection."
	local Disclaimer = vgui.Create( "DLabel", LowerPanel )
		Disclaimer:SetWide( Window:GetWide() - 40 )
		Disclaimer:SetPos( 20, Notice:GetTall() + 20 )
		Disclaimer:SetWrap( true )
		Disclaimer:SetAutoStretchVertical( true )
		Disclaimer:SetTextColor( Color( 255,255,255,255 ) )
		Disclaimer:SetText( text )
		Disclaimer:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	
	InnerPanel:StretchToParent( 5, 25, 5, 173 )
	
	Text:StretchToParent( 5, nil, 5, nil )	
	Text2:StretchToParent( 5, nil, 5, nil )	
	Text3:StretchToParent( 5, nil, 5, nil )	
	
	UsernameEntry:StretchToParent( 5, nil, 5, nil )
	PasswordEntry:StretchToParent( 5, nil, 5, nil )
	ConfirmEntry:StretchToParent( 5, nil, 5, nil )
	
	UsernameEntry:RequestFocus()
	UsernameEntry:SelectAllText( true )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
	Window:DoModal()

end

function RequestPassword( accountname )
	
	if (Account.Window and Account.Window:IsValid()) then return end
	
	gui.EnableScreenClicker(true)
	
	Window = vgui.Create( "STGamemodes.VGUI.Base" )
		Window:SetTitle( "Password Reset" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		-- Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		Window.Close = function()
			Window:SetVisible( false )
			gui.EnableScreenClicker(false)
			Window:Remove()
		end
		
	Account.Window = Window
	
	local InnerPanel = vgui.Create( "DPanel", Window )
	local yPosition = 5;

	local UsernameEntry = vgui.Create( "SassTextEntry", InnerPanel )
	local PasswordEntry = vgui.Create( "SassTextEntry", InnerPanel )
	local ConfirmEntry = vgui.Create( "SassTextEntry", InnerPanel )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( "This is your UserCP and Forum accountname." )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetPos( 5, yPosition )
		Text:SetTextColor( color_white )
		Text:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	yPosition = yPosition + Text:GetTall() + 10
	
		UsernameEntry:SetPos( 5, yPosition )
		UsernameEntry:SetText( accountname )
		UsernameEntry:SetEditable( false )
	
	yPosition = yPosition + Text:GetTall() + 10
	
	local Text2 = vgui.Create( "DLabel", InnerPanel )
		Text2:SetText( "Please choose a password between 4 and 13 alphanumeric characters." )
		Text2:SizeToContents()
		Text2:SetContentAlignment( 5 )
		Text2:SetPos( 5, yPosition )
		Text2:SetTextColor( color_white )
		Text2:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	yPosition = yPosition + Text:GetTall() + 10
	
		PasswordEntry:SetPos( 5, yPosition )
		PasswordEntry:SetText( "(password)" )
		PasswordEntry.OnEnter = function() ConfirmEntry:RequestFocus() ConfirmEntry:SelectAllText( true ) end
	
	yPosition = yPosition + Text:GetTall() + 10
	
	local Text3 = vgui.Create( "DLabel", InnerPanel )
		Text3:SetText( "Confirm your password." )
		Text3:SizeToContents()
		Text3:SetContentAlignment( 5 )
		Text3:SetPos( 5, yPosition )
		Text3:SetTextColor( color_white )
		Text3:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	yPosition = yPosition + Text:GetTall() + 10
	
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	
	local Button = vgui.Create( "DButton", ButtonPanel )
		
		ConfirmEntry:SetPos( 5, yPosition )
		ConfirmEntry:SetText( "(confirm password)" )
		ConfirmEntry.OnEnter = function()
			Button:DoClick()
		end
		
		Button:SetText( "OK" )
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button:SetPos( 5, 5 )
		Button.DoClick = function()
			if ValidEntry( accountname, PasswordEntry:GetValue(), ConfirmEntry:GetValue() ) then
				RunConsoleCommand("setpassword", accountname, ConfirmEntry:GetValue() )
			end
		end
		
	local ButtonCancel = vgui.Create( "DButton", ButtonPanel )
		ButtonCancel:SetText( "Cancel" )
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall( 20 )
		ButtonCancel:SetWide( Button:GetWide() + 20 )
		ButtonCancel:SetPos( 5, 5 )
		ButtonCancel.DoClick = function() Window:Close() end
		ButtonCancel:MoveRightOf( Button, 5 )
		
	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )
	
	local w, h = Text:GetSize()
	w = math.max( w, 400 ) 
	
	Window:SetSize( w + 50, h + 75 + 10 + yPosition + 128 )
	Window:Center()
	
	yPosition = yPosition + Text:GetTall() + 45
	
	local LowerPanel = vgui.Create( "DPanel", Window )
		LowerPanel:SetPos( 5, yPosition )
		LowerPanel:SetSize( Window:GetWide() - 10, Window:GetTall() - yPosition - 45 )

		--LowerPanel.Paint = function()
		--	draw.RoundedBox( 6, 0, 0, LowerPanel:GetWide(), LowerPanel:GetTall(), Color( 100, 100, 100, 100 ) )
		--end
	
	local Notice = vgui.Create( "WaveyText", LowerPanel )
		Notice:SetFont( "TabLarge" )
		Notice:SetText( "ATTENTION!" )
		Notice:SetColor( Color( 255, 255, 255, 255 ) )
		Notice:SetOutlined( false )
		Notice:SetPos( LowerPanel:GetWide() * 0.5, Notice:GetTall() )
		--Notice:SetExpensiveShadow(1, Color(0, 0, 0, 100))

	local text = "Attention! It is very important that you remember these personal details as they will be used to access the User Control Panel as well as login to your forum account.  Without this account you will not be able to donate to the server or acquire access to other bonuses such as VIP or advertisements. Your password will be hashed and stored into our database for extra protection."
	local Disclaimer = vgui.Create( "DLabel", LowerPanel )
		Disclaimer:SetWide( Window:GetWide() - 40 )
		Disclaimer:SetPos( 20, Notice:GetTall() + 20 )
		Disclaimer:SetWrap( true )
		Disclaimer:SetAutoStretchVertical( true )
		Disclaimer:SetTextColor( Color( 255,255,255,255 ) )
		Disclaimer:SetText( text )
		Disclaimer:SetExpensiveShadow(1, Color(0, 0, 0, 100))
	
	
	InnerPanel:StretchToParent( 5, 25, 5, 173 )
	
	Text:StretchToParent( 5, nil, 5, nil )	
	Text2:StretchToParent( 5, nil, 5, nil )	
	Text3:StretchToParent( 5, nil, 5, nil )	
	
	UsernameEntry:StretchToParent( 5, nil, 5, nil )
	PasswordEntry:StretchToParent( 5, nil, 5, nil )
	ConfirmEntry:StretchToParent( 5, nil, 5, nil )
	
	PasswordEntry:RequestFocus()
	PasswordEntry:SelectAllText( true )
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
	Window:DoModal()

end

local PANEL = {}

AccessorFunc( PANEL, "outline", "Outlined", FORCE_BOOL )
AccessorFunc( PANEL, "freq", "Frequency", FORCE_NUMBER )
AccessorFunc( PANEL, "amp", "Amplitude", FORCE_NUMBER )
AccessorFunc( PANEL, "font", "Font", FORCE_STRING )
AccessorFunc( PANEL, "col", "Color" )

function PANEL:Init()
	
	self.font = "GModWorldtip"
	self.freq = 2
	self.amp = 4
	self.col = Color( 255, 255, 255, 255 )
	self.outline = true
	self.ideal_x = false
	self.ideal_y = false
	
end

function PANEL:IdealPos( x, y )
	
	self.ideal_x = x
	self.ideal_y = y
	
end

function PANEL:SetText( txt )
	
	self.txt = txt
	self:ClearText()
	self:GenerateText()
	
	surface.SetFont( self.font )
	local w, h = surface.GetTextSize( txt )
	self:SetSize( w, h )
	
end

function PANEL:ClearText()
	
	self.letters = false
	
end

function PANEL:SetLifetime( int )
	
	self.lifespan = tonumber( int )
	self.life = CurTime() + tonumber( int )
	
end

function PANEL:Kill()
	
	if self.dead then return end
	
	self:SetLifetime( #self.letters*0.04 )
	self.dead = true
	
end

function PANEL:Think()
	
	if self.life and CurTime() > self.life then
		if !self.dead then
			self:Kill()
		else
			self:Remove()
		end
	end

	if !(self.ideal_x || self.ideal_y) then return end
	local x, y = self:GetPos()
	if math.abs(x - (self.ideal_x or x)) != 0 then
		local dis = self.ideal_x - x
		x = x + math.max( dis * 0.1, math.min( 1, dis ) )
	elseif self.ideal_x then
		self:SetPos( self.ideal_x, y )
		self.ideal_x = false
		return
	end
	if math.abs(y - (self.ideal_y or y)) != 0 then
		local dis = self.ideal_y - y
		y = y + math.max( dis * 0.1, math.min( 1, dis ) )
	elseif self.ideal_y then
		self:SetPos( x, self.ideal_y )
		self.ideal_y = false
		return
	end
	self:SetPos( x, y )
	
end

function PANEL:Paint()
	
	if !self.letters then return end
	if #self.letters == 0 then return end
	
	DisableClipping( true )
	
	surface.SetFont( self:GetFont() )
	local w, h = surface.GetTextSize( self.txt )
	w = w + h*0.1*#self.letters
	local pos = w*-0.5
	local a = self.col.a
	local col = Color( self.col.r, self.col.g, self.col.b, self.col.a )
	
	for i, l in pairs( self.letters ) do
		local wave = math.sin(RealTime()*10 + i/self:GetFrequency())
		if self.life and self.dead then
			a = (self.life - CurTime())/self.lifespan
			a = math.max( a*self.col.a - i*#self.letters, 0 )
			col.a = a
		end
		if self:GetOutlined() then
			draw.SimpleTextOutlined( l, self:GetFont(), pos, wave*self:GetAmplitude(), col, 0, 1, h*0.1, Color( 0, 0, 0, a ) )
		else
			draw.SimpleText( l, self:GetFont(), pos, wave*self:GetAmplitude(), col, 0, 1 )
		end
		w = surface.GetTextSize( l )
		pos = pos + w + h*0.1
	end

	DisableClipping( false )
	
end

function PANEL:GenerateText()
	
	local tbl = {}
	for i = 1, string.len( self.txt ) do
		tbl[ #tbl + 1 ] = self.txt:sub( i, i )
	end
	
	self.letters = tbl
	
end

vgui.Register( "WaveyText", PANEL, "Panel" )

usermessage.Hook("PlayerOnRank", function(um)
	local IsVIP = um:ReadBool()
	if(IsVIP) then
		STGamemodes.VIP = true
	end
	if(STValidEntity(LocalPlayer())) then
		RunConsoleCommand("st_playeronrank")
	end
end)
