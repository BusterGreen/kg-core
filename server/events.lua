-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if not KGCore.Players[src] then return end
    local Player = KGCore.Players[src]
    TriggerEvent('kg-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' .. '\n **Reason:** ' .. reason)
    TriggerEvent('KGCore:Server:PlayerDropped', Player)
    Player.Functions.Save()
    KGCore.Player_Buckets[Player.PlayerData.license] = nil
    KGCore.Players[src] = nil
end)

-- Player Connecting

local function onPlayerConnecting(name, _, deferrals)
    local src = source
    deferrals.defer()

    if KGCore.Config.Server.Closed and not IsPlayerAceAllowed(src, 'kgadmin.join') then
        return deferrals.done(KGCore.Config.Server.ClosedReason)
    end

    if KGCore.Config.Server.Whitelist then
        Wait(0)
        deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
        if not KGCore.Functions.IsWhitelisted(src) then
            return deferrals.done(Lang:t('error.not_whitelisted'))
        end
    end

    Wait(0)
    deferrals.update(string.format('Hello %s. Your license is being checked', name))
    local license = KGCore.Functions.GetIdentifier(src, 'license')

    if not license then
        return deferrals.done(Lang:t('error.no_valid_license'))
    elseif KGCore.Config.Server.CheckDuplicateLicense and KGCore.Functions.IsLicenseInUse(license) then
        return deferrals.done(Lang:t('error.duplicate_license'))
    end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.checking_ban'), name))

    local success, isBanned, reason = pcall(KGCore.Functions.IsPlayerBanned, src)
    if not success then return deferrals.done(Lang:t('error.connecting_database_error')) end
    if isBanned then return deferrals.done(reason) end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.join_server'), name))
    deferrals.done()

    TriggerClientEvent('KGCore:Client:SharedUpdate', src, KGCore.Shared)
end

AddEventHandler('playerConnecting', onPlayerConnecting)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('KGCore:Server:CloseServer', function(reason)
    local src = source
    if KGCore.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        KGCore.Config.Server.Closed = true
        KGCore.Config.Server.ClosedReason = reason
        for k in pairs(KGCore.Players) do
            if not KGCore.Functions.HasPermission(k, KGCore.Config.Server.WhitelistPermission) then
                KGCore.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        KGCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

RegisterNetEvent('KGCore:Server:OpenServer', function()
    local src = source
    if KGCore.Functions.HasPermission(src, 'admin') then
        KGCore.Config.Server.Closed = false
    else
        KGCore.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

-- Callback Events --

-- Client Callback
RegisterNetEvent('KGCore:Server:TriggerClientCallback', function(name, ...)
    if KGCore.ClientCallbacks[name] then
        KGCore.ClientCallbacks[name](...)
        KGCore.ClientCallbacks[name] = nil
    end
end)

-- Server Callback
RegisterNetEvent('KGCore:Server:TriggerCallback', function(name, ...)
    local src = source
    KGCore.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('KGCore:Client:TriggerCallback', src, name, ...)
    end, ...)
end)

-- Player

RegisterNetEvent('KGCore:UpdatePlayer', function()
    local src = source
    local Player = KGCore.Functions.GetPlayer(src)
    if not Player then return end
    local newHunger = Player.PlayerData.metadata['hunger'] - KGCore.Config.Player.HungerRate
    local newThirst = Player.PlayerData.metadata['thirst'] - KGCore.Config.Player.ThirstRate
    if newHunger <= 0 then
        newHunger = 0
    end
    if newThirst <= 0 then
        newThirst = 0
    end
    Player.Functions.SetMetaData('thirst', newThirst)
    Player.Functions.SetMetaData('hunger', newHunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
    Player.Functions.Save()
end)

RegisterNetEvent('KGCore:ToggleDuty', function()
    local src = source
    local Player = KGCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('KGCore:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('KGCore:Notify', src, Lang:t('info.on_duty'))
    end

    TriggerEvent('KGCore:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('KGCore:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- BaseEvents

-- Vehicles
RegisterServerEvent('baseevents:enteringVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entering'
    }
    TriggerClientEvent('KGCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entered'
    }
    TriggerClientEvent('KGCore:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('KGCore:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Left'
    }
    TriggerClientEvent('KGCore:Client:VehicleInfo', src, data)
end)

-- Items

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon.
RegisterNetEvent('KGCore:Server:UseItem', function(item)
    print(string.format('%s triggered KGCore:Server:UseItem by ID %s with the following data. This event is deprecated due to exploitation, and will be removed soon. Check kg-inventory for the right use on this event.', GetInvokingResource(), source))
    KGCore.Debug(item)
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot)
RegisterNetEvent('KGCore:Server:RemoveItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered KGCore:Server:RemoveItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- This event is exploitable and should not be used. It has been deprecated, and will be removed soon. function(itemName, amount, slot, info)
RegisterNetEvent('KGCore:Server:AddItem', function(itemName, amount)
    local src = source
    print(string.format('%s triggered KGCore:Server:AddItem by ID %s for %s %s. This event is deprecated due to exploitation, and will be removed soon. Adjust your events accordingly to do this server side with player functions.', GetInvokingResource(), src, amount, itemName))
end)

-- Non-Chat Command Calling (ex: kg-adminmenu)

RegisterNetEvent('KGCore:CallCommand', function(command, args)
    local src = source
    if not KGCore.Commands.List[command] then return end
    local Player = KGCore.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = KGCore.Functions.HasPermission(src, 'command.' .. KGCore.Commands.List[command].name)
    if hasPerm then
        if KGCore.Commands.List[command].argsrequired and #KGCore.Commands.List[command].arguments ~= 0 and not args[#KGCore.Commands.List[command].arguments] then
            TriggerClientEvent('KGCore:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            KGCore.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('KGCore:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)

-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
KGCore.Functions.CreateCallback('KGCore:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = KGCore.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

-- Use this for long distance vehicle spawning
-- vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
KGCore.Functions.CreateCallback('KGCore:Server:CreateVehicle', function(source, cb, model, coords, warp)
    local veh = KGCore.Functions.CreateAutomobile(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

--KGCore.Functions.CreateCallback('KGCore:HasItem', function(source, cb, items, amount)
-- https://github.com/kgcore-framework/kg-inventory/blob/e4ef156d93dd1727234d388c3f25110c350b3bcf/server/main.lua#L2066
--end)
