CreateThread(function()
    while true do
        local sleep = 0
        if LocalPlayer.state.isLoggedIn then
            sleep = (1000 * 60) * KGCore.Config.UpdateInterval
            TriggerServerEvent('KGCore:UpdatePlayer')
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if (KGCore.PlayerData.metadata['hunger'] <= 0 or KGCore.PlayerData.metadata['thirst'] <= 0) and not (KGCore.PlayerData.metadata['isdead'] or KGCore.PlayerData.metadata['inlaststand']) then
                local ped = PlayerPedId()
                local currentHealth = GetEntityHealth(ped)
                local decreaseThreshold = math.random(5, 10)
                SetEntityHealth(ped, currentHealth - decreaseThreshold)
            end
        end
        Wait(KGCore.Config.StatusInterval)
    end
end)
