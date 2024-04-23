class 'Help'

function Help:__init()
	Events:Subscribe( "PlayerJoin", self, self.PlayerJoin )
    Events:Subscribe( "PlayerChat", self, self.PlayerChat )
	Network:Subscribe( "Save", self, self.Save )

    SQL:Execute( "CREATE TABLE IF NOT EXISTS players_helpmenureaded (steamid VARCHAR UNIQUE, readed INTEGER)" )
end

function Help:PlayerJoin( args )
    local qry = SQL:Query( "select readed from players_helpmenureaded where steamid = (?)" )
    qry:Bind( 1, args.player:GetSteamId().id )
    local result = qry:Execute()

	if #result > 0 then
        args.player:SetNetworkValue( "HelpMenuReaded", tonumber(result[1].readed) )
    end
end

function Help:PlayerChat( args )
	local cmd_args = args.text:split( " " )

	if (cmd_args[1] == "/help") or (cmd_args[1] == "/rules") then
		Network:Send( args.player, "OpenHelpMenu" )
        return false
    end
end

function Help:Save( args, sender )
    if sender:GetValue( "HelpMenuReaded" ) then return end

    sender:SetNetworkValue( "HelpMenuReaded", 1 )

    local cmd = SQL:Command( "insert or replace into players_helpmenureaded (steamid, readed) values (?, ?)" )
    cmd:Bind( 1, sender:GetSteamId().id )
    cmd:Bind( 2, sender:GetValue( "HelpMenuReaded" ) )
    cmd:Execute()
end

Help = Help()