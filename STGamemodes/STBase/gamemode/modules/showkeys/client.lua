STGamemodes.KeysConVar = CreateClientConVar( "st_keys", "1", true, false )
STGamemodes.KeysAdminConVar = CreateClientConVar( "st_adminkeys", "1", true, false )
STGamemodes.Keys = STGamemodes.KeysConVar:GetInt()
STGamemodes.AdminKeys = STGamemodes.KeysAdminConVar:GetInt()==1

if(file.Exists("EnableKeys.txt", "DATA")) then
	file.Delete("EnableKeys.txt")
end

concommand.Add("st_enablekeys", function(ply, cmd, args)

	if STGamemodes.Keys == 0 then 
		STGamemodes.Keys = 1 
		RunConsoleCommand( "st_keys", "1" )
		ply:ChatPrint( "Keys: Enabled while dead" )
	elseif STGamemodes.Keys == 1 then 
		STGamemodes.Keys = 2 
		RunConsoleCommand( "st_keys", "2" )
		ply:ChatPrint( "Keys: Enabled at all times" )
	elseif STGamemodes.Keys == 2 then 
		STGamemodes.Keys = 0 
		RunConsoleCommand( "st_keys", "0" )
		ply:ChatPrint( "Keys: Disabled" )
	end 

	STGamemodes.Store.RefreshSettings = true
end)


STGamemodes.ShowKeys.Keys = {
	-- [Key] = { bPressed, x, y, x offset, y offset }
	[IN_FORWARD]		= { false, 60, 0, 64*3, 64*2 }, // W
	[IN_MOVELEFT]		= { false, 0, 64 + 5, 64, 64*2 }, // A
	[IN_BACK]			= { false, 64 + 5, 64 + 5, 64*2, 64*2 }, // S
	[IN_MOVERIGHT]	= { false, 64*2 + 5*2, 64 + 5, 0, 64*2 }, // D
	[IN_JUMP]				= { false, 64*3 + 5*5, 64 + 5, 64*2, 64 }, // Spacebar (Jump)
	[IN_DUCK]			= { false, -(64 + 5*2), 64 + 5, 64, 64 }, // Ctrl (Crouch)
	[IN_USE]				= { false, 64*3 - 32 + 5*5, 0, 64, 64 }, // E (Use)
	[IN_ATTACK]		= { false, -(64 + 32 + 5), 0, 64, 0 }, // Left Mouse
	[IN_ATTACK2]		= { false, -(32 + 5), 0, 0, 0 }, // Right Mouse
}


/*
	GenerateUVOffset
	Allows for the usage of spritesheets for textures
*/
function GenerateUVOffset( x, y, w, h, tw, th, xoffset, yoffset )

	local uoffset, voffset = xoffset/tw, yoffset/th
	local umax, vmax = w/tw, h/tw
	local rect = {
		[1] = { -- topleft
			["x"] = x,
			["y"] = y,
			["u"] = uoffset,
			["v"] = voffset,
		},
		[2] = { -- topright
			["x"] = x + w,
			["y"] = y,
			["u"] = umax + uoffset,
			["v"] = voffset,
		},
		[3] = { -- bottomright
			["x"] = x + w,
			["y"] = y + h,
			["u"] = umax + uoffset,
			["v"] = vmax + voffset,
		},
		[4] = { -- bottomleft
			["x"] = x,
			["y"] = y + h,
			["u"] = uoffset,
			["v"] = vmax + voffset,
		}
	}

	return rect
	
end


/*
	Spectator Show Keys
	
	View key pressed of the observed target. Key
	presses/releases sent from the server
*/
local idToKey = {
	[0] = IN_FORWARD,
	[1] = IN_BACK,
	[2] = IN_MOVELEFT,
	[3] = IN_MOVERIGHT,
	[4] = IN_JUMP,
	[5] = IN_DUCK,
	[6] = IN_USE
}

/*
	Spacebar Presses
	
	Green "+1" on press
*/
local SpaceUses = {}
local StayTime = 6

usermessage.Hook( "BhopSendKeyPress", function(data)
	local key = data:ReadShort()
	
	--Msg("RECEIVED KEYPRESS " .. tostring(key) .. "\n")
	STGamemodes.ShowKeys.Keys[key][1] = true

	if STGamemodes.Mod then 
		if key == IN_JUMP then 
			table.insert( SpaceUses, {Press=true, End=CurTime()+StayTime} )
		end 
	end 
end )

usermessage.Hook( "BhopSendKeyRelease", function(data)
	local key = data:ReadShort()
	
	--Msg("RECEIVED KEYPRESS " .. tostring(key) .. "\n")
	STGamemodes.ShowKeys.Keys[key][1] = RealTime()

	if STGamemodes.Mod then 
		if key == IN_JUMP then 
			table.insert( SpaceUses, {Press=false, End=CurTime()+StayTime} )
		end 
	end 
end )


