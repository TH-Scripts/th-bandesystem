--MARK: Get Gangs
--@param source int
--@return table

lib.callback.register('th-bandesystem:GetGangs', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    if not GetAdminGroup(source) then return end

    local test = MySQL.query.await('SELECT gang_name, gang_owner FROM `gangs`')

    return test
end)



--MARK: Check User Group
--@param source int
--@return boolean

lib.callback.register('th-bandesystem:CheckUserGroup', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    if not GetAdminGroup(source) then return end

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

    if not GetAdminGroup(source) then return end


    local create_gang = MySQL.insert.await('INSERT INTO `gangs` (gang_name, gang_owner) VALUES (?, ?)', {
        name, yPlayer.identifier
    })

    if not create_gang then return end

    local gang = MySQL.insert.await('UPDATE users SET gang = ? WHERE identifier = ?', {
        name, yPlayer.identifier
    })

    AddToSkill(name)

    SendDiscord('Bande oprettet', 'Der blev oprettet en bande\n\nBande navn: ' .. name .. '\nBande Leder (id): ' .. yPlayer.identifier .. '', 5763719)

    return true

end)

--MARK: Edit Name

lib.callback.register('th-bandesystem:EditName', function(source, oldname, newname)
    if not source then return end

    if not GetAdminGroup(source) then return end

    local success = MySQL.update.await('UPDATE gangs SET gang_name = ? WHERE gang_name = ?', {
        newname, oldname
    })

    if not success then return end

    SendDiscord('Bande navn ændret', 'En bande fik ændre sit navn\n\nGamle navn: ' .. oldname .. '\nNye navn ' .. newname .. '', 16776960)

    return true
end)

--MARK: Delete Gang

lib.callback.register('th-bandesystem:DeleteGang', function(source, gangname) 
    if not source then return end
    if not gangname then return end

    if not GetAdminGroup(source) then return end

    local deleted = MySQL.query.await('DELETE FROM gangs WHERE gang_name = ?', {
        gangname
    })

    if not deleted then return end

    SendDiscord('Bande Slettet', 'En bande er blevet slettet\n\nBande navn: ' .. gangname .. '', 15548997)

    return true
end)

--MARK: Add skill function

function AddToSkill(name)
    local gang_id = MySQL.query.await('SELECT gang_id FROM `gangs` WHERE gang_name = ?', {
        name
    })

    local add_skill = MySQL.insert.await('INSERT INTO `gang_skills` (gang_id) VALUES (?)' ,{
        gang_id[1].gang_id
    })
end

--MARK: Change gang boss

lib.callback.register('th-bandesystem:ChangeBoss', function(source, gangname, newOwner)
    local oPlayer = ESX.GetPlayerFromId(newOwner)

    if not oPlayer then return end

    if not GetAdminGroup(source) then return end

    local success = MySQL.update.await('UPDATE gangs SET gang_owner = ? WHERE gang_name = ?', {
        oPlayer.identifier, gangname
    })

    print(json.encode(success))

    if not success then return end

    SendDiscord('Bande leder ændret', 'Banden ' .. gangname .. ', fik ændret leder til ' .. GetPlayerName(newOwner) .. '', 16776960)

    return true
end)



--MARK: Get admin group
--@param source int
--@return bool

function GetAdminGroup(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    if not xPlayer.getGroup() == 'admin' then return false end

    return true

end
