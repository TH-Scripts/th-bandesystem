RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    ESX.PlayerData = xPlayer
end)

RegisterCommand('creategang', function()
    if not ESX.PlayerData.group == 'admin' then
        return lib.notify({title = 'Du har ikke adgang til dette', type = 'warning'})
    else
        CreateGang()
    end
end)

RegisterCommand('handlegangs', function()
    if not ESX.PlayerData.group == 'admin' then
        return lib.notify({title = 'Du har ikke adgang til dette', type = 'warning'})
    else
        getgangs()
    end
end)