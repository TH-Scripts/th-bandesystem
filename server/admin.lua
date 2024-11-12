lib.callback.register('th-bandesystem:GetGangs', function(source)
    local test = MySQL.query.await('SELECT gang_name, gang_owner FROM `gangs`')

    return test
end)