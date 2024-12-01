Palomino.API = Palomino.API or {}

require( "gwsockets" )
require( "chttp" )

Palomino.API.REST_URL = Palomino.API.REST_URL or false
Palomino.API.WS_URL = Palomino.API.WS_URL or false

local sAPISecret = ""
local sAPIToken = ""

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

    if not sAPIToken or #sAPIToken == 0 then
        ErrorNoHaltWithStack( "Attempted to make an API request without a valid token!" )
        return
    end

    tRequest.url = Palomino.ENV.REST_URL .. tRequest.url

    tRequest.headers = tRequest.headers or {}
    tRequest.headers["Authorization"] = "Bearer " .. sAPIToken
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

Palomino.API.Connect()