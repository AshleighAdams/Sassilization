// logic_attacker_controller
 
ENT.Type = "point"
 
AccessorFunc( FindMetaTable('Entity'), "m_eAttacker","Attacker" )
 
function ENT:AcceptInput( name, activator, caller, data )
        print("Working..")
        print(name)
        print(activator)
        print(caller)
        print(data)
        if ( name and name:lower() == "setattacker" ) then
                for k,v in pairs( ents.FindByName( data ) ) do
                        v:SetAttacker( activator )
                end
        end
end
 
/*
        ...
        elseif IsValid( Attacker:GetAttacker() ) then
       
                umsg.Start( "PlayerKilledByPlayer" )
                        umsg.Entity( ply )
                        umsg.String( Attacker:GetClass() )
                        umsg.Entity( Attacker:GetAttacker() )
                umsg.End()
               
                MsgAll( Attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. Attacker:GetClass() .. "\n" )
                BAdmin:Log( Attacker:Nick() .. " killed " .. ply:Nick() .. " using " .. Attacker:GetClass() .. "\n" )
               
        else
        ...
 
*/