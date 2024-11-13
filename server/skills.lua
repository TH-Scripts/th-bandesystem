lib.callback.register('th-bandesystem:GetGangSkills', function(source, gangname)

    local gangid = MySQL.query.await('SELECT gang_id FROM gangs WHERE gang_name = ?', {
        gangname
    })
    print(json.encode(gangid))

    local skills = MySQL.query.await('SELECT * FROM gang_skills WHERE gang_id = ?', {
        gangid[1].gang_id
    })

    print(json.encode(skills))

    return skills
end)