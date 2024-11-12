RegisterCommand('creategang', function()
    local group = GetPlayerGroup()

    if group ~= 'admin' then
        return lib.notify({title = 'Du har ikke adgang til dette', type = 'warning'})
    else
        CreateGang()
    end
end)

RegisterCommand('handlegangs', function()
    local group = GetPlayerGroup()

    if group ~= 'admin' then
        return lib.notify({title = 'Du har ikke adgang til dette', type = 'warning'})
    else
        GetGangs()
    end
end)