ESX = exports['es_extended']:getSharedObject()



--MARK: Get all members
--@param gangId int
--@return table | false

lib.callback.register('th-bandesystem:getAllMembers', function(source, gangId)
    local xPlayer      = ESX.GetPlayerFromId(source)
    local memberData   = {}

    if not xPlayer then return end

    local members = MySQL.Sync.fetchAll('SELECT * FROM gang_members WHERE gang_id = ?', { gangId.gang_id })


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

lib.callback.register('th-bandesystem:searchForMembers', function(source, search, gangId)
    local xPlayer       = ESX.GetPlayerFromId(source)
    local found         = false
    local foundMembers  = {}
    local members       = {}
    local memberNames   = {}

    if not xPlayer or not search then return end

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

    if not xPlayer then return end

    local gangId = MySQL.Sync.fetchAll('SELECT gang_id FROM gang_members WHERE identifier = ?', { xPlayer.identifier })
    
    return gangId[1]
end)

--MARK: Remove member
--@param source int
--@param identifier string
--@param gangId int
--@return boolean

lib.callback.register('th-bandesystem:removeMember', function(source, identifier, gangId)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    local remove_member = MySQL.Sync.execute('DELETE FROM gang_members WHERE identifier = ? AND gang_id = ?', { identifier, gangId })

    if remove_member then
        return true
    else
        return false
    end

end)
