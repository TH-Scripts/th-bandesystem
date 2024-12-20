ESX = exports['es_extended']:getSharedObject()



--MARK: Get all members
--@param gangId int
--@return table | false

lib.callback.register('th-bandesystem:getAllMembers', function(source)
    local xPlayer      = ESX.GetPlayerFromId(source)
    local gangId       = GetGangId(xPlayer.identifier)
    local members      = MySQL.Sync.fetchAll('SELECT * FROM gang_members WHERE gang_id = ?', { gangId })
    local memberData   = {}

    if not xPlayer then return end

    if not gangId then return end

    local check_gang_id = CheckGangId(source, gangId)

    if not check_gang_id then return false end

    for _, member in pairs(members) do

        local oPlayer = ESX.GetPlayerFromIdentifier(member.identifier)


        table.insert(memberData, {
            name = oPlayer.getName(),
            identifier = member.identifier,
            gang_id = member.gang_id
        })
    end


    return memberData
end)

--MARK: Search for members
--@param source int
--@param search string
--@param gangId int
--@return table | false

lib.callback.register('th-bandesystem:searchForMembers', function(source, search)
    local xPlayer       = ESX.GetPlayerFromId(source)
    local gangId        = GetGangId(xPlayer.identifier)
    local found         = false
    local foundMembers  = {}
    local members       = {}
    local memberNames   = {}

    if not gangId then return end

    if not xPlayer or not search then return end

    local check_gang_id = CheckGangId(source, gangId)

    if not check_gang_id then return false end

    members = MySQL.Sync.fetchAll('SELECT * FROM gang_members WHERE gang_id = ?', { gangId })


    for _, member in pairs(members) do

        local oPlayer = ESX.GetPlayerFromIdentifier(member.identifier)
        local name = oPlayer.getName()
        table.insert(memberNames, { name = name, identifier = member.identifier })
    end

    --Check if the search is in the memberNames

    for _, name in pairs(memberNames) do
        if string.lower(name.name):find(string.lower(search)) then
            found = true
            table.insert(foundMembers, {name = name.name, identifier = name.identifier, gangId = gangId})
        end
    end


    if found then
        return foundMembers
    else
        return false
    end


end)

--MARK: Get gang id
--@param source int
--@return int | false

lib.callback.register('th-bandesystem:getGangId', function(source)
    local xPlayer       = ESX.GetPlayerFromId(source)
    local gangId        = MySQL.Sync.fetchAll('SELECT gang_id FROM gang_members WHERE identifier = ?', { xPlayer.identifier })

    if not xPlayer then return end

    
    return gangId[1]
end)

--MARK: Get Gang Name

lib.callback.register('th-bandesystem:GetGangName', function(source)
    local xPlayer       = ESX.GetPlayerFromId(source)
    local gangName      = MySQL.query.await('SELECT gang FROM users WHERE identifier = ?', {
        xPlayer.identifier
    })

    if not gangName then return end

    return gangName[1].gang
end)


--MARK: Remove member
--@param source int
--@param identifier string
--@param gangId int
--@return boolean

lib.callback.register('th-bandesystem:removeMember', function(source, identifier)
    local xPlayer       = ESX.GetPlayerFromId(source)
    local gangId        = GetGangId(xPlayer.identifier)
    local remove_member = MySQL.Sync.execute('DELETE FROM gang_members WHERE identifier = ? AND gang_id = ?', { identifier, gangId })

    if not gangId then return end
    if not xPlayer then return end

    local check_gang_id = CheckGangId(source, gangId)

    if not check_gang_id then return false end

    if remove_member then
        return true
    else
        return false
    end

end)



--MARK: Get players in distance
--@param closePlayers table
--@return table | false

lib.callback.register('th-bandesystem:getPlayersInDistance', function(source, closePlayers)

    local players       = {}

    for _, player in pairs(closePlayers) do
        local xPlayer = ESX.GetPlayerFromId(player)
        table.insert(players, { name = xPlayer.getName(), identifier = xPlayer.identifier })
    end

    return players
end)


--MARK: Add member to gang
--@param identifier string
--@param gangId int
--@return boolean

lib.callback.register('th-bandesystem:addMemberToGang', function(source, identifier)
    local xPlayer       = ESX.GetPlayerFromId(source)
    local gangId        = GetGangId(xPlayer.identifier)

    if not xPlayer then return end
    if not gangId then return end

    local check_gang_id = CheckGangId(source, gangId)

    if not check_gang_id then return false end

    --Check if the player is already in a gang

    local is_in_gang = MySQL.Sync.fetchAll('SELECT * FROM gang_members WHERE identifier = ?', { identifier })

    if is_in_gang then return false end
    
    --Add the member to the gang

    local add_member = MySQL.Sync.execute('INSERT INTO gang_members (identifier, gang_id) VALUES (?, ?)', { identifier, gangId.gang_id })

    if not add_member then return false end

    return true
end)



--MARK: Check if gang id is equal to gang
--@param gangId int
--@return boolean

function CheckGangId(source, gangId)
    local xPlayer = ESX.GetPlayerFromId(source)

    local get_current_gang = MySQL.Sync.fetchAll('SELECT gang_id FROM gang_members WHERE identifier = ?', { xPlayer.identifier })

    if not xPlayer then return end

    if get_current_gang[1].gang_id == gangId then
        return true
    else
        return false
    end
end
