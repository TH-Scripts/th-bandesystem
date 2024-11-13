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

    SendDiscord('Bande oprettet', 'Der blev oprettet en bande\n\nBande navn: ' .. name .. '\nBande Leder (id): ' .. yPlayer.identifier .. '')

    return true

end)

--MARK: Edit Name

lib.callback.register('th-bandesystem:EditName', function(source, oldname, newname)
    if not source then return end

    -- local owner = MySQL.query.await('SELECT gang_owner FROM `gangs` WHERE gang_name = ?', {
    --     gangname
    -- })

    -- print(json.encode(owner))

    -- local oID = ESX.GetPlayerFromIdentifier(owner)

    -- if not oID then 
    --     return TriggerClientEvent('ox_lib:notify', source, {title = 'Ikke online', description = 'Ejeren af banden er ikke online', type = 'error'})
    -- end

    -- local alert = TriggerClientEvent('ox_lib:alertDialog', oID.source, {header = 'Vil du godkende dette navn?', content = 'Navnet vil blive ændret fra ' .. oldname .. ', til ' .. newname .. '', cancel = true, labels = {confirm = 'Ja', cancel = 'Nej'}})

        local success = MySQL.update.await('UPDATE gangs SET gang_name = ? WHERE gang_name = ?', {
            newname, oldname
        })
    
        if not success then return end
    
        SendDiscord('Bande navn ændret', 'En bande fik ændre sit navn\n\nGamle navn: ' .. oldname .. '\nNye navn ' .. newname .. '')
    
        return true
end)

--MARK: Delete Gang

lib.callback.register('th-bandesystem:DeleteGang', function(source, gangname) 
    if not source then return end
    if not gangname then return end


    local deleted = MySQL.query.await('DELETE FROM gangs WHERE gang_name = ?', {
        gangname
    })

    if not deleted then return end

    SendDiscord('Bande Slettet', 'En bande er blevet slettet\n\nBande navn: ' .. gangname .. '')

    return true
end)

-- lib.callback.register('th-bandesystem:GetOwner', function(source, gangname)
--     local owner = MySQL.query.await('SELECT gang_owner FROM gangs WHERE gang_name = ?', {
--         gangname
--     })

--     if not owner then return end

--     return owner[1]
-- end)