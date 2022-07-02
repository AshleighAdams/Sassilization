--------------------
-- STBase
-- By Spacetech
--------------------

local DermaOpen = false

function Derma_QueryFixed(strText, strTitle, ...)
	local arg = {...}
	
	if(DermaOpen) then
		timer.Simple(0.1, function() Derma_QueryFixed( strText, strTitle, unpack(arg)) end)
		return
	end
	
	ShowMouse()
	DermaOpen = true
	
	local Window = vgui.Create( "DFrame" )
		Window:SetTitle( strTitle or "Message Title (First Parameter)" )
		Window:SetDraggable( false )
		Window:ShowCloseButton( false )
		Window:SetBackgroundBlur( true )
		Window:SetDrawOnTop( true )
		
	local InnerPanel = vgui.Create( "DPanel", Window )
		InnerPanel:SetDrawBackground( false )
	
	local Text = vgui.Create( "DLabel", InnerPanel )
		Text:SetText( strText or "Message Text (Second Parameter)" )
		Text:SizeToContents()
		Text:SetContentAlignment( 5 )
		Text:SetTextColor( color_white )

	local ButtonPanel = vgui.Create( "DPanel", Window )
		ButtonPanel:SetTall( 30 )
		ButtonPanel:SetDrawBackground( false )

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k=1, 8, 2 do
		
		local Text = select( k, ... )
		if Text == nil then break end
		
		local Func = select( k+1, ... ) or function() end
	
		local Button = vgui.Create( "DButton", ButtonPanel )
			Button:SetText( Text )
			Button:SizeToContents()
			Button:SetTall( 20 )
			Button:SetWide( Button:GetWide() + 20 )
			Button.DoClick = function()
				Window:Close()
				Func()
				HideMouse()
				DermaOpen = false
			end
			Button:SetPos( x, 5 )
			
		x = x + Button:GetWide() + 5
			
		ButtonPanel:SetWide( x ) 
		NumOptions = NumOptions + 1
	
	end

	
	local w, h = Text:GetSize()
	
	w = math.max( w, ButtonPanel:GetWide() )
	
	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:Center()
	
	InnerPanel:StretchToParent( 5, 25, 5, 45 )
	
	Text:StretchToParent( 5, 5, 5, 5 )	
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( 8 )
	
	Window:MakePopup()
	Window:DoModal()
	
	if ( NumOptions == 0 ) then
	
		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil
	
	end
	
	return Window

end