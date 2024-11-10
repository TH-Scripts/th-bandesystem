

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    ESX.PlayerData = xPlayer
end)


RegisterCommand('bossmenu', function()
    OpenBossMenu()
end)


--Boss menu
--@return context menu

function OpenBossMenu()


    local jobName = ESX.PlayerData.job.label

    lib.registerContext({
        id = 'th_bandesystem_boss_menu',
        title = 'Boss Menu - '..jobName,
        options = {
            {
                title = 'Medlemsmenu',
                description = 'Medlemsmenuen for banden '..jobName,
                icon = 'fa-solid fa-users',
                iconColor = '#06915a',
                onSelect = function()
                    OpenMembersMenu(jobName)
                end
            }
        }
    })


    return lib.showContext('th_bandesystem_boss_menu')

end


--Members menu
--@param jobName string
--@return context menu

function OpenMembersMenu(jobName)

    lib.registerContext({
        id = 'th_bandesystem_members_menu',
        title = 'Medlemsmenu - '..jobName,
        menu = 'th_bandesystem_boss_menu',
        options = {
            {
                title = 'Søg efter medlemmer',
                description = 'Søg efter medlemmer i din banden',
                icon = 'fa-solid fa-magnifying-glass',
                iconColor = '#06915a',
                onSelect = function()
                    print('Søg efter medlemmer')
                end
            },
            {
                title = 'Se alle medlemmer',
                description = 'Se alle medlemmer i din banden',
                icon = 'fa-solid fa-users',
                iconColor = '#06915a',
                onSelect = function()
                    print('Se alle medlemmer')
                end
            },
            {
                title = 'Send besked',
                description = 'Send besked til alle medlemmer i din banden',
                icon = 'fa-solid fa-envelope',
                iconColor = '#06915a',
                onSelect = function()
                    print('Send besked')
                end
            },
            {
                title = 'Tilføj medlem',
                description = 'Tilføj medlem til din banden',
                icon = 'fa-solid fa-user-plus',
                iconColor = '#06915a',
                onSelect = function()
                    print('Tilføj medlem')
                end
            },
            {
                title = 'Slet medlem',
                description = 'Slet medlem fra din banden',
                icon = 'fa-solid fa-user-minus',
                iconColor = '#06915a',
                onSelect = function()
                    print('Slet medlem')
                end
            }
        }
    })

    return lib.showContext('th_bandesystem_members_menu')

end
