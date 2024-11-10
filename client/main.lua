RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function(xPlayer, isNew, skin)
    ESX.PlayerData = xPlayer
end)


RegisterCommand('bossmenu', function()
    OpenBossMenu()
end)


--MARK: Boss menu
--@return context menu

function OpenBossMenu()

    local gangId = GetGangId()

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
                    OpenMembersMenu(jobName, gangId)
                end
            }
        }
    })


    return lib.showContext('th_bandesystem_boss_menu')

end


--MARK: Members menu
--@param jobName string
--@return context menu

function OpenMembersMenu(jobName, gangId)

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
                    SearchForMembers(gangId)
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
        }
    })

    return lib.showContext('th_bandesystem_members_menu')

end

--MARK: Search for members
--@return void 

function SearchForMembers(gangId)

    local input = lib.inputDialog('Søg efter medlemmer', {
        {type = 'input', label = 'Medlemmets Navn', description = 'Indtast navnet for medlemmet', required = true, min = 2, max = 20},
    })
    
    if not input then return end

    lib.callback('th-bandesystem:searchForMembers', false, function(result)
        if result then
            SearchMemberContextMenu(result)
        else
            lib.notify({
                title = 'Ingen medlemmer fundet',
                description = 'Ingen medlemmer med navnet "'..input[1]..'" blev fundet i din bande',
                type = 'error'
            })
        end
    end, input[1], gangId)
end


--MARK: Member context menu
--@param members array
--@return context menu

function SearchMemberContextMenu(members)

    local options = {}

    for _, member in pairs(members) do
        table.insert(options, {
            title = member.name,
            description = "Tryk for at se medlemsfunktionerne",
            icon = 'fa-solid fa-user',
            iconColor = '#06915a',
            onSelect = function()
                MemberContextMenuSingle(member.name, member.identifier, member.gangId)
            end
        })
    end

    lib.registerContext({
        id = 'th_bandesystem_member_context_menu',
        title = 'Medlem',
        menu = 'th_bandesystem_members_menu',
        options = options
    })

    return lib.showContext('th_bandesystem_member_context_menu')
end


--MARK: Member context menu single
--@param name string
--@param identifier string
--@param gangId string
--@return context menu

function MemberContextMenuSingle(name, identifier, gangId)

    lib.registerContext({
        id = 'th_bandesystem_member_context_menu_single',
        title = 'Medlem - '..name,
        menu = 'th_bandesystem_member_context_menu',
        options = {
            {
                title = 'Fjern medlem',
                description = 'Fjern medlemmet fra din bande',
                icon = 'fa-solid fa-user-minus',
                iconColor = '#06915a',
                onSelect = function()
                    RemoveMember(name, identifier, gangId)
                end
            }
        }
    })

    return lib.showContext('th_bandesystem_member_context_menu_single')

end


-- MARK: Remove member
--@param name string
--@param identifier string
--@param gangId string
--@return void

function RemoveMember(name, identifier, gangId)
    lib.callback('th-bandesystem:removeMember', false, function(result)
        if result then
            lib.notify({
                title = 'Medlem fjernet',
                description = 'Medlemmet '..name..' er blevet fjernet fra din bande',
                type = 'success'
            })
            OpenBossMenu()
        elseif not result then
            lib.notify({
                title = 'Fejl',
                description = 'Der skete en fejl ved fjernelsen af medlemmet',
                type = 'error'
            })
        end
    end, identifier, gangId)
end


--MARK: Get gang id
--@return int

function GetGangId()
    lib.callback('th-bandesystem:getGangId', false, function(result)
        if result then
            return result.gang_id
        end
    end)
end
