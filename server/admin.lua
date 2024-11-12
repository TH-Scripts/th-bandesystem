--MARK: Get Gangs
--@param source int
--@return table

lib.callback.register('th-bandesystem:GetGangs', function(source)
    local test = MySQL.query.await('SELECT gang_name, gang_owner FROM `gangs`')

    return test
end)



--MARK: Check User Group
--@param source int
--@return boolean

lib.callback.register('th-bandesystem:CheckUserGroup', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    local group = xPlayer.getGroup()

    return group
end)

--MARK: Create Gang
--@param source int
--@param owner int
--@param name string
--@return boolean

lib.callback.register('th-bandesystem:CreateGang', function(source, owner, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    local yPlayer = ESX.GetPlayerFromId(owner)

    if not xPlayer or not yPlayer then return end


    local create_gang = MySQL.insert.await('INSERT INTO `gangs` (gang_name, gang_owner) VALUES (?, ?)', {
        name, yPlayer.identifier
    })

    if not create_gang then return end

    return true

end)