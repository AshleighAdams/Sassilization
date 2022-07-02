--------------------
-- STBase
-- By Spacetech
--------------------

function STGamemodes:PlaySound(ply, sound)
	umsg.Start("STGamemodesPS", ply)
		umsg.String(sound)
	umsg.End()
end

function STGamemodes:PrintAll(Message)
	print(Message)
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid()) then
			v:ChatPrint(Message)
		end
	end
end

function STGamemodes:PrintAdmin(Message)
	if !Message or Message == "" then return end 
	Message = "[ADMINS] ".. Message 
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:IsAdmin()) then
			v:ChatPrint(Message)
		end
	end
	print(Message)
end

function STGamemodes:PrintMod(Message)
	if !Message or Message == "" then return end 
	Message = "[MODS] ".. Message 
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:IsMod()) then
			v:ChatPrint(Message)
		end
	end
	print(Message)
end

function STGamemodes:ConsolePrint(Message, Staff)
	if !Message or Message == "" then return end 
	if Staff then Message = "[STAFF] ".. Message end 
	print(Message)
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and ((Staff and v:IsMod()) or !Staff)) then
			v:PrintMessage(HUD_PRINTCONSOLE, Message)
		end
	end
end

function STGamemodes:CustomChat(Name, Text, NameColor, TextColor, checkfunc)
	local rp = RecipientFilter()
	if(checkfunc) then
		for k,v in pairs(player.GetAll()) do
			if(v and v:IsValid() and checkfunc(v)) then
				rp:AddPlayer(v)
			end
		end
	else
		rp:AddAllPlayers()
	end
	
	umsg.Start("STGamemodes.ChatBox.AddCustomChat", rp)
		umsg.String(Name)
		umsg.String(Text)
		umsg.Vector(Vector(NameColor.r, NameColor.g, NameColor.b))
		umsg.Vector(Vector(TextColor.r, TextColor.g, TextColor.b))
	umsg.End()
end

function STGamemodes:GroupChat(ply, chat, checkfunc, col)
	local col = col or Color(255, 255, 255)
	local rp = RecipientFilter()
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and checkfunc(v)) then
			rp:AddPlayer(v)
		end
	end
	umsg.Start("STGamemodes.ChatBox.AddChat", rp)
		umsg.Entity(ply)
		umsg.String(chat)
		umsg.Vector(Vector(col.r, col.g, col.b))
	umsg.End()
end

function STGamemodes:AdminMessage(msg, Col)
	local rp = RecipientFilter()
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:IsAdmin()) then
			rp:AddPlayer(v)
		end
	end
	umsg.Start("STGamemodes.ChatBox.ConsoleMessage", rp)
		umsg.String(msg)
		umsg.Vector(Vector(Col.r, Col.g, Col.b))
	umsg.End()
end

function STGamemodes:ModMessage(msg, Col)
	local rp = RecipientFilter()
	for k,v in pairs(player.GetAll()) do
		if(v and v:IsValid() and v:IsMod()) then
			rp:AddPlayer(v)
		end
	end
	umsg.Start("STGamemodes.ChatBox.ConsoleMessage", rp)
		umsg.String(msg)
		umsg.Vector(Vector(Col.r, Col.g, Col.b))
	umsg.End()
end

function STGamemodes:ChangeMap(ply, map)
	local Msg = false 
	if ply and ply:IsValid() then 
		Msg = STGamemodes.GetPrefix(ply).." "..ply:CName().." has changed the map to "..map 
	end 
	for k,v in pairs(player.GetAll()) do
		v:EmitSound("vo/k_lab/kl_initializing02.wav")
		if(Msg) then
			v:ChatPrint(Msg)
		end
		GAMEMODE:EntityRemoved(v)
	end
	local ChangeMap = self.ServerDirectory.."/changemap.txt"
	file.Write(ChangeMap, map)
	timer.Simple(4.2, function() RunConsoleCommand("changelevel", map) end )

	-- Jukebox:Clean()
end

function STGamemodes:ChangeGamemode(ply, map, GM)
	local Msg, GM = false, GM
	if ply and ply:IsValid() then 
		Msg = STGamemodes.GetPrefix(ply).." "..ply:CName().." has changed the"
		if GM then 
			Msg = Msg  .." gamemode to ".. GM .." on the map ".. map 
		else 
			Msg = Msg .." map to ".. map 
			GM = GAMEMODE.Name
		end 
	end 

	for k,v in pairs(player.GetAll()) do
		v:EmitSound("vo/k_lab/kl_initializing02.wav")
		if(Msg) then
			v:ChatPrint(Msg)
		end
		GAMEMODE:EntityRemoved(v)
	end
	
	local ChangeMap = self.ServerDirectory.."/changemap.txt"
	file.Delete(ChangeMap) -- We don't want to change to a deathrun map if we're on bhop, do we?

	-- Jukebox:Clean()

	RunConsoleCommand("gamemode", GM) 
	timer.Simple(4.2, function() RunConsoleCommand("changelevel", ma, GM) end )
end 

function STGamemodes:IsMoving(ply)
	if(ply:KeyDown(IN_FORWARD) or ply:KeyDown(IN_BACK) or ply:KeyDown(IN_MOVELEFT) or ply:KeyDown(IN_MOVERIGHT)) then
		return true
	end
	return false
end

