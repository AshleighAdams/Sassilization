--------------------
-- STBase
-- By Spacetech
--------------------

STRTD:Add( "bombard", function( ply )
	ply:EmitSound("sassilization/rtd/bombard.wav", 500, 100)
	ply.LockPos = true

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 

	local effectdata = EffectData()
		effectdata:SetOrigin(ply:GetPos() + Vector(0, 0, 120))
		effectdata:SetMagnitude(4.5)
		effectdata:SetScale(65)
	util.Effect("rtd_bombard", effectdata, true, true)

	local startPos = ply:GetPos() + Vector(0, 0, 120)
	local endPos = ply:GetPos()

	for i = 1, math.random(5, 8) do
		function startArrow(startPos, endPos)
			ply:EmitSound("sassilization/rtd/arrowfire0"..math.random(1, 2)..".wav", 500, 100)
			local throw = Vector(math.random(-35, 35), math.random(-35, 35), 0)
			startPos = startPos + throw
			endPos = endPos + throw
			local arr = ents.Create( "rtd_arrow" )
				arr:SetPos( startPos)
				arr.PosStart = startPos
				arr.PosTarget = endPos
				arr.AngStart = Angle( 180, 0, 0 )
				arr:Spawn()
				arr:Activate()
			if ply:Health() > 10 then
				ply:SetHealth( ply:Health() - 10 )
			else
				ply.rtddie = true
			end
		end
		timer.Simple( math.Rand( 0, 3 ) + 2, function() startArrow( startPos, endPos) end )
	end

	timer.Simple(6, function()
		if !ply:IsValid() then return end 
		ply.LockPos = nil
		if (ply.rtddie) then
			ply:Kill()
		end
	end)
	STRTD:SendMsg( ply, "was hit with Bombard!" )
end, 1050)


