--MARK: Player Loaded

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    ESX.PlayerData = xPlayer
end)


--MARK: Get Player Group
--@return string

function GetPlayerGroup()
    local group = lib.callback.await('th-bandesystem:CheckUserGroup', false)
    
    return group
end

--MARK: Get Gangs
--@return context menu

function GetGangs()

    local gangs = lib.callback.await('th-bandesystem:GetGangs', false)
    local options = {}


    if not gangs then
        return lib.notify({title = 'Der er ikke registeret nogle bander', type = 'error'})
    end

    for _,v in pairs(gangs) do
        table.insert(options, {
            title = v.gang_name,
            description = 'Bande boss: ' .. v.gang_owner .. ''
        })
    end

    lib.registerContext({
        id = 'th_bandesystem_gangs_context_menu',
        title = 'Håndter bander',
        options = options
    })

    return lib.showContext('th_bandesystem_gangs_context_menu')

end

--MARK: Create Gang
--@return boolean

function CreateGang()
    local input = lib.inputDialog('Opret Bande', {
        {type = 'input', label = 'Spillerens ID', required = true},
        {type = 'input', label = 'Bandens navn', required = true}
    })

    if not input then return end

    local gang_owner_id = input[1]
    local gang_name = input[2]

    local create_gang = lib.callback.await('th-bandesystem:CreateGang', false, gang_owner_id, gang_name)

    if create_gang then
        lib.notify({title = 'Banden blev oprettet', type = 'success'})
    else
        lib.notify({title = 'Der opstod en fejl', description = 'Der opstod en fejl under oprettelsen af bande', type = 'error'})
    end
end