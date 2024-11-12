lib.callback.register('th-bandesystem:GetGangs', function(source)
    local test = MySQL.query.await('SELECT gang_name, gang_owner FROM `gangs`')

    return test
end)

lib.callback.register('th-bandesystem:CreateGang', function(source, owner, name)
    MySQL.insert.await('INSERT INTO `gangs` (gang_name, gang_owner) VALUES (?, ?)', {
        name, owner
    }, function(result)
        if not result then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Der opstod en fejl', description = 'Der opstod en fejl under oprettelsen af bande', type = 'error'})
        end
        
        TriggerClientEvent('ox_lib:notify', source, {title = 'Banden blev oprettet', type = 'success'})
    end)
end)