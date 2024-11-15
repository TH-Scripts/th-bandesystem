--MARK: Get Gangs
--@param source int
--@return table

lib.callback.register('th-bandesystem:GetGangs', function(source)
    local xPlayer  = ESX.GetPlayerFromId(source)
    local gangInfo = {}

    if not xPlayer then return end

    if not GetAdminGroup(source) then 
        DopPlayer(source, 'Du er blevet taget i vores anti-mod system.')
        SendDiscord('En spiller blev kicket', .. GetPlayerName(source) .. ' forsøgte at trigger et event, han ikke har adgang til (Efter al sansynlighed en modder!)', 15548997)
    end

    local gangs = MySQL.query.await('SELECT gang_id, gang_name, gang_owner FROM `gangs`')

    if not gangs then return end

    local gang_members = MySQL.query.await('SELECT identifier FROM `gang_members` WHERE gang_id = ?', { gangs[1].gang_id })

    table.insert(gangInfo, {
        gangs = gangs,
        members = gang_members
    })



    return gangInfo
end)



--MARK: Check User Group
--@param source int
--@return boolean

lib.callback.register('th-bandesystem:CheckUserGroup', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    iif not GetAdminGroup(source) then 
        DopPlayer(source, 'Du er blevet taget i vores anti-mod system.')
        SendDiscord('En spiller blev kicket', .. GetPlayerName(source) .. ' forsøgte at trigger et event, han ikke har adgang til (Efter al sansynlighed en modder!)', 15548997)
    end

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

    if not GetAdminGroup(source) then 
        DopPlayer(source, 'Du er blevet taget i vores anti-mod system.')
        SendDiscord('En spiller blev kicket', .. GetPlayerName(source) .. ' forsøgte at trigger et event, han ikke har adgang til (Efter al sansynlighed en modder!)', 15548997)
    end


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

    if not GetAdminGroup(source) then 
        DopPlayer(source, 'Du er blevet taget i vores anti-mod system.')
        SendDiscord('En spiller blev kicket', .. GetPlayerName(source) .. ' forsøgte at trigger et event, han ikke har adgang til (Efter al sansynlighed en modder!)', 15548997)
    end

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

    if not GetAdminGroup(source) then 
        DopPlayer(source, 'Du er blevet taget i vores anti-mod system.')
        SendDiscord('En spiller blev kicket', .. GetPlayerName(source) .. ' forsøgte at trigger et event, han ikke har adgang til (Efter al sansynlighed en modder!)', 15548997)
    end

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

    if not GetAdminGroup(source) then 
        DopPlayer(source, 'Du er blevet taget i vores anti-mod system.')
        SendDiscord('En spiller blev kicket', .. GetPlayerName(source) .. ' forsøgte at trigger et event, han ikke har adgang til (Efter al sansynlighed en modder!)', 15548997)
    end

    local success = MySQL.update.await('UPDATE gangs SET gang_owner = ? WHERE gang_name = ?', {
        oPlayer.identifier, gangname
    })

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
