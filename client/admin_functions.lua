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
            description = 'Bande boss: ' .. v.gang_owner .. '',
            onSelect = function()
                EditGang(v.gang_name)
            end
        })
    end

    lib.registerContext({
        id = 'th_bandesystem_gangs_context_menu',
        title = 'Håndter bander',
        options = options
    })

    return lib.showContext('th_bandesystem_gangs_context_menu')

end

--MARK: Edit Gang

function EditGang(gangname)
    if not gangname then return end

    lib.registerContext({
        id = 'the_bandesystem_gangs_edit',
        title = 'Håndter ' .. gangname .. '',
        options = {
            {
                title = 'Ændre navn',
                description = 'Tilpas bandens navn (Ejeren af bande skal være ingame)',
                onSelect = function()
                    EditGangName(gangname)
                end
            },
            {
                title = 'Slet bande',
                description = 'Fjerner en bande fra systemet',
                onSelect = function()
                    DeleteGang(gangname)
                end
            }
        }
    })

    lib.showContext('the_bandesystem_gangs_edit')
end

--@param: oldname
function EditGangName(oldname)

    if not oldname then return end

    local input = lib.inputDialog('Ændre ' .. oldname .."'s navn", {
        {type = 'input', label = 'Angiv det nye navn', required = true}
    })

    --print(newname)

    local newname = input[1]

    if not newname then return end

    if oldname == newname then
        return lib.notify({title = 'Fejl', description = 'Det nye bande navn kan ikke være det samme som det gamle', type = 'error'})
    end

    local alert = lib.alertDialog({
        header = 'Er du sikker',
        content = 'Er du sikker på at du vil ændre ' .. oldname .. "'s navn til " .. newname .. '?',
        centered = true,
        cancel = true,
        labels = {
            confirm = 'Ja',
            cancel = 'Nej'
        }
    })

    if alert == 'confirm' then
        local name_changed = lib.callback.await('th-bandesystem:EditName', false, oldname, newname)
        print(name_changed)

        if name_changed then
            lib.notify({title = 'Navn ændret', description = 'Du ændrede ' .. oldname .. "'s navn til " .. newname .. '!', type = 'success'})
        else
            lib.notify({title = 'Der opstod en fejl', description = 'Der opstod en fejl under ændringen af bandens navn', type = 'error'})
        end
    else
        return
    end
end

--MARK: Delete Gang
-- @param: gangname
function DeleteGang(gangname)
    if not gangname then return end

    local alert = lib.alertDialog({
        header = 'Er du sikker',
        content = 'Er du sikker på at du vil slette ' .. gangname .. '?\n\n# Dette kan ikke fortrydes',
        cancel = true,
        labels = {
            confirm = 'Ja',
            cancel = 'Nej',
        }
    })

    if alert == 'confirm' then

        local gang_removed = lib.callback.await('th-bandesystem:DeleteGang', false, gangname)

        if gang_removed then
            lib.notify({title = 'Du slettede banden ' .. gangname .. '', type = 'success'})
        else
            lib.notify({title = 'Der opstod en fejl', description = 'Der opstod en fejl under slettningen af ' .. gangname .. '. Banden eksistere ikke'})
        end
    else
        return
    end
end


--MARK: Create Gang
--@return boolean

function CreateGang()
    local input = lib.inputDialog('Opret Bande', {
        {type = 'input', label = 'Spillerens ID', required = true},
        {type = 'input', label = 'Bandens navn', required = true}
    })

    if not input then return end

    local gang_owner_id = newname
    local gang_name = input[2]

    local create_gang = lib.callback.await('th-bandesystem:CreateGang', false, gang_owner_id, gang_name)

    if create_gang then
        lib.notify({title = 'Banden blev oprettet', type = 'success'})
    else
        lib.notify({title = 'Der opstod en fejl', description = 'Der opstod en fejl under oprettelsen af bande. Banden eksistere allerede, eller ejeren har allerede en bande', type = 'error'})
    end
end