STRTD:Add( "decimate", function( ply )
	ply:EmitSound("sassilization/rtd/decimate.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 

	ply:Ignite( 10, 0 )

	
	STRTD:SendMsg( ply, "was hit with Decimate!" )
end, 1050)


STRTD:Add( "blast", function( ply )
	if ply:Team() == TEAM_DEATH then
		STRTD:Trigger( ply )
		return true
	end

	ply:EmitSound("sassilization/rtd/blast.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 



	local Position = ply:GetPos()		
	local Effect = EffectData()
	Effect:SetOrigin(Position)
	Effect:SetStart(Position)
	Effect:SetMagnitude(512)
	Effect:SetScale(128)
	util.Effect("Explosion", Effect)
	
	ply:Kill()

	
	STRTD:SendMsg( ply, "was hit with Blast!" )
end, 1050)


STRTD:Add( "heal", function( ply )
	if ply:Health() < ply:GetMaxHealth() then

		ply:EmitSound("sassilization/rtd/heal.wav", 500, 100)

		local effectdata = EffectData()
			effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
			effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
			effectdata:SetEntity(ply)
			effectdata:SetAttachment(1)
			effectdata:SetScale(20)
		util.Effect( "rtd_cast", effectdata ) 


		ply:SetHealth( ply:GetMaxHealth() )

		STRTD:SendMsg( ply, "was Healed!" )	
	else
		STRTD:Trigger( ply )
		return true 
	end
end, 1050)

STRTD:Add( "gravitate", function( ply )
	ply:EmitSound("sassilization/rtd/gravitate.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 

	ply:SetVelocity(Vector(0, 0, 500))

	
	STRTD:SendMsg( ply, "was hit with Gravitate!" )
end, 1050)

STRTD:Add( "vanish", function( ply )
	ply:EmitSound("sassilization/rtd/vanish.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 

	if STValidEntity( ply.Hat ) then
		ply.Hat:Remove()
	end
	if STValidEntity( ply.Trail ) then
		ply.Trail:Remove()
	end

	ply:SetRenderMode(RENDERMODE_TRANSALPHA)

	umsg.Start( "STRTD.SetVisible" )
		umsg.Entity( ply )
		umsg.Bool( false )
	umsg.End()
	
	STRTD:SendMsg( ply, "Vanished!" )
end, 750)

STRTD:Add( "paralyze", function( ply )
	ply:EmitSound("sassilization/rtd/paralysis.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 

	ply:Freeze( true )
	umsg.Start( "STRTD.FreezeEffect", ply )
	umsg.End()
	timer.Create( ply:SteamID().."-unfreeze", 10, 1, function() if ply:IsValid() then ply:Freeze( false ) end end )
	table.insert( STRTD.Timers, ply:SteamID().."-unfreeze" )

	
	STRTD:SendMsg( ply, "was Paralyzed for 10 seconds!" )
end, 1050)

STRTD:Add( "treason", function( ply )
	if GAMEMODE.PickedUp or (ply:Team() == TEAM_RUN and STGamemodes:TeamAliveNum({TEAM_RUN}) == 1) or (ply:Team() == TEAM_DEATH and STGamemodes:TeamAliveNum({TEAM_DEATH})) == 1 then
		STRTD:Trigger( ply )
		return true
	end
	
	ply:EmitSound("sassilization/rtd/treason.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos() + ply:GetUp())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(20)
	util.Effect( "rtd_cast", effectdata ) 

	if ply:Team() == TEAM_DEATH then
		ply:GoTeam( TEAM_RUN )
	elseif ply:Team() == TEAM_RUN then
		ply:GoTeam( TEAM_DEATH )
		ply:SetVar("DeathCount", 1)
	end
	STRTD:SendMsg( ply, "was hit with Treason! They switched teams!" )
end, 750 )

STRTD:Add( "strike", function( ply )

	ply:EmitSound("sassilization/rtd/strike.wav", 500, 100)

	local effectdata = EffectData()
		effectdata:SetStart(ply:GetPos() + ply:GetUp() * 500)
		effectdata:SetOrigin(ply:GetPos())
		effectdata:SetEntity(ply)
		effectdata:SetAttachment(1)
		effectdata:SetScale(40)
	util.Effect( "rtd_cast", effectdata ) 

	if ply:Health() > 50 then
		ply:SetHealth( ply:Health() - 50 )

		timer.Create( ply:SteamID().."-char", 1, 1, function() if ply:IsValid() then ply:SetColor(Color(0, 0, 0, 255)) end end )
		table.insert( STRTD.Timers, ply:SteamID().."-char" )
	else
		ply:Kill()
	end

	STRTD:SendMsg( ply, "was hit with Lightning! Ouch!" )
end, 750 )


 
//////////////////////////////////////////////////
/////            Neutral/Both RTDs            ////
//////////////////////////////////////////////////

-- STRTD:Add( "bighead", function( ply )
-- 	STGamemodes.ShrinkScale( ply, 4 )
-- 	STRTD:SendMsg( ply, "their head was made abnormally large." )
-- end, 400 )

-- STRTD:Add( "nohead", function( ply )
-- 	STGamemodes.ShrinkScale( ply, 0.1 )
-- 	STRTD:SendMsg( ply, "lost their head." )
-- end, 400 )
/*
STRTD:Add( "teamswap", function( ply )
	if GAMEMODE.PickedUp or (ply:Team() == TEAM_RUN and STGamemodes:TeamAliveNum({TEAM_RUN}) == 1) or (ply:Team() == TEAM_DEATH and STGamemodes:TeamAliveNum({TEAM_DEATH})) == 1 then
		STRTD:Trigger( ply )
		return true
	end
	
	if ply:Team() == TEAM_DEATH then
		ply:GoTeam( TEAM_RUN )
	elseif ply:Team() == TEAM_RUN then
		ply:GoTeam( TEAM_DEATH )
		ply:SetVar("DeathCount", 1)
	end
	STRTD:SendMsg( ply, "was forced to swap teams." )
end, 700 )
*/

STRTD:Add( "slowmo", function( ply )
	ply:ModSpeed( 0.4 )
	STRTD:SendMsg( ply, "got slow motion." )
end )

STRTD:Add( "disco", function( ply )
	umsg.Start( "STRTD.Disco", ply )
	umsg.End()
	STRTD:SendMsg( ply, "started seeing random colors." )
end )

STRTD:Add( "timebomb", function( ply )
	if !ply.Aaron then 
		STRTD:Trigger( ply )
		return true 
	end 

	if !ply:Team() == TEAM_RUN then 
		STRTD:Trigger( ply )
		return true 
	end 

	local Bomb = ents.Create( "st_timebomb" )
	Bomb:Spawn()
	Bomb:SetPos(ply:GetPos()+Vector(0,0,100))
	Bomb:SetParent(ply)

	STRTD:SendMsg( ply, "was made a time bomb! RUN!!!" )
end )

/////////////////////////////////////////////////
/////                    Positive            ////
/////////////////////////////////////////////////

STRTD:Add( "bonusrtd", function( ply ) 
	if !STRTD:HasBonus(ply) then ply.DisableOneBonus = true end 
	STRTD.Double[ply:SteamID()] = (STRTD.Double[ply:SteamID()] or 0) + 2
	STRTD:SendMsg( ply, "got two free bonus RTDs!" )
end )

/*
STRTD:Add( "invis", function( ply )
	if STValidEntity( ply.Hat ) then
		ply.Hat:Remove()
	end
	if STValidEntity( ply.Trail ) then
		ply.Trail:Remove()
	end
	umsg.Start( "STRTD.SetVisible" )
		umsg.Entity( ply )
		umsg.Bool( false )
	umsg.End()
	STRTD:SendMsg( ply, "was made invisible!" )
end, 300 )
*/

-- STRTD:Add( "god", function( ply )
-- 	ply:GodEnable()
-- 	timer.Simple( "God_.."..ply:SteamID(), 10, 1, function()
-- 		ply:GodDisable()
-- 		ply:ChatPrint( "You are no longer God!" )
-- 	end )
-- 	table.insert( STRTD.Timers, "God_.."..ply:SteamID() )
-- 	STRTD:SendMsg( ply, "was made God for 10 seconds." )
-- end, 500 )

STRTD:Add( "lgrav", function( ply )
	if ply:GetGravity() != 1 then 
		STRTD:Trigger(ply)
		return true 
	end 
	ply:SetGravity( 0.8 )
	STRTD:SendMsg( ply, "got low gravity!" )
end, 700 )

STRTD:Add( "5k", function( ply )
	ply:GiveMoney( 5100 )
	ply:SaveMoney()
	STRTD:SendMsg( ply, "won 5000 dough!" )
end, 50 )

STRTD:Add( "1k", function( ply )
	ply:GiveMoney( 1100 )
	ply:SaveMoney()
	STRTD:SendMsg( ply, "won 1000 dough!" )
end, 800 )

STRTD:Add( "300", function( ply )
	ply:GiveMoney( 400 )
	ply:SaveMoney()
	STRTD:SendMsg( ply, "won 300 dough!" )
end )

STRTD:Add( "hjp", function( ply )
	ply:SetJumpPower( 250 )
	STRTD:SendMsg( ply, "got higher jumping power!" )
end )

STRTD:Add( "incspeed", function( ply )
	ply:SetWalkSpeed( ply:GetWalkSpeed() + 30 )
	ply:SetRunSpeed( ply:GetWalkSpeed() )
	STRTD:SendMsg( ply, "got increased speed!" )
end )

/*
STRTD:Add( "fullhp", function( ply )
	if ply:Health() < ply:GetMaxHealth() then
		ply:SetHealth( ply:GetMaxHealth() )
		STRTD:SendMsg( ply, "received full health." )
	else
		STRTD:Trigger( ply )
		return true 
	end
end )
*/

STRTD:Add( "50bonus", function( ply )
	ply:SetHealth( ply:Health()+50 )
	STRTD:SendMsg( ply, "received 50 bonus HP!" )
end )

STRTD:Add( "crowbar", function( ply )
	if ply:HasWeapon( "weapon_crowbar" ) or ply:Team() == TEAM_DEATH then
		STRTD:Trigger( ply )
		return true
	end
	ply:Give( "weapon_crowbar" )
	ply:SelectWeapon( "weapon_crowbar" )
	STRTD:SendMsg( ply, "got a crowbar." )
end ) 

/////////////////////////////////////////////////
/////                    Negative            ////
/////////////////////////////////////////////////



STRTD:Add( "strip", function( ply )
	if #ply:GetWeapons() == 0 then 
		STRTD:Trigger( ply )
		return true 
	end 

	ply:StripWeapons()
	STRTD:SendMsg( ply, "was stripped of all weapons." )
end )

/*
STRTD:Add( "explode", function( ply )
	if ply:Team() == TEAM_DEATH then
		STRTD:Trigger( ply )
		return true
	end

	local Position = ply:GetPos()		
	local Effect = EffectData()
	Effect:SetOrigin(Position)
	Effect:SetStart(Position)
	Effect:SetMagnitude(512)
	Effect:SetScale(128)
	util.Effect("Explosion", Effect)
	
	ply:Kill()
	
	STRTD:SendMsg( ply, "spontaneously combusted!" )
end, 500 )
*/

/*STRTD:Add( "ignite", function( ply )
	ply:Ignite( 10, 0 )
	STRTD:SendMsg( ply, "got set on fire!" )
end )*/
/*
STRTD:Add( "lose50hp", function( ply )
	if ply:Health() > 50 then
		ply:SetHealth( ply:Health() - 50 )
	else
		ply:Kill()
	end
	STRTD:SendMsg( ply, "lost 50 hp!" )
end )
*/

STRTD:Add( "losemosthp", function( ply )
	ply:SetHealth( 1 )
	STRTD:SendMsg( ply, "nearly died!" )
end )

STRTD:Add( "hgrav", function( ply )
	if ply:GetGravity() != 1 then 
		STRTD:Trigger(ply)
		return true 
	end 
	ply:SetGravity( 1.3 )
	STRTD:SendMsg( ply, "got high gravity." )
end )

STRTD:Add( "ljp", function( ply )
	ply:SetJumpPower( 150 )
	STRTD:SendMsg( ply, "got lower jumping power." )
end )

STRTD:Add( "decspeed", function( ply )
	ply:SetWalkSpeed(ply:GetWalkSpeed() - 30  )
	ply:SetRunSpeed( ply:GetWalkSpeed() )
	STRTD:SendMsg( ply, "got decreased speed." )
end )

/*
STRTD:Add( "freeze", function( ply )
	ply:Freeze( true )
	umsg.Start( "STRTD.FreezeEffect", ply )
	umsg.End()
	timer.Create( ply:SteamID().."-unfreeze", 10, 1, function() if ply:IsValid() then ply:Freeze( false ) end end )
	table.insert( STRTD.Timers, ply:SteamID().."-unfreeze" )
	STRTD:SendMsg( ply, "froze for 10 seconds." )
end )
*/

STRTD:Add( "flash", function( ply )
	umsg.Start( "STRTD.BlindStart", ply )
	umsg.End()
	ply:EmitSound("weapons/flashbang/flashbang_explode2.wav", 500, 200)
	if ply:Health() > 25 then
		ply:SetHealth( ply:Health() - 25 )
	else
		ply:Kill()
	end
	STRTD:SendMsg( ply, "was hit with a flash grenade!" )
end )

STRTD:Add( "blur", function( ply )
	umsg.Start( "STRTD.Blur", ply )
		umsg.Bool( true )
	umsg.End()
	STRTD:SendMsg( ply, "got blurred vision." )
end )

STRTD:Add( "slap", function( ply )
	timer.Create( "Slap_".. ply:SteamID(), 0.5, 20, function()
		if !ply:IsValid() or !ply:Alive()  then
			timer.Destroy( "Slap_".. ply:SteamID() )
			return
		end
		ply:SetLocalVelocity( Vector( math.random( -500, 500 ), math.random( -500, 500 ), math.random( 0, 300 ) ) )
		ply:EmitSound( STRTD.SlapSounds[math.random( 1, #STRTD.SlapSounds )] )
	end )
	table.insert( STRTD.Timers, "Slap_".. ply:SteamID() )
	STRTD:SendMsg( ply, "is getting slapped 20 times." )
end )



STRTD:Add( "nada", function( ply )
	STRTD:SendMsg( ply, "got nothing." )
end, 600 )

STRTD:Add( "upsidedown", function( ply )
	umsg.Start( "STRTD.CustomView", ply )
		umsg.Bool( true )
		umsg.Angle( Angle( 0, 0, 180 ) )
	umsg.End()
	STRTD:SendMsg( ply, "got their view flipped-turned upside down." )
end, 600 )

/* STRTD:Add( "backwards", function( ply )
	umsg.Start( "STRTD.CustomView", ply )
		umsg.Bool( true )
		umsg.Angle( Angle( 0, 180, 0 ) )
	umsg.End()
	table.insert( STRTD.Resets.Views, ply )
	STRTD:SendMsg( ply, "got their view inverted." )
end, 600 ) */