-- Add or change (a) method(s) in the KGCore.Functions table
local function SetMethod(methodName, handler)
    if type(methodName) ~= 'string' then
        return false, 'invalid_method_name'
    end

    KGCore.Functions[methodName] = handler

    TriggerEvent('KGCore:Server:UpdateObject')

    return true, 'success'
end

KGCore.Functions.SetMethod = SetMethod
exports('SetMethod', SetMethod)

-- Add or change (a) field(s) in the KGCore table
local function SetField(fieldName, data)
    if type(fieldName) ~= 'string' then
        return false, 'invalid_field_name'
    end

    KGCore[fieldName] = data

    TriggerEvent('KGCore:Server:UpdateObject')

    return true, 'success'
end

KGCore.Functions.SetField = SetField
exports('SetField', SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if KGCore.Shared.Jobs[jobName] then
        return false, 'job_exists'
    end

    KGCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(jobs) do
        if type(key) ~= 'string' then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if KGCore.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        KGCore.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('KGCore:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, message, nil
end

KGCore.Functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not KGCore.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    KGCore.Shared.Jobs[jobName] = nil

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not KGCore.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    KGCore.Shared.Jobs[jobName] = job

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if KGCore.Shared.Items[itemName] then
        return false, 'item_exists'
    end

    KGCore.Shared.Items[itemName] = item

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end
    if not KGCore.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end
    KGCore.Shared.Items[itemName] = item
    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= 'string' then
            message = 'invalid_item_name'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if KGCore.Shared.Items[key] then
            message = 'item_exists'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        KGCore.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('KGCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, message, nil
end

KGCore.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if not KGCore.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end

    KGCore.Shared.Items[itemName] = nil

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if KGCore.Shared.Gangs[gangName] then
        return false, 'gang_exists'
    end

    KGCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(gangs) do
        if type(key) ~= 'string' then
            message = 'invalid_gang_name'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if KGCore.Shared.Gangs[key] then
            message = 'gang_exists'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        KGCore.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('KGCore:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, message, nil
end

KGCore.Functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not KGCore.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    KGCore.Shared.Gangs[gangName] = nil

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not KGCore.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    KGCore.Shared.Gangs[gangName] = gang

    TriggerClientEvent('KGCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('KGCore:Server:UpdateObject')
    return true, 'success'
end

KGCore.Functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local resourceName = GetCurrentResourceName()
local function GetCoreVersion(InvokingResource)
    local resourceVersion = GetResourceMetadata(resourceName, 'version')
    if InvokingResource and InvokingResource ~= '' then
        print(('%s called kgcore version check: %s'):format(InvokingResource or 'Unknown Resource', resourceVersion))
    end
    return resourceVersion
end

KGCore.Functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
    local name = GetPlayerName(playerId)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        name,
        KGCore.Functions.GetIdentifier(playerId, 'license'),
        KGCore.Functions.GetIdentifier(playerId, 'discord'),
        KGCore.Functions.GetIdentifier(playerId, 'ip'),
        origin,
        2147483647,
        'Anti Cheat'
    })
    DropPlayer(playerId, Lang:t('info.exploit_banned', { discord = KGCore.Config.Server.Discord }))
    TriggerEvent('kg-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'red', name .. ' has been banned for exploiting ' .. origin, true)
end

exports('ExploitBan', ExploitBan)
