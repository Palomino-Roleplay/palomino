Palomino.API = Palomino.API or {}

require( "gwsockets" )
require( "chttp" )

Palomino.API.REST_URL = Palomino.API.REST_URL or false
Palomino.API.WS_URL = Palomino.API.WS_URL or false

local sAPISecret = ""
local sAPIToken = ""

util.AddNetworkString( "Palomino.API.PlayerSessionToken" )

local function loadEnvironmentConfig()
    local sEnvironmentConfig = file.Read( "gamemodes/" .. GM.FolderName .. "/palomino.json", true )

    if not sEnvironmentConfig then
        ErrorNoHaltWithStack( "Palomino: Environment configuration file not found!" )

        return false
    end

    local tEnvironmentConfig = util.JSONToTable( sEnvironmentConfig )
    if not tEnvironmentConfig then
        ErrorNoHaltWithStack( "Palomino: Environment configuration file is invalid!" )

        return false
    end

    Palomino.ENV = Palomino.ENV or {}

    Palomino.ENV.PUID = tEnvironmentConfig.server_puid
    Palomino.ENV.REST_URL = tEnvironmentConfig.api.rest_url
    Palomino.ENV.WS_URL = tEnvironmentConfig.api.ws_url
    sAPISecret = tEnvironmentConfig.api.secret

    return true
end

function Palomino.API.Connect()
    local bEnvironmentConfigLoaded = loadEnvironmentConfig()

    if not bEnvironmentConfigLoaded then
        -- @TODO: Retry, error handling, etc?
        return
    end

    print( "Connecting to Palomino API..." )

    CHTTP( {
        url = Palomino.ENV.REST_URL .. "/auth/server",
        method = "POST",
        body = util.TableToJSON( {
            id = Palomino.ENV.PUID,
            secret = sAPISecret,
        } ),
        headers = {
            ["Content-Type"] = "application/json",
        },
        success = function( nCode, sBody, tHeaders )
            if nCode == 200 then
                local tBody = util.JSONToTable( sBody )

                if not tBody then
                    ErrorNoHaltWithStack( "Failed to parse API response!" )
                    return
                end

                sAPIToken = tBody.token
                Palomino.API.SessionID = tBody.sessionId

                print( "Connected to Palomino API!" )
            end
        end,
        failed = function( sReason )
            print(sReason)
        end,
    } )
end

function Palomino.API.HTTP( tRequest, fnOK, fnFailed )
    -- @TODO: Check if we have a valid REST URL, etc.

    -- if not sAPIToken or #sAPIToken == 0 then
    --     ErrorNoHaltWithStack( "Attempted to make an API request without a valid token!" )
    --     return
    -- end

    tRequest.url = Palomino.ENV.REST_URL .. tRequest.url

    tRequest.headers = tRequest.headers or {}
    tRequest.headers["x-api-key"] = sAPISecret
    tRequest.headers["Content-Type"] = tRequest.headers["Content-Type"] or "application/json"

    tRequest.success = function( nCode, sBody, tHeaders )
        if fnOK then
            fnOK( nCode, sBody, tHeaders )
        end
    end

    tRequest.failed = function( sReason )
        if fnFailed then
            fnFailed( sReason )
        end
    end

    CHTTP( tRequest )
end

function Palomino.API.CreateGameServerSession()
    Palomino.API.HTTP( {
            url = "/api/gameserver/sessions/gameserver",
            method = "POST",
            body = util.TableToJSON( {
                id = Palomino.ENV.PUID,
                token = sAPIToken,
            } ),
        },
        function( nCode, sBody, tHeaders )
            print( "success" )
            print( sBody )
        end,
        function( sReason )
            print( "failed" )
            print( sReason )
        end
    )
end

function Palomino.API.CreatePlayerSession( pPlayer )
    Palomino.API.HTTP(
        {
            url = "/api/gameserver/sessions/player",
            method = "POST",
            body = util.TableToJSON( {
                ip = pPlayer:IPAddress(),
                steamId = pPlayer:SteamID(),
            } ),
        },
        function( nCode, sBody, tHeaders )
            print( "success" )
            print( sBody )

            local tBody = util.JSONToTable( sBody )
            if not tBody or not tBody.id then
                ErrorNoHaltWithStack( "Failed to parse API response!" )
                return
            else
                net.Start( "Palomino.API.PlayerSessionToken" )
                    net.WriteString( tBody.id )
                net.Send( pPlayer )
            end
        end,
        function( sReason )
            print( "failed" )
            print( sReason )
        end
    )
end

gameevent.Listen( "player_activate" )
hook.Add( "player_activate", "Palomino.API.player_activate", function( tData )
    local pPlayer = Player( tData.userid )

    Palomino.API.CreatePlayerSession( pPlayer )
end )

hook.Add( "PlayerDisconnected", "Palomino.API.PlayerDisconnected", function( pPlayer )
    -- @TODO: End player session
end )

Palomino.API.Connect()