/*
	Clientside Key Display
	
	Players may use st_showkeys [0/1] to show their own key presses -- Changed
	on their screen. Could be used for recording someone's gameplay.
*/
hook.Add( "KeyPress", "ClientKeyPress", function(ply, key)
	if STGamemodes.Keys == 0 then return end 
	if !ply:Alive() and !ply:IsGhost() then return end 

	if key and table.HasValue(STGamemodes.ShowKeys:GetFilter(), key) then 
		STGamemodes.ShowKeys.Keys[key][1] = true
	end 

	if STGamemodes.Mod then 
		if key == IN_JUMP then 
			table.insert( SpaceUses, {Press=true, End=CurTime()+StayTime} )
		end 
	end 
end )

hook.Add( "KeyRelease", "ClientKeyRelease", function(ply, key)
	if STGamemodes.Keys == 0 then return end 
	if !ply:Alive() and !ply:IsGhost() then return end 

	if key and table.HasValue(STGamemodes.ShowKeys:GetFilter(), key) then 
		STGamemodes.ShowKeys.Keys[key][1] = RealTime()
	end 

	if STGamemodes.Mod then 
		if key == IN_JUMP then 
			table.insert( SpaceUses, {Press=false, End=CurTime()+StayTime} )
		end 
	end 
end )


/*
	GAMEMODE:HUDPaint()
	
	Display the keys on the screen, whether spectating a player
	or displaying the player's own keys.
*/
local target
local iconsheet = surface.GetTextureID( "sassilization/hud/iconsheet" )
local tw, th = surface.GetTextureSize( iconsheet )
local UsesX = 10
local NextUpdate = CurTime()
hook.Add( "HUDPaint", "PaintClientKeys", function()

	if STGamemodes.Keys != 2 then 
		if !IsValid(LocalPlayer()) then 
			return
		elseif STGamemodes.Keys == 0 then 
			return 
		elseif STGamemodes.Keys == 1 then 
			if LocalPlayer():Alive() then 
				return 
			end 
		else 
			return 
		end 
	end 

	local x, y = ScrW() - 464, ScrH() - 220
	
	// If the player has changed observer target...
	if IsValid(LocalPlayer():GetObserverTarget()) and LocalPlayer():GetObserverTarget():Alive() and target != LocalPlayer():GetObserverTarget() then
		if target != LocalPlayer():GetObserverTarget() then 
			target = LocalPlayer():GetObserverTarget()
			
			// Reset each key press to false
			for _, key in pairs(STGamemodes.ShowKeys.Keys) do
				key[1] = false
			end
		end 
	end
	
	// Portal 2 key icons :D
	surface.SetTexture( iconsheet )
	
	// Draw texture for each key
	for k, key in pairs(STGamemodes.ShowKeys.Keys) do
		surface.SetDrawColor( 255, 255, 255, 255 )
		if (k and table.HasValue(STGamemodes.ShowKeys:GetFilter(), k)) then
			if key[1] == true then
				surface.SetDrawColor( 80, 128, 190, 255 )
			elseif type(key[1]) == "number" then -- fade since last key release
				local fadeAmount = math.Clamp((RealTime() - key[1])/0.1, 0, 1)
				surface.SetDrawColor( 24 + (255-24)*fadeAmount, 108 + (255-108)*fadeAmount, 214 + (255-214)*fadeAmount, 255 )
			end

			if k == IN_JUMP then // spacebar texture is 2x as wide
				surface.DrawPoly( GenerateUVOffset( x + key[2], y + key[3], 128, 64, tw, th, key[4], key[5] ) )
			else
				surface.DrawPoly( GenerateUVOffset( x + key[2], y + key[3], 64, 64, tw, th, key[4], key[5] ) )
			end
		end
	end

	if !STGamemodes.Mod then return end 

	if NextUpdate <= CurTime() then 
		STGamemodes.AdminKeys = STGamemodes.KeysAdminConVar:GetInt()==1
		NextUpdate = CurTime()+5
	end 

	if !STGamemodes.AdminKeys then return end 

	local key = STGamemodes.ShowKeys.Keys[IN_JUMP]
	local Data = GenerateUVOffset( x + key[2], y + key[3], 64, 64, tw, th, key[4], key[5] )
	local NewTable = {}
	local count = table.Count(SpaceUses)
	for k, v in pairs(SpaceUses) do 
		if v.End >= CurTime() and count-k <= 50 then 
			-- if !v.x then v.x = math.random( 40, 100 ) end 
			if !v.x then
				v.x = UsesX
				UsesX = UsesX+25
				if UsesX >= 128 then UsesX = 0 end 
			end 

			if !v.y then v.y = 10 else v.y = v.y + 5 end 

			surface.SetTextPos( Data[1].x+v.x, Data[1].y-v.y )
			if v.Press then 
				surface.SetTextColor( 0, 255, 0, 255 )
				surface.DrawText("+1")
			else 
				surface.SetTextColor( 255, 0, 0, 255 )
				surface.DrawText("-1")
			end 
			surface.SetDrawColor( 0, 0, 0, 35 )
			surface.DrawRect( Data[1].x+v.x-2, Data[1].y-v.y, 20, 20 )

			surface.SetDrawColor( 0, 200, 0, 255 )
			surface.DrawRect( Data[1].x+175, Data[1].y-v.y, 5, 5 )

			table.insert(NewTable, v)
		end 
	end 
	SpaceUses = table.Copy(NewTable) 
end )