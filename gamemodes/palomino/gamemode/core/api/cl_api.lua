Palomino.API = Palomino.API or {}

net.Receive( "Palomino.API.PlayerSessionToken", function()
    local sSessionToken = net.ReadString()

    -- @TODO: Consider keeping this locally instead.
    Palomino.API.SessionToken = sSessionToken
end )