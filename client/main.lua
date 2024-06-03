KGCore = {}
KGCore.PlayerData = {}
KGCore.Config = KGConfig
KGCore.Shared = KGShared
KGCore.ClientCallbacks = {}
KGCore.ServerCallbacks = {}

exports('GetCoreObject', function()
    return KGCore
end)

-- To use this export in a script instead of manifest method
-- Just put this line of code below at the very top of the script
-- local KGCore = exports['kg-core']:GetCoreObject()
