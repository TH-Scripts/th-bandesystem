function getgangs()
    lib.callback('th-bandesystem:GetGangs', false, function(gangs)

        if not gangs then
            return lib.notify({title = 'Der er ikke registeret nogle bander', type = 'error'})
        end


        for _,v in pairs(gangs) do
            local options = {}

            table.insert(options, {
                title = v.gang_name,
                description = 'Bande boss: ' .. v.gang_owner .. ''
            })

            lib.registerContext({
                id = 'gangs',
                title = 'Håndter bander',
                options = options
            })
        end

        lib.showContext('gangs')
    end)
end

function CreateGang()
    local input = lib.inputDialog('Opret Bande', {
        {type = 'input', label = 'Steam navn', required = true},
        {type = 'input', label = 'Bande navn', required = true}
    })

    lib.callback('th-bandesystem:CreateGang', false, function() end, input[1], input[2])
end