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

    local jobName = lib.callback.await('th-bandesystem:GetGangName', false)

    if not jobName then
        return lib.notify({ title = 'Du er ikke medlem af en bande', type = 'error'})
    end

    local options = {
        {
            title = 'Medlemsmenu',
            description = 'Medlemsmenuen for banden '..jobName,
            icon = 'fa-solid fa-users',
            iconColor = '#06915a',
            onSelect = function()
                OpenMembersMenu(jobName, gangId)
            end
        },
    }

    if Config.enableSkills then
        table.insert(options, {
            
            title = 'Skillsmenu',
            description = 'Tjek status på bandens skills',
            icon = 'fa-solid fa-flask',
            iconColor = '#06915a',
            onSelect = function()
                ShowSkills(jobName)
            end
            
        })
    end

    lib.registerContext({
        id = 'th_bandesystem_boss_menu',
        title = 'Boss Menu - '..jobName,
        options = options
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
                    AllMembersContextMenu(gangId)
                end
            },
            {
                title = 'Tilføj medlem',
                description = 'Tilføj medlem til din bande',
                icon = 'fa-solid fa-user-plus',
                iconColor = '#06915a',
                onSelect = function()
                    AddMembersContextMenu(gangId)
                end
            }
            -- {
            --     title = 'Send besked',
            --     description = 'Send besked til alle medlemmer i din banden',
            --     icon = 'fa-solid fa-envelope',
            --     iconColor = '#06915a',
            --     onSelect = function()
            --         print('Send besked')
            --     end
            -- },
        }
    })

    return lib.showContext('th_bandesystem_members_menu')

end



--MARK: See all members
--@param gangId int
--@return context menu

function AllMembersContextMenu(gangId)
    
    local options = {}

    local result = lib.callback.await('th-bandesystem:getAllMembers', false, gangId)

    if result then
        for _, member in pairs(result) do
            table.insert(options, {
                title = member.name,
                description = 'Tryk for at se medlemsfunktionerne',
                icon = 'fa-solid fa-user',
                iconColor = '#06915a',
                onSelect = function()
                    MemberContextMenuSingle(member.name, member.identifier, member.gang_id)
                end
            })
        end
    end

    lib.registerContext({
        id = 'th_bandesystem_see_all_members',
        title = 'Se alle medlemmer',
        menu = 'th_bandesystem_members_menu',
        options = options
    })

    return lib.showContext('th_bandesystem_see_all_members')

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


--MARK: Add Members Context Menu
--@param gangId int
--@return context menu

function AddMembersContextMenu(gangId)

    local options = {}
    local players_in_area_ids = {}

    local players_in_area = ESX.Game.GetPlayersInArea(GetEntityCoords(cache.ped), 5.0, true)
    
    for _, player in pairs(players_in_area) do
        table.insert(players_in_area_ids, GetPlayerServerId(player))
    end

    local players_in_distance = lib.callback.await('th-bandesystem:getPlayersInDistance', false, players_in_area_ids)



    if not players_in_distance then 
        lib.notify({
            title = 'Ingen personer i nærheden',
            description = 'Ingen personer i nærheden',
            type = 'error'
        })
        return
    end


    for _, player in pairs(players_in_distance) do
        table.insert(options, {
            title = player.name,
            description = 'Tryk for at tilføje medlem til din bande',
            icon = 'fa-solid fa-user-plus',
            iconColor = '#06915a',
            onSelect = function()
                AddMemberToGang(player.identifier, gangId)
            end
        })
    end


    lib.registerContext({
        id = 'th_bandesystem_add_members_context_menu',
        title = 'Tilføj medlem',
        menu = 'th_bandesystem_members_menu',
        options = options
    })

    return lib.showContext('th_bandesystem_add_members_context_menu')

end

--MARK: Get gang id
--@return int

function GetGangId()
    return lib.callback.await('th-bandesystem:getGangId', false)
end




--MARK: Add member to gang
--@param identifier string
--@param gangId int
--@return void

function AddMemberToGang(identifier, gangId)

    if not identifier then return end

    lib.callback('th-bandesystem:addMemberToGang', false, function(result)
        if result then
            lib.notify({
                title = 'Medlem tilføjet',
                description = 'Medlemmet er blevet tilføjet til din bande',
                type = 'success'
            })
        else
            lib.notify({
                title = 'Problem',
                description = 'Medlemmet er allerede i en bande',
                type = 'error'
            })
        end
    end, identifier, gangId)

end