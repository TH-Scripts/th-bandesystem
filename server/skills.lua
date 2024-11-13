lib.callback.register('th-bandesystem:GetGangSkills', function(source, gangname)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then return end

    local gangId = MySQL.Sync.fetchAll('SELECT gang_id FROM gangs WHERE gang_owner = ?', { xPlayer.identifier })

    print(json.encode(gangId))

    local skills = MySQL.query.await('SELECT * FROM gang_skills WHERE gang_id = ?', {
        gangId[1].gang_id
    })


    return skills
end)
