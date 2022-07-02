--------------------
-- STBase
-- By Spacetech
--------------------

local ConVar = CreateClientConVar( "st_voicedisabled", "0", true, false )


STGamemodes.Voice = {}
STGamemodes.Voice.ServerEnabled = 0
STGamemodes.Voice.ClientDisabled = false
STGamemodes.Voice.WasMuted = {}

if ConVar:GetInt() == 1 then STGamemodes.Voice.ClientDisabled = true end 
if file.Exists( "sassilization/voicemute.txt", "DATA" ) then file.Delete( "sassilization/voicemute.txt" ) end -- No longer used, delete it!

function STGamemodes.Voice.ToggleVoice()
	if STGamemodes.Voice.ClientDisabled == false then
		LocalPlayer():ChatPrint( "[VOICE] Disabling Voice Chat..." )
		STGamemodes.Voice.ClientDisabled = true
		RunConsoleCommand( "st_voicedisabled", "1" )
	else
		LocalPlayer():ChatPrint( "[VOICE] Enabling Voice Chat..." )
		LocalPlayer():ChatPrint( "[VOICE] (Not all players may be unmuted)" )
		STGamemodes.Voice.ClientDisabled = false
		RunConsoleCommand( "st_voicedisabled", "0" )
		for k,v in pairs( player.GetAll() ) do
			if v:IsMuted() and table.HasValue(STGamemodes.Voice.WasMuted, v:SteamID()) then
				v:SetMuted( false )
			end
		end
		STGamemodes.Voice.WasMuted = {}
	end
	STGamemodes.Store.RefreshSettings = true
end

usermessage.Hook( "STGamemodes.VoiceSetVar", function( um )
	STGamemodes.Voice.ServerEnabled = um:ReadChar()
end )

function STGamemodes.Voice:MuteCheck( ply )
	if self.ServerEnabled > 0 and self.ClientDisabled then
		if !ply:IsMuted() and ply != LocalPlayer() then
			LocalPlayer():ChatPrint( "[VOICE] Muting: ".. ply:CName() )
			LocalPlayer():ChatPrint( "[VOICE] Type /voice to enable voice chat.  You have it disabled." )
			ply:SetMuted( true )
			table.insert( self.WasMuted, ply:SteamID() )
			return true 
		end 
	elseif self.ServerEnabled <= 0 then 
		return true 
	end 
	return false 
end

local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()

	self.LabelName = vgui.Create( "DLabel", self )
	self.LabelName:SetFont( "GModNotify" )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 8, 0, 0, 0 )
	self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:Dock( LEFT );
	self.Avatar:SetSize( 32, 32 )

	self.SassTag = vgui.Create( "DImage", self ) 
	self.SassTag:Dock( LEFT ) 
	self.SassTag:SetSize(32, 16)
	self.SassTag:DockMargin(8, 8, 0, 8) 

	self.Color = color_transparent

	self:SetSize( 250, 32 + 8 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )

end

function PANEL:Setup( ply )

	self.ply = ply
	self.LabelName:SetText( ply:Nick() )
	self.Avatar:SetPlayer( ply )
	if ply:GetRank() != "guest" then 
		self.SassTag:SetMaterial(RepMat[ply:GetRank()])  
	end 
	
	self.Color = team.GetColor( ply:Team() )
	
	self:InvalidateLayout()

end

function PANEL:Paint( w, h )

	if ( !IsValid( self.ply ) ) then return end
	draw.RoundedBox( 4, 0, 0, w, h, Color( 0, self.ply:VoiceVolume() * 255, 0, 240 ) )

end

function PANEL:Think( )

	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end

end

function PANEL:FadeOut( anim, delta, data )
	
	if ( anim.Finished ) then
	
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
		
	return end
			
	self:SetAlpha( 255 - (255 * delta) )

end

derma.DefineControl( "SassVoiceNotify", "", PANEL, "DPanel" )



function GM:PlayerStartVoice( ply )
	if STGamemodes.Voice:MuteCheck( ply ) then return end 

	if ( !IsValid( g_VoicePanelList ) ) then return end
	
	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )


	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return;

	end

	if ( !IsValid( ply ) ) then return end

	local pnl = g_VoicePanelList:Add( "SassVoiceNotify" )
	pnl:Setup( ply )
	
	PlayerVoicePanels[ ply ] = pnl
	
end


local function VoiceClean()

	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( !IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end

end

timer.Create( "VoiceClean", 10, 0, VoiceClean )


function GM:PlayerEndVoice( ply )
	
	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end

		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

	end
	
end


local function CreateVoiceVGUI()

	g_VoicePanelList = vgui.Create( "DPanel" )

	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( ScrW() - 300, 100 )
	g_VoicePanelList:SetSize( 250, ScrH() - 200 )
	g_VoicePanelList:SetDrawBackground( false )

end

hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )


-- -- function UnmutePeople( ply, cmd, args )
-- -- 	ply:ChatPrint( args[1] )
-- -- 	local Ply = STGamemodes.FindByPartial( args[1] )
-- -- 	ply:ChatPrint( Ply:Nick() )
-- -- 	if Ply:IsMuted() and !STGamemodes.Voice.ClientDisabled and table.HasValue( STGamemodes.Voice.WasMuted, Ply ) then
-- -- 		Ply:SetMuted( false )
-- -- 		for k,v in pairs( STGamemodes.Voice.WasMuted ) do
-- -- 			if v == Ply then
-- -- 				table.remove( STGamemodes.Voice.WasMuted, k )
-- -- 				break
-- -- 			end
-- -- 		end
-- -- 	end
-- -- end
-- -- concommand.Add( "st_voiceunmute", UnmutePeople )
