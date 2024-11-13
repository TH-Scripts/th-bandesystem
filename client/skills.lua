--MARK: Skill System
--@param gangname string
--@return context menu

function ShowSkills(gangname)

    local options = {}
    local skills = lib.callback.await('th-bandesystem:GetGangSkills', false, gangname)

    for _,v in pairs(skills) do
        print(json.encode(v))

        table.insert(options, {
            title = 'Røveri level: ' .. v.robbery_level .. '',
            progress = v.robbery_xp
        })
        
        table.insert(options, {
            title = 'Hus level: ' .. v.house_level .. '',
            progress = v.house_xp
        })

    end

    lib.registerContext({
        id = 'Skill_main',
        title = gangname .. ' skills',
        options = options
    })

    return lib.showContext('Skill_main')
end