function STGamemodes:GetHeadAttachment(ply)
	local Head = ply:LookupAttachment("anim_attachment_head")
	if(!Head) then
		return
	end
	
	local Attachment = ply:GetAttachment(Head)
	if(!Attachment or !Attachment.Pos) then
		return
	end
	
	return Attachment
end

function STGamemodes:RemoveEntities()
	local Removed = 0
	for k,v in pairs(ents.GetAll()) do
		if(IsValid(v) and ((v:IsWeapon() and v:GetClass() != "weapon_frag") or v:GetClass() == "weapon_spawn" or v:GetClass() == "game_player_equip" or v:GetClass() == "point_template")) then
			v:Remove()
			Removed = Removed + 1
		end
	end
	print("Removed "..tostring(Removed).." entities")
end

function STGamemodes:CreateRagdoll(ent, force, forcepos)
    -- We don't necessarily need these paramaters, so default to something if they aren't given
    force = force or vector_origin
    forcepos = forcepos or ent:LocalToWorld( ent:OBBCenter() )
 
    -- Get  the model and make sure it's a ragdoll
    local model = ent:GetModel()
    if not util.IsValidRagdoll( model ) then return nil end
   
    -- Create the ragdoll
    local ragdoll = ents.Create( "prop_ragdoll" )
   
    ragdoll:SetModel( model )
    ragdoll:SetPos( ent:GetPos() )
    ragdoll:SetAngles( ent:GetAngles() )
    ragdoll:Spawn()
   
    -- It didn't work, give up
    if not ragdoll:IsValid() then return nil end
   
    -- Change the collision group to whatever you want
    --ragdoll:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	ragdoll:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
    -- We add the velocity of the ent to each of the bones
    local entvel
    local entphys = ent:GetPhysicsObject()
    if entphys:IsValid() then
        entvel = entphys:GetVelocity()
    else
        entvel = ent:GetVelocity()
    end
 
    -- Setup the bones
   -- for i=1,128 do -- There should be less than 128 bones for any ragdoll
	for i=1, ragdoll:GetPhysicsObjectCount() do
   
        -- This is the physics object of one of the ragdoll's bones
        local bone = ragdoll:GetPhysicsObjectNum( i )
       
        if ValidEntity( bone ) then
       
            -- This gets the position and angles of the entity bone corresponding to the above physics bone
            local bonepos, boneang = ent:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
   
            -- All we need to do is set the bones position and angle
            bone:SetPos( bonepos )
            bone:SetAngle( boneang )
           
            -- Apply the correct force to each bone
            bone:ApplyForceOffset( force, forcepos )
            bone:AddVelocity( entvel )
           
        end
 
    end
 
    -- Inherit everything we can from the entity
    ragdoll:SetSkin( ent:GetSkin() )
    ragdoll:SetColor( ent:GetColor() )
    ragdoll:SetMaterial( ent:GetMaterial() )
    if ent:IsOnFire() then ragdoll:Ignite( math.Rand( 8, 10 ), 0 ) end
   
    return ragdoll
end

function STGamemodes:GetPitch(ply)
	-- local Attachment = self:GetHeadAttachment(ply)
	-- if(!Attachment) then
		-- return
	-- end
	
	local Trace = {}
	Trace.start = ply:GetPos() --Attachment.Pos
	Trace.endpos = Trace.start - Vector(0, 0, 100)
	Trace.mask = MASK_SOLID_BRUSHONLY
	local tr = util.TraceLine(Trace)
	
	if(tr.HitWorld) then
		return tr.HitNormal:Angle().p
	end
	
	return 270
end

local Pitch
local AreaSpecific = false
local Areas = {}
local SlayCount = {}
function STGamemodes:PitchCheck()
	if(!self.PitchCheckEnabled) then
		return
	end
	for k,v in pairs(player.GetAll()) do
		if(v:Alive() and !v.Winner) then
			Pitch = self:GetPitch(v)
			if((Pitch < 100 or Pitch > 320) and !v:OnGround()) then
				if(!v.PitchTime) then
					v.PitchTime = CurTime() + 2.5
				end
				if(v.PitchTime <= CurTime() or ((v.PitchTime - 1) <= CurTime() and v:GetVelocity():Length() >= 400)) then
					if AreaSpecific then
						for _, areas in pairs( Areas ) do
							if v:GetPos():Distance( areas[1] ) >= areas[2] then
								return
							end
						end
					end
					v:Kill()
					if(!SlayCount[v:SteamID()]) then
						SlayCount[v:SteamID()] = 0
					end
					SlayCount[v:SteamID()] = SlayCount[v:SteamID()] + 1
					if(SlayCount[v:SteamID()] >= 75) then
						STGamemodes.SecretKick(v, "No Surfing")
					end
					v.PitchTime = nil
				end
			else
				if(v.PitchTime) then
					v.PitchTime = nil
				end
			end
		end
	end
end

function STGamemodes:EnablePitchCheck(Bool)
	self.PitchCheckEnabled = Bool

	if Bool then 
		timer.Create("STPitchCheck", 0.5, 0, function() self:PitchCheck() end  )
	else 
		timer.Destroy("STPitchCheck") 
	end 
	
end

function STGamemodes:AddPitchArea( Vec, Radius )
	if !Vec or !Radius then return end
	STGamemodes:EnablePitchCheck( true )
	AreaSpecific = true
	table.insert( Areas, {Vec, Radius} )
end

